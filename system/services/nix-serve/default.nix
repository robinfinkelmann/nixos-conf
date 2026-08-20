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

  services.nix-serve = {
    enable = true;

    # Note: You don't need to give nix-serve ownership of the file because systemd reads it.
    secretKeyFile = config.age.secrets.nix-serve-signing-key.path;
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      # ... existing hosts config etc. ...
      "cache.finkelmann.net" = {
        locations."/".proxyPass =
          "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];
}
