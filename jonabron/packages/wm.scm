(define-module (jonabron packages wm)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages multiprecision)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages libidn)
  #:use-module (gnu packages base)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages pciutils)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages build-tools)
  #:use-module (gnu packages ninja)
  #:use-module (gnu packages pkg-config)
  #:use-module (guix build-system meson)
  #:use-module ((guix licenses) #:prefix license:)
  #:export (naitre vicinae))

(define-public vicinae
  (package
    (name "vicinae")
    (version "0.19.3")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/vicinaehq/vicinae/releases/download/v"
                                  version "/Vicinae-x86_64.AppImage"))
              (sha256
               (base32
                "1nw7llw1ad71jqbpcjfb96ghq4lbqvzw64gmxbmrc2hqnrc2vhkj"))))
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build utils))
       #:builder
       (begin
         (use-modules (guix build utils))
         (let* ((out           (assoc-ref %outputs "out"))
                (bin           (string-append out "/bin"))
                (bash          (assoc-ref %build-inputs "bash-minimal"))
                (patchelf      (assoc-ref %build-inputs "patchelf"))
                (glibc         (assoc-ref %build-inputs "glibc"))
                (libxcb        (assoc-ref %build-inputs "libxcb"))
                (dbus          (assoc-ref %build-inputs "dbus"))
                (wayland       (assoc-ref %build-inputs "wayland"))
                (openssl       (assoc-ref %build-inputs "openssl"))
                (libxkbcommon  (assoc-ref %build-inputs "libxkbcommon"))
                (libx11        (assoc-ref %build-inputs "libx11"))
                (freetype      (assoc-ref %build-inputs "freetype"))
                (icu4c         (assoc-ref %build-inputs "icu4c"))
                (brotli        (assoc-ref %build-inputs "brotli"))
                (libidn2       (assoc-ref %build-inputs "libidn2"))
                (libxft        (assoc-ref %build-inputs "libxft"))
                (libglvnd      (assoc-ref %build-inputs "libglvnd"))
                (gmp           (assoc-ref %build-inputs "gmp"))
                (zlib          (assoc-ref %build-inputs "zlib"))
                (gcc-lib       (assoc-ref %build-inputs "gcc-lib"))
                (e2fsprogs     (assoc-ref %build-inputs "e2fsprogs"))
                (fontconfig    (assoc-ref %build-inputs "fontconfig"))
                (xkbdata       (assoc-ref %build-inputs "xkeyboard-config"))
                (mesa          (assoc-ref %build-inputs "mesa"))
                (source        (assoc-ref %build-inputs "source"))
                (ld-so         (string-append glibc "/lib/ld-linux-x86-64.so.2")))

           (mkdir-p bin)
           (copy-file source "vicinae.AppImage")
           (chmod "vicinae.AppImage" #o755)

           ;; Extract AppImage
           (invoke "./vicinae.AppImage" "--appimage-extract")

           ;; Move contents to output
           (copy-recursively "squashfs-root/usr" out)

           ;; Fix 1
           (for-each (lambda (lib)
                       (chmod lib #o755)
                       (invoke (string-append patchelf "/bin/patchelf")
                               "--set-rpath" (string-append out "/lib")
                               lib))
                     (find-files (string-append out "/lib") "\\.so"))
           (let ((target-bin (string-append bin "/vicinae")))
             ;; Patch interpreter
             (invoke (string-append patchelf "/bin/patchelf")
                     "--set-interpreter" ld-so
                     target-bin)

             ;; Wrap with BOTH internal and external libraries
             (wrap-program target-bin
               #:sh (string-append bash "/bin/bash")
               `("QT_STYLE_OVERRIDE" "=" prefix ,(list "Fusion"))
               `("QT_PLUGIN_PATH" ":" = (,(string-append out "/lib/qt6/plugins")))
               `("XKB_CONFIG_ROOT" ":" = (,(string-append xkbdata "/share/X11/xkb")))
               `("FONTCONFIG_FILE" ":" = (,(string-append fontconfig "/etc/fonts/fonts.conf")))
               `("LD_LIBRARY_PATH" ":" =
                 (,(string-append out "/lib:"
                                  e2fsprogs "/lib:"
                                  wayland "/lib:"
                                  libxcb "/lib:"
                                  freetype "/lib:"
                                  libxft "/lib:"
                                  libxkbcommon "/lib:"
                                  icu4c "/lib:"
                                  brotli "/lib:"
                                  libidn2 "/lib:"
                                  gcc-lib "/lib:"
                                  gmp "/lib:"
                                  zlib "/lib:"
                                  openssl "/lib:"
                                  dbus "/lib:"
                                  libx11 "/lib:"
                                  libglvnd "/lib:"
                                  fontconfig "/lib:"
                                  glibc "/lib:"
                                  mesa "/lib")))))
           #t))))
    (native-inputs
     (list patchelf bash-minimal glibc))
    (inputs
     `(("bash-minimal" ,bash-minimal)
           ("glibc" ,glibc)
           ("wayland" ,wayland)
           ("e2fsprogs" ,e2fsprogs)
           ("libxcb" ,libxcb)
           ("xkeyboard-config" ,xkeyboard-config)
           ("libxkbcommon" ,libxkbcommon)
           ("openssl" ,openssl)
           ("freetype" ,freetype)
           ("dbus" ,dbus)
           ("libxft" ,libxft)
           ("gcc-lib" ,gcc "lib")
           ("libx11" ,libx11)
           ("zlib" ,zlib)
           ("gmp" ,gmp)
           ("libglvnd" ,libglvnd)
           ("fontconfig" ,fontconfig)
           ("brotli" ,brotli)
           ("icu4c" ,icu4c)
           ("libidn2" ,libidn2)
           ("zstd" ,zstd)
           ("mesa" ,mesa)))
    (home-page "https://github.com/vicinaehq/vicinae")
    (synopsis "A focused launcher for your desktop")
    (description "Vicinae AppImage patched for Guix compatibility.")
    (license license:gpl3)))

(define-public naitre
  (let ((commit "fe813d7b157c2d290a79cc863387800e99f1f1eb")
        (revision "1"))
  (package
    (name "naitre")
    (version(git-version "1.0.0" revision commit))
    (source (origin
             (method git-fetch)
             (uri (git-reference
                   (url "https://github.com/librepup/NaitreHUD")
                   (commit commit)))
             (file-name (git-file-name name version))
             (sha256
              (base32
               "1jbkpcrdw1yqfqnijgfchs0w2iy2ncw9a18h5czvsgcfk5hji4fj"))
             ))
    (build-system meson-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list (string-append "-Dsysconfdir=" #$output "/etc"))
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'configure 'patch-meson
            (lambda _
              (substitute* "meson.build"
                (("'-DSYSCONFDIR=\\\"@0@\\\"'.format\\('/etc'\\)")
                 "'-DSYSCONFDIR=\"@0@\"'.format(sysconfdir)")
                (("sysconfdir = sysconfdir.substring\\(prefix.length\\(\\)\\)")
                 ""))))
          (add-after 'install 'install-desktop-file
            (lambda* (#:key outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (wayland-sessions (string-append out "/share/wayland-sessions")))
                (mkdir-p wayland-sessions)
                (call-with-output-file (string-append wayland-sessions "/naitre.desktop")
                  (lambda (port)
                    (format port "[Desktop Entry]
Encoding=UTF-8
Name=NaitreHUD
Comment=NaitreHUD Wayland WM
Exec=~a/bin/naitre
Type=Application
DesktopNames=NaitreHUD
"
                            out)))))))))
    (inputs (list wayland
                  libinput
                  libdrm
                  libxkbcommon
                  pixman
                  libdisplay-info
                  libliftoff
                  hwdata
                  seatd
                  pcre2
                  libxcb
                  xcb-util-wm
                  wlroots
                  scenefx))
    (native-inputs (list pkg-config wayland-protocols))
    (home-page "https://github.com/librepup/NaitreHUD")
    (synopsis "Wayland Compositor and Window Manager")
    (description "A Wayland compositor based on wlroots and scenefx,
inspired by dwl but aiming to be more feature-rich.")
    (license license:gpl3))))
