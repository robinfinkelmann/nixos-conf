{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.robins-nixos.sound;
in
{
  options.robins-nixos.sound = {
    enable = lib.mkEnableOption "Sound";
  };
  config = lib.mkIf cfg.enable {
    # rtkit (optional, recommended) allows Pipewire to use the realtime scheduler for increased performance.
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      #alsa.enable = true;
      #alsa.support32Bit = true;
      #pulse.enable = true;
      jack.enable = true;
    };
  };
}
