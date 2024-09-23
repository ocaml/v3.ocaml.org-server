(lang dune 3.9)

(name ocamlorg)

(documentation "https://ocaml.github.io/ocaml.org/")

(source
 (github ocaml/ocaml.org))

(license ISC)

(authors
 "Thibaut Mattio"
 "Lucas Pluvinage"
 "Patrick Ferris"
 "Ashish Agarwal"
 "Kanishka Azimi"
 "Richard Davison"
 "Jiae Kam")

(maintainers "Thibaut Mattio" "Patrick Ferris")

(generate_opam_files true)

(using mdx 0.1)

(package
 (name ocamlorg)
 (synopsis "Official OCaml website")
 (description
  "This repository contains the server that serves the official OCaml website at https://ocaml.org.")
 (depends
  (ocaml
   (< 5))
  dune
  cohttp
  cohttp-lwt-unix
  bos
  crunch
  mirage-kv-mem
  dream-accept
  dream-encoding
  (graphql
   (>= 0.14.0))
  fpath
  fmt
  logs
  (cmarkit
   (>= 0.2.0))
  opam-format
  (timedesc
   (>= 2.0.0))
  yojson
  lwt
  (hilite
   (>= 0.4.0))
  syndic
  ounit
  (alcotest :with-test)
  (mdx
   (and
    :with-test
    (>= 1.10.0)))
  ; tools/ood-gen
  ppx_deriving_yaml
  ppx_stable
  ezjsonm
  lambdasoup
  ptime
  (cmdliner
   (>= 1.1.0))
  xmlm
  uri))
