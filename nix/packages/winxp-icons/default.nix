{ pkgs ? import <nixpkgs> {}, xptheme ? null }:
pkgs.stdenv.mkDerivation rec {
  pname = "winxp-icons";
  version = "1.0";
  src = pkgs.fetchFromGitHub {
    owner = "ZoomTen";
    repo = "WinXP-Icons";
    rev = "8a193ecfdbc87d47e1b7891eff2f8f7e374eed90";
    sha256 = "sha256-PQtxXcAoMwhJ3dfHzODyqgB+yEcfWzRM8hofGtw+BlI=";
  };
  dontBuild = true;
  dontFixup = true;
  dontDropIconThemeCache = true;
  nativeBuildInputs = [
    pkgs.gtk3
    pkgs.librsvg
    xptheme
  ];
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons/WinXP-Icons
    cp -r ./* $out/share/icons/WinXP-Icons/
    runHook postInstall
  '';
  postInstall = ''
    XDG_DATA_DIRS="${xptheme}/share:${pkgs.hicolor-icon-theme}/share" \
    GDK_PIXBUF_MODULE_FILE="$(echo ${pkgs.librsvg}/lib/gdk-pixbuf-2.0/*/loaders.cache)" \
      gtk-update-icon-cache --force --ignore-theme-index -v $out/share/icons/WinXP-Icons 2>&1 || true
  '';
  propagatedBuildInputs = [
    pkgs.hicolor-icon-theme
    pkgs.librsvg
    pkgs.gtk-engine-murrine
    xptheme
  ];
  meta = {
    homepage = "https://github.com/ZoomTen/WinXP-Icons";
    description = "Windows XP icon pack, based on YlmfOS to solve scaling problems";
    license = pkgs.lib.licenses.gpl3Plus;
    maintainers = with pkgs.lib; [ maintainers.librepup ];
    platforms = pkgs.lib.platforms.linux;
  };
}
