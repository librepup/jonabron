{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  pname = "xptheme";
  version = "1.0";
  src = pkgs.fetchFromGitHub {
    owner = "ZoomTen";
    repo = "xptheme-20180113";
    rev = "512721982e2d4dea7f05bcf5e51494c873920aae";
    sha256 = "sha256-QGzd4a5hG5aQwI+FJtvfaf6RaYf06+spNsh/PGyAiTo=";
  };
  dontBuild = true;
  dontFixup = true;
  dontDropIconThemeCache = true;
  nativeBuildInputs = [
    pkgs.gtk3
  ];
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/CinnXP
    mkdir -p $out/share/icons/Classic95
    mkdir -p $out/share/icons/w2k-bibo
    cp -r ./icons/CinnXP/* $out/share/icons/CinnXP/
    cp -r ./icons/Classic95/* $out/share/icons/Classic95/
    cp -r ./icons/w2k-bibo/* $out/share/icons/w2k-bibo/

    mkdir -p "$out/share/themes/Windows XP Luna"
    mkdir -p "$out/share/themes/Office 2007"
    cp -r "./gtk-themes/Windows XP Luna"/* "$out/share/themes/Windows XP Luna"/
    cp -r "./gtk-themes/Office 2007"/* "$out/share/themes/Office 2007"/

    runHook postInstall
  '';
  propagatedBuildInputs = [
    pkgs.hicolor-icon-theme
    pkgs.gtk-engine-murrine
  ];
  meta = {
    homepage = "https://github.com/ZoomTen/xptheme-20180113";
    description = "Windows XP Look Themefiles";
    license = pkgs.lib.licenses.gpl3Plus;
    maintainers = with pkgs.lib; [ maintainers.librepup ];
    platforms = pkgs.lib.platforms.linux;
  };
}
