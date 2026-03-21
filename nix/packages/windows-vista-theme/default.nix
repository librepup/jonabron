{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  pname = "windows-vista-theme";
  version = "1.0";
  src = pkgs.fetchFromGitHub {
    owner = "B00merang-Project";
    repo = "Windows-Vista";
    rev = "719b12bdb6f6dd352f7ca26ac2fd78ddc10efb8c";
    sha256 = "sha256-ck2F1EsEgavyXTBXX3bVfB/T3ips31O4S1KDelXln48=";
  };
  dontBuild = true;
  dontFixup = true;
  dontDropIconThemeCache = true;
  nativeBuildInputs = [
    pkgs.gtk3
    pkgs.xcursorgen
  ];
  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/themes/Windows Vista"
    cp -r ./* "$out/share/themes/Windows Vista/"
    runHook postInstall
  '';
  propagatedBuildInputs = [
    pkgs.hicolor-icon-theme
    pkgs.gtk-engine-murrine
  ];
  meta = {
    homepage = "https://github.com/B00merang-Project/Windows-Vista";
    description = "Windows Vista Theme";
    license = pkgs.lib.licenses.gpl3Plus;
    maintainers = with pkgs.lib; [ maintainers.librepup ];
    platforms = pkgs.lib.platforms.linux;
  };
}
