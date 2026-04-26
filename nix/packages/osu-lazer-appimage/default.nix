{
  lib,
  stdenvNoCC,
  fetchurl,
  fetchzip,
  appimageTools,
  makeWrapper,
  nativeWayland ? false,
}:

let
  pname = "osu-lazer-appimage";
  version = "2026.425.0";

  src = fetchurl {
    url = "https://github.com/ppy/osu/releases/download/${version}-lazer/osu.AppImage";
    hash = "sha256-JpuHeZdXHx5n93y87cUiuBFFXexIMx0gO2HMezXWy0A=";
  };

  meta = {
    description = "Rhythm is just a *click* away! (AppImage Version for Score Submission and Multiplayer)";
    homepage = "https://osu.ppy.sh";
    license = with lib.licenses; [
      mit
      cc-by-nc-40
      unfreeRedistributable
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ librepup ];
    mainProgram = "osu!";
    platforms = [ "x86_64-linux" ];
  };

  passthru.updateScript = ./update.sh;
in
appimageTools.wrapType2 {
  inherit
    pname
    version
    src
    meta
    passthru
    ;

  extraPkgs = pkgs: with pkgs; [ icu ];

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      . ${makeWrapper}/nix-support/setup-hook
      mv -v $out/bin/${pname} $out/bin/osu!

      wrapProgram $out/bin/osu! \
        ${lib.optionalString nativeWayland "--set SDL_VIDEODRIVER wayland"} \
        --set OSU_EXTERNAL_UPDATE_PROVIDER 1

      install -m 444 -D ${contents}/osu!.desktop -t $out/share/applications
      for i in 16 32 48 64 96 128 256 512 1024; do
        install -D ${contents}/osu.png $out/share/icons/hicolor/''${i}x$i/apps/osu.png
      done
    '';
}
