{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  pname = "revista";
  version = "1.0";
  src = pkgs.fetchFromGitHub {
    owner = "x35gaming";
    repo = "revista";
    rev = "1fbf85a57eeebb647acb58133387d225a53fa3fe";
    sha256 = "sha256-DooUIJSp6gFvL/BzTRZU5fC/VSKR3OH9sv0Fua1VQL8=";
  };
  dontBuild = true;
  dontFixup = true;
  dontDropIconThemeCache = true;
  nativeBuildInputs = [
    pkgs.gtk3
    pkgs.librsvg
    pkgs.gnused
  ];
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/ReVista
    mkdir -p $out/share/themes/ReVista
    mkdir -p $out/share/themes/ReVista-dark

    cp -r ./Icons/ReVista/* $out/share/icons/ReVista/
    cp -r ./Themes/ReVista/* $out/share/themes/ReVista/
    cp -r ./Themes/ReVista-dark/* $out/share/themes/ReVista-dark/

    runHook postInstall
  '';
  propagatedBuildInputs = [
    pkgs.hicolor-icon-theme
    pkgs.librsvg
    pkgs.gtk-engine-murrine
  ];
  meta = {
    homepage = "https://github.com/x35gaming/revista";
    description = "ReVista Themes and Icon Pack";
    license = pkgs.lib.licenses.gpl3Plus;
    maintainers = with pkgs.lib; [ maintainers.librepup ];
    platforms = pkgs.lib.platforms.linux;
  };
}
