{
  pkgs,
  lib,
  config,
  agenix,
  ...
}:

{
  age.rekey = {
    agePlugins = [ pkgs.age-plugin-fido2-hmac ];
    masterIdentities = [
      {
        identity = ./master/yubi1.pub;
        pubkey = "age13aszp62u8r85zdxumx46sd3srzjx5836e3clgz94r756kh7x9a4sw0wuh7";
      }
      {
        identity = ./master/only1.pub;
        pubkey = "age1asw79ujutva9yrpwly8evu5dmrykemtjnaptq72lt6r9p40ku99ssecfw0";
      }
    ];
    storageMode = "local";
    # Choose a directory to store the rekeyed secrets for this host.
    # This cannot be shared with other hosts. Please refer to this path
    # from your flake's root directory and not by a direct path literal like ./secrets
    localStorageDir = ./. + "/rekeyed/${config.networking.hostName}";
  };

  age.generators.ssh-ed25519-python =
    {
      pkgs,
      ...
    }:
    let
      # Python script to generate a key in memory and print to stdout
      keygenScript = pkgs.writeText "ssh-ed25519-keygen.py" ''
        import sys
        from cryptography.hazmat.primitives import serialization as crypto_serialization
        from cryptography.hazmat.primitives.asymmetric import ed25519

        private_key = ed25519.Ed25519PrivateKey.generate()

        # Correctly serialize the key to the OpenSSH format,
        # wrapped in PEM encoding.
        ssh_private_key = private_key.private_bytes(
            encoding=crypto_serialization.Encoding.PEM,
            format=crypto_serialization.PrivateFormat.OpenSSH,
            encryption_algorithm=crypto_serialization.NoEncryption()
        )

        # Write the key directly to standard output
        sys.stdout.buffer.write(ssh_private_key)
      '';

      # A minimal Python environment with the required library
      pythonWithCrypto = pkgs.python3.withPackages (ps: [ ps.cryptography ]);
    in
    # The final shell command to be executed by agenix
    ''
      ${pythonWithCrypto}/bin/python ${keygenScript}
    '';

  age.generators.wireguard =
    { pkgs, file, ... }:
    ''
      priv=$(${pkgs.wireguard-tools}/bin/wg genkey)
      ${pkgs.wireguard-tools}/bin/wg pubkey <<< "$priv" > ${
        lib.escapeShellArg (lib.removeSuffix ".age" file + ".pub")
      }
      echo "$priv"
    '';
}
