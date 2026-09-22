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
    # Stylix requires allow-import-from-derivation to be enabled. TODO maybe investigate how to improve this
    extraConfig = ''
      allow_import_from_derivation = true
      <git-input>
        timeout = 3600
      </git-input>
    '';
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
