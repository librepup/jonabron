(define-module (jonabron packages ai)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages bootstrap)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages node)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system node)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module ((nonguix licenses) #:prefix lic:)
  #:use-module (ice-9 match)
  #:export (claude-code))

(define-public claude-code
  (package
    (name "claude-code")
    (version "2.1.45")
    (source
     (let ((arch (match (or (%current-target-system) (%current-system))
                   ("aarch64-linux" "linux-arm64")
                   (_ "linux-x64")))
           (hash (match (or (%current-target-system) (%current-system))
                   ("aarch64-linux"
                    "0zvy0m0wrsd43vr7ixj82m0x2h0rrcz8imisfa90lirf27lg0y76")
                   (_
                    "1pp4fn9q8npzllxhsqjk051x4kgqmdb8w7kl0x3rjrj67hw4gs77"))))
       (origin
         (method url-fetch)
         (uri
          (string-append
           "https://storage.googleapis.com/claude-code-dist-"
           "86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/"
           version "/" arch "/claude"))
         (sha256
          (base32 hash)))))
    (build-system copy-build-system)
    (arguments
     (list
      #:validate-runpath? #f
      #:strip-binaries? #f
      #:install-plan
      #~'(("claude" "libexec/claude"))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'patch-proc-self-exe
            (lambda _
              (invoke "sed" "-i" "s|/proc/self/exe|/proc/self/ex_|g" "claude")))
          (add-after 'install 'make-binary-executable
            (lambda _
              (chmod (string-append #$output "/libexec/claude") #o555)))
          (add-after 'make-binary-executable 'create-wrapper
            (lambda _
              (let ((bin (string-append #$output "/bin"))
                    (libexec (string-append #$output "/libexec/claude"))
                    (ld.so (string-append #$(this-package-input "glibc")
                                          #$(glibc-dynamic-linker)))
                    (lib-path
                     (string-join
                      (list (string-append
                             #$(this-package-input "glibc") "/lib")
                            (string-append
                             #$(this-package-input "gcc:lib") "/lib"))
                      ":")))
                (mkdir-p bin)
                (call-with-output-file (string-append bin "/claude")
                  (lambda (port)
                    (format port "#!~a
exec ~a --argv0 ~a --library-path ~a ~a \"$@\"~%"
                            #$(file-append bash-minimal "/bin/sh")
                            ld.so
                            libexec
                            lib-path
                            libexec)))
                (chmod (string-append bin "/claude") #o755)))))))
    (native-inputs
     (list sed))
    (inputs
     `(("bash-minimal" ,bash-minimal)
       ("glibc" ,glibc)
       ("gcc:lib" ,gcc "lib")))
    (supported-systems '("aarch64-linux" "x86_64-linux"))
    (properties '((substitutable? . #f)))
    (home-page "https://claude.ai/code")
    (synopsis "AI coding agent for the terminal")
    (description
     "Claude Code is an agentic coding tool that lives in your terminal,
understands your codebase, and helps you code faster by executing routine
tasks, explaining complex code, and handling git workflows through natural
language commands.")
    (license
     (lic:nonfree
      "https://code.claude.com/docs/en/legal-and-compliance"))))
