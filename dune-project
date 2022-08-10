(lang dune 1.10)
(name dryunit)
(version 0.7.0)

(source
 (github gersonmoraes/dryunit))

(authors "Gerson Moraes")

(maintainers "Gerson Moraes")

(generate_opam_files true)
(implicit_transitive_deps false)

(package
 (name dryunit)
 (synopsis "Detection tool for alcotest")
 (description "Dryunit is a detection tool for unit testing in OCaml that is focused in Convention over Configuration.")
 (depends
  (ocaml (>= 4.08.0))
  (dune (>= 3.0.0))
  terminal_size
  (cmdliner (= 1.0.2))))
