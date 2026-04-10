# NotITG
## Installation
If you do not want to compile `wineWowPackages.yabridge` from source, I recommend you install the NotITG Package like this:
```nix
# ...
users.users.<USERNAME> = {
  # ...
  packages = with pkgs; [
    # ...
    wineWowPackages.yabridge
    (pkgs.callPackage "${inputs.jonabron}/nix/packages/notitg/default.nix" { })
    # ...
  ];
  # ...
};
```

You can add the two packages, `wineWowPackages.yabridge` and `(pkgs.callPackage "${inputs.jonabron}/nix/packages/notitg/default.nix" { })` to your system packages, user packages, or home packages (if you pass the inputs through).

What's important is that you manually install wine-yabridge, and circumvent the `flake.nix`'s defaults and attempts at managing dependencies for you. With this Method you ignore Jonabron's `flake.nix` (Only for NotITG of course...), and make NixOS use your locally installed, and cached packages - instead of forcefully compiling wine from source due to minute changes.
