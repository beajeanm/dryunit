open Core_runtime
open Printf

open TestSuite
open TestDescription

let boot_alcotest oc suites : unit =
  fprintf oc "let () =\n";
  fprintf oc "  Alcotest.run \"Main\" [\n";
  List.iter
    ( fun suite ->
      fprintf oc "    \"%s\", [\n" suite.suite_path;
      List.iter
        ( fun test ->
          fprintf oc "      \"%s\", `Quick, %s.%s;\n" test.test_name suite.suite_name test.test_name;
        )
        suite.tests;
      fprintf oc "];\n";
    )
    suites;
fprintf oc "  ]\n";
flush oc
