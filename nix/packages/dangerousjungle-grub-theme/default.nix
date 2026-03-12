{ pkgs ? import <nixpkgs> {} }:
let
  inherit (pkgs) lib;
in
pkgs.stdenv.mkDerivation rec {
  # Add 'boot.loader.grub.theme = inputs.jonabron.packages.x86_64-linux.dangerousjungle-grub-theme;' to use Theme.
  pname = "dangerousjungle-grub-theme";
  version = "1.1";
  src = ./theme;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/grub/themes/${pname}
    cp -r ./* $out/share/grub/themes/${pname}/
    runHook postInstall
  '';
  meta = with lib; {
    description = "Dangerous Jungle (Vibrant) GRUB Bootloader Theme";
    homepage = "https://github.com/librepup/jonabron";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.librepup ];
  };
}
