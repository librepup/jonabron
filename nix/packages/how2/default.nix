{ pkgs ? import <nixpkgs> {} }:
let
  inherit (pkgs) buildFHSEnv;
  baseapp = pkgs.stdenv.mkDerivation {
    pname = "how2-linux";
    version = "3.0.3";
    src = pkgs.fetchzip {
      url = "https://github.com/santinic/how2/releases/download/v3.0.3/how2-linux-x64.tar.gz";
      sha256 = "sha256-MdMxpfVCtDAcd8wHj+XqHvfiaQiX1m2Ul8GKclS6wuI=";
    };
    installPhase = ''
      mkdir -p $out/opt/how2
      cp -r . $out/opt/how2
    '';
  };
in
buildFHSEnv {
  name = "how2";
  targetPkgs = p: with p; [
    libgcc.lib
  ];
  runScript = "${baseapp}/opt/how2/how2-linux";
}
