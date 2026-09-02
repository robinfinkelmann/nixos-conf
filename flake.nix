{
  description = "Nixos config flake";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-compat.url = "github:edolstra/flake-compat";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-easyroam = {
      url = "github:0x5a4/nix-easyroam";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      #nixpkgs-stable,
      flake-parts,
      nixos-hardware,
      agenix,
      agenix-rekey,
      home-manager,
      flake-utils,
      disko,
      stylix,
      nix-easyroam,
      ...
    }:
    # https://flake.parts/module-arguments.html
    flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        config,
        withSystem,
        moduleWithSystem,
        ...
      }:
      {
        imports = [
          inputs.agenix-rekey.flakeModule
        ];
        flake = {
          #agenix-rekey = agenix-rekey.configure {
          #  userFlake = self;
          #  nixosConfigurations = self.nixosConfigurations;
          #};

          nixosConfigurations =
            let
              defaultModules = [
                agenix.nixosModules.default
                agenix-rekey.nixosModules.default
                stylix.nixosModules.stylix
              ];
            in
            {
              default = self.outputs.nixosConfigurations.laptop;
              laptop = nixpkgs.lib.nixosSystem rec {
                specialArgs = {
                  inherit inputs;
                };
                modules = defaultModules ++ [
                  ./hosts/laptop/configuration.nix
                  nixos-hardware.nixosModules.framework-12th-gen-intel
                  home-manager.nixosModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.backupFileExtension = "backup";
                    home-manager.users.robin = import ./home/robin.nix;
                    home-manager.extraSpecialArgs = {
                      inherit inputs;
                    };
                  }
                  nix-easyroam.nixosModules.nix-easyroam
                ];
              };
              friendlynas = nixpkgs.lib.nixosSystem {
                specialArgs = {
                  inherit inputs;
                };
                modules = defaultModules ++ [
                  ./hosts/friendlynas/configuration.nix
                ];
              };
              nix-prox = nixpkgs.lib.nixosSystem {
                modules = defaultModules ++ [
                  ./hosts/proxmox/configuration.nix
                ];
              };
              ionos3 = nixpkgs.lib.nixosSystem {
                modules = defaultModules ++ [
                  disko.nixosModules.disko
                  { disko.devices.disk.disk1.device = "/dev/vda"; }
                  ./hosts/ionos3/configuration.nix
                ];
              };
              desktop = nixpkgs.lib.nixosSystem rec {
                specialArgs = {
                  inherit inputs;
                };
                modules = defaultModules ++ [
                  ./hosts/desktop/configuration.nix
                  nixos-hardware.nixosModules.common-cpu-amd
                  nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
                  nixos-hardware.nixosModules.common-pc
                  nixos-hardware.nixosModules.common-pc-ssd
                  home-manager.nixosModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.backupFileExtension = "backup";
                    home-manager.users.robin = import ./home/robin.nix;

                    # Optionally, use home-manager.extraSpecialArgs to pass
                    # arguments to home.nix
                    home-manager.extraSpecialArgs = {
                      inherit inputs;
                    };
                  }
                ];
              };
            };
        };
        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "riscv64-linux"
        ];
        perSystem = { config, pkgs, ... }: {
          devShells.default = pkgs.mkShell {
            buildInputs = [
              pkgs.nh
              pkgs.lix
              pkgs.nix-tree
              pkgs.nixd
              pkgs.git
              config.agenix-rekey.package
              pkgs.age-plugin-fido2-hmac
            ];
            shellHook = ''
              echo "Hello there! This is robin's NixOS-configuration shell!"
            '';
          };

          formatter = pkgs.nixfmt-tree;
        };
      }
    );
}
