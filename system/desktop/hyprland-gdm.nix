{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Replace kernel's fbcon with kmscon
  services.kmscon = {
    enable = true;
    hwRender = true;
    useXkbConfig = true;
  };

  services.displayManager = {
    gdm.enable = true;
  };

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  environment.sessionVariables = {
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };
  programs.nm-applet.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk # handles some interfaces that hyprland does not implement (namely org.freedesktop.portal.OpenURI)
    ];
    xdgOpenUsePortal = true;
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
