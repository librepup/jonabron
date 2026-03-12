{
  description = "G(N)eex: a custom Nix Channel/Input for various Packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    gobm = pkgs.callPackage ./nix/packages/gobm/default.nix { };
    urbit = pkgs.callPackage ./nix/packages/urbit/default.nix { };
    win2ksvg = pkgs.callPackage ./nix/packages/win2ksvg/default.nix { };
  in
  {
    packages.x86_64-linux = {
      gobm = gobm;
      urbit = urbit;
      win2ksvg = win2ksvg;
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
      win2ksvg = win2ksvg;
    };
  };
}
