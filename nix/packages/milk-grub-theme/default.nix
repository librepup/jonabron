{ pkgs ? import <nixpkgs> {} }:
let
  inherit (pkgs) lib;
in
pkgs.stdenv.mkDerivation rec {
  pname = "milk-grub-theme";
  version = "1.0";
  src = ./theme;
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r ./* $out/
    runHook postInstall
  '';
  meta = with lib; {
    description = "Milk Outside a Bag of Milk GRUB Bootloader Theme";
    homepage = "https://www.opendesktop.org/p/2296341";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.librepup ];
  };
}
