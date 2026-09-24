{
  pkgs,
  lib,
  config,
  ...
}:

{
  age.secrets.ssl-key-bitwarden = {
    rekeyFile = ./bitwarden.finkelmann.net.key.age;
    owner = "nginx";
    group = "nginx";
  };

  services.vaultwarden = {
    enable = true;
    backupDir = "/fast/vaultwarden/backup";
    # in order to avoid having  ADMIN_TOKEN in the nix store it can be also set with the help of an environment file
    # be aware that this file must be created by hand (or via secrets management like sops or agenix)
    # environmentFile = "/fast/vaultwarden/vaultwarden.env";
    config = {
      # Refer to https://github.com/dani-garcia/vaultwarden/blob/main/.env.template
      DOMAIN = "https://bitwarden.finkelmann.net";
      SIGNUPS_ALLOWED = false;

      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "bitwarden.finkelmann.net" = {
        forceSSL = true;
        sslCertificate = ./bitwarden.finkelmann.net.crt;
        sslCertificateKey = config.age.secrets.ssl-key-bitwarden.path;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
          proxyWebsockets = true;
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
