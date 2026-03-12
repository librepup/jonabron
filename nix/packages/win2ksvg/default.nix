{
  stdenvNoCC,
  fetchurl,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "win2ksvg-icons";
  version = "1.0";
  src = fetchurl {
    url = "https://files06.pling.com/api/files/download/j/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MTc2NjU4NDU0MSwibyI6IjEiLCJzIjoiMmJlNTJjYjEzZjcyNTcyYTNmNzQ5ZWE2YzUwZjI3YmNkZDU4ZGY0OWNiM2Q1Mjg5NjAzOGMxZWYxYTNiMzMxNzVjZWMwMzIyYTFiZDJjN2JlYjdkYTQ0ZDFmYWY4MTk4ZWE2NDMwODAyMjYzNzcwZjBjMDZmMGJiY2I4MjE4OWEiLCJ0IjoxNzczMzMxMjQ2LCJzdGZwIjpudWxsLCJzdGlwIjoiOTQuMTM1LjE3NC4yMTQifQ.QZF9NkkuuodSpXd2rSE6ZamDwJAZsrKZWLALW9InRhA/2025.12.24-14-28.WinXPSVG-plasma5up-scalable-icontheme-blackysgate.de.tar.gz";
    hash = "sha256-lhaU3g7sg9j7waBEt7RhHZSJndGoZk1Ym0ippaetLj0=";
  };
  dontBuild = true;
  dontFixup = true;
  dontUpdateIconCache = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons/WinXPSVG
    cp -r 8x8@2 $out/share/icons/WinXPSVG/8x8@2
    cp -r 8x8@3 $out/share/icons/WinXPSVG/8x8@3
    cp -r 12x12 $out/share/icons/WinXPSVG/12x12
    cp -r 12x12@2 $out/share/icons/WinXPSVG/12x12@2
    cp -r 12x12@3 $out/share/icons/WinXPSVG/12x12@3
    cp -r 16x16 $out/share/icons/WinXPSVG/16x16
    cp -r 16x16@2 $out/share/icons/WinXPSVG/16x16@2
    cp -r 16x16@3 $out/share/icons/WinXPSVG/16x16@3
    cp -r 22x22 $out/share/icons/WinXPSVG/22x22
    cp -r 22x22@2 $out/share/icons/WinXPSVG/22x22@2
    cp -r 22x22@3 $out/share/icons/WinXPSVG/22x22@3
    cp -r 24x24 $out/share/icons/WinXPSVG/24x24
    cp -r 24x24@2 $out/share/icons/WinXPSVG/24x24@2
    cp -r 24x24@3 $out/share/icons/WinXPSVG/24x24@3
    cp -r 32x32 $out/share/icons/WinXPSVG/32x32
    cp -r 32x32@2 $out/share/icons/WinXPSVG/32x32@2
    cp -r 32x32@3 $out/share/icons/WinXPSVG/32x32@3
    cp -r 48x48 $out/share/icons/WinXPSVG/48x48
    cp -r 48x48@2 $out/share/icons/WinXPSVG/48x48@2
    cp -r 48x48@3 $out/share/icons/WinXPSVG/48x48@3
    cp -r 64x64 $out/share/icons/WinXPSVG/64x64
    cp -r 96x96 $out/share/icons/WinXPSVG/96x96
    cp -r 128x128 $out/share/icons/WinXPSVG/128x128
    cp -r 256x256 $out/share/icons/WinXPSVG/256x256
    cp -r 512x512 $out/share/icons/WinXPSVG/512x512
    cp -r scalable $out/share/icons/WinXPSVG/scalable
    cp index.theme $out/share/icons/WinXPSVG/index.theme
    cp index.desktop $out/share/icons/WinXPSVG/index.desktop
    runHook postInstall
  '';
  meta = {
    homepage = "https://www.opencode.net/Blackcrack/win2ksvg";
    description = "Scalable W2K Icons for Plasma 5/6^ from Blackysgate.de - Letz there be bloody Classic ! - with extra PNG's";
    license = with lib; licenses.gpl3Plus;
    maintainers = with lib; [ maintainers.librepup ];
    platforms = with lib; platforms.linux;
  };
}
