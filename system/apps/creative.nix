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
      pkgs.inkscape

      # Video
      pkgs.obs-studio
      pkgs.kdePackages.kdenlive
      #pkgs.davinci-resolve
      pkgs.handbrake

      # DAW
      pkgs.ardour
      pkgs.tenacity
      pkgs.klick
      pkgs.qpwgraph

      # Audio plugins (LV2, VST2, VST3, LADSPA)
      # distrho # does not exist anymore?
      pkgs.calf
      pkgs.eq10q
      pkgs.lsp-plugins
      pkgs.x42-plugins
      pkgs.x42-gmsynth
      pkgs.dragonfly-reverb
      pkgs.guitarix
      pkgs.fil-plugins
      pkgs.geonkick

      # Support for Windows VST2/VST3 plugins
      pkgs.yabridge
      pkgs.yabridgectl
      pkgs.wineWowPackages.stable
    ];
  };
}
