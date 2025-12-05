{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.robins-nixos.nix;
in
{
  options.robins-nixos.nix = {
    mydefaults = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable my default nix settings.";
      type = lib.types.bool;
    };
    auto-upgrade = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to automatically upgrade.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.mydefaults {
    # Enable flakes
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    nix.package = pkgs.lix;

    nix.settings = {
      max-silent-time =
        let
          minute = 60;
        in
        120 * minute;
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    system.autoUpgrade = lib.mkIf cfg.auto-upgrade {
      flake = "github:robinfinkelmann/nixos-conf";
      allowReboot = true;
      rebootWindow = {
        lower = "12:00";
        upper = "13:00";
      };
    };

    nix.optimise.automatic = true;

    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep 10 --keep-since 90d";
      };
    };
  };
}
