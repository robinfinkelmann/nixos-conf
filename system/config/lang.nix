{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.robins-nixos.lang;
in
{
  options.robins-nixos.lang = {
    keyboardLayout = lib.mkOption {
      type = lib.types.enum [
        "de"
        "en"
      ];
      default = "en";
      example = "de";
      description = ''
        The desired Keyboard Layout.
      '';
    };
  };

  config = {
    time.timeZone = "Europe/Berlin";

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };

    # Configure keymap in WM
    services.xserver.xkb = lib.mkMerge [
      (lib.mkIf (cfg.keyboardLayout == "de") {
        layout = "de";
        variant = "";
      })
      (lib.mkIf (cfg.keyboardLayout == "en") {
        layout = "us";
        variant = "intl";
      })
    ];

    # Configure console keymap
    console.useXkbConfig = true; # use xkbOptions in tty.
  };
}
