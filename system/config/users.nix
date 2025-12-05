{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.robins-nixos.users;
in
{
  config = {
    users.users.robin = {
      uid = 1000;
      isNormalUser = true;
      hashedPassword = lib.mkDefault "$y$j9T$AxJE3MhHyeqszCLDAs7O40$o/OXrGUblqmB5r9kJdUYMUSEAzTH1Rney34QOkVedeB";
      description = "robin";
      extraGroups = [
        "networkmanager"
        "wheel"
        "plugdev"
        "dialout"
        "libvirtd"
        "vboxusers"
        "adbusers"
        "docker"
      ];
      packages = [ ];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFSc/+2oA2KJZh0pJnZCTvDUf1Ji6oRt/h7TnGR/hP0bAAAAD3NzaDpyb2Jpbi1uaXRybw== ssh:robin-nitro"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIC2ofY861X+o2tP6F1N0Tvuw8u4ImUSxuP+f/fteu+L9AAAABHNzaDo= ssh:robin-yubi1"
      ];
    };
  };
}
