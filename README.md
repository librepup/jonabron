# Jonabron Channel
![Guix Banner](https://raw.githubusercontent.com/librepup/jonabron/refs/heads/master/guixBanner.jpg)
# Info
## Provides
The **Jonabron** Channel provides the following packages:
### Emacs (jonabron packages emacs)
- emacs-hoon-mode
- emacs-fancy-dabbrev
### WM (jonabron packages wm)
- naitre
- vicinae
### Fonts (jonabron packages fonts)
- font-jonafonts
### Games (jonabron packages games)
- osu-lazer-bin
- gamemode
- gamemode-service-type **(service)**
### Communication (jonabron packages communication)
- discord
### Shells (jonabron packages shells)
- oh-my-zsh
- powerlevel-10k
### Entertainment (jonabron packages entertainment)
- ani-cli
- ani-skip

# Usage
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
             (jonabron packages emacs)
             (jonabron packages communication)
             (jonabron packages games)
             (jonabron packages entertainment))

(define %guix-os (operating-system
  (packages (append
             (map specification->package+output
                  '("naitre"
                    "vicinae"
                    "font-jonafonts"
                    "osu-lazer-bin"
                    "emacs-fancy-dabbrev"
                    "discord"
                    "oh-my-zsh"
                    "ani-cli"
                    ))
             ))
))

%guix-os
```
