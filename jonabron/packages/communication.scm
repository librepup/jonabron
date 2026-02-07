(define-module (jonabron packages communication)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages kerberos)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages node)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages video)
  #:use-module (gnu packages wget)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xorg)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module ((guix licenses) :prefix license:)
  #:use-module (nonguix build-system chromium-binary)
  #:use-module ((nonguix licenses) :prefix license:)
  #:use-module (ice-9 match)
  #:export (discord))

(define discord-disable-breaking-updates
  (with-extensions
   (list (@ (gnu packages guile) guile-json-4))
   (program-file
    "disable-breaking-updates"
    #~(begin
        (use-modules (json))
        (let* ((config-home (or (getenv "XDG_CONFIG_HOME")
                                (string-append (getenv "HOME") "/.config")))
               (settings-path (string-append config-home
                                             "/discord/settings.json"))
               (settings-tmp (string-append settings-path ".tmp"))
               (settings
                (if (file-exists? settings-path)
                    (with-exception-handler
                        (lambda (_)
                          (display "Settings invalid")
                          (newline)
                          (exit 0))
                      (lambda () (with-input-from-file settings-path json->scm))
                      #:unwind? #t
                      #:unwind-for-type 'json-invalid)
                    (list)))
               (skip (assoc-ref settings "SKIP_HOST_UPDATE")))
          (unless (eq? skip (not (getenv "DISCORD_ENABLE_UPDATES")))
            (set! skip (not skip))
            (with-output-to-file settings-tmp
              (lambda ()
                (scm->json (assoc-set! settings "SKIP_HOST_UPDATE" skip))))
            (rename-file settings-tmp settings-path)
            (display (if skip "Disabled updates" "Enabled updates"))
            (newline)))))))

(define-public discord
  (package
   (name "discord")
   (version "0.0.123")
   (source
    (origin
     (method url-fetch)
     (uri (string-append "https://cdn.discordapp.com/apps/linux/" version
                         "/discord-" version ".tar.gz"))
     (sha256
      (base32 "15646f76vigp35ffc5p2shrilbwj9c8ds6yfy979yvfgiiyl1hyr"))))
   (build-system chromium-binary-build-system)
   (arguments
    (list
     #:patchelf-plan
     #~`(("Discord") ("chrome_crashpad_handler") ("chrome-sandbox"))
     #:install-plan
     #~`(("." "opt/discord")
         ("discord.desktop" "/share/applications/")
         ("discord.sh" "bin/discord")
         ("discord.png" "share/icons/hicolor/256x256/apps/")
         ("discord.png" "share/pixmaps/"))
     #:phases
     (with-imported-modules '((guix build utils))
       #~(modify-phases %standard-phases
           (add-after 'binary-unpack 'setup-cwd
             (lambda* (#:key outputs #:allow-other-keys)
               (use-modules (guix build utils))
               (define output (assoc-ref outputs "out"))
               (substitute* "discord.desktop"
                 (("Exec=.*$")
                  (string-append "Exec=" output "/bin/discord\n"))
                 (("Path=.*$")
                  (string-append "Path=" output "/opt/discord\n")))
               (with-output-to-file "discord.sh"
                 (lambda _
                   (define (line . args)
                     (display (apply string-append args)) (newline))
                   (line "#!/bin/sh")
                   (line #$discord-disable-breaking-updates)
                   (line "cd " output "/opt/discord")
                   (line "./Discord"
                         ;; Always use Ozone on Wayland, not sure if this is a good idea.
                         " ${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WebRTCPipeWireCapturer}"
                         " \"$@\"")))
               (for-each
                (lambda (f) (chmod f #o755))
                '("Discord" "chrome_crashpad_handler" "chrome-sandbox"
                  "discord.sh" "postinst.sh"))))))))
   (inputs (list ffmpeg
                 gdk-pixbuf
                 libappindicator
                 libdbusmenu
                 libglvnd
                 libxscrnsaver
                 util-linux
                 wayland
                 gzip
                 libsm
                 node
                 pipewire
                 pulseaudio
                 unzip
                 wget
                 xdg-utils))
   (synopsis "Discord chat client")
   (description "All-in-one cross-platform voice and text chat for gamers.")
   (license (license:nonfree "https://discord.com/terms"))
   (home-page "https://discordapp.com")))
