open Util
open Printf

type test = {
  test_name: string;
  test_title: string;
}

let title_from = title_from
let title_from_no_padding = title_from_filename

let extract_from ~filename : test list =
  tests_from filename
  |> List.map
    (fun test_name ->
       { test_name; test_title = title_from test_name }
    )

let pp name tests =
  print_endline ("Tests in `" ^ name ^ "`");
  List.iter (fun t -> Printf.printf " - %s [%s]\n" t.test_title t.test_name) tests

let debug ~filename : string =
  extract_from ~filename
  |> List.map (fun v -> v.test_title)
  |> String.concat "\n"

module Test = struct
  let name (t:test) = t.test_name
  let title (t:test) = t.test_title
end

let extract_name_from_file ~filename =
  String.capitalize_ascii
