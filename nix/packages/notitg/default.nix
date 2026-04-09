{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  pname = "notitg";
  version = "4.9.1";
  src = pkgs.fetchurl {
    url = "https://cloud.noti.tg/QuickStart-v4.9.1.zip";
    sha256 = pkgs.lib.fakeSha256;
  };
  nativeBuildInputs = with pkgs; [
    unzip
    makeWrapper
    procps
    wineWowPackages.yabridge
  ];
  unpackPhase = ''
    unzip $src -d $out/share/notitg
  '';
  installPhase = ''
    mkdir -p $out/bin
    cat <<EOF > $out/bin/notitg
#!/usr/bin/env bash
TARGET_DIR="\$HOME/.jonabron-notitg/game"
export WINEPREFIX="\$HOME/.jonabron-notitg/prefix"

if [ ! -d "\$TARGET_DIR" ]; then
  echo "Initializing NotITG in \$TARGET_DIR..."
  mkdir -p "\$TARGET_DIR"
  cp -rn $out/share/notitg/* "\$TARGET_DIR/"
  chmod -R u+w "\$TARGET_DIR"
  ${pkgs.wineWowPackages.yabridge}/bin/wineboot
fi

cd "\$TARGET_DIR/Program"
echo "Starting NotITG-v${version}.exe in \$TARGET_DIR with prefix \$WINEPREFIX..."
exec ${pkgs.wineWowPackages.yabridge}/bin/wine NotITG-v${version}.exe "\$@"
EOF

    cat <<EOF > $out/bin/notitg-kill
#!/usr/bin/env bash
TARGET_DIR="\$HOME/.jonabron-notitg/game"
export WINEPREFIX="\$HOME/.jonabron-notitg/prefix"

${pkgs.wineWowPackages.yabridge}/bin/wineserver -k || true
${pkgs.procps}/bin/pkill -9 -f "NotITG" || true
EOF

    chmod +x $out/bin/notitg
    chmod +x $out/bin/notitg-kill
  '';
  meta = with pkgs.lib; {
    description = "NotITG Rhythm Game";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
