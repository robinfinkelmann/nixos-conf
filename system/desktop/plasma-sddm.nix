{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.xserver.enable = true;
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "minesddm";
    };
  };

  services.desktopManager.plasma6.enable = true;

  programs.kdeconnect.enable = true;
}
