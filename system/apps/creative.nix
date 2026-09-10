{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.robins-nixos.apps;
in
{
  config = lib.mkIf (cfg.gui && cfg.creative) {
    environment.systemPackages = [
      # Photo
      pkgs.gimp3

      # Video
      pkgs.obs-studio
      pkgs.kdePackages.kdenlive
      #pkgs.davinci-resolve
      pkgs.handbrake
    ];
  };
}
