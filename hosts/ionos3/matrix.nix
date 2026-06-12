{
  config,
  lib,
  pkgs,
  ...
}:
let
  fqdn =
    let
      join = hostName: domain: hostName + lib.optionalString (domain != null) ".${domain}";
    in
    join config.networking.hostName config.networking.domain;
  domain = "chat.finkelmann.net";
in
{
  security.acme.acceptTerms = true;
  networking.firewall.allowedTCPPorts = [
    80
    443
    29317
  ];
  services.nginx = {
    enable = true;
    # only recommendedProxySettings and recommendedGzipSettings are strictly required,
    # but the rest make sense as well
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts = {
      # This host section can be placed on a different host than the rest,
      # i.e. to delegate from the host being accessible as ${config.networking.domain}
      # to another host actually running the Matrix homeserver.
      ${domain} = {
        enableACME = true;
        forceSSL = true;

        # Or do a redirect instead of the 404, or whatever is appropriate for you.
        # But do not put a Matrix Web client here! See the Riot Web section below.
        locations."/".extraConfig = ''
          return 404;
        '';

        locations."= /.well-known/matrix/server".extraConfig =
          let
            # use 443 instead of the default 8448 port to unite
            # the client-server and server-server port for simplicity
            server = {
              "m.server" = "${domain}:443";
            };
          in
          ''
            add_header Content-Type application/json;
            return 200 '${builtins.toJSON server}';
          '';
        locations."= /.well-known/matrix/client".extraConfig =
          let
            client = {
              "m.homeserver" = {
                "base_url" = "https://${domain}";
              };
              "m.identity_server" = {
                "base_url" = "https://vector.im";
              };
            };
            # ACAO required to allow riot-web on any URL to request this json file
          in
          ''
            add_header Content-Type application/json;
            add_header Access-Control-Allow-Origin *;
            return 200 '${builtins.toJSON client}';
          '';
        # forward all Matrix API calls to the synapse Matrix homeserver
        locations."/_matrix" = {
          proxyPass = "http://[::1]:6167"; # without a trailing /
        };

      };

      ${fqdn} = {
        enableACME = true;
        forceSSL = true;

        # Or do a redirect instead of the 404, or whatever is appropriate for you.
        # But do not put a Matrix Web client here! See the Riot Web section below.
        locations."/".extraConfig = ''
          return 404;
        '';
      };
    };
  };
  services.matrix-continuwuity = {
    enable = true;
    settings = {
      global = {
        server_name = domain;
        #address = [
        #  "0.0.0.0"
        #];
      };
    };
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };
  };
  environment.systemPackages = [ pkgs.podman-compose ];
}
