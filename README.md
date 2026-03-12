# Jonabron Channel
![Guix Banner](https://raw.githubusercontent.com/librepup/jonabron/refs/heads/master/guixBanner.jpg)
# Info
## Provides
The **Jonabron** Channel provides the following packages:
### Guix
#### Emacs (jonabron packages emacs)
- emacs-hoon-mode
- emacs-fancy-dabbrev
#### WM (jonabron packages wm)
- naitre
- vicinae
- plan9-rio-session
#### Fonts (jonabron packages fonts)
- font-jonafonts
#### Games (jonabron packages games)
- osu-lazer-bin
- gamemode
- gamemode-service-type **(service)**
#### Communication (jonabron packages communication)
- discord
#### Shells (jonabron packages shells)
- oh-my-zsh
- powerlevel-10k
- plan9-rc-shell
#### Entertainment (jonabron packages entertainment)
- ani-cli
- ani-skip
- kew
#### Editors (jonabron packages editors)
- plan9-acme
#### Terminals (jonabrok packages terminals)
- plan9-term
#### AI (jonabron packages ai)
- claude-code
#### Geex (jonabron packages geex)
- geex-installer
- geex-bar
### Nix
#### Gaming Utils
 - gobm
#### Networks
 - urbit
#### Themes
 - win2ksvg

# Usage
## Guix
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
## NixOS
Add the **Jonabron** Channel as a Flake Input to your `/etc/nixos/flake.nix`, and use either the provided overlay, or manually reference Jonabron Packages via `inputs.jonabron.packages.x86_64-linux.<package>`:
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    geex.url = "github:librepup/jonabron";
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
        # Optional, add Overlay:
        #   nixpkgs.overlays = [ inputs.jonabron.overlays.default ];
        environment.systemPackages = with pkgs; [ inputs.jonabron.packages.x86_64-linux.gobm ];
        system.stateVersion = "25.11";
      }
    };

  };
}
```

Then rebuild your NixOS system with the command `doas nixos-rebuild switch --flake /etc/nixos#HOSTNAME` (replace `doas` with your escalation utility of choice).
