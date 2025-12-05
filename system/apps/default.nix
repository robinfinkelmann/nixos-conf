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
  imports = [
    ./science.nix
    ./common.nix
    ./creative.nix
    ./radio.nix
    ./science.nix
    ./social.nix
    ./games/common.nix
    ./games/vr.nix
    ./dev/cli.nix
    ./dev/games.nix
    ./dev/gui.nix
  ];
  options.robins-nixos.apps = {
    science = lib.mkOption {
      default = false;
      example = true;
      description = "Whether to install Science Apps.";
      type = lib.types.bool;
    };
    radio = lib.mkOption {
      default = false;
      example = true;
      description = "Whether to install Radio Apps.";
      type = lib.types.bool;
    };
    creative = lib.mkOption {
      default = false;
      example = true;
      description = "Whether to install Creative Apps.";
      type = lib.types.bool;
    };
    social = lib.mkOption {
      default = false;
      example = true;
      description = "Whether to install Social Apps.";
      type = lib.types.bool;
    };
    games = lib.mkOption {
      default = false;
      example = true;
      description = "Whether to install Games.";
      type = lib.types.bool;
    };
    vr = lib.mkOption {
      default = false;
      example = true;
      description = "Whether to install VR Games.";
      type = lib.types.bool;
    };
    gui = lib.mkOption {
      default = false;
      example = true;
      description = "Whether to install GUI Apps.";
      type = lib.types.bool;
    };
    dev = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to install Development Apps.";
      type = lib.types.bool;
    };
  };

  config = {
  };
}
