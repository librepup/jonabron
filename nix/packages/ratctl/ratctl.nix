{ pkgs ? import <nixpkgs> {} }:
let
  pythonWrapped = pkgs.python313.withPackages (ps: [
    ps.libusb1
    ps.pyqt5
  ]);
in
pkgs.stdenv.mkDerivation rec {
  pname = "ratctl";
  version = "0.1.1";
  src = pkgs.fetchFromGitHub {
    owner = "MayeulC";
    repo = "Saitek";
    rev = "ef9d36c0fb0cb7756e330f5c8c7e4b0e3ba09f8b";
    sha256 = "sha256-eMVUS3FZVnZ24iu+ERvKvJH4f0aYesaDzKI42iaHE4U=";
  };
  nativeBuildInputs = [
    pkgs.makeWrapper
    pkgs.wrapGAppsHook3
    pkgs.qt5.wrapQtAppsHook
  ];
  buildInputs = [
    pkgs.gtk3
    pythonWrapped
    pkgs.libusb1
    pkgs.libxcb
    pkgs.libxcb-util
    pkgs.libxcb-cursor
  ];
  dontBuild = true;
  installPhase = ''
    # Create Directories
    mkdir -p $out/bin $out/share $out/share/ratctl $out/share/applications $out/share/pixmaps

    # Copy Icon (Ensure this folder and file exist locally relative to default.nix!)
    cp ${./files/icon.png} $out/share/pixmaps/ratctl.png

    # Python Script
    cp $src/ratctl.py $out/share/ratctl/ratctl.py
    chmod +x $out/share/ratctl/ratctl.py

    # Use makeWrapper to link to the python script cleanly
    makeWrapper ${pythonWrapped}/bin/python3 $out/bin/ratctl \
      --add-flags "$out/share/ratctl/ratctl.py"

    # Make Desktop Item
    cp ${pkgs.makeDesktopItem {
      name = pname;
      desktopName = "RatCTL";
      exec = "ratctl";
      icon = "ratctl";
      terminal = false;
      categories = [ "Settings" "System" ];
    }}/share/applications/* $out/share/applications/

    runHook postInstall
  '';
  meta = {
    homepage = "https://github.com/MayeulC/Saitek";
    description = "RatCTL Utility for Mad Catz R.A.T. Mice. (Depends on Jonabron's ratctl-udevrules Package)";
    license = pkgs.lib.licenses.gpl3Plus;
    maintainers = with pkgs.lib; [ maintainers.librepup ];
    platforms = pkgs.lib.platforms.linux;
  };
}
