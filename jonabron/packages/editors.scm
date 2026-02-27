(define-module (jonabron packages editors)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages plan9)
  #:use-module ((guix licenses) #:prefix license:)
  #:export (plan9-acme))

(define-public plan9-acme
  (package
   (name "plan9-acme")
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
                 (acme-path (string-append bin "/acme")))
           (mkdir-p bin)
           (call-with-output-file acme-path
             (lambda (port)
               (format port "#!/bin/sh\nexec ~a/bin/9 acme \"$@\"\n"
                       #$(this-package-input "plan9port"))))
           (chmod acme-path #o555)))))
   (inputs
    (list plan9port))
   (synopsis "Then Plan 9 Acme Editor, wrapped into an Acme Binary.")
   (description "Provides a standalone 'acme' binary that calls plan9port's acme.")
   (home-page "https://9fans.github.io/plan9port/")
   (license #f)))
