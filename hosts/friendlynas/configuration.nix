# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  system,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Secrets
    ../../secrets

    # System config
    ../../system/robins-nixos.nix

    # Desktop
    ../../system/desktop/plasma-sddm.nix
  ];

  networking.hostName = "friendlynas"; # Define your hostname.
  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHb2OZsWnbgZXeubVub4BAIqz7F+F9R52QPjdz8iSrDp";

  robins-nixos.efiboot.enable = true;
  robins-nixos.hardware-security-keys.enable = true;
  robins-nixos.wireguard = {
    enable = true;
    address = "10.0.0.200/24";
    endpoint = "192.168.0.129:51820";
    endpointPublicKey = "zgdoxlAt2/b1B+TVeDcqomkaceqp+lODgFhVuKCJx2M=";
  };
  robins-nixos.apps = {
    dev = true;
  };

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "eab60804";
  boot.zfs.extraPools = [ "fast" ];

  services.nfs.server.enable = true;
  networking.firewall.allowedTCPPorts = [ 2049 ];

  hardware.enableRedistributableFirmware = true;
  hardware = {
    deviceTree = {
      enable = true;
      name = "rockchip/rk3588-friendlyelec-cm3588-nas.dtb";
      kernelPackage = pkgs.linux_latest;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
