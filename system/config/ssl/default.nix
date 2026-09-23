{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.robins-nixos.ssl;
in
{
  options.robins-nixos.ssl = {
    enable = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to install self-signed CA certificate";
      type = lib.types.bool;
    };
  };
  config = lib.mkIf cfg.enable {
    security.pki.certificateFiles = [ ./crts/local_ca.crt ];
  };
}
