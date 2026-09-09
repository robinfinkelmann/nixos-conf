{
  config,
  lib,
  pkgs,
  ...
}:
let
  url = "cache.finkelmann.net";
in
{
  services.nginx = {
    enable = true;

    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts = {
      ${url} = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://10.0.0.200";
          proxyWebsockets = true;
        };
      };
    };
  };
}
