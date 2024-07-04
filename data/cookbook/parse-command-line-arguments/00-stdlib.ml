---
packages: []
discussion: |
  For a longer introduction, see the [Command-line arguments](https://ocaml.org/docs/cli-arguments) tutorial in the docs.
  The standard library documents the [Arg module](https://ocaml.org/manual/latest/api/Arg.html).
---
(* At the lowest level, we can interact with `Sys.argv` and access arguments by index.

   With this approach all our error checking will have to be entirely manual.
   If we pass a non-numeric first argument, then `int_of_string` raises an exception.
   A leading dash on our second argument will just be treated as part of the
   name - there is no option handling here.
*)
let () =
  if Array.length Sys.argv <> 3 then (
    print_endline "Usage: command <num-repeats> <name>";
    exit 1)
  else
    let command_name = Sys.argv.(0) in
    let num_repeats = Sys.argv.(1) |> int_of_string in
    let greeting_name = Sys.argv.(2) in
    for i = 1 to num_repeats do
      Printf.printf "%d: Command '%s' says 'hello %s'\n" i command_name
        greeting_name
    done

(* The `Arg` module from the standard library gives us a higher-level
   interface than `Sys.argv`. It is a good choice for basic command-line
   applications.

   We can handle options with values and repeating positional arguments, too.
   It also automatically provides a `--help` option to our application.

   The `Arg` module is quite imperative and updates references to a value.
   Typically we initialise each option with a default value ("en", 1 etc).

   To handle multiple positional (anonymous) arguments, we need a function like
   `record_anon_arg` to construct a list or otherwise accumulate each item.

   With `speclist`, we define the arguments we will parse.
   Each argument needs the option-characters themselves, the action that will
   be run when matched and a short explanatory piece of text.

   Finally, `Arg.parse` will either print an error message or succed and update
   the global refs.
*)
let greet language name =
  match language with
  | "en" -> Printf.printf "Hello %s\n" name
  | "fr" -> Printf.printf "Bonjour %s\n" name
  | "sp" -> Printf.printf "Hola %s\n" name
  | _ -> Printf.printf "Hi %s\n" name

let usage_msg = "arg_module [-l en|fr|sp] [-r <NUM REPEATS>] name1 [name2] ..."
let language = ref "en"
let num_repeats = ref 1
let names = ref []

let record_anon_arg arg = names := arg :: !names

let speclist =
  [
    ("-l", Arg.Set_string language, "Language to use (en|fr|sp, default en)");
    ( "-r",
      Arg.Set_int num_repeats,
      "Number of times to repeat greeting (default 1)" );
  ]

let () =
  Arg.parse speclist record_anon_arg usage_msg;
  for i = 1 to !num_repeats do
    Printf.printf "Greeting %d of %d\n" i !num_repeats;
    List.iter (greet !language) !names
  done
