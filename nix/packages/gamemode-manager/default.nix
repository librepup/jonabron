{ lib
, pkgs
, python313
, gtk3
, wrapGAppsHook3
, gobject-introspection
, gamemode
}:

let
  pythonEnv = python313.withPackages (ps: [
    ps.pygobject3
  ]);
in
pkgs.stdenv.mkDerivation rec {
  pname = "gamemode-manager";
  version = "1.0";

  src = ./files;

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
    pkgs.makeWrapper
  ];

  buildInputs = [
    gtk3
    pythonEnv
    gamemode
  ];

  # We don't need a build command, we'll just install the files
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # 1. Create directory structure
    mkdir -p $out/bin $out/share/applications $out/share/pixmaps $out/lib/gamemode-manager

    # 2. Copy the python script and icon
    cp main.py $out/lib/gamemode-manager/main.py
    cp icon.png $out/share/pixmaps/gamemode-manager.png

    # 3. Create the entry point wrapper
    # wrapGAppsHook will automatically wrap this bin to fix the "Namespace Gtk" error
    makeWrapper ${pythonEnv}/bin/python3 $out/bin/gamemode-manager \
      --add-flags "$out/lib/gamemode-manager/main.py" \
      --prefix PATH : ${lib.makeBinPath [ gamemode ]}

    # 4. Create the desktop item
    cp ${pkgs.makeDesktopItem {
      name = pname;
      desktopName = "Gamemode Manager";
      exec = "gamemode-manager";
      icon = "gamemode-manager";
      terminal = false;
      categories = [ "Settings" "Game" ];
    }}/share/applications/* $out/share/applications/

    runHook postInstall
  '';

  meta = with lib; {
    description = "A simple GUI to toggle Gamemode for running processes";
    platforms = platforms.linux;
  };
}
