open Printf

open Model
open TestSuite
open TestDescription
open Util


let boot_alcotest oc suites : unit =
  fprintf oc "let () =\n";
  fprintf oc "  Alcotest.run \"Main\" [\n";
  List.iter
    ( fun suite ->
      fprintf oc "    \"%s\", [\n" suite.suite_title;
      List.iter
        ( fun test ->
          fprintf oc "      \"%s\", `Quick, %s.%s;\n"
            test.test_title
            suite.suite_name
            test.test_name;
        )
        suite.tests;
      fprintf oc "    ];\n";
    )
    suites;
fprintf oc "  ]\n";
flush oc


let boot_ounit oc suites : unit =
  fprintf oc "open OUnit2\n";
  fprintf oc "\nlet () =\n  run_test_tt_main (\n";
  fprintf oc "    \"All tests\" >::: [\n";
  List.iter
    ( fun suite ->
      List.iter
        ( fun test ->
          fprintf oc "      \"%s.%s\" >:: %s.%s;\n"
            suite.suite_name
            test.test_name
            suite.suite_name
            test.test_name;
        )
        suite.tests;
        fprintf oc "\n";
    )
    suites;
fprintf oc "    ]\n";
fprintf oc "  )\n";
flush oc


let init_default framework =
  print_endline @@ String.trim @@ "
(executable
 ((name main)
  (libraries (" ^ TestFramework.package framework ^ "))))

(rule
 ((targets (main.ml))
  (deps ((glob_files tests.ml) (glob_files *tests.ml) (glob_files *Tests.ml)))
  (action (with-stdout-to ${@} (run dryunit gen
    --framework " ^ TestFramework.to_string framework ^ "
    ;; --filter \"space separated list\"
    ;; --ignore \"space separated list\"
    ;; --ignore-path \"space separated list\"
  )))))

(alias
  ((name runtest)
   (deps (main.exe))
   (action (run ${<}))
  ))
"
