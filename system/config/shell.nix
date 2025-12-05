{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.robins-nixos.shell;
in
{
  options.robins-nixos.shell = {
    fish = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable fish.";
      type = lib.types.bool;
    };
  };

  config = {
    programs.fish.enable = cfg.fish;
  };
}
