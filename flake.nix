{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    minegrub-theme.url = "github:Lxtharia/minegrub-theme";

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
      nixos-hardware,
      agenix,
      agenix-rekey,
      home-manager,
      flake-utils,
      disko,
      stylix,
      minegrub-theme,
      nix-easyroam,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ agenix-rekey.overlays.default ];
      };
      #pkgs-stable = import nixpkgs-stable {
      #  inherit system;
      #  config.allowUnfree = true;
      #  overlays = [ agenix-rekey.overlays.default ];
      #};
      defaultModules = [
        agenix.nixosModules.default
        agenix-rekey.nixosModules.default
        minegrub-theme.nixosModules.default
        stylix.nixosModules.stylix
      ];
    in
    {
      nixosConfigurations = {
        default = self.outputs.nixosConfigurations.nix-laptop;
        nix-laptop = nixpkgs.lib.nixosSystem rec {
          specialArgs = {
            inherit inputs;
            #inherit pkgs-stable;
            inherit agenix;
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

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
            }
            #minesddm.nixosModules.default
            nix-easyroam.nixosModules.nix-easyroam
          ];
        };
        friendlynas = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs;
            #inherit pkgs-stable;
          };
          modules = defaultModules ++ [
            ./hosts/friendlynas/configuration.nix
          ];
        };
        nix-prox = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = defaultModules ++ [
            ./hosts/proxmox/configuration.nix
          ];
        };
        ionos2 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = defaultModules ++ [
            disko.nixosModules.disko
            { disko.devices.disk.disk1.device = "/dev/vda"; }
            ./hosts/ionos2/configuration.nix
          ];
        };
        nix-desktop = nixpkgs.lib.nixosSystem rec {
          specialArgs = {
            inherit inputs;
            #inherit pkgs-stable;
            inherit agenix;
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
            #minesddm.nixosModules.default
          ];
        };
      };

      # Expose the necessary information in your flake so agenix-rekey
      # knows where it has to look for secrets and paths.
      # Make sure that the pkgs passed here comes from the same nixpkgs version as
      # the pkgs used on your hosts in `nixosConfigurations`, otherwise the rekeyed
      # derivations will not be found!
      agenix-rekey = agenix-rekey.configure {
        userFlake = self;
        nixosConfigurations = self.nixosConfigurations;
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.nh
          pkgs.lix
          pkgs.nix-tree
          pkgs.nixd
          pkgs.git
          pkgs.agenix-rekey
          pkgs.age-plugin-fido2-hmac
        ];
        shellHook = ''
          echo "Hello there! This is robin's NixOS-configuration shell!"
        '';
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
