{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.robins-nixos.backup;
in
{
  options.robins-nixos.backup = {
    enable = lib.mkEnableOption "Backup-Home";
    user = lib.mkOption {
      default = "robin";
      example = "yourusername";
      description = "User whose home folder to backup";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.borgbackup-home-ssh = {
      rekeyFile = ./ssh-ed25519-${config.networking.hostName}.age;
      owner = cfg.user;
      generator = {
        script = "ssh-ed25519-python";
        tags = [
          "borg"
          "borg-ssh"
          "${config.networking.hostName}"
        ];
      };
    };
    age.secrets.borgbackup-home-repokey = {
      rekeyFile = ./repokey-${config.networking.hostName}.age;
      owner = cfg.user;
      generator = {
        script = "alnum";
        tags = [
          "borg"
          "borg-repokey"
          "${config.networking.hostName}"
        ];
      };
    };

    services.borgbackup.jobs.home-robin = {
      user = cfg.user;
      paths = [ "/home/robin" ];
      exclude = [
        "/home/robin/.cache"
        "/home/robin/.local/share/Steam"
      ];
      repo = "ssh://u417305@u417305.your-storagebox.de:23/./backups/home/${config.networking.hostName}";
      compression = "auto,zstd";
      encryption = {
        mode = "repokey-blake2";
        passCommand = "cat ${config.age.secrets.borgbackup-home-repokey.path}";
      };
      prune.keep = {
        within = "1d"; # Keep all archives from the last day
        daily = 7;
        weekly = 4;
        monthly = -1; # Keep at least one archive for each month
      };

      environment.BORG_RSH = "ssh -i ${config.age.secrets.borgbackup-home-ssh.path}";
      startAt = "hourly";
      persistentTimer = true;
    };
  };
}
