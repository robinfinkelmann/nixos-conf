{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.robins-nixos.printing;
in
{
  options.robins-nixos.printing = {
    enable = lib.mkEnableOption "Printing";
  };
  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
    services.printing.drivers = [ pkgs.samsung-unified-linux-driver ];

    # Does not seem to be necessary?!?
    #hardware.sane.enable = true; # enables support for SANE scanners
    #ardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];
  };
}
