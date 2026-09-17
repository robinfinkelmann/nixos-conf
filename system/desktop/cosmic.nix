{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  # COSMIC uses GNOME Keyring, whoose SSH agent apparently can't handle FIDO2 resident keys
  services.gnome.gcr-ssh-agent.enable = false;

  programs.kdeconnect.enable = true;
}
