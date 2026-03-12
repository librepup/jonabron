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
    cp -r . $out/share/icons/WinXPSVG/
    rm $out/share/icons/WinXPSVG/WinXPsound.tar.gz
    rm $out/share/icons/WinXPSVG/addmimetouser.sh
    rm $out/share/icons/WinXPSVG/Readme.md
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
