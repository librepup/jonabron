{
  description = "Jonabron: Nix Channel Master Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  outputs = inputs@{ self, nixpkgs, ... }:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    gobm = pkgs.callPackage ./nix/packages/gobm/default.nix { };
    urbit = pkgs.callPackage ./nix/packages/urbit/default.nix { };
    dangerousjungle-grub-theme = pkgs.callPackage ./nix/packages/dangerousjungle-grub-theme/default.nix { };
    xptheme = pkgs.callPackage ./nix/packages/xptheme/default.nix { };
    winxp-icons = pkgs.callPackage ./nix/packages/winxp-icons/default.nix { inherit xptheme; };
  in
  {
    packages.x86_64-linux = {
      gobm = gobm;
      urbit = urbit;
      dangerousjungle-grub-theme = dangerousjungle-grub-theme;
      xptheme = xptheme;
      winxp-icons = winxp-icons;
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
    };
    overlays.default = final: prev: {
      gobm = gobm;
      urbit = urbit;
      dangerousjungle-grub-theme = dangerousjungle-grub-theme;
      xptheme = xptheme;
      winxp-icons = winxp-icons;
    };
  };
}
