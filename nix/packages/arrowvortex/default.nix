{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  pname = "arrowvortex";
  version = "2017-02-25";
  src = pkgs.fetchurl {
    url = "https://arrowvortex.ddrnl.com/releases/ArrowVortex-${version}.rar";
    sha256 = "sha256-Mfc+IIADiOwS4jRjeNaBTcxnNO50bWd2ZxQmaSdQDY4=";
  };
  nativeBuildInputs = with pkgs; [
    rar
    makeWrapper
    procps
    wineWowPackages.yabridge
  ];
  unpackPhase = ''
    mkdir -p $out/share/arrowvortex
    rar x $src $out/share/
    mv "$out/share/ArrowVortex ${version}"/* "$out/share/arrowvortex"/
    rm -rf "$out/share/ArrowVortex ${version}"
  '';
  installPhase = ''
    mkdir -p $out/bin
    cat <<EOF > $out/bin/arrowvortex
#!/usr/bin/env bash
TARGET_DIR="\$HOME/.jonabron-arrowvortex/app"
export WINEPREFIX="\$HOME/.jonabron-arrowvortex/prefix"

if [ ! -d "\$TARGET_DIR" ]; then
  echo "Initializing ArrowVortex in \$TARGET_DIR..."
  mkdir -p "\$TARGET_DIR"
  cp -rn $out/share/arrowvortex/* "\$TARGET_DIR/"
  chmod -R u+w "\$TARGET_DIR"
  ${pkgs.wineWowPackages.yabridge}/bin/wineboot
fi

cd "\$TARGET_DIR"
echo "Starting ArrowVortex.exe in \$TARGET_DIR with prefix \$WINEPREFIX..."
exec ${pkgs.wineWowPackages.yabridge}/bin/wine ArrowVortex.exe "\$@"
EOF

    cat <<EOF > $out/bin/arrowvortex-kill
#!/usr/bin/env bash
TARGET_DIR="\$HOME/.jonabron-arrowvortex/app"
export WINEPREFIX="\$HOME/.jonabron-arrowvortex/prefix"

${pkgs.wineWowPackages.yabridge}/bin/wineserver -k || true
${pkgs.procps}/bin/pkill -9 -f "ArrowVortex" || true
EOF

    chmod +x $out/bin/arrowvortex
    chmod +x $out/bin/arrowvortex-kill
  '';
  meta = with pkgs.lib; {
    description = "ArrowVortex Chart Editor for StepMania, osu!, (Not)ITG, and More!";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
