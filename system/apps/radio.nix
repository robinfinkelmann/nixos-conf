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
  config = lib.mkIf cfg.radio {
    hardware.rtl-sdr.enable = true;
    environment.systemPackages = [
      pkgs.gqrx
      pkgs.gpredict
      pkgs.rtl-sdr
      pkgs.fldigi
      pkgs.chirp
      pkgs.uhd
      # pkgs.sdrangel # TODO does not build
      (pkgs.gnuradio.override {
        extraPackages = with pkgs.gnuradioPackages; [
          osmosdr
        ];
      })
      pkgs.spdlog
    ];

    services.udev.packages = [ pkgs.uhd ];

    services.udev.extraRules = ''
      # Crazyradio (normal operation)
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="7777", MODE="0664", GROUP="plugdev"
      # Crazyradio 2.0 (normal operation) TODO this is not documented anywhere, WTH?!?!?
      SUBSYSTEM=="usb", ATTRS{idVendor}=="35f0", ATTRS{idProduct}=="bad2", MODE="0664", GROUP="plugdev"
      # Bootloader
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="0101", MODE="0664", GROUP="plugdev"
      # Crazyflie (over USB)
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", MODE="0664", GROUP="plugdev"
    '';
    #services.udev.extraRules = ''
    #  #
    #  # Copyright 2011,2015 Ettus Research LLC
    #  # Copyright 2018 Ettus Research, a National Instruments Company
    #  #
    #  # SPDX-License-Identifier: GPL-3.0
    #  #
    #
    #  #USRP1
    #  SUBSYSTEMS=="usb", ATTRS{idVendor}=="fffe", ATTRS{idProduct}=="0002", MODE:="0666"
    #
    #    #B100
    #    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2500", ATTRS{idProduct}=="0002", MODE:="0666"#
    #
    #    #B200
    #    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2500", ATTRS{idProduct}=="0020", MODE:="0666"
    #    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2500", ATTRS{idProduct}=="0021", MODE:="0666"
    #    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2500", ATTRS{idProduct}=="0022", MODE:="0666"
    #    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3923", ATTRS{idProduct}=="7813", MODE:="0666"
    #    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3923", ATTRS{idProduct}=="7814", MODE:="0666"
    #  '';
  };
}
