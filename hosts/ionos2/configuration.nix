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
  ];

  networking = {
    hostName = "ionos2"; # Define your hostname.
    domain = "finkelmann.net";
  };
  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINsLONTh6ebkz71f+V40OTnwcemTzr3ImgXe1GK8q/cS";

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
