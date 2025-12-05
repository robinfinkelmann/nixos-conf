{
  imports = [
    ./config/lang.nix
    ./config/network
    ./config/backup/borgbackup-home.nix
    ./config/nix/remotebuild/builder.nix
    ./config/nix/remotebuild/client.nix
    ./config/nix
    ./config/hardware-security-keys.nix
    ./config/print.nix
    ./config/sound.nix
    ./config/boot.nix
    ./config/shell.nix
    ./config/users.nix
    ./config/wireguard
    ./apps
  ];
}
