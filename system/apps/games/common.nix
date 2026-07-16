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
  config = lib.mkIf (cfg.gui && cfg.games) {
    environment.systemPackages = [
      # Native
      pkgs.heroic
      pkgs.ryubing
      pkgs.cemu
      pkgs.dolphin-emu
      pkgs.prismlauncher
      pkgs.bottles
    ];

    programs.steam = {
      enable = true;
      extest.enable = true;
      remotePlay.openFirewall = true;
    };
  };
}
