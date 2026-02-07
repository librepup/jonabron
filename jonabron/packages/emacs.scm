(define-module (jonabron packages emacs)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix build-system emacs)
  #:use-module (guix licenses)
  #:use-module (gnu packages emacs-xyz)
  #:export (emacs-fancy-dabbrev
            emacs-hoon-mode))

(define-public emacs-hoon-mode
  (let ((commit "5369ecec3cd154628cb23cf80d65c007bd940c70")
        (revision "0"))
    (package
     (name "emacs-hoon-mode")
     (version (git-version "0.1" revision commit))
     (source
      (origin
       (uri (git-reference
             (url "https://github.com/urbit/hoon-mode.el")
             (commit commit)))
       (method git-fetch)
       (sha256
        (base32 "077zhnq18kmjkrkdakwbpvrdmadxk9d189jpv4d8a03iwggs3sc0"))
       (file-name (git-file-name name version))))
     (build-system emacs-build-system)
     (arguments
      (list
       #:phases
       #~(modify-phases %standard-phases
        (add-after 'install 'install-dictionary
         (lambda* (#:key outputs #:allow-other-keys)
                  (let* ((out (assoc-ref outputs "out"))
                         (elpa-name-ver (string-append
                                         "hoon-mode" "-" #$version))
                         (site-lisp (string-append out "/share/emacs/site-lisp/" elpa-name-ver)))
                    (install-file "hoon-dictionary.json" site-lisp))))
          ))
       )
     (propagated-inputs
      (list
       )
      )
     (home-page "https://github.com/urbit/hoon-mode.el")
     (synopsis "Syntax Highlighting for the Hoon Language.")
     (description
      "This package provides hoon-mode, which povides syntax highlighting for the language Hoon, which is part of the Urbit ecosystem. Additionally, it provides documentation extracted from 'developers.urbit.org' via 'eldoc'.")
     (license gpl3))))

(define-public emacs-fancy-dabbrev
  (let ((commit "cf4a2f7e3e43e07ab9aa9db16532a21010e9fc8c")
        (revision "0"))
    (package
     (name "emacs-fancy-dabbrev")
     (version (git-version "1.1" revision commit))
     (source
      (origin
       (uri (git-reference
             (url "https://github.com/jrosdahl/fancy-dabbrev")
             (commit commit)))
       (method git-fetch)
       (sha256
        (base32 "04z9pwvl68hsisnyf9wlxmkwk8xag36jvcchwcwp4n9vp04z8745"))
       (file-name (git-file-name name version))))
     (build-system emacs-build-system)
     (propagated-inputs
      (list
       emacs-popup))
     (home-page "https://github.com/jrosdahl/fancy-dabbrev")
     (synopsis "Emacs dabbrev-expand with preview and popup menu.")
     (description
      "fancy-dabbrev essentially wraps the Emacs built-in dabbrev functionality, with two improvements: preview in fancy-dabbrev-mode, and a popup menu after the first call of fancy-dabbrev-expand.")
     (license gpl3))))
