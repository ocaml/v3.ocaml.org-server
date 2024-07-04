---
packages:
- name: cmdliner
  tested_version: 1.3.0
  used_libraries:
    - cmdliner
discussion: |
  The main [Cmdliner docs](https://erratique.ch/software/cmdliner/doc/index.html)
  offer a quick tutorial, guides to how the parsing and man-page construction
  works as well as example parsers and links to API docs.
---
(* The Cmdliner package offers a sophisticated compositional way of handling
   command-line parsing. It handles options, positional arguments, and
   subcommands. It will automatically generate help and a manpage.

   The core of our application in this recipe is the `greeter` function.
   Cmdliner will call this for us.

   For `num_repeats`, we want an optional integer (with a default of 1)

   For the `names`, we want all the positional arguments in a list.

   The top-level `Term` of our parser-definition combines the function to call
   along with the arguments to parse.

   The `cmd` represents the body of our application.

   Try to parse the command line and call "greeter" if successful. If not,
   it prints formatted help-text and returns a non-zero exit code.
*)
open Cmdliner

let greeter num_repeats names =
  for i = 1 to num_repeats do
    Printf.printf "Greeting %d of %d\n" i num_repeats;
    List.iter (fun name -> Printf.printf "Hello %s\n" name) names
  done

let num_repeats =
  let doc = "Repeat the greeting $(docv) times." in
  Arg.(value & opt int 1 & info [ "r"; "repeat" ] ~docv:"REPEAT" ~doc)

let names = Arg.(non_empty & pos_all string [] & info [] ~docv:"NAME")

let recipe_t = Term.(const greeter $ num_repeats $ names)

let cmd = Cmd.v (Cmd.info "cmdliner_module") recipe_t

let () = exit (Cmd.eval cmd)
