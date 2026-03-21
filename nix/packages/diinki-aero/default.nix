{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  pname = "diinki-aero";
  version = "1.0";
  src = pkgs.fetchFromGitHub {
    owner = "diinki";
    repo = "diinki-aero";
    rev = "630a7fc2ac1aa6160585cafa61967581e8b51376";
    sha256 = "sha256-+mZyhAIgm75code/hP2hUTEvbYUYrDPEF+Xmxx5HdAk=";
  };
  dontBuild = true;
  dontFixup = true;
  dontDropIconThemeCache = true;
  nativeBuildInputs = [
    pkgs.gtk3
  ];
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/crystal-remix-icon-theme-diinki-version
    mkdir -p $out/share/themes/diinki-aero

    cp -r ./IconTheme/crystal-remix-icon-theme-diinki-version $out/share/icons/
    cp -r ./GTKTheme/diinki-aero $out/share/themes/

    runHook postInstall
  '';
  propagatedBuildInputs = [
    pkgs.hicolor-icon-theme
    pkgs.gtk-engine-murrine
  ];
  meta = {
    homepage = "https://github.com/diinki/diinki-aero";
    description = "Diinki's Aero GTK Theme and Icon Pack";
    license = pkgs.lib.licenses.mit;
    maintainers = with pkgs.lib; [ maintainers.librepup ];
    platforms = pkgs.lib.platforms.linux;
  };
}
