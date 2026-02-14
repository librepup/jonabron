(define-module (jonabron packages games)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu services)
  #:use-module (gnu packages admin)
  #:use-module (gnu services dbus)
  #:use-module (gnu services shepherd)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages bootstrap)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gnuzilla)
  #:use-module (gnu packages gstreamer)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages image)
  #:use-module (gnu packages instrumentation)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages libffi)
  #:use-module (gnu packages linphone)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages pciutils)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages video)
  #:use-module (gnu packages vulkan)
  #:use-module (gnu packages web)
  #:use-module (gnu packages webkit)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xorg)
  #:use-module (guix build utils)
  #:use-module (gnu packages build-tools)
  #:use-module (gnu packages ninja)
  #:use-module (guix build-system cargo)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module (guix build-system meson)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:export (osu-lazer-bin gamemode gamemode-service-type))

(define osu-lazer-bin
  (package
    (name "osu-lazer-bin")
    (version "2026.119.0-lazer")
    (source
      (origin
        (method url-fetch)
        (uri
          (string-append "https://github.com/ppy/osu/releases/download/"
                         version
                         "/osu.AppImage"))
        (sha256
          (base32 "0kxpqxyzmamm7w4m16fz5d51wbnhj66992lnmrs3yp2dvd9ja7wp"))))
    (build-system copy-build-system)
    (arguments
      (list #:install-plan
            #~'(("usr/share/" "share/")
                ("usr/bin/" "lib/osu/")
                ("osu!.desktop" "share/applications/"))
            #:modules '((guix build utils)
                        (guix build copy-build-system)
                        (ice-9 format))
            #:phases
            #~(modify-phases %standard-phases
                (add-after 'unpack 'extract-appimage
                  (lambda _
                    (invoke "7z" "x" "osu.AppImage")))
                (add-after 'extract-appimage 'remove-unused-files
                  (lambda _
                    (map delete-file '("usr/bin/UpdateNix"))))
                (add-after 'install 'patch-elf
                  (lambda* (#:key inputs #:allow-other-keys)
                    (let ((ld.so (string-append #$(this-package-input "glibc")
                                                #$(glibc-dynamic-linker)))
                          (rpath (string-join
                                   (cons*
                                     (string-append #$output "/lib/osu")
                                     (map
                                       (lambda (input)
                                         (string-append (cdr input) "/lib"))
                                       inputs))
                                   ":")))
                      ;; Got this proc from hako's Rosenthal, thanks
                      (define (patch-elf file)
                        (format #t "Patching ~a ..." file)
                        (unless (string-contains file ".so")
                          (invoke "patchelf" "--set-interpreter" ld.so file))
                        (invoke "patchelf" "--set-rpath" rpath file)
                        (display " done\n"))
                      (for-each
                        (lambda (binary)
                          (patch-elf binary))
                        (append
                          (map
                            (lambda (binary)
                              (string-append #$output "/lib/osu/" binary))
                            '("osu!"))
                          (find-files (string-append #$output "/lib/osu") ".*\\.so.*"))))))
                (add-after 'patch-elf 'wrap-program
                  (lambda _
                    (let* ((bin (string-append #$output "/lib/osu/osu!"))
                           (wrapper (string-append #$output "/bin/osu!")))
                      (mkdir-p (dirname wrapper))
                      (symlink bin wrapper)
                      (wrap-program wrapper
                        `("OSU_EXTERNAL_UPDATE_PROVIDER" = ("1"))
                        `("SDL_VIDEODRIVER" = ("wayland"))
                        `("LD_LIBRARY_PATH" prefix (,(string-append #$output "/lib/osu")))))))
                (add-after 'wrap-program 'fix-so
                  (lambda _
                    (symlink (string-append #$(this-package-input "lttng-ust") "/lib/liblttng-ust.so")
                             (string-append #$output "/lib/osu/liblttng-ust.so.0"))
                    (symlink (string-append #$(this-package-input "eudev") "/lib/libudev.so.1.6.3")
                             (string-append #$output "/lib/osu/libudev.so.0"))))
                (add-after 'wrap-program 'make-files-executable
                  (lambda _
                    (let* ((lib-osu (string-append #$output "/lib/osu")))
                      (map (lambda (file)
                             (chmod file #o555))
                           (cons* (string-append lib-osu "/osu!")
                                  (append (find-files lib-osu ".*\\.dll")
                                          (find-files lib-osu ".*\\.so.*"))))))))))
    (native-inputs (list p7zip patchelf))
    (inputs
      (list alsa-lib
            dbus
            elfutils
            eudev
            gcc-toolchain
            glib
            glibc
            icu4c
            libdrm
            libxcb
            libxext
            libxkbcommon
            lttng-ust
            mesa
            openssl
            vulkan-loader
            wayland
            zlib
            alsa-plugins
            pulseaudio))
    (home-page "https://osu.ppy.sh/")
    (synopsis "rhythm is just a *click* away!")
    (description "A free-to-win rhythm game. This is the future – and final
– iteration of the osu! game client which marks the beginning of an open era!
Currently known by and released under the release codename lazer. As in
sharper than cutting-edge.")
    (properties '((upstream-name  . "osu")))
    (license license:expat)))

(define-public gamemode
  (package
    (name "gamemode")
    (version "1.8.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/FeralInteractive/gamemode")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "14i3y385jzpr30lxk38z84rq76sy4cz0pwm54rm62f4mnk0xwjjp"))
       (patches (list (local-file "files/gamemode-preload-nix-workaround.patch")))))
    (build-system meson-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list "-Dwith-pam-limits-dir=etc/security/limits.d"
              "-Dwith-systemd-user-unit-dir=lib/systemd/user"
              "-Dwith-systemd-group-dir=lib/sysusers.d"
              "--libexecdir=libexec")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'patch-paths
            (lambda _
              ;; Fix the library path for the runner script
              (substitute* "data/gamemoderun"
                (("@libraryPath@")
                 (string-append #$output "/lib")))))
          (add-before 'configure 'fix-systemd-dep
                      (lambda _
                        (let ((elogind-pc (string-append #+elogind "/lib/pkgconfig/libelogind.pc")))
                          (mkdir-p "pkgconfig")
                          (copy-file elogind-pc "pkgconfig/libsystemd.pc")
                          (setenv "PKG_CONFIG_PATH"
                                  (string-append (getcwd) "/pkgconfig:"
                                                 (or (getenv "PKG_CONFIG_PATH") ""))))))
          (add-after 'install 'post-fixup
            (lambda _
              (let* ((bin-dir (string-append #$output "/bin"))
                     (lib-dir (string-append #$output "/lib")))
                (for-each
                 (lambda (prog)
                   (let ((file (string-append bin-dir "/" prog)))
                     (when (file-exists? file)
                       (invoke "patchelf" "--set-rpath"
                               (string-append lib-dir ":" (getenv "LIBRARY_PATH"))
                               file))))
                 '("gamemoded" "gamemode-simulate-game"))))))))
(native-inputs
     (list pkg-config meson ninja patchelf))
    (inputs
     (list dbus libinih procps psmisc elogind))
    (home-page "https://feralinteractive.github.io/gamemode")
    (synopsis "Optimise Linux System Performance on Demand")
    (description "GameMode is a daemon/lib combo for Linux that allows games to
request a set of optimisations be temporarily applied to the host operating
system and/or a game process.")
    (properties '((upstream-name  . "gamemode")))
    (license license:bsd-3)))

(define %gamemode-polkit-rule
  (file-union "gamemode-polkit"
              `(("share/polkit-1/rules.d/gamemode.rules"
                 ,(plain-file "gamemode.rules"
                              "polkit.addRule(function(action, subject) {
                              if (action.id == \"com.feralinteractive.GameMode.governor-helper\" ||
                                  action.id == \"com.feralinteractive.GameMode.procmgr-helper\") {
                                  return polkit.Result.YES;
                              }
                              });")))))

; Enables '(service gamemode-service-type)' to be used in (operating-system (services ... )) definition.
(define-public gamemode-service-type
               (service-type
                 (name 'gamemode)
                 (extensions (list
                   (service-extension dbus-root-service-type
                                      (compose list identity))
                   (service-extension polkit-service-type
                                      (lambda (_) (list %gamemode-polkit-rule)))

                   (service-extension shepherd-root-service-type
                                      (lambda (package)
                                        (list (shepherd-service
                                                (provision '(gamemode))
                                                (documentation "Run the GameMode daemon.")
                                                (requirement '(dbus-system user-processes))
                                                (start #~(make-forkexec-constructor
                                                          (list #$(file-append package "/bin/gamemoded"))))
                                                (stop #~(make-kill-destructor))))))))
                   (default-value gamemode)
                   (description "Set up GameMode D-Bus and Polkit policies, as well as run the GameMode daemon.")
                   ))
