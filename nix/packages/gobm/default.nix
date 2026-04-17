{ pkgs ? import <nixpkgs> {} }:
let
  inherit (pkgs.lib) versions;
  guileVersion = "${versions.major pkgs.guile.version}.${versions.minor pkgs.guile.version}";
in
pkgs.stdenv.mkDerivation {
  pname = "gobm";
  version = "1.1";
  src = ./.;
  buildInputs = [
    (pkgs.haskellPackages.ghcWithPackages (ps: with ps; [
      aeson
      regex-tdfa
    ]))
    pkgs.guile
    pkgs.curl
    pkgs.guile-json
  ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin

    # Copy script to $out/share so the binary can find it
    mkdir -p $out/share/gobm
    cp gobm.scm $out/share/gobm/gobm.scm
    cp Main.hs $out/share/gobm/Main.hs

    # Haskell Compilation
    cd $out/share/gobm
    ghc -o hgobm Main.hs
    mv $out/share/gobm/hgobm $out/bin/hgobm
    chmod +x $out/bin/hgobm

    # Create the wrapper script
    # We set GUILE_LOAD_PATH to include the path where guile-json is installed
    cat <<EOF > $out/bin/gobm
#!/usr/bin/env bash
export GUILE_LOAD_PATH="${pkgs.guile-json}/share/guile/site/${guileVersion}:\$GUILE_LOAD_PATH"
export PATH="${pkgs.curl}/bin:\$PATH"
exec ${pkgs.guile}/bin/guile $out/share/gobm/gobm.scm "\$@"
EOF
    chmod +x $out/bin/gobm
  '';
}
