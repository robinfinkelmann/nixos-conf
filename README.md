# About

This repo contains my personal NixOS configuration files. I use flakes btw :P

I do not recommend anyone use this exact config, as it is quite personalized to my own needs. I also have not found the time to modularize things properly, in order to make some parts usable as plug-and-play NixOS modules.

However, feel free to get inspired for creating your own config :)

# Structure

- [flake.nix](flake.nix): the main entrypoint
    - `nixosConfigurations.<hostname>`
    - `devshells.default`
- [home](home): Home-Manager modules
- [hosts](hosts): host-specific NixOS modules (mainly `configuration.nix` and `hardware-configuration.nix` of each host)
- [secrets](secrets): agenix-rekey configuration and rekeyed secrets
- [system](system): NixOS modules that get reused between hosts
    - [apps](system/apps): package installs
    - [config](system/config): system services
    - [desktop](system/desktop): display manager and desktop environment
- [.envrc](.envrc): auto-loading `nix develop` using direnv
- [shell.nix](shell.nix): backwards-compatibility with `nix-shell`
