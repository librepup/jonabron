# Info
## Provides
The **Jonabron** Channel provides the following packages:
- emacs-hoon-mode
- emacs-fancy-dabbrev
- naitre
- font-bundle-synapsian-karamarea
- vicinae
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
