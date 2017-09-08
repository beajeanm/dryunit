open Printf


let param n =
  try
    Array.get Sys.argv n
  with
  | _ -> "unknown"

let get_int () =
  (Random.int 9999) + 1


let help_message () =
  [ "gen alcotest        - Generate bootstrap for Alcotest in stdout."
  ; "                      To setup a destination, use:"
  ; "                      --output _build/default/tests/main.ml"
  ; ""
  ; "gen ounit           - Generate bootstrap for OUnit2"
  ; ""
  ; "clean               - Remove cache. You can remove the `.dryunit` directory"
  ; "                      directly"
  ; ""
  ; "--version           - Cli version"
  ; "--help              - Show this message"
  ] |>
  List.map (sprintf "  %s\n") |>
  String.concat "\n" |>
  sprintf "USAGE:\n  %s  subcommand [options] %s\n" (Array.get Sys.argv 0)


let generate_testsuite_exe framework =
  let id = sprintf "%d%d%d" (get_int ()) (get_int ()) (get_int ()) in
  let message = "This file is supposed to be generated before build automatically with a " ^
    "random `ID`.\n  Do not include it in your source control." in
  printf "(*\n  %s\n\n  ID = %s\n*)\n\nlet () = [%s%s]\n"
    message id "%" framework

let () =
  if ( (Array.length Sys.argv = 2) && (param 1 = "clean") ) then
  ( if Sys.file_exists ".dryunit" then
    ( Sys.readdir ".dryunit" |>
      Array.iter (fun f -> Sys.remove(".dryunit" ^ Filename.dir_sep ^ f));
      Unix.rmdir ".dryunit"
    );
    exit 0
  )

let () =
  Random.self_init ();
  if ( (Array.length Sys.argv < 3)
       || (not(param 1 = "--gen"))) then
  ( Printf.eprintf "%s" (help_message ());
    exit 1;
  );
  let framework = param 2 in
  if not (framework = "alcotest") && not (framework = "ounit") then
  ( eprintf "Unknown test framework: %s" framework;
    exit 1;
  );
  generate_testsuite_exe framework
