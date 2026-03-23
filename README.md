# Jonabron Channel
![Guix Banner](https://raw.githubusercontent.com/librepup/jonabron/refs/heads/master/guixBanner.jpg)
# Info
## Provides
The **Jonabron** Channel provides the following packages:
### Guix
<details>
<summary>Package List</summary>
#### Emacs (jonabron packages emacs)
- emacs-hoon-mode | Hoon Recognition for Emacs
- emacs-fancy-dabbrev | Simple Auto-Complete
#### WM (jonabron packages wm)
- naitre | Wayland WM and Compositor based on MangoWC
- vicinae | Wayland-Native Application Launcher
- plan9-rio-session | Session-File for Plan9's Rio
#### Fonts (jonabron packages fonts)
- font-jonafonts | Jonabron Fonts Bundle
#### Games (jonabron packages games)
- osu-lazer-bin | Packaged osu!lazer AppImage
- gamemode | Game Wrapper
- gamemode-service-type **(service)**
#### Communication (jonabron packages communication)
- discord | Chatting Platform
#### Shells (jonabron packages shells)
- oh-my-zsh | ZSH Suite
- powerlevel-10k | ZSH Theme
- plan9-rc-shell | Wrapped RC Shell from Plan9
#### Entertainment (jonabron packages entertainment)
- ani-cli | Watch Anime in the Terminal
- ani-skip | Automatically Skip Anime Intros
- kew | Terminal Music Player
#### Editors (jonabron packages editors)
- plan9-acme | Wrapped Plan9 Acme Editor
#### Terminals (jonabrok packages terminals)
- plan9-term | Wrapped Plan9 9Term Terminal
#### AI (jonabron packages ai)
- claude-code | Anthropic's Claude Coding Agent
#### Geex (jonabron packages geex)
- geex-installer | Interactive Guix Installer
- geex-bar | Pre-Configured Polybar
</details>

### Nix
<details>
<summary>Package List</summary>
#### Gaming Utils
 - gobm | Download osu! Beatmaps from URL
#### Networks
 - urbit | Clean Slate OS for the 21st Century
#### GRUB
 - dangerousjungle-grub-theme | GRUB Theme
#### Icons & GTK Themes
 - xptheme | Windows XP Themefiles
 - winxp-icons | Windows XP Icon Theme
 - windows-xp-theme | Windows XP Theme
 - revista | Windows Vista Theme
 - windows-vista-theme | Another Windows Vista Theme
 - diinki-aero | Diinki's Aero Theme
 - aeroshell-desktop | KDE Plasma Windows Aero Theme
#### Other
 - momoisay | Animated and Talking Sabai Momoi from Blue Archive
 - jonabar | Pre-Configured Polybar Setup
#### Games
 - osu-lazer-appimage | Latest Version of the osu!lazer AppImage
#### Fonts
 - cartographcf-font | CartographCF Font
 - gnutypewriter-font | GNU Typewriter Font
 - jonafonts | Jonafonts Bundle
   - Includes (jonafonts.*):
     - synapsian
     - karamarea
     - templeos
     - icons
     - lucidabright
     - blexmono
     - all (Install All Available Jonafonts)
</details>

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
