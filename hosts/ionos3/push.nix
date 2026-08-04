{
  config,
  lib,
  pkgs,
  ...
}:
let
  url = "push.finkelmann.net";
  port = "8080";
in
{
  services.nginx = {
    virtualHosts = {
      ${url} = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://[::1]:${port}";
        };
      };
    };
  };
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://${url}";
      listen-http = ":${port}";
    };
  };
}
