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
    builderHostname = lib.mkOption {
      default = "10.0.0.10";
      example = "hostname.example.com";
      description = "Hostname of the remote builder";
      type = lib.types.str;
    };
    builderSystems = lib.mkOption {
      default = [
        "x86_64-linux"
        "i686-linux"
      ];
      example = [
        "aarch64-linux"
      ];
      description = "System architectures of the remote builder";
      type = lib.types.listOf lib.types.str;
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
        hostName = cfg.builderHostname;
        sshUser = "remotebuild";
        sshKey = config.age.secrets.nix-remotebuild-ssh.path;
        systems = cfg.builderSystems;
        supportedFeatures = [
          "kvm"
          "nixos-test"
          "big-parallel"
          "benchmark"
        ];
        maxJobs = 4;
      }
    ];
  };
}
