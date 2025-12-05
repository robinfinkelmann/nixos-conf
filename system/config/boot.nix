{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.robins-nixos.efiboot;
in
{
  options.robins-nixos.efiboot = {
    enable = lib.mkEnableOption "Enable Boot Config with Efi";
    systemd-boot = {
      enable = lib.mkOption {
        default = true;
        example = false;
        description = "Whether to enable systemd-boot.";
        type = lib.types.bool;
      };
      netbootxyz = lib.mkOption {
        default = cfg.systemd-boot.enable;
        example = false;
        description = "Whether to enable netbootxyz in systemd-boot.";
        type = lib.types.bool;
      };
    };
    grub = {
      enable = lib.mkOption {
        default = false;
        example = true;
        description = "Whether to enable grub.";
        type = lib.types.bool;
      };
      minecraft-theme = lib.mkOption {
        default = cfg.grub.enable;
        example = false;
        description = "Whether to enable the grub minecraft theme.";
        type = lib.types.bool;
      };
    };
    memtest86 = lib.mkOption {
      default = pkgs.stdenv.hostPlatform.system == "x86_64-linux";
      example = false;
      description = "Whether to enable the memtest86 in the boot menu.";
      type = lib.types.bool;
    };
  };
  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot = {
      enable = cfg.systemd-boot.enable;
      netbootxyz.enable = cfg.systemd-boot.netbootxyz;
      memtest86.enable = cfg.memtest86;
    };
    boot.loader.grub = {
      enable = cfg.grub.enable;
      device = "nodev";
      efiSupport = true;
      theme = lib.mkIf (!cfg.grub.minecraft-theme) "pkgs.nixos-grub2-theme";
      memtest86.enable = true;
      minegrub-theme = lib.mkIf cfg.grub.minecraft-theme {
        enable = true;
        splash = "100% Flakes!";
        background = "background_options/1.8  - [Classic Minecraft].png";
        boot-options-count = 4;
      };
    };
    boot.loader.efi.canTouchEfiVariables = true;
    services.fwupd.enable = true;
  };
}
