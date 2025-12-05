{ config, pkgs, ... }:

# TODO: I'm not 100% sure whether it is safe to expose device IDs publicly.
# I know it does not break encryption, as you would need to know the private client cert to spoof the device ID.
# However, I presume that if global discovery is enabled (it is per default with the nixos module),
# one could discover your public IP adress and/or spam you with "wants to share a folder".
# FolderIDs are safe to share :)
{
  environment.systemPackages = [ pkgs.syncthingtray ];
  services.syncthing = {
    enable = true;
    # key = config.age.secrets.syncthing.key;   # Allows persistance of your deviceID
    # cert = config.age.secrets.syncthing.cert;   # Allows persistance of your deviceID
    dataDir = "/home/robin";
    openDefaultPorts = true;
    user = "robin";
    group = "users";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      # Important: disable global discovery, which makes it more safe to expose the device ID
      options = {
        globalAnnounceEnabled = false;
        relaysEnabled = false;
        natEnabled = false;
      };
      urAccepted = -1;
      devices = {
        "fp4" = {
          id = "KEDKHO5-LR5N3X2-BC5EUPX-FZT2ZWA-OM2LSIP-RVPK4F3-NNBBYZB-JYGHUAE";
        };
        "nix-desktop" = {
          id = "AGUD3PH-TUHPQJY-7RQSS4M-Y3LE2AX-EEHOXZD-OCSSKA3-AC57CR7-5IBKOAR";
        };
        "nix-laptop" = {
          id = "F7RKJ2E-RF4PAH6-OX3KDR2-NKF2GRP-MMUCHOF-YBM362A-PKVT3AC-DEYUFAL";
        };
        "tab" = {
          id = "ZLRGNYC-XWCJ44N-SQSZTLC-JFVOIC3-HVC3QUB-LN5CPC3-BC4OQHQ-MPDG7AD";
        };
      };
      folders = {
        "robins-documents" = {
          path = "/home/robin/robins-documents";
          devices = [
            "fp4"
            "nix-desktop"
            "tab"
            "nix-laptop"
          ];
          versioning = {
            type = "staggered";
            params = {
              cleanInterval = "3600";
              maxAge = "15768000";
            };
          };
        };
        "robins-music" = {
          id = "pazjc-y3ysp";
          path = "/home/robin/music";
          devices = [
            "fp4"
            "nix-desktop"
            "tab"
            "nix-laptop"
          ];
          versioning = {
            type = "staggered";
            params = {
              cleanInterval = "3600";
              maxAge = "15768000";
            };
          };
        };
        "Android Camera" = {
          id = "fp4_d5qc-photos";
          path = "/home/robin/Pictures/Android Camera";
          devices = [
            "fp4"
            "nix-desktop"
            "tab"
            "nix-laptop"
          ];
          versioning = {
            type = "staggered";
            params = {
              cleanInterval = "3600";
              maxAge = "15768000";
            };
          };
        };
      };
    };
  };
}
