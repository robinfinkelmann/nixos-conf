{
  modulesPath,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disk-config.nix
    ./hardware-configuration.nix

    # Secrets
    ../../secrets

    # System config
    ../../system/robins-nixos.nix

    # Matrix
    ./matrix.nix
    ./push.nix
  ];

  networking = {
    hostName = "ionos3"; # Define your hostname.
    domain = "finkelmann.net";
  };
  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGv6zZsS1ZPARaQ5NOK5Z08z9wwTQTTZQXj1LVYTkiXE";

  robins-nixos.apps.defaultApps = false; # save disk space
  robins-nixos.wireguard = {
    enable = true;
    address = "10.0.0.4/24";
  };

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  # Auto Update
  robins-nixos.nix.auto-upgrade = true;

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 1 * 1024;
    }
  ];

  system.stateVersion = "26.05";
}
