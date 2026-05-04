# Jonabron Channel
![Guix Banner](https://raw.githubusercontent.com/librepup/jonabron/refs/heads/master/guixBanner.jpg)

<details>
<summary>
Notice for NotITG Players
</summary>

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
# ...
```

You can add the two packages, `wineWowPackages.yabridge` and `(pkgs.callPackage "${inputs.jonabron}/nix/packages/notitg/default.nix" { })` to your system packages, user packages, or home packages (if you pass the inputs through).

What's important is that you manually install wine-yabridge, and circumvent the `flake.nix`'s defaults and attempts at managing dependencies for you. With this Method you ignore Jonabron's `flake.nix` (Only for NotITG of course...), and make NixOS use your locally installed, and cached packages - instead of forcefully compiling wine from source due to minute changes.

</details>

# Usage/Installation

<details>
<summary>
NixOS
</summary>

Add the **Jonabron** Channel as a Flake Input to your `/etc/nixos/flake.nix`, and use either the provided overlay, or manually reference Jonabron Packages via `inputs.jonabron.packages.x86_64-linux.<package>`:
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    jonabron.url = "github:librepup/jonabron";
  };
  outputs = inputs@{ self, nixpkgs, jonabron, ... }:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations.HOSTNAME = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
      };
      {
        { config, pkgs, lib, ... }:
        # -- Optional, add Overlay: --
        #   nixpkgs.overlays = [
        #     inputs.jonabron.overlays.default
        #   ];
        # --                        --

        environment.systemPackages = with pkgs; [
          inputs.jonabron.packages.x86_64-linux.gobm
        ];

        system.stateVersion = "25.11";
      }
    };

  };
}
```

Then rebuild your NixOS system with the command `doas nixos-rebuild switch --flake /etc/nixos#HOSTNAME` (replace `doas` with your escalation utility of choice).

</details>

<details>
<summary>
GNU Guix
</summary>

Add the **Jonabron** Channel to your Guix `channels.scm`, located at `~/.config/guix/channels.scm` (and optionally to your `/etc/guix/channels.scm` as well):
```scm
(append (list
 ; ... your other Channels ...
 (channel
  (name 'jonabron)
  (branch "master")
  (url "https://github.com/librepup/jonabron.git"))
 ; ... your other Channels ...
))
```

Afterwards, run `guix pull` to update Guix and your Channels. Once that is completed, you should be able to include the Jonabron Channel in your system configuration files, like so:
```scm
(use-modules ; ... your other Modules ...
             (jonabron packages wm)
             (jonabron packages fonts)
             (jonabron packages terminals)
             (jonabron packages emacs)
             (jonabron packages communication)
             (jonabron packages games)
             (jonabron packages editors)
             (jonabron packages shells)
             (jonabron packages entertainment))

(define %guix-os (operating-system
  (packages (append
             (map specification->package+output
                  '("naitre"
                    "plan9-rc-shell"
                    "vicinae"
                    "font-jonafonts"
                    "osu-lazer-bin"
                    "plan9-acme"
                    "emacs-fancy-dabbrev"
                    "plan9-term"
                    "discord"
                    "oh-my-zsh"
                    "ani-cli"
                    ))
             ))
))

%guix-os
```
</details>

# Packages
<details>
<summary>
Nix
</summary>

# Package List
 - gobm
 - urbit
 - dangerousjungle-grub-theme
 - milk-grub-theme
 - xptheme
 - winxp-icons
 - momoisay
 - epdfinfo
 - cartographcf-font
 - osu-lazer-appimage
 - gnutypewriter-font
 - jonafonts
 - jonabar
 - diinki-aero
 - windows-vista-theme
 - revista
 - windows-xp-theme
 - aeroshell-desktop
 - keyboard-layout-exporter
 - notitg
 - arrowvortex
 - image-text-extractor
 - pybrowse
 - gamemode-manager

</details>

<details>
<summary>
Guix
</summary>

# Package List
- emacs-hoon-mode
- emacs-fancy-dabbrev
- naitre
- vicinae
- plan9-rio-session
- font-jonafonts
- osu-lazer-bin
- gamemode
- gamemode-service-type
- discord
- oh-my-zsh
- powerlevel-10k
- plan9-rc-shell
- ani-cli
- ani-skip
- kew
- plan9-acme
- plan9-term
- claude-code
- geex-installer
- geex-bar

</details>
