{
  pkgs,
  lib,
  config,
  agenix,
  ...
}:

{
  age.rekey = {
    agePlugins = [ 
      pkgs.age
      pkgs.age-plugin-fido2-hmac
    ];
    masterIdentities = [
      {
        identity = ./master/yubi1.pub;
        pubkey = "age1pq1h2dvu96gwcc54fp8kwgx632ct09pqyfjpxngw0hmp2d8cdasuvf9p928nvty4d5mwq5sswn3u3v2pqc90zkcztdaav3fhfnn5cc8xqyte53wv94877hzerqhhynue07cw8g5cg8vyx0y25ngm99cyctyqlugx3g6s7t3dwt3dldc06tmy6evvcv5u0zugu9j7urhv52u8gdurtffwd2mysagt5xtz3szncd0xqdz8vlq9wpgxwdtc8qqwsgcsv7pyj2wcuvvvu2r3t229dae8dcnw99xz0p92ugj0wqz370h394c7c7s2d9zx5j9ez5ccx90xlymq4lavjpkyna408p6t2ncjgs983l46wnnc0p6tmycqddrvehgawhsl46pv89u248mcgn9d8gn2c7a69c0w34cgexvg2zuqae2qcqtg220ksdg4yqr0lt3tjlamrxa9q4gptmra0gstm3dhfeag9kckhz95acx2wuesr0s3j3z0qzvdk6len6580kf8w9af357f3gmtxfwcs6eruvts39chn5ddfg40kkf6tyhj4gq85fd9zg76ztgzhz2qfuqytf68rmyt0jp2uy9lmxfqdkp7r98wnjc2446ckhtl436jcjhecvqenkf5nnyu6wj5z59l0fcp5pk2zsh0r7fc26cw635k67tpx52h9ntvdcay4w2td66nt45t8yxj3dkp35qhsherwrcwzp95quf8l8lttly730m0g5vpgshfdcyvrzgtydqafwxn5yl0y2c85przaga5u2tzqv9j6upsh99scw49xr9jkd73q9z70xxyljcvz0pexltgx7592w8ny34dwr906cee2eecwm3kv76u3nufkq67aarnphg5pd0knpsydccdkj8a36ezqtdwea5zan9zxsum02ctme8kdx5kwjx6r8sknpmzva882gtthx5dpjh5r9gc4yekhmgmtfun520xh4nxcmsm34zddqg5wmmnv4d32ye93s8ckgqnk589z56h64w9sqza9gk2vmy2srhkykgfmmlnqwsu677ua5jgrm2s2c6ds8h2pdxkywex59qvpynnud5n3rc0gpvkz0nru2wxsdn9ajtzug2sst5jfac65trn3asfpfyqg35sv7uul92h6dcafz953tn9wgq8fz2sxvqhkwqc2zm3jeee2qpvngsdpt43fm8x24ez6d255qashsz9wc55p9uzf492ramnfllngsemwrxlspukl2rcqwtt0xrzzc7gzl9wjp7d8jevp9eylpzsy26vxkmh5ptqrmgxkjkrgyfjfrnu4jscxn4ymaruh6vpzknyjqyy90q775nesqs40akp2gfjdsp4gtlgjspt0f6qqj8p88lqqr7tzdqsyfw23fffx2yr0zw4j26vgcz3978xjvmvpzzck4tngpuvnq03x9zgv6z8cx4tm9lj9d9uu8l7x45duw8y3vc4wcxwzpfcd548ymdxncgwasrpnuzpyqqdzg2e9truq3kkqex9mzn9w7l3yjx9crl8jxrmvds2re40xkemjk8xl9f2yz9sfg4sxqrv93sedulgdmwy52fn5tq5tfshzh9e27eve7ru3vfds3qnppcfr85cxtc0zfsd3efq8zj0m52qvq377w8eawfhedzvggur60uw3nufyr9yqk836n3gelexxn0hrcyrxaau9ncegf92xshed9ye36yjh8xagt4d74s60szfrthqflm2j643az2detjvr9vgc2xez5g9p58zg44lkn4at448cxv4stmzv4lmpgnj0degn88ptpcq98uc47k2qz7gf783tckzktkrqqa0jfc4kpwudvkjdrda0ls882qkv3e8l8z7a806wkr4camqjazqp4xxhsf7p3j25jj546jgxprlaewkm9utqccfux5fw2t35rgq2awykmhfva0vluh";
      }
      {
        identity = ./master/nitro2.pub;
        pubkey = "age1pq1873z49mssz0qvsuw2vzzjat7x5tvy4tx0sku2vz74sc99gv7qrv8wpdrqta05l724d2epvrjcf9rclehq6j9jtzdlwjyedz8xy68es0rq4rdevc6dp2qfztksr32wd52gaclrz3ykqvddszuqf7xpuxt0gecjn92tgwst0z29sgr5ek4r0hqhjt7jx4n9z3muwuxx90zs8x3gf6pxasrssalzgp4u9askgc4g6hsz6zcfzgjsvvglu3mqfmj397nq9tkup3kdhgf9j823esftvam0xgl4j954k3nyd3rr5ym5z7gucyuhy98f9m2rllhd74t2sf9psmyug4fgh33mjm9hfnrwe72w50gjezeqdu2qagg30jtsyjfkgmxlr9d9z3umv2hrjszvvj2rx2tnepplzvymsqfhk3cx9ak38x5ye2n25r2x6nfe829x9uvexspe2fn79fk6nrf0hysjwpmzh8zyjqe5ftsvswzx8uskc9gzpymfxydyzs5zrnm5u5ugr9f54n269vtqk5jf754pz9ftd834jssx336xhkrnuyp2xs02tre7yzam3tulw3spnfpduzw24uxtdur3cftq4kqck7ex700e27uwsm3ajnzvyappk0tf4tqd2qqeqah6zmdj2q3cxc8w3cp40uhrx6xt49m4l2qqudt49yge8gt74ddk5795pgmaje23dwvr0sl3vctccd6kcp9yzr654h20sqg5seaj89xwm48v8e2kmwfhv2gffkmxc4lyuu90tdgyvr2209etjey2vn7c32kctr295f8j0xk5vk67lp00lrh7gwh5mrdvudp6du377yez8eq647vpy93xtn0pxa5uvemgvez0jphc37jj973qpz9vkqn9ztre6hr9mtl4rq2d3zs29rcm83u0x5t4g523qdkkxvjlygdnw3mtst9tu3ywprw6sqhj9pkfykpy7psqw3fj6puag9l6y9jrguythspgazg9xyrjkxzeagenlm4cddtyqcwzjrlrxxqlv45guzsxedktt47nzhp8pskj59um6crkqk5eyfrh0eqzqy8cpee6cw2uk7xeycjwnap8qknf29dvz2jl7qfqdeykc2csphmgy2tzy5v6vf355z2kzkvu6r0xfer9wmkxv68rl4nsvm5nyqlww5j9pcun80y93qfpd6hawcl7ssesv9xpzxhdu4xxpug6xpg2uugwzt43rjjhr8uvz8my8xyx4ekvxrvg3wjf8c35ny2kac5gmp9vypj2y5ypd3rez44upmmj7es3ztgl3dppzn60w5qlyccdvszvndhez74e4y5y903pp4mqws7ey7fz7h4qengglspxfmaxjajtdez4xnf8p4nkr4x2pf850zymzw9n5cf2gltzhsngq58la6t2gemalvvsn0u3nanrx326v2tvsxprd6x9z3nsqvg5vm9agf9r65jazeqxl8sqqvnyk754st9w49jtp0fqpmsjfn4ndly6d6mggyvjfsjvttpslcfujaqvsex6xj2pwm34hlrkjavv7s7awrvgt992mfutntn9r33c4t7l24n52mjsm6hqh33weyckgvwggpq9gvq839xykfuypup72ffvsferk6449e5xppnyjlaydg3dwcnrrs2lnmfq508xqznsfmg99deqqw66rk8w4aftyrytwpgm4sq5rc3hchtpjwke2ctrwrw7wz0wlynqu69ejggr0twx6cjvl92zss3tksx2u9jvmqz92qvljce8fr8lr5zpw67w0636k4mwnrvmy48pkauy27gc5ndwap0ns5p5qrug78ps80xz7xhvz4ktjhcq3qxsl8ka6tycvdmzwrf522nxex2x9kc2dxgfcug9qdt7qpukkyfhaqzmmn3ctmn8dq6e4qcfpj2g0vpr7vnlpjs6w3rftn3vv8m72al";
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

  age.generators.nix =
    {
      pkgs,
      secret,
      file,
      ...
    }:
    ''
      priv=$(${pkgs.nix}/bin/nix key generate-secret --key-name ${secret.settings.key-name})
      ${pkgs.nix}/bin/nix key convert-secret-to-public <<< "$priv" > ${
        lib.escapeShellArg (lib.removeSuffix ".age" file + ".pub")
      }
      echo "$priv"
    '';
}
