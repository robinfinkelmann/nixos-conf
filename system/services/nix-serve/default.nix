{
  pkgs,
  lib,
  config,
  ...
}:

{
  age.secrets = {
    nix-serve-signing-key = {
      rekeyFile = ./signing-key.age;
      generator = {
        script = "nix";
        tags = [
          "cache"
          "${config.networking.hostName}"
        ];
      };
      settings.key-name = "cache.finkelmann.net";
    };
  };
  age.secrets.ssl-key-cache = {
    rekeyFile = ./cache.finkelmann.net.key.age;
    owner = "nginx";
    group = "nginx";
  };

  services.nix-serve = {
    enable = true;

    # Note: You don't need to give nix-serve ownership of the file because systemd reads it.
    secretKeyFile = config.age.secrets.nix-serve-signing-key.path;
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    eventsConfig = "worker_connections 20000;";
    virtualHosts = {
      "cache.finkelmann.net" = {
        addSSL = true;
        sslCertificate = ./cache.finkelmann.net.crt;
        sslCertificateKey = config.age.secrets.ssl-key-cache.path;
        locations."/".proxyPass =
          "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
