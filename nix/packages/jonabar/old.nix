{ lib
, stdenv
, writeShellApplication
, polybar
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
let
  configSource = ./files/config.ini;
  traySource = ./files/tray.ini;
  jonabar-toggle-tray = writeShellApplication {
    name = "jonabar-toggle-tray";
    runtimeInputs = [ procps polybar ];
    text = ''
      TRAY_CONFIG="${traySource}"
      PID=$(pgrep -f "polybar tray-bar --config=$TRAY_CONFIG" || true)
      if [ -n "$PID" ]; then
        kill -9 "$PID"
      else
        polybar tray-bar --config="$TRAY_CONFIG" &
      fi
    '';
  };
in
writeShellApplication {
  name = "jonabar";
  runtimeInputs = [
    polybar
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
    glibcLocales
  ];
  text = ''
    export LC_ALL="de_DE.UTF-8"
    export LANG="de_DE.UTF-8"
    export XDG_DATA_DIRS="${jonafonts}/share:$XDG_DATA_DIRS"

    if pgrep -x polybar > /dev/null; then
      pkill polybar
    fi
    if command -v xrandr > /dev/null; then
      for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --config="${configSource}" --reload main &
      done
    else
      polybar --config="${configSource}" --reload main &
    fi
  '';
}
