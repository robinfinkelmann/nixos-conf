{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

let
  cfg = config.robins-nixos.apps;
in
{
  config = lib.mkMerge [
    {
      environment.systemPackages = [
        # Make all fanpeople angry at the same time
        pkgs.nano
        pkgs.vim
        pkgs.helix

        pkgs.wget
        pkgs.btop
        pkgs.nixfmt-rfc-style
        pkgs.nixpkgs-fmt
        pkgs.usbutils
        pkgs.nix-output-monitor
        pkgs.nix-tree
        pkgs.smartmontools
        pkgs.nmap
        pkgs.tmux
        pkgs.ntfs3g
        pkgs.exfat
        pkgs.dua
        pkgs.duf
        pkgs.ffmpeg
        pkgs.file
        pkgs.util-linux
      ];

      programs.git = {
        enable = true;
        lfs.enable = true;
      };

      # Fonts
      fonts.packages = [
        pkgs.comfortaa
        pkgs.roboto
        pkgs.roboto-mono
        pkgs.roboto-slab
        pkgs.roboto-serif
        pkgs.inter
      ]
      ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

      # Theme
      stylix.enable = true;
      stylix.polarity = "dark";
      # Photo "asphalt road and cliff horizon" by Rory Hennessey on Unsplash: https://unsplash.com/photos/asphalt-road-and-cliff-horizon-PBrovES5uuI
      # See ./wallpapers/README.md
      stylix.image = ./wallpapers/rory-hennessey-PBrovES5uuI-unsplash.jpg;
      stylix.cursor.package = pkgs.bibata-cursors;
      stylix.cursor.name = "Bibata-Modern-Classic";
      stylix.cursor.size = 32;
    }
    (lib.mkIf cfg.gui {
      environment.systemPackages = [
        # Media
        pkgs.vlc
        pkgs.kdePackages.gwenview
        pkgs.drawio

        # Web
        pkgs.firefox
        pkgs.thunderbird
        pkgs.chromium
        pkgs.tor-browser

        # PDF
        pkgs.pdfmixtool
        # pkgs.gscan2pdf # TODO does not pass check
        pkgs.simple-scan
        pkgs.kdePackages.okular

        # Office
        pkgs.libreoffice-qt
        pkgs.hunspell
        pkgs.hunspellDicts.de_DE
        pkgs.hunspellDicts.en_US

        # Files
        pkgs.nextcloud-client
        pkgs.obsidian
        pkgs.keepassxc
        pkgs.kdePackages.filelight
        pkgs.kdePackages.ark

        # Other
        pkgs.tigervnc
        pkgs.freerdp
        # pkgs.winboat # TODO does not build https://github.com/NixOS/nixpkgs/issues/462513
      ];

      programs.noisetorch.enable = true;

      programs.ausweisapp = {
        enable = true;
        openFirewall = true;
      };
    })
  ];
}
