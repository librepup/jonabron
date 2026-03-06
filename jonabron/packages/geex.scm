(define-module (jonabron packages geex)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix build-system trivial)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages suckless)
  #:use-module (gnu packages base)
  #:use-module (gnu packages wget)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages disk)
  #:use-module (gnu packages gawk)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages pciutils)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages wm)
  #:use-module (jonabron packages fonts)
  #:export (geex-installer geex-bar))

(define-public geex-bar
  (package
   (name "geex-bar")
   (version "5")
   (source #f)
   (build-system trivial-build-system)
   (arguments
    (list
     #:modules '((guix build utils) (ice-9 string-fun))
     #:builder
     #~(begin
         (use-modules (guix build utils) (ice-9 string-fun))
         (let* ((out #$output)
                (bash-bin (string-append #$bash "/bin/bash"))
                (pkill-bin (string-append #$procps "/bin/pkill"))
                (pgrep-bin (string-append #$procps "/bin/pgrep"))
                (etc (string-append out "/etc"))
                (bin (string-append out "/bin"))
                (exec (string-append bin "/geex-bar"))
                (glibc-utf8-locales #$(this-package-input "glibc-utf8-locales"))
                (locales #$(this-package-input "glibc-utf8-locales"))
                (config-source #$(local-file "files/geex.geex-bar.config.ini"))
                (polybar #$(this-package-input "polybar"))
                (xrandr #$(this-package-input "xrandr"))
                (grep #$(this-package-input "grep"))
                (pulseaudio #$(this-package-input "pulseaudio"))
                (dmenu #$(this-package-input "dmenu"))
                (coreutils #$(this-package-input "coreutils"))
                (sed #$(this-package-input "sed"))
                (kitty #$(this-package-input "kitty"))
                (bash #$(this-package-input "bash"))
                (gawk #$(this-package-input "gawk"))
                (procps #$(this-package-input "procps"))
                (sysstat #$(this-package-input "sysstat"))
                (network-manager #$(this-package-input "network-manager"))
                (font-jonafonts #$(this-package-input "font-jonafonts"))
                (paths (map (lambda (input)
                              (string-append input "/bin"))
                            '#$(list xrandr
                                     polybar
                                     grep
                                     dmenu
                                     pulseaudio
                                     kitty
                                     coreutils
                                     sed
                                     bash
                                     gawk
                                     procps
                                     sysstat
                                     network-manager
                                     font-jonafonts
                                     glibc-utf8-locales)))
                (input-list (list #$xrandr #$polybar #$grep #$coreutils #$sed #$bash #$gawk #$procps #$sysstat #$network-manager #$kitty #$dmenu #$pulseaudio #$font-jonafonts))
                (path-string (string-join (map (lambda (p) (string-append p "/bin"))
                                               input-list))))
           (mkdir-p bin)
           (mkdir-p etc)
           (copy-file config-source (string-append etc "/geex-bar.ini"))
           (with-output-to-file exec
             (lambda ()
               (format #t "#!/bin/sh
export GUIX_LOCPATH=\"~a/lib/locale\"
export LC_ALL=\"de_DE.UTF-8\"
export LANG=\"de_DE.UTF-8\"
export XDG_DATA_DIRS=\"~a/share:$XDG_DATA_DIRS\"
export PATH=$PATH:~a

if ~a -x polybar > /dev/null; then
  ~a polybar
fi

if type \"xrandr\" > /dev/null; then
  for m in $(xrandr --query | grep \" connected\" | cut -d\" \" -f1); do
    MONITOR=$m ~a/bin/polybar --config=~a/geex-bar.ini --reload main &
  done
else
  ~a/bin/polybar --config=~a/geex-bar.ini --reload main &
fi" locales font-jonafonts path-string pgrep-bin pkill-bin #$polybar etc #$polybar etc)))
           (patch-shebang exec (list (string-append #$bash "/bin")))
           (chmod exec #o555)
           (wrap-program exec
                         #:sh bash-bin
                         `("PATH" ":" prefix ,paths))))))
   (inputs
    (list polybar
          kitty
          xrandr
          grep
          coreutils
          sed
          bash
          gawk
          procps
          sysstat
          network-manager
          font-jonafonts
          dmenu
          pulseaudio
          glibc-utf8-locales))
   (synopsis "Custom Polybar Launcher and Configuration")
   (description "Geex-Bar provides the User with a fully customized, and fully featured Polybar Configuration, as well as an executable which automatically detects and adapts to multi-monitor setups.")
   (home-page "https://github.com/librepup")
   (license license:gpl3+)))

(define-public geex-installer
  (package
   (name "geex-installer")
   (version "5")
   (source (local-file "files/geex.geex-installer.installer.sh"))
   (build-system trivial-build-system)
   (arguments
    (list
     #:modules '((guix build utils))
     #:builder
     #~(begin
         (use-modules (guix build utils)
                      (srfi srfi-1))
         (let* ((out #$output)
                (bin (string-append out "/bin"))
                (target (string-append bin "/geex-installer"))
                (bash-bin (string-append #$bash-minimal "/bin/bash"))
                (tzdata-path (string-append #$tzdata "/share/zoneinfo"))
                (xkb-path (string-append #$xkeyboard-config "/share/X11/xkb"))
                (paths (map (lambda (input)
                              (string-append input "/bin"))
                            '#$(list coreutils
                                     bash-minimal
                                     gawk
                                     grep
                                     parted
                                     findutils
                                     util-linux
                                     git-minimal
                                     dialog
                                     procps
                                     e2fsprogs
                                     pciutils
                                     wpa-supplicant
                                     isc-dhcp
                                     curl
                                     wget
                                     tzdata
                                     xkeyboard-config))))
           (mkdir-p bin)
           (copy-file #$(package-source this-package) target)
           (substitute* target
                        (("@@GEEX_ZONEINFO@@") tzdata-path)
                        (("@@GEEX_XKB@@") xkb-path))
           (patch-shebang target (list (string-append #$bash-minimal "/bin")))
           (chmod target #o755)
           (wrap-program target
                         #:sh bash-bin
                         `("PATH" ":" prefix ,paths))))))
   (inputs
    (list coreutils
          bash-minimal
          gawk
          grep
          parted
          findutils
          util-linux
          git-minimal
          dialog
          procps
          e2fsprogs
          pciutils
          wpa-supplicant
          isc-dhcp
          curl
          wget
          tzdata
          xkeyboard-config))
   (home-page "https://github.com/librepup/geex")
   (synopsis "Geex Interactive Installe and Generator")
   (description "The Geex Installer is an interactive, shell-based script, designed to allow users to easily generate GNU Guix Systems Configuration Files via easy to understand prompts, smart auto-detection system, and a multitude of options.")

   (license license:gpl3+)))
