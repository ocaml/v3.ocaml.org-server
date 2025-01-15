---
packages:
- name: "ppx_deriving"
  tested_version: "6.0.3"
  used_libraries:
  - ppx_deriving
discussion: |
    To create a minimal project:
    ```
    mkdir printDebug
    cd printDebug
    printf "\
    (executable
     (name minimo)
       (preprocess (pps ppx_deriving.show))
       )" > ./dune
    printf "(lang dune 3.17)" > ./dune-project
    printf "let () = print_endline ([%%show: string] \"hello world\")" > ./minimo.ml
    opam switch create ./
    opam install dune ppx_deriving
    ```
    Check your dune version by `opam exec -- dune --version` and modify `dune-project` file if needed. Build and execute the project by `opam exec -- dune exec ./minimo.exe`.
    For a background, see [minimum setup](https://ocaml.org/docs/your-first-program#minimum-setup), [opam switch intro](https://ocaml.org/docs/opam-switch-introduction), and [ppx](https://ocaml.org/docs/metaprogramming).
---

(* string *)
let () = print_endline "hello world"
let () = print_endline ([%show: string] "hello world")

(* integer *)
let show_int = [%show: int]
let () = print_endline (show_int 7)

(* tuple *)
let show_pair : (int * string) -> string = [%show: (int * string)]
let () = print_endline (show_pair (3, "hello"))

(* list of tuples *)
let () = print_endline @@ [%show: (bool * char) list] [ (true, 'a'); (false, 'b') ]

(* user-defined type *)
type tree =
    | Leaf of float
    | Node of float * tree * tree
    [@@deriving show]
let () = (Node (0.3,
            Node (0.5,
                Leaf 0.2, Leaf 0.3),
            Leaf 0.1) ) |> show_tree |> print_endline

(* user-defined type, excluding path *)
type tree_char =
    | Leaf of char
    | Node of char * tree_char * tree_char
    [@@deriving show { with_path = false }]
let foo : tree_char = Node('a', Leaf 'b', Leaf 'c')
let () = foo |> show_tree_char |> print_endline

(* list of option *)
let () = print_endline @@ [%show: (bool option) list] @@ [Some true; None; Some false]

(* result *)
let () = Ok "hello" |> [%show: (string, int) result] |> print_endline
let () = Error 404 |> [%show: (string, int) result] |> print_endline

(* record *)
type person = {
    last_name : string;
    age : int;
    is_married : bool
} [@@deriving show]

let gerard = {
    last_name = "Touny";
    age = 26;
    is_married = true
}
let () = print_endline @@ show_person @@ gerard

(* formatter *)
let () =
    let i = 20 in
    Printf.printf "At line 20 - and variable i is %i" i
