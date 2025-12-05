# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Secrets
    ../../secrets

    # System config
    ../../system/robins-nixos.nix

    # Desktop
    ../../system/desktop/hyprland-gdm.nix

    # Syncthing
    ../../system/config/syncthing.nix

    # NVIDIA drivers
    ./nvidia.nix
  ];

  networking.hostName = "nix-desktop"; # Define your hostname.
  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBPMF8UQEP29KpH9RVZdSh5GZkTj9JY/Tmk1Zyz7w5gR";

  robins-nixos.lang.keyboardLayout = "de";
  robins-nixos.networking.openconnect = true;
  robins-nixos.backup.enable = true;
  robins-nixos.sound.enable = true;
  robins-nixos.printing.enable = true;
  robins-nixos.nix.remotebuild.builder.enable = true;
  robins-nixos.hardware-security-keys.enable = true;

  robins-nixos.wireguard = {
    enable = true;
    fileSystems = true;
    address = "10.0.0.10/24";
    endpoint = "192.168.0.129:51820";
    endpointPublicKey = "zgdoxlAt2/b1B+TVeDcqomkaceqp+lODgFhVuKCJx2M=";
  };

  robins-nixos.apps = {
    radio = true;
    games = true;
    vr = true;
    social = true;
    dev = true;
    gui = true;
    science = true;
    creative = true;
  };

  hardware.bluetooth.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.mutableUsers = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
  ];

  virtualisation.docker.enable = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
