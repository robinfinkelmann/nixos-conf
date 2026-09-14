{
  pkgs,
  lib,
  config,
  ...
}:

{
  age.secrets."easyroam-${config.networking.hostName}-p12".rekeyFile =
    ./easyroam-${config.networking.hostName}.p12.age;

  services.easyroam = {
    enable = true;
    pkcsFile = config.age.secrets."easyroam-${config.networking.hostName}-p12".path; # or e.g. config.sops.secrets.easyroam.path
    networkmanager = lib.mkIf config.networking.networkmanager.enable {
      enable = true;
    };
  };
}
