{
  pkgs,
  lib,
  config,
  ...
}:

{
  age.secrets.ssl-key-photos = {
    rekeyFile = ./photos.finkelmann.net.key.age;
    owner = "nginx";
    group = "nginx";
  };

  services.immich = {
    enable = true;
    host = "localhost";
    environment.IMMICH_MACHINE_LEARNING_URL = "http://localhost:3003";
    mediaLocation = "/fast/immich";
    settings = null; # TODO export config to here
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "photos.finkelmann.net" = {
        forceSSL = true;
        sslCertificate = ./photos.finkelmann.net.crt;
        sslCertificateKey = config.age.secrets.ssl-key-photos.path;
        locations."/".proxyPass =
          "http://${config.services.immich.host}:${toString config.services.immich.port}";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
