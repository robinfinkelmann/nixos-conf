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
    ../../system/config/network/easyroam.nix # TODO imported only here because otherwise every host (???) required an agenix secret for easyroam

    # Desktop
    ../../system/desktop/hyprland-gdm.nix

    #../../system/apps/custom/slp.nix

    # Syncthing
    ../../system/config/syncthing.nix
  ];

  networking.hostName = "nix-laptop"; # Define your hostname.
  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFA2Zi2volmT8uSamcns/nJGs5lq4Mj8eZVH0NAhKu1Z";

  # NixOS
  robins-nixos.networking.openconnect = true;
  robins-nixos.backup.enable = true;
  robins-nixos.sound.enable = true;
  robins-nixos.printing.enable = true;
  robins-nixos.nix.remotebuild.builder.enable = true;
  #robins-nixos.nix.remotebuild.client = {
  #  enable = true;
  #  builder-hostname = "10.0.0.10";
  #};
  robins-nixos.hardware-security-keys.enable = true;
  robins-nixos.wireguard = {
    enable = true;
    fileSystems = true;
    address = "10.0.0.21/24";
  };
  robins-nixos.apps = {
    radio = true;
    games = true;
    social = true;
    dev = true;
    gui = true;
    science = true;
    creative = true;
  };

  hardware.bluetooth.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  virtualisation.docker.enable = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
