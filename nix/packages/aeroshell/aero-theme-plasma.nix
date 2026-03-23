{ pkgs ? import <nixpkgs> {}, xptheme ? null }:
pkgs.stdenv.mkDerivation rec {
  pname = "aero-theme-plasma";
  version = "6.5.5";
  src = pkgs.fetchFromGitHub {
    owner = "aeroshell-desktop";
    repo = "aerothemeplasma";
    tag = "6.5.5";
    sha256 = "sha256-AuQH8lIpG9nnneN48RATI7E8llBLK7YOkKjTOSW3hAM=";
  };
  installPhase = ''
    # 1. Plasma Desktop Theme (Path: desktoptheme/Seven-Black)
    mkdir -p $out/share/plasma/desktoptheme/Seven-Black
    cp -r plasma/desktoptheme/Seven-Black/. $out/share/plasma/desktoptheme/Seven-Black/

    # 2. Look and Feel (Path: look-and-feel/authui7)
    mkdir -p $out/share/plasma/look-and-feel/authui7
    cp -r plasma/look-and-feel/authui7/. $out/share/plasma/look-and-feel/authui7/

    # 3. Kvantum (Path: kvantum/Kvantum/Windows7Aero)
    mkdir -p $out/share/Kvantum/Windows7Aero
    cp -r misc/kvantum/Kvantum/Windows7Aero/. $out/share/Kvantum/Windows7Aero/

    # 4. Color Scheme (Path: color_scheme/Aero.colors)
    mkdir -p $out/share/color-schemes
    cp plasma/color_scheme/Aero.colors $out/share/color-schemes/

    # 5. Plasmoids (Path: plasmoids/io.gitgud.wackyideas.*)
    mkdir -p $out/share/plasma/plasmoids
    for d in plasma/plasmoids/io.gitgud.wackyideas.*; do
      if [ -d "$d" ]; then
        cp -r "$d" $out/share/plasma/plasmoids/
      fi
    done

    # 6. Layout Templates (Path: layout-templates/io.gitgud.wackyideas.taskbar)
    mkdir -p $out/share/plasma/layout-templates
    for d in plasma/layout-templates/io.gitgud.wackyideas.*; do
      if [ -d "$d" ]; then
        cp -r "$d" $out/share/plasma/layout-templates/
      fi
    done
  '';
  meta = {
    homepage = "https://github.com/aeroshell-desktop/aerothemeplasma";
    description = "AeroShell Theme for KDE Plasma.";
    license = pkgs.lib.licenses.gpl3Plus;
    maintainers = with pkgs.lib; [ maintainers.librepup ];
    platforms = pkgs.lib.platforms.linux;
  };
}
