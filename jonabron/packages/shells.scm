(define-module (jonabron packages shells)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module  (guix build-system copy)
  #:use-module  (guix download)
  #:use-module  (guix git-download)
  #:use-module (guix git)
  #:export (oh-my-zsh powerlevel-10k))

(define-public oh-my-zsh
  (let ((rev "9df4ea095fe27ccd0ee95f2d34bab884c4a75585"))
    (package
      (name "oh-my-zsh")
      (version "2026011-0")
      (source
       (origin (method git-fetch)
               (uri (git-reference
                     (url "https://github.com/ohmyzsh/ohmyzsh")
                     (commit rev)))
               (file-name (git-file-name name version))
               (sha256
                (base32 "0bdmvdidlckvg4haa0k9rrv76wriv2gyd9bk509cmaqwjyi0n7a9"))
               (snippet
                 #~(begin
                     (use-modules (guix build utils))
                     (substitute* "lib/cli.zsh"
                       (("<detached>") #$version)
                       (("version=\\$\\(.*\\)")
                        "false")
                       (("local commit=.*$")
                        (string-append "local commit=" #$rev)))))))
      (build-system copy-build-system)
      (home-page "https://ohmyz.sh/")
      (synopsis "Oh My Zsh configuration framework")
      (description
       "This package provides Oh My Zsh configuration framework for zsh.")
      (license license:expat-0)
      (arguments (list #:install-plan
                       #~(cons (list "oh-my-zsh.sh" "share/zsh/plugins/oh-my-zsh/oh-my-zsh.zsh")
                               (map (lambda (d) `(,d "share/zsh/plugins/oh-my-zsh/"))
                                '("cache" "custom""lib" "log" "plugins"
                                  "templates" "themes""tools"))))))))

(define-public powerlevel-10k
  (let ((commit "efc9ddd9b615a0042b5bcc36f97f070ca6fdf09e")
        (revno "1"))
    (package
     (name "powerlevel-10k")
     (version (git-version "1.20.0" revno commit))
     (source
      (origin (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/romkatv/powerlevel10k")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256 (base32 "02shc1yc1a8bg7ycrdghwgn4zqq2wsb8852fhbaz9cahn5qdmig2"))))
     (build-system copy-build-system)
     (home-page "https://github.com/romkatv/powerlevel10k/")
     (synopsis "Powerlevel 10K zsh prompt framework")
     (description
      "This package provides powerlevel10k prompt framework for zsh.")
     (license license:expat-0)
     (arguments (list #:install-plan
                      #~(map (lambda (d)
                               (list d
                                     "share/zsh/plugins/powerlevel10k/"))
                             (list "config"
                                   "gitstatus"
                                   "internal"
                                   "Makefile"
                                   "powerlevel10k.zsh-theme"
                                   "powerlevel9k.zsh-theme"
                                   "prompt_powerlevel10k_setup"
                                   "prompt_powerlevel9k_setup")))))))
