{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  pname = "image-text-extractor";
  version = "1.0";
  src = ./.;
  buildInputs = with pkgs; [
    flameshot
    xclip
    tesseract
  ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp script.sh $out/bin/image-text-extractor
    chmod a+x $out/bin/image-text-extractor
  '';
}
