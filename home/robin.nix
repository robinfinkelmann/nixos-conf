{
  osConfig,
  pkgs,
  lib,
  config,
  options,
  inputs,
  ...
}:

{
  imports = [
    ./modules/hyprland.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "robin";
  home.homeDirectory = "/home/robin";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  home.shellAliases = {
    cat = "bat";
    cd = "z";
    #ls = "ls -l";
    df = "duf";
    du = "dua i";
    grep = "rg";
  };

  # Extra packages
  home.packages = [
    pkgs.duf
    pkgs.dua
  ];

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    fish = {
      enable = true;
      shellInitLast = "fastfetch";
    };
    starship = {
      enable = true;
    };
    eza = {
      enable = true;
      git = true;
      icons = "auto";
    };
    fd.enable = true;
    bat.enable = true;
    btop.enable = true;
    ripgrep.enable = true;
    ripgrep-all.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    helix.enable = true;
    emacs = {
      enable = true;
      package = pkgs.emacs-nox;
    };
    zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "latex"
        "typst"
      ];
    };

    mpv.enable = true;
    kitty.enable = true;
    zoxide.enable = true;
    fastfetch.enable = true;
    lazydocker.enable = true;
    lazygit.enable = true;

    git = {
      enable = true;
      settings = {
        user.name = "Robin Finkelmann";
        user.email = "robin.finkelmann@gmail.com";
      };
    };
    delta = {
      enable = true;
      enableGitIntegration = true;
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      includes = [ "config.secret" ];
      matchBlocks = {
        "*" = {
          identityAgent = "none"; # TODO workaround to fix ssh, pls investigate agent not working
          identityFile = "~/.ssh/id_ed25519_sk_rk_robin-yubi1";
          identitiesOnly = true;
        };
      };
    };

    vscode = {
      enable = true;
      #  extensions = [
      #    pkgs.vscode-extensions.rust-lang.rust-analyzer
      #    pkgs.vscode-extensions.ms-vscode.cpptools
      #    pkgs.vscode-extensions.ms-python.python
      #    pkgs.vscode-extensions.devsense.phptools-vscode
      #    pkgs.vscode-extensions.ms-vscode.cpptools
      #    pkgs.vscode-extensions.ms-vscode.cpptools
      #  ];
    };
  };

  # For WiVRn:
  xdg.configFile."openxr/1/active_runtime.json".enable = osConfig.services.wivrn.enable;
  xdg.configFile."openxr/1/active_runtime.json".source =
    "${pkgs.wivrn}/share/openxr/1/openxr_wivrn.json";
  xdg.configFile."openvr/openvrpaths.vrpath".enable = osConfig.services.wivrn.enable;
  xdg.configFile."openvr/openvrpaths.vrpath".text = ''
    {
      "config" :
      [
        "${config.xdg.dataHome}/Steam/config"
      ],
      "external_drivers" : null,
      "jsonid" : "vrpathreg",
      "log" :
      [
        "${config.xdg.dataHome}/Steam/logs"
      ],
      "runtime" :
      [
        "${pkgs.opencomposite}/lib/opencomposite"
      ],
      "version" : 1
    }
  '';
}
