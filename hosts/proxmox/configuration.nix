{
  pkgs,
  lib,
  config,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    # Secrets
    ../../secrets

    # System config
    ../../system/robins-nixos.nix
  ];

  system.stateVersion = "24.11";

  age.rekey.localStorageDir = lib.mkForce (./. + "/secrets/rekeyed"); # Needs to differ from other secret dirs because $(networking.hostname) is empty!

  networking.nameservers = [ "192.168.1.1" ];

  # Auto Update
  robins-nixos.nix.auto-upgrade = true;

  environment.systemPackages = [
    pkgs.vim
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  services.paperless = {
    enable = true;
    dataDir = "/mnt/paperless/data";
    mediaDir = "/mnt/paperless/media";
    consumptionDir = "/mnt/paperless/consume";
    consumptionDirIsPublic = true;
    address = "0.0.0.0";
    settings = {
      PAPERLESS_URL = "https://docs.finkelmann.net";
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
      ];
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
        continue_on_soft_render_error = true;
      };
      PAPERLESS_TASK_WORKERS = 4;
      PAPERLESS_THREADS_PER_WORKER = 1;
      PAPERLESS_FILENAME_FORMAT = "{created_year}/{correspondent}/{document_type}/{title}-{tag_list}";
    };
  };

  services.immich = {
    enable = true;
    host = "0.0.0.0";
    openFirewall = true;
    environment.IMMICH_MACHINE_LEARNING_URL = "http://localhost:3003";
  };

  # Reverse Proxy requests to priviledged ports
  services.traefik = {
    enable = true;

    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;
          #http.redirections.entrypoint = {
          #  to = "websecure";
          #  scheme = "https";
          #};
        };

        #websecure = {
        #  address = ":443";
        #  asDefault = true;
        #  http.tls.certResolver = "letsencrypt";
        #};
      };

      log = {
        level = "INFO";
        filePath = "${config.services.traefik.dataDir}/traefik.log";
        format = "json";
      };

      api.dashboard = true;
      # Access the Traefik dashboard on <Traefik IP>:8080 of your server
      api.insecure = true;
    };

    dynamicConfigOptions = {
      http.routers = {
        paperless = {
          rule = "Host(`docs.finkelmann.net`)";
          service = "paperless";
        };
        immich = {
          rule = "Host(`photos.finkelmann.net`)";
          service = "immich";
        };
      };
      http.services = {
        "paperless" = {
          loadBalancer = {
            servers = [
              {
                url = "http://localhost:${toString config.services.paperless.port}/";
              }
            ];
          };
        };
        "immich" = {
          loadBalancer = {
            servers = [
              {
                url = "http://localhost:${toString config.services.immich.port}/";
              }
            ];
          };
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    config.services.paperless.port
    80
    443
    8080
  ];
}
