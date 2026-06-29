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
  config = lib.mkIf (cfg.gui && cfg.social) {
    environment.systemPackages = [
      # Messages
      pkgs.telegram-desktop
      #pkgs.signal-desktop TODO insecure
      pkgs.fluffychat

      # Voice Chat
      pkgs.discord
      pkgs.discover-overlay

      # Music
      pkgs.high-tide
    ];
  };
}
