{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.robins-nixos.nix.remotebuild.builder;
in
{
  options.robins-nixos.nix.remotebuild.builder = {
    enable = lib.mkEnableOption "Remote Builder";
  };

  config = lib.mkIf cfg.enable {
    users.users.remotebuild = {
      isNormalUser = true;
      createHome = false;
      group = "remotebuild";

      openssh.authorizedKeys.keyFiles = [ ./builder-ssh-ed25519.pub ];
    };

    users.groups.remotebuild = { };

    nix = {
      nrBuildUsers = 64;
      settings = {
        trusted-users = [ "remotebuild" ];

        min-free = 10 * 1024 * 1024;
        max-free = 200 * 1024 * 1024;
      };
    };

    systemd.services.nix-daemon.serviceConfig = {
      MemoryAccounting = true;
      MemoryMax = "90%";
      OOMScoreAdjust = 500;
    };
  };
}
