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
  config = lib.mkIf (cfg.gui && cfg.games && cfg.dev) {
    environment.systemPackages = [
      (pkgs.unityhub.override { extraPkgs = pkgs: [ pkgs.vulkan-loader ]; })
      pkgs.blender
      pkgs.krita
      pkgs.github-desktop
      pkgs.dotnet-sdk_8
    ];
  };
}
