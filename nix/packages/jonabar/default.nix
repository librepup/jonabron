{ lib
, stdenv
, makeWrapper
, polybarFull # Use polybarFull to ensure PulseAudio/i3/etc. support is compiled in
, kitty
, xorg
, gnugrep
, coreutils
, gnused
, bash
, gawk
, procps
, sysstat
, networkmanager
, dmenu
, pulseaudio
, glibcLocales
, jonafonts
}:

stdenv.mkDerivation {
  pname = "jonabar";
  version = "1.1";

  phases = [ "installPhase" "fixupPhase" ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/etc

    cp ${./files/config.ini} $out/etc/config.ini
    cp ${./files/tray.ini} $out/etc/tray.ini

    # Improved Toggle Tray Script
    cat <<EOF > $out/bin/jonabar-toggle-tray
#!/usr/bin/env bash
TRAY_CONFIG="$out/etc/tray.ini"
# Search for the specific tray process
PID=\$(pgrep -f "polybar tray-bar --config=\$TRAY_CONFIG" || true)

if [ -n "\$PID" ]; then
  echo "Killing existing tray (PID: \$PID)..."
  kill -9 "\$PID"
else
  echo "Starting tray..."
  # Use 'nohup' or '& disown' to keep it alive independently
  polybar tray-bar --config="\$TRAY_CONFIG" >/dev/null 2>&1 &
fi
EOF

    # Improved Main Bar Script
    cat <<EOF > $out/bin/jonabar
#!/usr/bin/env bash
export LC_ALL="de_DE.UTF-8"
export LANG="de_DE.UTF-8"
export XDG_DATA_DIRS="${jonafonts}/share:\$XDG_DATA_DIRS"

# Kill ALL polybar instances to clear tray selection locks
pkill -9 polybar || true

if command -v xrandr > /dev/null; then
  for m in \$(xrandr --query | grep " connected" | cut -d" " -f1); do
    echo "Launching bar on monitor: \$m"
    MONITOR=\$m polybar --config="$out/etc/config.ini" --reload main &
  done
else
  polybar --config="$out/etc/config.ini" --reload main &
fi
EOF

    chmod +x $out/bin/jonabar $out/bin/jonabar-toggle-tray
  '';

  postFixup = ''
    for bin in $out/bin/*; do
      wrapProgram "$bin" \
        --prefix PATH : ${lib.makeBinPath [
          polybarFull
          kitty
          xorg.xrandr
          gnugrep
          coreutils
          gnused
          bash
          gawk
          procps
          sysstat
          networkmanager
          dmenu
          pulseaudio
        ]} \
        --set ALSA_PLUGIN_DIRS "${pulseaudio}/lib/alsa-lib"
    done
  '';
}
