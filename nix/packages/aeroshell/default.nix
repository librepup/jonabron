{ pkgs ? import <nixpkgs> {} }:
let
  aero-kwin-decoration = pkgs.callPackage ./aero-kwin-decoration.nix { };
  aero-theme-plasma = pkgs.callPackage ./aero-theme-plasma.nix { };
in
{
  inherit aero-kwin-decoration aero-theme-plasma;
  aeroshell-desktop = pkgs.symlinkJoin {
    name = "aeroshell-desktop";
    paths = [
      aero-kwin-decoration
      aero-theme-plasma
    ];
    meta = {
      description = "Complete AeroShell for KDE Plasma.";
      homepage = "https://github.com/aeroshell-desktop/aerothemeplasma";
      license = pkgs.lib.licenses.gpl3Plus;
      maintainers = with pkgs.lib; [ maintainers.librepup ];
    };
  };
}
