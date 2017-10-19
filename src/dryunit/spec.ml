open Cmdliner

(* Help sections common to all commands *)

let help_secs = [
 `S Manpage.s_common_options;
 `P "These options are common to all commands.";
 `S "MORE HELP";
 `P "Use `$(mname) $(i,COMMAND) --help' for help on a single command.";`Noblank;
 `P "Use `$(mname) help patterns' for help on patch matching."; `Noblank;
 `P "Use `$(mname) help environment' for help on environment variables.";
 `S Manpage.s_bugs; `P "Check bug reports at http://bugs.example.org.";
]


(* Options common to all commands *)

(* unstable *)
let gen_opts nocache framework cache_dir ignore only ignore_path targets =
  Action.({ nocache; framework; cache_dir; ignore; only; ignore_path; targets })
let gen_opts_t =
  let docs = "Generate bootstrap code" in
  let nocache =
    let doc = "Do not use cache." in
    Arg.(value & flag & info ["nocache"] ~docs ~doc) in
  let framework =
    let doc = "Select a test framework." in
    Arg.(value & opt (some string) None & info ["framework"] ~docs ~doc) in
  let cache_dir =
    let doc = "Select a custom cache dir." in
    Arg.(value & opt (some string) None & info ["cache-dir"] ~docs ~doc) in
  let only =
    let doc = "Space separated list of words used to filter tests." in
    Arg.(value & opt (some string) None & info ["only"] ~docs ~doc) in
  let ignore =
    let doc = "Space separated list of words used to ignore tests." in
    Arg.(value & opt (some string) None & info ["ignore"] ~docs ~doc) in
  let ignore_path =
    let doc = "Space separated list of words used to ignore files." in
    Arg.(value & opt (some string) None & info ["ignore-path"] ~docs ~doc) in
  let targets = Arg.(value & pos_all string [] & info [] ~docv:"TARGET") in
  Term.(const gen_opts $ nocache $ framework $ cache_dir $ ignore $ only $ ignore_path $ targets)

let init_opts framework =
  Action.({ framework; })
let init_opts_t =
  let docs = "Generate jbuild config template" in
  let framework =
    let doc = "Select a test framework." in
    Arg.(value & opt (some string) None & info ["framework"] ~docs ~doc) in
  Term.(const init_opts $ framework)


(* Commands *)

(* unstable *)
let init_cmd =
  let doc = "shows a template configuration" in
  let exits = Term.default_exits in
  let man = [
    `S Manpage.s_description;
    `P "Creates a dryunit.toml configuration file";
    `Blocks help_secs; ]
  in
  Term.(ret (const Action.init_executable $ init_opts_t)),
  Term.info "init" ~doc ~sdocs:Manpage.s_common_options ~exits ~man


let gen_alcotest_cmd =
  let doc = "Create the bootstrap code for Alcotest" in
  let exits = Term.default_exits in
  let man = [
    `S Manpage.s_description;
    `P "All source code describing test suites for Alcotests will be generated";
    `Blocks help_secs; ]
  in
  Term.(ret (const Action.(gen_executable "alcotest") $ gen_opts_t)),
  Term.info "alcotest" ~doc ~sdocs:Manpage.s_common_options ~exits ~man


let gen_ounit_cmd =
  let doc = "Create the bootstrap code for Alcotest" in
  let exits = Term.default_exits in
  let man = [
    `S Manpage.s_description;
    `P "All source code describing test suites for Alcotests will be generated";
    `Blocks help_secs; ]
  in
  Term.(ret (const Action.(gen_executable "ounit") $ gen_opts_t)),
  Term.info "ounit" ~doc ~sdocs:Manpage.s_common_options ~exits ~man


let gen_extension_cmd =
  let doc = "Generate dryunit initialization code" in
  let exits = Term.default_exits in
  let man = [
    `S Manpage.s_description;
    `P "Creates the code to activate dryunit before building the tests";
    `Blocks help_secs; ]
  in
  Term.(ret (const Action.gen_extension $ gen_opts_t)),
  Term.info "gen" ~doc ~sdocs:Manpage.s_common_options ~exits ~man


(* unstable *)
let clean_cmd =
  let doc = "clean cache" in
  let exits = Term.default_exits in
  let man = [
    `S Manpage.s_description;
    `P "Use to clean dryunit cache";
    `Blocks help_secs; ]
  in
  Term.(const App.clean $ const ()),
  Term.info "clean" ~doc ~sdocs:Manpage.s_common_options ~exits ~man


(* stable *)
let help_cmd =
  let topic =
    let doc = "The topic to get help on. `topics' lists the topics." in
    Arg.(value & pos 0 (some string) None & info [] ~docv:"TOPIC" ~doc)
  in
  let doc = "show help" in
  let man =
    [`S Manpage.s_description;
     `P "Prints help about darcs commands and other subjects...";
     `Blocks help_secs; ]
  in
  Term.(ret
    (const Action.help $ Arg.man_format $ Term.choice_names $ topic)),
  Term.info "help" ~doc ~exits:Term.default_exits ~man


(* stable *)
let default_cmd ~version =
  let doc = "a detection tool for traditional testing in OCaml" in
  let sdocs = Manpage.s_common_options in
  let exits = Term.default_exits in
  let man = help_secs in
  Term.(ret (const (fun _ -> `Help (`Pager, None)) $ const ())),
  Term.info "dryunit" ~version ~doc ~sdocs ~exits ~man

let cmds = [init_cmd; gen_alcotest_cmd; gen_ounit_cmd; gen_extension_cmd; clean_cmd; help_cmd]
