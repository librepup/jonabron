{ pkgs ? import <nixpkgs> {}, xptheme ? null }:
pkgs.stdenv.mkDerivation rec {
  pname = "aero-kwin-decoration";
  version = "6.5.5";
  src = pkgs.fetchFromGitHub {
    owner = "aeroshell-desktop";
    repo = "aerothemeplasma";
    tag = "6.5.5";
    sha256 = "sha256-AuQH8lIpG9nnneN48RATI7E8llBLK7YOkKjTOSW3hAM=";
  };
  sourceRoot = "source/kwin/decoration";
  nativeBuildInputs = with pkgs; [
    cmake
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
    pkg-config
    qt6.qtbase
  ];
  buildInputs = with pkgs.kdePackages; [
    kcolorscheme
    kconfig
    kguiaddons
    ki18n
    kiconthemes
    kwindowsystem
    kcoreaddons
    kdecoration
    qtbase
    kirigami
    ksvg
    kcmutils
    frameworkintegration
    karchive
  ];
  dontWrapQtApps = true;
  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=$out"
    "-DKDE_INSTALL_QTPLUGINDIR=lib/qt-6/plugins"
    "-DBUILD_TESTING=OFF"
  ];
  meta = {
    homepage = "https://github.com/aeroshell-desktop/aerothemeplasma";
    description = "AeroShell KWin Decorations for KDE Plasma.";
    license = pkgs.lib.licenses.gpl3Plus;
    maintainers = with pkgs.lib; [ maintainers.librepup ];
    platforms = pkgs.lib.platforms.linux;
  };
}
