{ config, pkgs, ... }:

let
  slp = pkgs.stdenv.mkDerivation rec {
    name = "smart-label-printer";
    version = "0.0.1";

    nativeBuildInputs = [
      pkgs.autoPatchelfHook
      pkgs.cups
    ];

    buildInputs = [
      pkgs.libusb1
      pkgs.kdePackages.wrapQtAppsHook
      pkgs.kdePackages.qtbase
      pkgs.stdenv.cc.cc
      pkgs.stdenv.cc.cc.lib
      pkgs.perl
    ];

    src = fetchGit {
      url = "https://github.com/danieloneill/SeikoSLPLinuxDriver.git";
      ref = "master";
      rev = "a7395817d464d95d50d0630013f60ce492eecde6";
    };

    patches = [
      ./slp-filterdir-patch.diff
    ];

    buildPhase = ''
      runHook preBuild
      sed -i 's\filterdir := $(shell cups-config --serverbin)/filter\filterdir := ""\g' makefile
      make build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      # Install the CUPS filter with executable permissions
      install -Dm755 ./seikoslp.rastertolabel $out/lib/cups/filter/seikoslp.rastertolabel
      # Install all PPD files with read and write permissions for owner, and read for group>
      for ppd in ./*.ppd; do
        install -Dm644 $ppd $out/share/cups/model/label/$(basename $ppd)
      done
      runHook postInstall
    '';
  };
in
{
  services.printing.drivers = [ slp ];
  environment.systemPackages = [ slp ];
}
