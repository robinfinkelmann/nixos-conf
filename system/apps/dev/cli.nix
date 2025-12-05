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
  config = lib.mkIf cfg.dev {
    programs.adb.enable = true;

    # This driver apparently also handles some generic FTDI devices
    services.upower.enableWattsUpPro = true;
  };
}
