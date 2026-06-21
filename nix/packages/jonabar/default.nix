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
, writeShellApplication
}:
let
  inetScript = writeShellApplication {
    name = "mori-inet";
    runtimeInputs = [
      networkmanager
    ];
    excludeShellChecks = [
      "SC2034"
    ];
    checkPhase = "";
    text = builtins.readFile ./files/inet.sh;
  };
  jonabarBin = writeShellApplication {
    name = "jonabar";
    runtimeInputs = [
      polybarFull
      xorg.xrandr
      procps
    ];
    text = ''
      set -euo pipefail

      export LC_ALL="de_DE.UTF-8"
      export LANG="de_DE.UTF-8"
      export XDG_DATA_DIRS="${jonafonts}/share:$XDG_DATA_DIRS"

      CONFIG_DIR="$JONABAR_CONFIG_DIR"
      tray_config="$CONFIG_DIR/tray.ini"

      kill_polybar() {
        pkill -9 polybar || true
      }

      start_bar() {
        local cfg="$1"
        local config_file="$CONFIG_DIR/$cfg.ini"

        kill_polybar

        if command -v xrandr >/dev/null; then
          for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
            MONITOR=$m polybar --config="$config_file" --reload main &
          done
        else
          polybar --config="$config_file" --reload main &
        fi
      }

      toggle_tray() {
        local pid
        pid=$(pgrep -f "polybar tray-bar --config=$tray_config" || true)

        if [[ -n "$pid" ]]; then
          kill -9 "$pid"
        else
          polybar tray-bar --config="$tray_config" >/dev/null 2>&1 &
        fi
      }

      case "''${1:-}" in
        tray)
          toggle_tray
          ;;
        start)
          start_bar "''${2:-main}"
          ;;
        kill)
          ${procps}/bin/pkill -9 polybar
          ;;
        *)
          echo "Usage:"
          echo "  jonabar tray"
          echo "  jonabar kill"
          echo "  jonabar start <config>"
          exit 1
          ;;
      esac
    '';
  };
in
stdenv.mkDerivation {
  pname = "jonabar";
  version = "1.3";
  phases = [
    "installPhase"
    "fixupPhase"
  ];
  nativeBuildInputs = [
    makeWrapper
  ];
  installPhase = ''
    mkdir -p $out/bin $out/etc

    substitute ${./files/mori.ini} $out/etc/mori.ini \
      --replace-fail "INETSTATUSREPLACEMENTTEXT14171209" \
      "${inetScript}/bin/mori-inet"

    substitute ${./files/shondo.ini} $out/etc/shondo.ini \
      --replace-fail "INETSTATUSREPLACEMENTTEXT14171209" \
      "${inetScript}/bin/mori-inet"

    cp ${./files/config.ini} $out/etc/main.ini
    cp ${./files/mori.ini} $out/etc/mori.ini
    cp ${./files/gigi.ini} $out/etc/gigi.ini
    cp ${./files/elXoX.ini} $out/etc/elxox.ini
    cp ${./files/camila.ini} $out/etc/camila.ini
    cp ${./files/nihmune.ini} $out/etc/nihmune.ini
    cp ${./files/nihmune.ini} $out/etc/numi.ini
    cp ${./files/shondo.ini} $out/etc/shondo.ini
    cp ${./files/tray.ini} $out/etc/tray.ini

    substitute ${./files/mori.ini} $out/etc/mori.ini \
      --replace-fail "INETSTATUSREPLACEMENTTEXT14171209" \
      "${inetScript}/bin/mori-inet"

    substitute ${./files/shondo.ini} $out/etc/shondo.ini \
      --replace-fail "INETSTATUSREPLACEMENTTEXT14171209" \
      "${inetScript}/bin/mori-inet"

    install -Dm755 ${jonabarBin}/bin/jonabar $out/bin/jonabar
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
        --set ALSA_PLUGIN_DIRS "${pulseaudio}/lib/alsa-lib" \
        --set JONABAR_CONFIG_DIR "$out/etc"
    done
  '';
}
