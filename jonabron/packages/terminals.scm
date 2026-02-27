(define-module (jonabron packages terminals)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages plan9)
  #:use-module ((guix licenses) #:prefix license:)
  #:export (plan9-term))

(define-public plan9-term
  (package
   (name "plan9-term")
   (version "0.1")
   (source #f)
   (build-system trivial-build-system)
   (arguments
    (list
     #:modules '((guix build utils))
     #:builder
     #~(begin
         (use-modules (guix build utils))
         (let* ((bin (string-append #$output "/bin"))
                (term-path (string-append bin "/term")))
           (mkdir-p bin)
           (call-with-output-file term-path
             (lambda (port)
               (format port "#!/bin/sh\nexec ~a/bin/9 9term \"$@\"\n"
                       #$(this-package-input "plan9port"))))
           (chmod term-path #o555)))))
   (inputs
    (list plan9port))
   (synopsis "Then Plan 9 Acme Editor, wrapped into an Acme Binary.")
   (description "Provides a standalone 'acme' binary that calls plan9port's acme.")
   (home-page "https://9fans.github.io/plan9port/")
   (license #f)))
