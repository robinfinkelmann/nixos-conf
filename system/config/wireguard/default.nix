{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.robins-nixos.wireguard;
in
{
  # TODO for now, this supports only a single peer, that receives all traffic. As I do not have any NixOS nodes with more than one peer, this suffices atm.
  options.robins-nixos.wireguard = {
    enable = lib.mkEnableOption "Wireguard";
    fileSystems = lib.mkOption {
      default = false;
      example = true;
      description = "Whether to mount Wireguard Network Filesystems";
      type = lib.types.bool;
    };
    address = lib.mkOption {
      default = "10.0.0.1/24";
      description = "IPv4 address and subnet of the Wireguard Interface";
      type = lib.types.str;
    };
    endpoint = lib.mkOption {
      default = "finkelmann.net:51820";
      description = "Endpoint of the Peer";
      type = lib.types.str;
    };
    endpointPublicKey = lib.mkOption {
      default = "7b0VYcoL1X1RXnp7ugJU6bPV58i2KwtUvJFVbVrVOVw=";
      description = "Wireguard Public Key of the Peer";
      type = lib.types.str;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      age.secrets.wg0 = {
        rekeyFile = ./wg0-${config.networking.hostName}.age;
        generator = {
          script = "wireguard";
          tags = [
            "wg0"
            "wireguard"
            "${config.networking.hostName}"
          ];
        };
      };

      networking.wg-quick.interfaces.wg0 = {
        address = [ cfg.address ];
        peers = [
          {
            allowedIPs = [
              "10.0.0.0/24"
              "192.168.1.0/24"
            ];
            endpoint = cfg.endpoint;
            publicKey = cfg.endpointPublicKey;
            persistentKeepalive = 25;
          }
        ];
        privateKeyFile = config.age.secrets.wg0.path;
        dns = [ "10.0.0.100" ];
      };

      networking.hosts = {
        "10.0.0.1" = [ "ionos1" ];
        "10.0.0.2" = [ "pi" ];
        "10.0.0.10" = [ "desktop" ];
        "10.0.0.21" = [ "laptop" ];
        "10.0.0.22" = [ "risky" ];
        "10.0.0.100" = [ "pfsense" ];
        "10.0.0.200" = [ "friendlynas" ];
      };
    })

    (lib.mkIf cfg.fileSystems {
      services.rpcbind.enable = true;

      security.wrappers."mount.nfs4" = {
        program = "mount.nfs4";
        source = "${lib.getBin pkgs.nfs-utils}/bin/mount.nfs4";
        owner = "root";
        group = "root";
        setuid = true;
      };
      security.wrappers."mount.nfs" = {
        program = "mount.nfs";
        source = "${lib.getBin pkgs.nfs-utils}/bin/mount.nfs";
        owner = "root";
        group = "root";
        setuid = true;
      };

      # TODO: Some of the options cause instabilities when mounting without network, and timeouts when shutting down. Investigate pls!
      fileSystems."/media/data" = {
        device = "10.0.0.100:/horde/share";
        fsType = "nfs4";
        options = [
          "defaults"
          "x-systemd.automount"
          "noauto"
          "_netdev"
          "user"
          "noatime"
        ];
      };
      fileSystems."/media/fast" = {
        device = "10.0.0.200:/fast/share";
        fsType = "nfs4";
        options = [
          "defaults"
          "x-systemd.automount"
          "noauto"
          "_netdev"
          "user"
          "noatime"
        ];
      };
    })
  ];
}
