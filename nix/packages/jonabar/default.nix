{ lib
, stdenv
, makeWrapper
, polybarFull
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
  version = "1.2";

  phases = [ "installPhase" "fixupPhase" ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/etc

    cp ${./files/config.ini} $out/etc/config.ini
    cp ${./files/tray.ini} $out/etc/tray.ini
    cp ${./files/gigi.ini} $out/etc/gigi.ini
    cp ${./files/mori.ini} $out/etc/mori.ini
    cp ${./files/elXoX.ini} $out/etc/elxox.ini
    cp ${./files/camila.ini} $out/etc/camila.ini
    cp ${./files/nihmune.ini} $out/etc/nihmune.ini

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

    cat <<EOF > $out/bin/jonabar-gigi
#!/usr/bin/env bash
export LC_ALL="de_DE.UTF-8"
export LANG="de_DE.UTF-8"
export XDG_DATA_DIRS="${jonafonts}/share:\$XDG_DATA_DIRS"

# Kill ALL polybar instances to clear tray selection locks
pkill -9 polybar || true

if command -v xrandr > /dev/null; then
  for m in \$(xrandr --query | grep " connected" | cut -d" " -f1); do
    echo "Launching bar on monitor: \$m"
    MONITOR=\$m polybar --config="$out/etc/gigi.ini" --reload main &
  done
else
  polybar --config="$out/etc/gigi.ini" --reload main &
fi
EOF

    cat <<EOF > $out/bin/jonabar-mori
#!/usr/bin/env bash
export LC_ALL="de_DE.UTF-8"
export LANG="de_DE.UTF-8"
export XDG_DATA_DIRS="${jonafonts}/share:\$XDG_DATA_DIRS"

# Kill ALL polybar instances to clear tray selection locks
pkill -9 polybar || true

if command -v xrandr > /dev/null; then
  for m in \$(xrandr --query | grep " connected" | cut -d" " -f1); do
    echo "Launching bar on monitor: \$m"
    MONITOR=\$m polybar --config="$out/etc/mori.ini" --reload main &
  done
else
  polybar --config="$out/etc/mori.ini" --reload main &
fi
EOF

    cat <<EOF > $out/bin/jonabar-elxox
#!/usr/bin/env bash
export LC_ALL="de_DE.UTF-8"
export LANG="de_DE.UTF-8"
export XDG_DATA_DIRS="${jonafonts}/share:\$XDG_DATA_DIRS"

# Kill ALL polybar instances to clear tray selection locks
pkill -9 polybar || true

if command -v xrandr > /dev/null; then
  for m in \$(xrandr --query | grep " connected" | cut -d" " -f1); do
    echo "Launching bar on monitor: \$m"
    MONITOR=\$m polybar --config="$out/etc/elxox.ini" --reload main &
  done
else
  polybar --config="$out/etc/elxox.ini" --reload main &
fi
EOF

    cat <<EOF > $out/bin/jonabar-camila
#!/usr/bin/env bash
export LC_ALL="de_DE.UTF-8"
export LANG="de_DE.UTF-8"
export XDG_DATA_DIRS="${jonafonts}/share:\$XDG_DATA_DIRS"

# Kill ALL polybar instances to clear tray selection locks
pkill -9 polybar || true

if command -v xrandr > /dev/null; then
  for m in \$(xrandr --query | grep " connected" | cut -d" " -f1); do
    echo "Launching bar on monitor: \$m"
    MONITOR=\$m polybar --config="$out/etc/camila.ini" --reload main &
  done
else
  polybar --config="$out/etc/camila.ini" --reload main &
fi
EOF

    cat <<EOF > $out/bin/jonabar-numi
#!/usr/bin/env bash
export LC_ALL="de_DE.UTF-8"
export LANG="de_DE.UTF-8"
export XDG_DATA_DIRS="${jonafonts}/share:\$XDG_DATA_DIRS"

# Kill ALL polybar instances to clear tray selection locks
pkill -9 polybar || true

if command -v xrandr > /dev/null; then
  for m in \$(xrandr --query | grep " connected" | cut -d" " -f1); do
    echo "Launching bar on monitor: \$m"
    MONITOR=\$m polybar --config="$out/etc/nihmune.ini" --reload main &
  done
else
  polybar --config="$out/etc/nihmune.ini" --reload main &
fi
EOF

    chmod +x $out/bin/jonabar $out/bin/jonabar-toggle-tray $out/bin/jonabar-gigi $out/bin/jonabar-mori $out/bin/jonabar-elxox $out/bin/jonabar-camila $out/bin/jonabar-numi
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
