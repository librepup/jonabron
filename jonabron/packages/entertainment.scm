(define-module (jonabron packages entertainment)
  #:use-module (ice-9 match)
  #:use-module ((srfi srfi-1) #:hide (zip))
  #:use-module (srfi srfi-26)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix deprecation)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system pyproject)
  #:use-module (guix build-system python)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages bittorrent)
  #:use-module (gnu packages build-tools)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages datastructures)
  #:use-module (gnu packages dbm)
  #:use-module (gnu packages dejagnu)
  #:use-module (gnu packages dns)
  #:use-module (gnu packages docbook)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages file)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages ghostscript)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages gnunet)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages graphics)
  #:use-module (gnu packages gstreamer)
  #:use-module (gnu packages image)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages music)
  #:use-module (gnu packages mp3)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages nettle)
  #:use-module (gnu packages networking)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages perl-check)
  #:use-module (gnu packages perl-web)
  #:use-module (gnu packages pretty-print)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages python-compression)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages video)
  #:use-module (gnu packages web)
  #:use-module (gnu packages wget)
  #:use-module (gnu packages nss)
  #:export (ani-cli ani-skip))


(define-public ani-skip
  (package
   (name "ani-skip")
   (version "1.0.1")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/synacktraa/ani-skip")
           (commit "12b4960ecd34082a47ae4387d802b0a2847ec0a2")))
     (file-name (git-file-name name version))
     (sha256
      (base32 "1nk0vp9lpm90s8wfn0lwhcym5l8c30ssny1vdqwbwxzzg7882nms"))))
   (build-system gnu-build-system)
   (arguments
    (list
     #:tests? #f
     #:phases
     #~(modify-phases %standard-phases
                      (delete 'configure)
                      (delete 'build)
                      (replace 'install
                               (lambda _
                                 (install-file "ani-skip" (string-append #$output "/bin"))))
                      (add-after 'install 'wrap
                                 (lambda* (#:key inputs #:allow-other-keys)
                                          (let ((bin-path (map (lambda (pkg)
                                                                 (string-append (assoc-ref inputs pkg) "/bin"))
                                                               '("aria2" "curl" "ffmpeg" "fzf" "grep" "mpv" "sed"
                                                                 "ncurses" "yt-dlp" "nss-certs"))
                                                          ))
                                            (wrap-program (string-append #$output "/bin/ani-skip")
                                                          `("PATH" ":" prefix ,bin-path)
                                                          `("SSL_CERT_DIR" ":" = ("/etc/ssl/certs"))
                                                          `("SSL_CERT_FILE" ":" = ("/etc/ssl/certs/ca-certificates.crt")))
                                            )))
                      )))
   (inputs (list aria2
                 bash-minimal
                 coreutils
                 curl
                 ffmpeg
                 fzf
                 grep
                 mpv
                 ncurses
                 sed
                 yt-dlp
                 nss-certs))
   (native-search-paths
    (list (search-path-specification
           (variable "CURL_CA_BUNDLE")
           (file-type 'regular)
           (separator #f)
           (files '("etc/ssl/certs/ca-certificates.crt")))))
   (home-page "https://github.com/synacktraa/ani-skip")
   (synopsis "A script that offers an automated solution to bypass anime opening and ending sequences, enhancing your viewing experience by eliminating the need for manual intro and outro skipping.")
   (description
    "A script to automatically skip anime opening and ending sequences, making it easier to watch your favorite shows without having to manually skip the intros and outros each time.")
   (license license:gpl3+)))

(define-public ani-cli
  (package
    (name "ani-cli")
    (version "4.10")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/pystardust/ani-cli")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "17yjddnky3dkdl0v6gm2rmdmhb8yh9b5lwmmrq2c0k9dcz9i1xj7"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (delete 'build)
          (replace 'install
            (lambda _
              (install-file "ani-cli" (string-append #$output "/bin"))
              (install-file "ani-cli.1"
                            (string-append #$output "/share/man/man1"))))
          (add-after 'install 'wrap
                     (lambda* (#:key inputs #:allow-other-keys)
                              (let ((bin-path (map (lambda (pkg)
                                                     (string-append (assoc-ref inputs pkg) "/bin"))
                                                   '("aria2" "curl" "ffmpeg" "fzf" "grep" "mpv" "sed"
                                                     "ncurses" "yt-dlp" "nss-certs"))
                                              ))
                                   (wrap-program (string-append #$output "/bin/ani-cli")
                                                 `("PATH" ":" prefix ,bin-path)
                                                 `("SSL_CERT_DIR" ":" = ("/etc/ssl/certs"))
                                                 `("SSL_CERT_FILE" ":" = ("/etc/ssl/certs/ca-certificates.crt")))
                                   )))
          )))
    (inputs (list aria2
                  bash-minimal
                  coreutils
                  curl
                  ffmpeg
                  fzf
                  grep
                  mpv
                  ncurses
                  sed
                  yt-dlp
                  nss-certs))
    (native-search-paths
     (list (search-path-specification
            (variable "CURL_CA_BUNDLE")
            (file-type 'regular)
            (separator #f)
            (files '("etc/ssl/certs/ca-certificates.crt")))))
    (home-page "https://github.com/pystardust/ani-cli")
    (synopsis "Browse and watch Anime from the Command Line.")
    (description
     "ani-cli is a @acronym{CLI, command-line interface} to browse and watch
anime by streaming videos from @uref{https://allanime.to,All Anime}.

There are different features such as episode browsing, history tracking,
streaming at multiple resolutions, and much more, depending on what programs the
user has installed.")
    (license license:gpl3+)))
