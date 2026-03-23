{
  description = "Jonabron: Nix Channel Master Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  outputs = inputs@{ self, nixpkgs, ... }:
  let
    config = { allowUnfree = true; };
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      inherit config;
    };
    gobm = pkgs.callPackage ./nix/packages/gobm/default.nix { };
    urbit = pkgs.callPackage ./nix/packages/urbit/default.nix { };
    dangerousjungle-grub-theme = pkgs.callPackage ./nix/packages/dangerousjungle-grub-theme/default.nix { };
    xptheme = pkgs.callPackage ./nix/packages/xptheme/default.nix { };
    winxp-icons = pkgs.callPackage ./nix/packages/winxp-icons/default.nix { inherit xptheme; };
    momoisay = pkgs.callPackage ./nix/packages/momoisay/default.nix { };
    epdfinfo = pkgs.callPackage ./nix/packages/epdfinfo/default.nix { };
    cartographcf-font = pkgs.callPackage ./nix/packages/cartographcf-font/default.nix { };
    osu-lazer-appimage = pkgs.callPackage ./nix/packages/osu-lazer-appimage/default.nix { };
    gnutypewriter-font = pkgs.callPackage ./nix/packages/gnutypewriter-font/default.nix { };
    jonafonts = pkgs.callPackage ./nix/packages/jonafonts/default.nix { };
    jonabar = pkgs.callPackage ./nix/packages/jonabar/default.nix { jonafonts = jonafonts.all; };
    diinki-aero = pkgs.callPackage ./nix/packages/diinki-aero/default.nix { };
    windows-vista-theme = pkgs.callPackage ./nix/packages/windows-vista-theme/default.nix { };
    revista = pkgs.callPackage ./nix/packages/revista/default.nix { };
    windows-xp-theme = pkgs.callPackage ./nix/packages/windows-xp-theme/default.nix { };
    aeroshell-desktop = (pkgs.callPackage ./nix/packages/aeroshell/default.nix {  }).aeroshell-desktop;
  in
  {
    packages.x86_64-linux = {
      gobm = gobm;
      urbit = urbit;
      dangerousjungle-grub-theme = dangerousjungle-grub-theme;
      xptheme = xptheme;
      winxp-icons = winxp-icons;
      momoisay = momoisay;
      epdfinfo = epdfinfo;
      cartographcf-font = cartographcf-font;
      osu-lazer-appimage = osu-lazer-appimage;
      gnutypewriter-font = gnutypewriter-font;
      jonafonts = jonafonts;
      jonabar = jonabar;
      diinki-aero = diinki-aero;
      windows-vista-theme = windows-vista-theme;
      revista = revista;
      windows-xp-theme = windows-xp-theme;
      aeroshell-desktop = aeroshell-desktop;
    };
    apps.x86_64-linux = {
      gobm = {
        type = "app";
        program = "${gobm}/bin/gobm";
        meta = {
          description = "Download osu! Beatmaps from a URL";
          mainProgram = "gobm";
        };
      };
      urbit = {
        type = "app";
        program = "${urbit}/bin/urbit";
        meta = {
          description = "A clean-slate OS and network for the 21st century.";
          mainProgram = "urbit";
        };
      };
      momoisay = {
        type = "app";
        program = "${momoisay}/bin/momoisay";
        meta = {
          description = "A CLI program written in C featuring talking Saiba Momoi from Blue Archive";
          mainProgram = "momoisay";
        };
      };
      epdfinfo = {
        type = "app";
        program = "${epdfinfo}/bin/epdfinfo";
        meta = {
          description = "EPDFInfo from Emacs";
          mainProgram = "epdfinfo";
        };
      };
      osu-lazer-appimage = {
        type = "app";
        program = "${osu-lazer-appimage}/bin/osu!";
        meta = {
          description = "Rhythm is just a *click* away!";
          mainProgram = "osu!";
        };
      };
      jonabar = {
        type = "app";
        program = "${jonabar}/bin/jonabar";
        meta = {
          description = "Customized Polybar Wrapper";
          mainProgram = "jonabar";
        };
      };
    };
    overlays.default = final: prev: {
      gobm = gobm;
      urbit = urbit;
      dangerousjungle-grub-theme = dangerousjungle-grub-theme;
      xptheme = xptheme;
      winxp-icons = winxp-icons;
      momoisay = momoisay;
      epdfinfo = epdfinfo;
      cartographcf-font = cartographcf-font;
      osu-lazer-appimage = osu-lazer-appimage;
      gnutypewriter-font = gnutypewriter-font;
      jonafonts = jonafonts;
      jonabar = jonabar;
      diinki-aero = diinki-aero;
      windows-vista-theme = windows-vista-theme;
      revista = revista;
      windows-xp-theme = windows-xp-theme;
      aeroshell-desktop = aeroshell-desktop;
    };
  };
}
