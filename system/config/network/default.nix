{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.robins-nixos.networking;
in
{
  options.robins-nixos.networking = {
    networkmanager = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable networking via NetworkManager.";
      type = lib.types.bool;
    };
    openconnect = lib.mkOption {
      default = false;
      example = true;
      description = "Whether to install OpenConnect.";
      type = lib.types.bool;
    };
    sshd = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable the OpenSSH server.";
      type = lib.types.bool;
    };
    avahi = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable the Avahi";
      type = lib.types.bool;
    };
  };

  config = {
    networking.networkmanager.enable = lib.mkIf cfg.networkmanager true;

    environment = lib.mkMerge [
      (lib.mkIf cfg.openconnect { systemPackages = [ pkgs.openconnect ]; })
      (lib.mkIf (cfg.openconnect && cfg.networkmanager) {
        systemPackages = [ pkgs.networkmanager-openconnect ];
      })
    ];

    # Enable the OpenSSH daemon.
    services.openssh = lib.mkIf cfg.sshd {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.PermitRootLogin = "no";
    };

    # .local network discovery
    services.avahi = lib.mkIf cfg.avahi {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
    };
  };
}
