{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  pname = "windows-xp-theme";
  version = "1.0";
  src = pkgs.fetchFromGitHub {
    owner = "B00merang-Project";
    repo = "Windows-XP";
    rev = "7637830906823af40a3cd7e7079be753d8b7d679";
    sha256 = "sha256-6fWionYwQidx6VnXPcehQRNG4M71c2VxcVpZgCdBzQc=";
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
    mkdir -p $out/share/themes/{Windows\ XP\ Embedded,Windows\ XP\ Homestead,Windows\ XP\ Luna,Windows\ XP\ Metallic,Windows\ XP\ Royale\ Dark,Windows\ XP\ Royale,Windows\ XP\ Zune}
    cp -r ./Windows\ XP\ Embedded/* $out/share/themes/Windows\ XP\ Embedded/
    cp -r ./Windows\ XP\ Homestead/* $out/share/themes/Windows\ XP\ Homestead/
    cp -r ./Windows\ XP\ Luna/* $out/share/themes/Windows\ XP\ Luna/
    cp -r ./Windows\ XP\ Metallic/* $out/share/themes/Windows\ XP\ Metallic/
    cp -r ./Windows\ XP\ Royale\ Dark/* $out/share/themes/Windows\ XP\ Metallic/
    cp -r ./Windows\ XP\ Royale/* $out/share/themes/Windows\ XP\ Royale/
    cp -r ./Windows\ XP\ Zune/* $out/share/themes/Windows\ XP\ Zune/
    runHook postInstall
  '';
  propagatedBuildInputs = [
    pkgs.hicolor-icon-theme
    pkgs.gtk-engine-murrine
  ];
  meta = {
    homepage = "https://github.com/B00merang-Project/Windows-XP";
    description = "Windows XP Theme";
    license = pkgs.lib.licenses.gpl3Plus;
    maintainers = with pkgs.lib; [ maintainers.librepup ];
    platforms = pkgs.lib.platforms.linux;
  };
}
