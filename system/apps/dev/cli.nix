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
    environment.systemPackages = [ pkgs.android-tools ];

    # This driver apparently also handles some generic FTDI devices
    services.upower.enableWattsUpPro = true;

    services.udev.packages = [
      pkgs.platformio-core.udev
      pkgs.openocd
    ];

    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="c0ca", MODE="0664", GROUP="plugdev"
    '';
  };
}
