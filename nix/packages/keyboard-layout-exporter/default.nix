{ pkgs ? import <nixpkgs> {} }:
let
  pythonResult = pkgs.python313.withPackages (p: with p; [
    pillow
  ]);
in
pkgs.stdenv.mkDerivation {
  pname = "keyboard-layout-exporter";
  version = "1.0";
  src = ./.;
  buildInputs = [
    pythonResult
  ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/keyboard-layout-exporter
    cp ${./files/main.py} $out/share/keyboard-layout-exporter/main.py

    cat <<EOF > $out/bin/keyboard-layout-exporter
#!/usr/bin/env bash
exec ${pythonResult}/bin/python3 $out/share/keyboard-layout-exporter/main.py "\$@"
EOF
    chmod +x $out/bin/keyboard-layout-exporter
  '';
}
