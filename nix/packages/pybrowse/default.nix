{ lib
, stdenv
, makeWrapper
, pkgs
}:

let
  pythonEnv = pkgs.python313.withPackages (ps: [
    ps.pyqt5
    ps.pyqt6
    ps.pyside6
    ps.bashlex
    ps.pathlib2
  ]);
in
stdenv.mkDerivation rec {
  pname = "pybrowse";
  version = "1.0";
  src = ./files;
  nativeBuildInputs = [
    pythonEnv
    makeWrapper
    pkgs.kdePackages.kdialog
  ];
  dontBuild = true;
  dontWrapQtApps = true;

  buildCommand = let
    script = pkgs.writeShellApplication {
      name = pname;
      runtimeInputs = [
        pythonEnv
        makeWrapper
        pkgs.kdePackages.kdialog
      ];
      text = ''
        exec ${pythonEnv}/bin/python3 ${./files/main.py} "$@"
      '';
      #text = (builtins.readFile ./files/main.py);
    };
    desktopEntry = pkgs.makeDesktopItem {
      name = pname;
      desktopName = pname;
      exec = "${script}/bin/${pname} %f";
      terminal = true;
    };
    exampleConfig = pkgs.writeText "example.config" ''
      "Helium" "helium"
      "Zen" "zen"
      "Firefox" "firefox"
      "Edge" "microsoft-edge"
      "Floorp" "Floorp"
    '';
    manpage = pkgs.writeText "pybrowse.1" ''
      .\" Manpage for pybrowse.
      .\" Contact @puppyfailure on Discord or via librepup@member.fsf.org on E-Mail for Error Reports and Suggestions.
      .TH pybrowse 1
      .SH NAME
      pybrowse \- GUI Browser Launcher and Selector
      .SH SYNOPSIS
      .B pybrowse
      URL
      .SH DESCRIPTION
      Launches the PyBrowse Application, passing a URL/Link for it to open.
      .SH CONFIGURATION
      .TP
      .BR $HOME/.config/pybrowse/config ", " $XDG_CONFIG_HOME/pybrowse/config
      The Configuration File for pybrowse. Provide two arguments: "Entry Name" and "Executable Name" in quotes per line, which will be read by pybrowse and used to create the menu.
      .TP
      .SH EXAMPLE CONFIGURATION FILE
      The example configuration file for pybrowse, located at: "${exampleConfig}".
      .SH AUTHOR
      librepup (librepup@member.fsf.org, or @puppyfailure on Discord)
    '';
  in ''
    runHook preInstall
    mkdir -p $out/bin $out/share/applications $out/etc $out/share/man/man1
    
    cp ${script}/bin/pybrowse $out/bin/pybrowse  
    cp ${desktopEntry}/share/applications/pybrowse.desktop $out/share/applications/pybrowse.desktop
    cp ${./files/main.py} $out/etc/pybrowse.py
    cp ${manpage} $out/share/man/man1/pybrowse.1
    cp ${exampleConfig} $out/etc/example.config
    
    runHook postInstall
  '';
}
