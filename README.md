# Jonabron Channel
![Guix Banner](https://raw.githubusercontent.com/nixpup/jonabron/refs/heads/master/guixBanner.jpg)
# Info
## Provides
The **Jonabron** Channel provides the following packages:
### Emacs
- emacs-hoon-mode
- emacs-fancy-dabbrev
### WM
- naitre
- vicinae
### Fonts
- font-jonafonts
### Games
- osu-lazer-bin
# Usage
Add the **Jonabron** Channel to your Guix `channels.scm`, located at "~/.config/guix/channels.scm":
```scm
(append (list
 ; ... your other Channels ...
 (channel
  (name 'jonabron)
  (url "https://github.com/nixpup/jonabron.git"))
 ; ... your other Channels ...
))
```
Afterwards, run `guix pull` to update Guix and your Channels. Once that is completed, you should be able to include the Jonabron Channel in your system configuration files, like so:
```scm
(use-modules ; ... your other Modules ...
             (jonabron packages wm)
             (jonabron packages fonts)
             (jonabron packages emacs)
             (jonabron packages games))

(define %guix-os (operating-system
  (packages (append
             (map specification->package+output
                  '("naitre" ; From (jonabron packages wm).
                    "vicinae" ; From (jonabron packages wm).
                    "font-bundle-synapsian-karamarea" ; From (jonabron packages fonts).
                    "osu-lazer-bin" ; From (jonabron packages games).
                    "emacs-fancy-dabbrev" ; From (jonabron packages emacs).
                    ))
             ))
))
```
