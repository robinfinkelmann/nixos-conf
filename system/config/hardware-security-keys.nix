{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.robins-nixos.hardware-security-keys;
in
{
  options.robins-nixos.hardware-security-keys = {
    enable = lib.mkEnableOption "Hardware Security Keys";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.yubikey-manager
      pkgs.yubioath-flutter
      pkgs.yubikey-personalization
      pkgs.yubioath-flutter
      pkgs.nitrokey-app2
      pkgs.pynitrokey
      #pkgs.onlykey # TODO not working? and nwjs is not available on aarch
      #pkgs.onlykey-cli # TODO insecure python3.13-ecdsa-0.19.1
      #pkgs.onlykey-agent # TODO insecure python3.13-ecdsa-0.19.1
    ];
    services.udev.packages = [ pkgs.yubikey-personalization ];
    hardware.onlykey.enable = true;
    hardware.nitrokey.enable = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    security.pam.services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };

    # Lock the screen when unplugging Yubikey
    #services.udev.extraRules = ''
    #  ACTION=="remove",\
    #   ENV{ID_BUS}=="usb",\
    #   ENV{ID_MODEL_ID}=="0407",\
    #   ENV{ID_VENDOR_ID}=="1050",\
    #   ENV{ID_VENDOR}=="Yubico",\
    #   RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
    #  ACTION=="remove",\
    #   ENV{ID_BUS}=="usb",\
    #   ENV{ID_MODEL_ID}=="42b2",\
    #   ENV{ID_VENDOR_ID}=="20a0",\
    #   ENV{ID_VENDOR}=="Clay Logic",\
    #   RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
    #'';
  };
}
