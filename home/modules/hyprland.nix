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
    ./waybar/waybar.nix
  ];

  home.packages = [
    # file manager
    pkgs.nautilus
    # wallapaper
    pkgs.hyprpaper
    # keyring
    pkgs.seahorse
    # theming
    pkgs.nwg-look
    # screenshot
    pkgs.hyprshot
    # clipboard
    pkgs.wl-clip-persist

    # utils
    pkgs.brightnessctl
    pkgs.playerctl
    pkgs.networkmanagerapplet
    pkgs.pavucontrol

    # others
    pkgs.gnome-calculator
    pkgs.gnome-text-editor
    pkgs.killall

    ## Catppuccin
    #(pkgs.catppuccin-kvantum.override {
    #  #accent = "red";
    #})
    #pkgs.libsForQt5.qtstyleplugin-kvantum
    #pkgs.libsForQt5.qt5ct
    #pkgs.papirus-folders
  ];

  #catppuccin.enable = true;
  ##catppuccin.cache.enable = true;
  #catppuccin.accent = "red";
  #catppuccin.cursors.enable = true;

  gtk = {
    enable = true;
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };

  qt = {
    enable = true;
  };

  programs = {
    alacritty.enable = true;
    # TODO First available in HM 25.11
    #ashell = {
    #  enable = true;
    #  systemd.enable = true;
    #};
    hyprlock.enable = true;
    hyprpanel = {
      #enable = true;
      #settings = {
      #  bar.battery.label = true;
      #  bar.bluetooth.label = false;
      #  bar.clock.format = "%H:%M:%S";
      #  bar.layouts = {
      #    "*" = {
      #      left = [
      #        "dashboard"
      #        "workspaces"
      #        "media"
      #      ];
      #      middle = [ "windowtitle" ];
      #      right = [
      #        "volume"
      #        "network"
      #        "bluetooth"
      #        "notifications"
      #      ];
      #    };
      #  };
      #};
      #settings = {
      #  # Configure bar layouts for monitors.
      #  # See 'https://hyprpanel.com/configuration/panel.html'.
      #  # Default: null
      #  layout = {
      #    bar.layouts = {
      #      "0" = {
      #        left = [ "dashboard" "workspaces" ];
      #        middle = [ "media" ];
      #        right = [ "volume" "systray" "notifications" ];
      #      };
      #    };
      #  };
      #
      #  bar.launcher.autoDetectIcon = true;
      #  bar.workspaces.show_icons = true;
      #
      #  menus.clock = {
      #    time = {
      #      military = true;
      #      hideSeconds = true;
      #    };
      #    weather.unit = "metric";
      #  };
      #
      #  menus.dashboard.directories.enabled = false;
      #  menus.dashboard.stats.enable_gpu = true;
      #
      #  theme.bar.transparent = true;
      #
      #  theme.font = {
      #    name = "CaskaydiaCove NF";
      #    size = "16px";
      #  };
      #};
    };
    rofi = {
      enable = true;
      package = pkgs.rofi;
      plugins = [
        pkgs.rofi-emoji
        pkgs.rofi-calc
        pkgs.rofi-vpn
        pkgs.rofi-systemd
        pkgs.rofi-bluetooth
        pkgs.rofi-screenshot
        pkgs.rofi-power-menu
        pkgs.rofi-file-browser
        pkgs.rofi-network-manager
      ];
      terminal = "${pkgs.alacritty}/bin/alacritty";
    };
  };

  services = {
    hyprpaper = {
      enable = true;
      #settings = {
      #  preload = [
      #    "~/robins-documents/wallpapers/wallpaper.png"
      #  ];
      #  wallpaper = [
      #    ", ~/robins-documents/wallpapers/wallpaper.png"
      #  ];
      #};
    };
    hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };

        listener = [
          {
            timeout = 315;
            on-timeout = "hyprlock";
          }
          {
            timeout = 300;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;

    # This needs to be set to null if using the NixOS module of hyprland - otherwise some xdg stuff breaks
    package = null;
    portalPackage = null;

    settings = {
      # Programs
      "$terminal" = "alacritty";
      "$fileManager" = "nautilus";
      "$menu" = "rofi -show drun";
      "$code" = "code";
      "$browser" = "firefox";
      "$mail" = "thunderbird";

      "monitor" = [
        "eDP-1, 2256x1504@60, 0x0, 1.333333" # Laptop
        "DP-2, 3840x2160@60, 0x0, 1.5" # Desktop
      ];

      general = {
        border_size = 2;
        gaps_in = 3;
        gaps_out = 6;
      };

      decoration = {
        rounding = 5;
      };

      #################
      ### AUTOSTART ###
      #################

      # Autostart necessary processes (like notifications daemons, status bars, etc.)
      # Or execute your favorite apps at launch like this:

      exec-once = [
        "wl-clip-persist"
        "power-profiles-daemon"
        "nm-applet --no-agent"
        "keepassxc"
        "noisetorch -i"
        "sleep 5 && syncthingtray"
      ];

      dwindle = {
        pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # You probably want this
      };

      misc = {
        force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
      };

      input = {
        kb_layout = osConfig.services.xserver.xkb.layout;
        kb_variant = osConfig.services.xserver.xkb.variant;

        follow_mouse = 1;

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

        touchpad = {
          natural_scroll = true;
        };

        numlock_by_default = true;
      };

      gesture = [
        "3, horizontal, workspace"
      ];

      # Keybindings
      "$mainMod" = "SUPER";
      bind = [
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        "$mainMod, Return, exec, $terminal"
        "$mainMod, T, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, W, exec, $browser"
        "$mainMod, F, fullscreen"
        "$mainMod, C, exec, $code"
        "$mainMod, V, togglefloating,"
        "$mainMod, R, exec, $menu"
        "$mainMod, Space, exec, $menu"
        "$mainMod, L, exec, hyprlock"
        "$mainMod, P, pseudo, # dwindle"
        "$mainMod, J, togglesplit," # dwindle

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Move windo with mainMod + shift + arrow keys
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Example special workspace (scratchpad)
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        ", PRINT, exec, hyprshot -m region"
      ];
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      bindel = [
        # Laptop multimedia keys for volume and LCD brightness
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
      bindl = [
        # Requires playerctl
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };
  };
}
