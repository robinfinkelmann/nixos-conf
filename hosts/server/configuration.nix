{
  modulesPath,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix

    # Secrets
    ../../secrets

    # System config
    ../../system/robins-nixos.nix
  ];
  robins-nixos.apps.defaultApps = false; # save disk space

  networking = {
    hostName = "server"; # Define your hostname.
    domain = "finkelmann.net";
  };
  #age.rekey.hostPubkey = "";

  robins-nixos.wireguard = {
    enable = true;
    address = "10.0.0.100/24";
  };

  # Auto Update
  robins-nixos.nix.auto-upgrade = true;

  system.stateVersion = "26.05";
}
