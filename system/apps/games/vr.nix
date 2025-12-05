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
  config = lib.mkIf (cfg.gui && cfg.games && cfg.vr) {
    environment.systemPackages = [
      pkgs.monado-vulkan-layers
      #pkgs.bs-manager
    ];

    #programs.alvr = {
    #  enable = true;
    #  openFirewall = true;
    #};

    services.wivrn = {
      enable = true;
      package = pkgs.wivrn.override { cudaSupport = true; };
      openFirewall = true;

      # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
      # will automatically read this and work with WiVRn (Note: This does not currently
      # apply for games run in Valve's Proton)
      defaultRuntime = true;

      # Run WiVRn as a systemd service on startup
      autoStart = false;

      # Config for WiVRn (https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md)
      #config = {
      #  enable = true;
      #  json = {
      #    # 1.0x foveation scaling
      #    scale = 1.0;
      #    # 100 Mb/s
      #    bitrate = 100000000;
      #    encoders = [{
      #      encoder = "vaapi";
      #      codec = "h265";
      #      # 1.0 x 1.0 scaling
      #      width = 1.0;
      #      height = 1.0;
      #      offset_x = 0.0;
      #      offset_y = 0.0;
      #    }];
      #  };
      #};
    };

    #nixpkgs.overlays =
    #  let
    #    newpkgs =
    #      import
    #        (builtins.fetchTarball {
    #          url = "https://github.com/NixOS/nixpkgs/archive/abec03b635287cfb8ab2b3f9ecfceaefb2b4132f.tar.gz";
    #          sha256 = "11569zqsvnk4prp3vv58lf1lpijbf319xnp9qdjjrninl1w6h0ib";
    #        })
    #        {
    #          config = config.nixpkgs.config;
    #          system = pkgs.stdenv.hostPlatform.system;
    #        };
    #  in
    #  [
    #    (self: super: {
    #      wivrn = newpkgs.wivrn.override { cudaSupport = true; };
    #      #wivrn = super.wivrn.override { cudaSupport = true; };
    #    })
    #  ];

    hardware.graphics.extraPackages = [ pkgs.monado-vulkan-layers ];

    #services.udev.packages = [
    #  (pkgs.writeTextFile {
    #    name = "50-oculus.rules";
    #    text = ''
    #      SUBSYSTEM="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0186", MODE="0660" group="plugdev", symlink+="ocuquest%n"
    #    '';
    #    destination = "/etc/udev/rules.d/50-oculus.rules";
    #  })
    #  (pkgs.writeTextFile {
    #    name = "52-android.rules";
    #    text = ''
    #      SUBSYSTEM=="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0186", MODE="0666", OWNER=robin;
    #    '';
    #    destination = "/etc/udev/rules.d/52-android.rules";
    #  })
    #];

    #networking.firewall.allowedUDPPorts = [
    #  67
    #  68
    #];
  };
}
