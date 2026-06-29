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
      #pkgs.heroic # TODO insecure
      pkgs.ryubing
      pkgs.cemu
      #pkgs.dolphin-emu # TODO broken
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
