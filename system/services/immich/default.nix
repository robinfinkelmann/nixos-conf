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
        locations."/" = {
          proxyPass = "http://[::1]:${toString config.services.immich.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
          '';
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
