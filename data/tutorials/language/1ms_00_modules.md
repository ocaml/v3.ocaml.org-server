---
id: modules
title: Modules
description: >
  Modules are collections of definitions. This is the basic means to organise OCaml software.
category: "Module System"
prerequisite_tutorials:
  - values-and-functions
  - basic-data-types
---

## Introduction

In this tutorial, we look at how to use and define modules.

Modules are collections of definitions grouped together. This is the basic means to organise OCaml software. Separate concerns can and should be isolated into separate modules.

**Note**: The files that illustrate this tutorial are available as a Git [repo](https://github.com/ocaml-web/ocamlorg-docs-modules).

## Basic Usage

### File-Based Modules

In OCaml, every piece of code is wrapped into a module. Optionally, a module
itself can be a [submodule](#submodules) of another module, pretty much like
directories in a file system.

Here is a program using two files: `athens.ml` and `berlin.ml`. Each file
defines a module named `Athens` and `Berlin`, respectively.

Here is the file `athens.ml`:
<!-- $MDX file=examples/athens.ml -->
```ocaml
let hello () = print_endline "Hello from Athens"
```

Here is the file `berlin.ml`:
<!-- $MDX file=examples/berlin.ml -->
```ocaml
let () = Athens.hello ()
```

To compile them using [Dune](https://dune.build/), at least two
configuration files are required:
* The `dune-project` file contains project-wide configuration.
  ```lisp
  (lang dune 3.7)
  ```
* The `dune` file contains actual build directives. A project may have several
  `dune` files, one per directory containing things to build. This single line is
  sufficient in this example:
  ```lisp
  (executable (name berlin))
  ```

After you create those files, build and run them:
<!-- $MDX dir=examples -->
```bash
$ opam exec -- dune build

$ opam exec -- dune exec ./berlin.exe
Hello from Athens
```

Actually, `opam exec -- dune build` is optional. Running `opam exec -- dune exec ./berlin.exe` would have
triggered the compilation. Note that in the `opam exec -- dune exec` command, the parameter
`./berlin.exe` is not a file path. This command means “execute the content of
the file `./berlin.ml`.” However, the executable file is stored and named
differently.

In a project, it is preferable to create the `dune` configuration files and
directory structure using the `dune init project` command. Refer to the Dune
documentation for more on this matter.

### Naming and Scoping

In `berlin.ml`, we used `Athens.hello` to refer to `hello` from `athens.ml`.
Generally, to access something from a module, use the module's name (which
always starts with a capital letter: `Athens`) followed by a dot and the
thing you want to use (`hello`). It may be a value, a type constructor, or
anything the module provides.

If you are using a module heavily, you might want to `open` it. This brings the
module's definitions into scope. In our example, `berlin.ml` could have been
written:
<!-- $MDX skip -->
```ocaml
open Athens
let () = hello ()
```

Using `open` is optional. Usually, we don't open a module like `List` because it
provides names other modules also provide, such as [`Array`](/manual/api/Array.html) or `Option`. Modules
like `Printf` provide names that aren't subject to conflicts, such as `printf`.
Placing `open Printf` at the top of a file avoids writing `Printf.printf` repeatedly.
```ocaml
open Printf
let data = ["a"; "beautiful"; "day"]
let () = List.iter (printf "%s\n") data
```

 The standard library is a module called `Stdlib`. It contains
 [submodules](#submodules) `List`, `Option`, `Either`, and more. By default, the
 OCaml compiler opens the standard library, as if you had written `open Stdlib`
 at the top of every file. Refer to Dune documentation if you need to opt-out.

You can open a module inside a definition, using the `let open ... in` construct:
```ocaml
# let list_sum_sq m =
    let open List in
    init m Fun.id |> map (fun i -> i * i) |> fold_left ( + ) 0;;
val list_sum_sq : int -> int = <fun>
```

The module access notation can be applied to an entire expression:
```ocaml
# let array_sum_sq m =
    Array.(init m Fun.id |> map (fun i -> i * i) |> fold_left ( + ) 0);;
val array_sum_sq : int -> int = <fun>
```

## Interfaces and Implementations

By default, anything defined in a module is accessible from other modules.
Values, functions, types, or submodules, everything is public. This can be
restricted to avoid exposing definitions that are not relevant from the outside.

For this, we must distinguish:
- The definitions inside a module (the module implementation)
- The public declarations of a module (the module interface)

An `.ml` file contains a module implementation; an `.mli` file contains a module
interface. By default, when no corresponding `.mli` file is provided, an
implementation has a default interface where everything is public.

Copy the `athens.ml` file into `cairo.ml` and change its contents:
<!-- $MDX file=examples/cairo.ml -->
```ocaml
let message = "Hello from Cairo"
let hello () = print_endline message
```

As it is, `Cairo` has the following interface:
<!-- $MDX skip -->
```ocaml
val message : string
val hello : unit -> unit
```

Explicitly defining a module interface allows restricting the default one. It
acts as a mask over the module's implementation. The `cairo.ml` file defines
`Cairo`'s implementation. Adding a `cairo.mli` file defines `Cairo`'s interface.
Filenames without extensions must be the same.

To turn `message` into a private definition, don't list it in the `cairo.mli` file:
<!-- $MDX file=examples/cairo.mli -->
```ocaml
val hello : unit -> unit
(** [hello ()] displays a greeting message. *)
```

**Note**: The double asterisk at the beginning indicates a
comment meant for API documentation tools, such as
[`odoc`](https://github.com/ocaml/odoc). It is a good habit to document `.mli`
files using the format supported by this tool.

The file `delhi.ml` defines the program calling `Cairo`:

<!-- $MDX file=examples/delhi.ml -->
```ocaml
let () = Cairo.hello ()
```

Update the `dune` file to allow this example's compilation aside from the
previous one.
```lisp
(executables (names berlin delhi))
```

Compile and execute both programs:
```shell
$ opam exec -- dune exec ./berlin.exe
Hello from Athens

$ opam exec -- dune exec ./delhi.exe
Hello from Cairo
```

You can check that `Cairo.message` is not public by attempting to compile a `delhi.ml` file containing:
```ocaml
let () = print_endline Cairo.message
```

This triggers a compilation error.

## Abstract and Read-Only Types

Function and value definitions are either public or private. That also applies
to type definitions, but there are two more cases.

Create files named `exeter.mli` and `exeter.ml` with the following contents:

**Interface: `exeter.mli`**

```ocaml
type aleph = Ada | Alan | Alonzo

type gimel
val gimel_of_bool : bool -> gimel
val gimel_flip : gimel -> gimel
val gimel_to_string : gimel -> string

type dalet = private Dennis of int | Donald of string | Dorothy
val dalet_of : (int, string) Either.t option -> dalet
```

**Implementation: `exeter.ml`**

```ocaml
type aleph = Ada | Alan | Alonzo

type bet = bool

type gimel = Christos | Christine
let gimel_of_bool b = if (b : bet) then Christos else Christine
let gimel_flip = function Christos -> Christine | Christine -> Christos
let gimel_to_string x = "Christ" ^ match x with Christos -> "os" | _ -> "ine"

type dalet = Dennis of int | Donald of string | Dorothy
let dalet_of = function
  | None -> Dorothy
  | Some (Either.Left x) -> Dennis x
  | Some (Either.Right x) -> Donald x
```

Update file `dune` to have three targets; two executables: `berlin` and `delhi`; and a library `exeter`.
```lisp
(executables (names berlin delhi) (modules athens berlin cairo delhi))
(library (name exeter) (modules exeter))
```

Run the `opam exec -- dune utop` command. This triggers `Exeter`'s compilation, launches `utop`, and loads `Exeter`.
```ocaml
# open Exeter;;

# #show aleph;;
type aleph = Ada | Alan | Alonzo
```

Type `aleph` is public. Values can be created or accessed.
```ocaml
# #show bet;;
Unknown element.
```

Type `bet` is private. It is not available outside of the implementation where it is defined, here `Exeter`.
```ocaml
# #show gimel;;
type gimel

# Christos;;
Error: Unbound constructor Christos

# #show_val gimel_of_bool;;
val gimel_of_bool : bool -> gimel

# true |> gimel_of_bool |> gimel_to_string;;
- : string = "Christos"

# true |> gimel_of_bool |> gimel_flip |> gimel_to_string;;
- : string = "Christine"
```

Type `gimel` is _abstract_. Values can be created or manipulated, but only as function results or arguments. Just the provided functions `gimel_of_bool`, `gimel_flip`, and `gimel_to_string` or polymorphic functions can receive or return `gimel` values.
```ocaml
# #show dalet;;
type dalet = private Dennis of int | Donald of string | Dorothy

# Donald 42;;
Error: Cannot create values of the private type Exeter.dalet

# dalet_of (Some (Either.Left 10));;
- : dalet = Dennis 10

# let dalet_to_string = function
  | Dorothy -> "Dorothy"
  | Dennis _ -> "Dennis"
  | Donald _ -> "Donald";;
val dalet_to_string : dalet -> string = <fun>
```

The type `dalet` is _read-only_. Pattern matching is possible, but values can only be constructed by the provided functions, here `dalet_of`.

Abstract and read-only types can be either variants, as shown in this section, records, or aliases. It is possible to access a read-only record field's value, but creating such a record requires using a provided function.

## Submodules

### Submodule Implementation

A module can be defined inside another module. That makes it a _submodule_.
Let's consider the files `florence.ml` and `glasgow.ml`

**`florence.ml`**
```ocaml
module Hello = struct
  let message = "Hello from Florence"
  let print () = print_endline message
end

let print_goodbye () = print_endline "Goodbye"
```

**`glasgow.ml`**
```ocaml
let () =
  Florence.Hello.print ();
  Florence.print_goodbye ()
```

Definitions from a submodule are accessed by chaining module names, here
`Florence.Hello.print`. Here is the updated `dune` file, with an additional
executable:

**`dune`**
```lisp
(executables (names berlin delhi) (modules athens berlin cairo delhi))
(executable (name glasgow) (modules florence glasgow))
(library (name exeter) (modules exeter))
```

### Submodule With Signatures

To define a submodule's interface, we can provide a _module signature_. This
is done in this second version of the `florence.ml` file:
```ocaml
module Hello : sig
 val print : unit -> unit
end = struct
  let message = "Hello"
  let print () = print_endline message
end

let print_goodbye () = print_endline "Goodbye"
```

The first version made `Florence.Hello.message` public. In this version it can't be accessed from `glasgow.ml`.

### Module Signatures are Types

The role played by module signatures to implementations is akin to the role played by types to values. Here is a third possible way to write file `florence.ml`:
```ocaml
module type HelloType = sig
  val print : unit -> unit
end

module Hello : HelloType = struct
  let message = "Hello"
  let print () = print_endline message
end

let print_goodbye () = print_endline "Goodbye"
```

First, we define a `module type` called `HelloType`, which defines the same module interface as before. Instead of providing the signature when defining the `Hello` module, we use the `HelloType` module type.

This allows writing interfaces shared by several modules. An implementation satisfies any module type listing some of its contents. This implies a module may have several types and that there is a subtyping relationship between module types.

## Module Manipulation

### Displaying a Module's Interface

You can use the OCaml toplevel to see the contents of an existing
module, such as `Unit`:

```ocaml
# #show Unit;;
module Unit :
  sig
    type t = unit = ()
    val equal : t -> t -> bool
    val compare : t -> t -> int
    val to_string : t -> string
  end
```

The OCaml compiler tool chain can be used to dump an `.ml` file's default interface.
```shell
$ ocamlc -c -i cairo.ml
val message : string
val hello : unit -> unit
```

### Module Inclusion

Let's say we feel that a function is missing from the `List` module,
but we really want it as if it were part of it. In an `extlib.ml` file, we
can achieve this effect by using the `include` directive:

```ocaml
module List = struct
  include Stdlib.List
  let uncons = function
    | [] -> None
    | hd :: tl -> Some (hd, tl)
end
```

It creates a module `Extlib.List` that has everything the standard `List` module
has, plus a new `uncons` function. In order to override the default `List`
module from another `.ml` file, we need to add `open Extlib` at the beginning.

## Stateful Modules

A module may have an internal state. This is the case for the `Random` module from the standard library. The functions `Random.get_state` and `Random.set_state` provide read and write access to the internal state, which is nameless and has an abstract type.
```ocaml
# let s = Random.get_state ();;
val s : Random.State.t = <abstr>

# Random.bits ();;
- : int = 89809344

# Random.bits ();;
- : int = 994326685

# Random.set_state s;;
- : unit = ()

# Random.bits ();;
- : int = 89809344
```

Values returned by `Random.bits` will differ when you run this code. The first
and third calls return the same results, showing that the internal state was
reset.

## Conclusion

OCaml, modules are the basic means of organising software. To sum up, a
module is a collection of definitions wrapped under a name. These definitions
can be submodules, which allows the creation of hierarchies of modules.
Top-level modules must be files and are the units of compilation. Every module
has an interface, which is the list of definitions a module exposes. By default,
a module's interface exposes all its definitions, but this can be restricted
using the interface syntax.

Going further, here are the other means to handle OCaml software components:
- Functors, which act like functions from modules to modules
- Libraries, which are compiled modules bundled together
- Packages, which are installation and distribution units
