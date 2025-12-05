{
  config,
  pkgs,
  inputs,
  ...
}:

let
  hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  xdg-desktop-portal-hyprland =
    inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
in
{
  services.displayManager = {
    gdm.enable = true;
  };

  # Enable Hyprland
  programs.hyprland = {
    # Install the packages from nixpkgs
    enable = true;
    # Whether to enable XWayland (default true)
    xwayland.enable = true;
    # set the flake package
    package = hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = xdg-desktop-portal-hyprland;
  };
  environment.sessionVariables = {
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };
  programs.nm-applet.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  security.pam.services.hyprlock = { };
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm-password.enableGnomeKeyring = true;
  # enables trash
  services.gvfs.enable = true;
  # waybar icons
  fonts.packages = with pkgs; [
    font-awesome
  ];
  # power-profiles-daemon
  services.power-profiles-daemon.enable = true;

  environment.systemPackages = [
    pkgs.dunst
    pkgs.libnotify # maybe unnecessary
    pkgs.hyprpaper
    #pkgs.swww
    pkgs.kitty
    pkgs.wofi
    pkgs.grimblast
    #pkgs.brightnessctl
    #pkgs.playerctl
  ];

  #services.blueman.enable = true;

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
