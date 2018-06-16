open Model
open Util


let help man_format cmds topic =
  match topic with
  | None -> `Help (`Pager, None)
  | Some topic ->
      let topics = "topics" :: "patterns" :: "environment" :: cmds in
      let conv, _ =
        Cmdliner.Arg.enum (List.rev_map (fun s -> (s, s)) topics) in
      ( match conv topic with
        | `Error e -> `Error (false, e)
        | `Ok t when t = "topics" -> List.iter print_endline topics; `Ok ()
        | `Ok t when List.mem t cmds -> `Help (man_format, Some t)
        | `Ok t ->
            let page = (topic, 7, "", "", ""), [`S topic; `P "Say something";] in
            `Ok (Cmdliner.Manpage.print man_format Format.std_formatter page)
      )


type gen_opts =
  { context    : bool
  ; sort       : bool
  ; nocache    : bool
  ; framework  : string option
  ; cache_dir  : string option
  ; only       : string option
  ; ignore     : string option
  ; ignore_path: string option
  ; targets    : string list
  }


type init_opts =
  { framework: string }


let create_init_options framework : init_opts =
  { framework }


let catch f () =
  try
    f ();
    `Ok ()
  with
   Failure e -> `Error (false, e)


let gen_executable { context; sort; nocache; framework; cache_dir; ignore; only; ignore_path; targets } =
  let cache_dir = unwrap_or "_build/.dryunit" cache_dir in
  let ignore = unwrap_or "" ignore in
  let only = unwrap_or "" only in
  let ignore_path = unwrap_or "" ignore_path in
  let framework = TestFramework.of_string (unwrap_or "alcotest" framework) in
  if List.length targets == 0 then
    ( let suites = App.get_suites ~sort ~nocache ~framework ~cache_dir ~ignore ~only ~targets
        ~ignore_path ~detection:"dir" ~main:"main.ml" in
      App.gen_executable ~context framework suites stdout
    )
  else
    List.iter
      ( fun target ->
          let suites = App.get_suites ~sort ~nocache ~framework ~cache_dir ~ignore ~only ~targets
            ~ignore_path ~detection:"dir" ~main:target in
          let oc = open_out target in
          App.gen_executable ~context framework suites oc;
          close_out oc
      )
      targets;
  `Ok ()


let init_executable { framework; } =
  Serializer.init_default (TestFramework.of_string framework);
  `Ok ()


let init_framework f =
  Serializer.init_default f;
  `Ok ()
