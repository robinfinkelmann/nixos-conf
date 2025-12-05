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
  config = lib.mkIf cfg.science {
    services.flatpak.enable = true;

    environment.systemPackages = [
      # Typesetting
      pkgs.texliveFull
      pkgs.typst
      pkgs.tinymist
      pkgs.typstyle

      # Mathematics
      pkgs.octave
    ]
    ++ lib.optionals cfg.gui [
      # CAD / 3D
      pkgs.kicad
      pkgs.freecad

      # Space Observation
      pkgs.kstars
      pkgs.indi-full # technically not gui
      pkgs.stellarium
    ];
  };
}
