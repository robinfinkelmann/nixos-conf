{
  pkgs,
  lib,
  config,
  ...
}:

# TODO Test this module

let
  cfg = config.robins-nixos.nix.remotebuild.client;
in
{
  options.robins-nixos.nix.remotebuild.client = {
    enable = lib.mkEnableOption "Enable Remote Building on this Machine";
    builder-hostname = lib.mkOption {
      default = "10.0.0.10";
      example = "hostname.example.com";
      description = "Hostname of the remote builder";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.nix-remotebuild-ssh = {
      rekeyFile = ./builder-ssh-ed25519.age;
      generator = {
        script = "ssh-ed25519-python";
        tags = [
          "remotebuild"
          "${config.networking.hostName}"
        ];
      };
    };

    nix.distributedBuilds = true;
    nix.settings.builders-use-substitutes = true;

    nix.buildMachines = [
      {
        hostName = cfg.builder-hostname;
        sshUser = "remotebuild";
        sshKey = config.age.secrets.nix-remotebuild-ssh.path;
        system = pkgs.stdenv.hostPlatform.system;
        supportedFeatures = [
          "nixos-test"
          "big-parallel"
          "kvm"
        ];
      }
    ];
  };
}
