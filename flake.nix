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
    keyboard-layout-exporter = pkgs.callPackage ./nix/packages/keyboard-layout-exporter/default.nix { };
    notitg = pkgs.callPackage ./nix/packages/notitg/default.nix { };
    arrowvortex = pkgs.callPackage ./nix/packages/arrowvortex/default.nix { };
    image-text-extractor = pkgs.callPackage ./nix/packages/image-text-extractor/default.nix { };
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
      keyboard-layout-exporter = keyboard-layout-exporter;
      notitg = notitg;
      image-text-extractor = image-text-extractor;
      arrowvortex = arrowvortex;
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
      notitg = {
        type = "app";
        program = "${notitg}/bin/notitg";
        meta = {
          description = "NotITG Rhythm Game";
          mainProgram = "notitg";
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
      arrowvortex = {
        type = "app";
        program = "${arrowvortex}/bin/arrowvortex";
        meta = {
          description = "ArrowVortex Chart Editor for StepMania, osu!, (Not)ITG, and More!";
          mainProgram = "arrowvortex";
        };
      };
      image-text-extractor = {
        type = "app";
        program = "${image-text-extractor}/bin/image-text-extractor";
        meta = {
          description = "Script for Extracting Text from Images";
          mainProgram = "image-text-extractor";
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
      keyboard-layout-exporter = {
        type = "app";
        program = "${keyboard-layout-exporter}/bin/keyboard-layout-exporter";
        meta = {
          description = "Export Current Keyboard Layout and Maps as Image.";
          mainProgram = "keyboard-layout-exporter";
        };
      };
    };
    overlays.default = final: prev: {
      gobm = gobm;
      urbit = urbit;
      notitg = notitg;
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
      keyboard-layout-exporter = keyboard-layout-exporter;
      image-text-extractor = image-text-extractor;
      arrowvortex = arrowvortex;
    };
  };
}
