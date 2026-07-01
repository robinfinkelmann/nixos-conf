{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.robins-nixos.virtualisation;
in
{
  options.robins-nixos.virtualisation = {
    enable = lib.mkEnableOption "Virtualisation";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.distrobox
    ];

    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
}
