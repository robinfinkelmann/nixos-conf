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

    # uniwue rovers
    services.udev.extraRules = ''
      SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", ATTRS{serial}=="FTHJPYW1", SYMLINK+="VMC"
      SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", ATTRS{serial}=="FTHJRKHP", SYMLINK+="xsens"
      SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", ATTRS{serial}=="FTGSEMAV", SYMLINK+="VMC"
      SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="a8b0", ATTR{serial}=="662080015707", SYMLINK+="EPOS2R", GROUP="users", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="a8b0", ATTR{serial}=="662080015698", SYMLINK+="EPOS2L", GROUP="users", MODE="0666"

      SUBSYSTEM=="usb", ATTR{idVendor}=="24e7", ATTR{idProduct}=="3b01", SYMLINK+="EPOS4", GROUP="users", MODE="0666"

      # ftdi rule for EPOS4 70/15
      SUBSYSTEMS=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="a8b0", GROUP="users", MODE="0666"
    '';

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
