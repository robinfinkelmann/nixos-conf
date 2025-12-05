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
  config = lib.mkIf (cfg.gui && cfg.dev) {
    environment.systemPackages = [
      pkgs.vscode

      pkgs.gparted

      pkgs.virtiofsd
      #pkgs.vagrant

      pkgs.saleae-logic-2

      pkgs.kdePackages.krdc
    ];

    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    programs.virt-manager.enable = true;

    virtualisation.virtualbox.host.enable = true;
    #virtualisation.virtualbox.host.enableExtensionPack = true;

    hardware.saleae-logic.enable = true;
  };
}
