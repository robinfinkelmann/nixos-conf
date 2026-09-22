{
  pkgs,
  lib,
  config,
  ...
}:

{
  services.hydra = {
    enable = true;
    hydraURL = "http://hydra.finkelmann.net";
    notificationSender = "hydra@localhost";
    useSubstitutes = true;
  };
  nix.settings.allowed-uris = [
    "github:"
    "git+https://github.com/"
    "git+ssh://github.com/"
  ];
  nix.buildMachines = [
    {
      hostName = "localhost";
      protocol = null;
      system = "aarch64-linux";
      supportedFeatures = [
        "kvm"
        "nixos-test"
        "big-parallel"
        "benchmark"
      ];
      maxJobs = 8;
    }
    {
      hostName = "localhost";
      protocol = null;
      system = "x86_64-linux";
      supportedFeatures = [
        "kvm"
        "nixos-test"
        "big-parallel"
        "benchmark"
      ];
      maxJobs = 8;
    }
  ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "hydra.finkelmann.net" = {
        locations."/".proxyPass = "http://localhost:${toString config.services.hydra.port}";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];
}
