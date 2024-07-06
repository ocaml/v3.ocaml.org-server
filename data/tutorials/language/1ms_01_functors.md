---
id: functors
title: Functors
description: >
  In OCaml, a functor is a function at the module-level. Functors take modules as arguments and return a new module.
category: "Module System"
prerequisite_tutorials:
  - modules
---

## Introduction

In this tutorial, we look at how to apply functors and how to write functors. We also show some use cases involving functors.

As suggested by the name, a _functor_ is almost like a function. However, while functions are between values, functors are between modules. A functor has a module as a parameter and returns a module as a result. A functor in OCaml is a parametrised module, not to be confused with a [functor in mathematics](https://en.wikipedia.org/wiki/Functor).

**Note**: The files illustrating this tutorial are available as a [Git repo](https://github.com/ocaml-web/ocamlorg-docs-functors).

## Project Setup

This tutorial uses the [Dune](https://dune.build) build tool. Make sure you have installed version 3.7 or later. We start by creating a fresh project. We need a directory named `funkt` with files `dune-project`, `dune`, and `funkt.ml`.

```shell
$ mkdir funkt; cd funkt
```

Place the following in the file **`dune-project`**:
```lisp
(lang dune 3.7)
(package (name funkt))
```

The content of the file **`dune`** should be this:
```lisp
(executable
  (name funkt)
  (public_name funkt)
  (libraries str))
```

Create an empty file `funkt.ml`.

Check that this works using the `opam exec -- dune exec funkt` command. It shouldn't do anything (the empty file is valid OCaml syntax), but it shouldn't fail either. The stanza `libraries str` makes the `Str` module (which we will use later) available.

## Using an Existing Functor: `Set.Make`

The standard library contains a [`Set`](/manual/api/Set.html) module which is designed to handle sets. This module enables you to perform operations such as union, intersection, and difference on sets. You may check the [Set](/docs/sets) tutorial to learn more about this module, but it is not required to follow the present tutorial.

To create a set module for a given element type (which allows you to use the provided type and its associated [functions](/manual/api/Set.S.html)), it's necessary to use the functor `Set.Make` provided by the `Set` module. Here is a simplified version of `Set`'s interface:
```ocaml
module type OrderedType = sig
  type t
  val compare : t -> t -> int
end

module Make : functor (Ord : OrderedType) -> Set.S
```

Here is how this reads (starting from the bottom, then going up):
* Like a function (indicated by the arrow `->`), the functor `Set.Make`
  - takes a module with signature `OrderedType` and
  - returns a module with signature [`Set.S`](/manual/api/Set.S.html)
* The module type `OrderedType` requires a type `t` and a function `compare`, which are used to perform the comparisons between elements of the set.

**Note**: Most set operations need to compare elements to check if they are the same. To allow using a user-defined comparison algorithm, the `Set.Make` functor takes a module that specifies both the element type `t` and the `compare` function. Passing the comparison function as a higher-order parameter, as done in `Array.sort`, for example, would add a lot of boilerplate code. Providing set operations as a functor allows specifying the comparison function only once.

Here is an example of how to use `Set.Make`:

**`funkt.ml`**

```ocaml
module StringCompare = struct
  type t = string
  let compare = String.compare
end

module StringSet = Set.Make(StringCompare)
```

This defines a module `Funkt.StringSet`. What `Set.Make` needs are:
- Type `t`, here `string`
- Function allowing to compare two values of type `t`, here `String.compare`

**Note**: A type `t` must be defined in the parameter module, here
`StringCompare`. Most often, as shown in this example, `t` is an alias for
another type, here `string`. If that other type is also called `t`, the compiler
will trigger an error _“The type abbreviation t is cyclic”_. This can be worked
around by adding the `nonrec` keyword to the type definition, like this:
```ocaml
type nonrec t = t
```

This can be simplified using an _anonymous module_ expression:
```ocaml
module StringSet = Set.Make(struct
  type t = string
  let compare = String.compare
end)
```

The module expression `struct ... end` is inlined in the `Set.Make` call.

However, since the module `String` already defines
- Type name `t`, which is an alias for `string`
- Function `compare` of type `t -> t -> bool` compares two strings

This can be simplified even further into this:
```ocaml
module StringSet = Set.Make(String)
```

In all versions, the module resulting from the functor application `Set.Make` is bound to the name `StringSet`, and it has the signature `Set.S`. The module `StringSet` provides the operations on sets of strings. The function `String.compare` is used internally by `StringSet`.

When you run `opam exec -- dune exec funkt`, it doesn't do anything, but it shouldn't fail either.

Let's add some code to `funkt.ml` so that it does something.

**`funkt.ml`**
```ocaml
module StringSet = Set.Make(String)

let _ =
  In_channel.input_lines stdin
  |> List.concat_map Str.(split (regexp "[ \t.,;:()]+"))
  |> StringSet.of_list
  |> StringSet.iter print_endline
```

Here is how this code works:
- `In_channel.input_lines` : reads lines of text from standard input
- `List.concat_map` : splits lines into words and produces a word list
- `StringSet.of_list : string list -> StringSet.t` : converts the word list into a set
- `StringSet.iter : StringSet.t -> unit` : displays the set's elements

The functions `StringSet.of_list` and `StringSet.iter` are available in the functor's application result.

```shell
$ opam exec -- dune exec funkt < dune
executable
libraries
name
public_name
str
funkt
```

There are no duplicates in a `Set`. Therefore, the string `"funkt"` is only displayed once, although it appears twice in the `dune` file.

## Extending a Module with a Standard Library Functor

Using the `include` statement, here is an alternate way to expose the module created by `Set.Make(String)`:

**`funkt.ml`**
```ocaml
module String = struct
  include String
  module Set = Set.Make(String)
end

let _ =
  stdin
  |> In_channel.input_lines
  |> List.concat_map Str.(split (regexp "[ \t.,;:()]+"))
  |> String.Set.of_list
  |> String.Set.iter print_endline
```

This allows the user to seemingly extend the module `String` with a submodule `Set`. Check the behaviour using `opam exec -- dune exec funkt < dune`.

## Parametrising Modules with Functors

### Functors From the Standard Library

A functor is almost a module, except it needs to be applied to a module. This turns it into a module. In that sense, a functor allows module parametrisation.

That's the case for the sets, maps, and hash tables provided by the standard library. It works like a contract between the functor and the developer.
* If you provide a module that implements what is expected, as described by the parameter interface
* The functor returns a module that implements what is promised, as described by the result interface

Here is the module's signature that the functors `Set.Make` and `Map.Make` expect:
```ocaml
module type OrderedType = sig
  type t
  val compare : t -> t -> int
end
```

Here is the module's signature that the functor `Hashtbl.Make` expects:
```ocaml
module type HashedType = sig
  type t
  val equal : t -> t -> bool
  val hash : t -> int
end
```

The functors  `Set.Make`, `Map.Make`, and `Hashtbl.Make` return modules satisfying the interfaces `Set.S`, `Map.S`, and `Hashtbl.S` (respectively), which all contain an abstract type `t` and associated functions. Refer to the documentation for the details about what they provide:
* [`Set.S`](/manual/api/Set.S.html)
* [`Map.S`](/manual/api/Map.S.html)
* [`Hashtbl.S`](/manual/api/Hashtbl.S.html)

### Writing Your Own Functors

One reason to write a functor is to provide a data structure that is parametrised. This is the same as `Set` and `Map` on other data structures. In this section, we take heaps as an example.

There are many kinds of [heap](https://en.wikipedia.org/wiki/Heap_(data_structure)) data structures. Examples include binary heaps, leftist heaps, binomial heaps, or Fibonacci heaps.

The kind of data structures and algorithms used to implement a heap is not discussed in this document.

The common prerequisite to implement any heap is a means to compare the elements they contain. That's the same signature as the parameter of `Set.Make` and `Map.Make`:
```ocaml
module type OrderedType = sig
  type t
  val compare : t -> t -> int
end
```

Using such a parameter, a heap implementation must provide at least this interface:
```ocaml
module type HeapType = sig
  type elt
  type t
  val empty : t
  val is_empty : t -> bool
  val insert : t -> elt -> t
  val merge : t -> t -> t
  val find : t -> elt
  val delete : t -> t
end
```

Heap implementations can be represented as functors from `OrderedType` into `HeapType`. Each kind of heap would be a different functor.

Here is the skeleton of a possible implementation:

**heap.ml**
```ocaml
module type OrderedType = sig
  type t
  val compare : t -> t -> int
end

module type S = sig
  type elt
  type t
  val empty : t
  val is_empty : t -> bool
  val insert : t -> elt -> t
  val merge : t -> t -> t
  val find : t -> elt
  val delete : t -> t
end

module Binary(Elt: OrderedType) : S = struct
  type elt (* Add your own type definition *)
  type t (* Add your own type definition *)
  (* Add private functions here *)
  let empty = failwith "Not yet implemented"
  let is_empty h = failwith "Not yet implemented"
  let insert h e = failwith "Not yet implemented"
  let merge h1 h2 = failwith "Not yet implemented"
  let find h = failwith "Not yet implemented"
  let delete h = failwith "Not yet implemented"
end
```

Here, binary heaps is the only implementation suggested. This can be extended to other implementations by adding one functor per each, e.g., `Heap.Leftist`, `Heap.Binomial`, `Heap.Fibonacci`, etc.

<!--

TODO: Create this section

When several implementations of the same interface are needed at runtime, functors allow sharing of their common parts.

## Multiple Implementation of the Same Signature.

> Proposal:
>
>Functors arise when we want to provide multiple implementation of the same signature: client module should be parametrised so that we can choose between these implementations at link time.

> Example:
>
> The Unison file synchroniser has both a textual and a graphical user interface, both matching the signature `UI`. The main program is parametrised on the user interface module.

Benjamin Piece and Robert Harper.
Advanced Module Systems, ICFP 2000
-->

## Injecting Dependencies Using Functors

**Dependencies Between Modules**

Here is a new version of the `funkt` program:

**`funkt.ml`**
```ocaml
module StringSet = Set.Make(String)

module IterPrint : sig
  val f : string list -> unit
end = struct
  let f = List.iter (fun s -> Out_channel.output_string stdout (s ^ "\n"))
end

let _ =
  stdin
  |> In_channel.input_lines
  |> List.concat_map Str.(split (regexp "[ \t.,;:()]+"))
  |> StringSet.of_list
  |> StringSet.elements
  |> IterPrint.f
```

It embeds an additional `IterPrint` module that exposes a single function `f` of type `string list -> unit` and has two dependencies:
  - Module `List` through `List.iter` and `f`'s type
  - Module `Out_channel` through `Out_channel.output_string`

Check the program's behaviour using `opam exec -- dune exec funkt < dune`.

**Dependency Injection**

[Dependency injection](https://en.wikipedia.org/wiki/Dependency_injection) is a way to parametrise over a dependency.

Here is a refactoring of the module `IterPrint` to use this technique:

**`iterPrint.ml`**
```ocaml
module type Iterable = sig
  type 'a t
  val iter : ('a -> unit) -> 'a t -> unit
end

module type S = sig
  type 'a t
  val f : string t -> unit
end

module Make(Dep: Iterable) : S with type 'a t := 'a Dep.t = struct
  let f = Dep.iter (fun s -> Out_channel.output_string stdout (s ^ "\n"))
end
```

The module `IterPrint` is refactored into a functor that takes a module providing the function `iter` as a parameter. The `with type 'a t := 'a Dep.t` constraint means the type `t` from the parameter `Dep` replaces the type `t` in the result module. This allows `f`'s type to use `Dep`'s `t` type. With this refactoring, `IterPrint` only has one dependency. At its compilation time, no implementation of function `iter` is available yet.

**Note**: An OCaml interface file (`.mli`) must be a module, not a functor. Functors must be embedded inside modules. Therefore, it is customary to call them `Make`.

**`funkt.ml`**

```ocaml
module StringSet = Set.Make(String)
module IterPrint = IterPrint.Make(List)

let _ =
  stdin
  |> In_channel.input_lines
  |> List.concat_map Str.(split (regexp "[ \t.,;:()]+"))
  |> StringSet.of_list
  |> StringSet.elements
  |> IterPrint.f
```

The dependency `List` is _injected_ when compiling the module `Funkt`. Observe that the code using `IterPrint` is unchanged. Check the program's behaviour using `opam exec -- dune exec funkt < dune`.

**Replacing a Dependency**

Now, replacing the implementation of `iter` inside `IterListPrint` is no longer a refactoring; it is another functor application with another dependency. Here, [`Array`](/manual/api/Array.html) replaces `List`:

**`funkt.ml`**
```ocaml
module StringSet = Set.Make(String)
module IterPrint = IterPrint.Make(Array)

let _ =
  stdin
  |> In_channel.input_lines
  |> List.concat_map Str.(split (regexp "[ \t.,;:()]+"))
  |> StringSet.of_list
  |> StringSet.elements
  |> Array.of_list
  |> IterPrint.f
```

Check the program's behaviour using `opam exec -- dune exec funkt < dune`.

**Note**: Modules received and returned by `IterPrint.Make` both have a type `t`. The `with type ... := ...` constraint exposes that the two types `t` are the same. This makes functions from the injected dependency and result module use the exact same type. When the parameter's contained type is not exposed by the result module (i.e., when it is an _implementation detail_), the `with type` constraint is not necessary.

### Naming and Scoping

The `with type` constraint unifies types within a functor's parameter and result modules. We've used that in the previous section. This section addresses the naming and scoping mechanics of this constraint.

Naively, we might have defined `Iter.Make` as follows:

```ocaml
module Make(Dep: Iterable) : S = struct
  type 'a t = 'a Dep.t
  let f = Dep.iter (fun s -> Out_channel.output_string stdout (s ^ "\n"))
end
```

If the function `f` isn't used, the project compiles without error.

However, since `Make` is invoked to create module `IterPrint` in `funkt.ml`, the project fails to compile with the following error message:

```shell
5 | ..stdin
6 |   |> In_channel.input_lines
7 |   |> List.concat_map Str.(split (regexp "[ \t.,;:()]+"))
8 |   |> StringSet.of_list
9 |   |> StringSet.elements
Error: This expression has type string list
       but an expression was expected of type string IterPrint.t
```

Outside the functor, it is not known that `type 'a t` is set to `Dep.t`. In `funkt.ml`, `IterPrint.t` appears as an abstract type exposed by the result of `Make`. This is why the `with type` constraint is needed. It propagates the knowledge that `IterPrint.t` is the same type as `Dep.t` (`List.t` in this case).

The type constrained using `with type` isn't shadowed by definitions within the functor body. In the example, the `Make` functor can be redefined as follows:

```ocaml
module Make(Dep: Iterable) : S with type 'a t := 'a Dep.t = struct
  type 'a t = LocalType
  let g LocalType = "LocalType"
  let f = Dep.iter(fun s ->
    Out_channel.output_string stdout (g LocalType ^ "\n");
    Out_channel.output_string stdout (s ^ "\n"))
end
```

In the example above, `t` from `with type` takes precedence over the local `t`, which only has a local scope. Don't shadow names too often because it makes the code harder to understand.

## Write a Functor to Extend Modules

In this section, we define a functor to extend several modules in the same way. This is the same idea as in the [Extending a Module with a Standard Library Functor](#extending-a-module-with-a-standard-library-functor), except we write the functor ourselves.

In this example, we extend `List` and [`Array`](/manual/api/Array.html) modules with a function `scan_left`. It does almost the same as `fold_left`, except it returns all the intermediate values, not the last one as `fold_left` does.

Create a fresh directory with the following files:

**`dune-project`**
```lisp
(lang dune 3.7)
```
**`dune`**
```lisp
(library (name scanLeft))
```

**`scanLeft.ml`**
```ocaml
module type LeftFoldable = sig
  type 'a t
  val fold_left : ('b -> 'a -> 'b) -> 'b -> 'a t -> 'b
  val of_list : 'a list -> 'a t
end

module type S = sig
  type 'a t
  val scan_left : ('b -> 'a -> 'b) -> 'b -> 'a t -> 'b t
end

module Make(F: LeftFoldable) : S with type 'a t := 'a F.t = struct
  let scan_left f b u =
    let f (b, u) a =
      let b' = f b a in
      (b', b' :: u) in
    u |> F.fold_left f (b, []) |> snd |> List.rev |> F.of_list
end
```

Run the `dune utop` command. Once inside the toplevel, enter the following commands.
```ocaml
# module Array = struct
    include Stdlib.Array
    include ScanLeft.Make(Stdlib.Array)
  end;;

# module List = struct
    include List
    include ScanLeft.Make(struct
      include List
      let of_list = Fun.id
    end)
  end;;

# Array.init 10 Fun.id |> Array.scan_left ( + ) 0;;
- : int array = [|0; 1; 3; 6; 10; 15; 21; 28; 36; 45|]

# List.init 10 Fun.id |> List.scan_left ( + ) 0;;
- : int list = [0; 1; 3; 6; 10; 15; 21; 28; 36; 45]
```

Modules `Array` and `List` appear augmented with `Array.scan_left` and `List.scan_left`. For brevity, the output of the first two toplevel commands is not shown here.

## Initialisation of Stateful Modules

Modules can hold a state. Functors can provide a means to initialise stateful modules. As an example of such, here is a possible way to handle random number generation seeds as a state:

**`random.ml`**
```ocaml
module type SeedType : sig
  val v : int array
end

module type S : sig
  val reset_state : unit -> unit

  val bits : unit -> int
  val bits32 : unit -> int32
  val bits64 : unit -> int64
  val nativebits : unit -> nativeint
  val int : int -> int
  val int32 : int32 -> int32
  val int64 : int64 -> int64
  val nativeint : nativeint -> nativeint
  val full_int : int -> int
  val float : float -> float
  val bool : unit -> bool
end

module Make(Seed: SeedType) : S = struct
  let state = Seed.v |> Random.State.make |> ref
  let reset_state () = state := Random.State.make Seed.v

  let bits () = Random.State.bits !state
  let bits32 () = Random.State.bits32 !state
  let bits64 () = Random.State.bits64 !state
  let nativebits () = Random.State.nativebits !state
  let int = Random.State.int !state
  let int32 = Random.State.int32 !state
  let int64 = Random.State.int64 !state
  let nativeint = Random.State.nativeint !state
  let full_int = Random.State.full_int !state
  let float = Random.State.float !state
  let bool () = Random.State.bool !state
end
```

Create this file and launch `utop`.
```ocaml
# #mod_use "random.ml";;

# module R1 = Random.Make(struct let v = [|0; 1; 2; 3|] end);;

# module R2 = Random.Make(struct let v = [|0; 1; 2; 3|] end);;

# R1.bits ();;
- : int = 75783189

# R2.bits ();;
- : int = 75783189

# R1.bits ();;
- : int = 774473149

# R1.reset_state ();;
- : unit = ()

# R2.bits ();;
- : int = 774473149

# R1.bits ();;
- : int = 75783189
```

Modules `R1` and `R2` are created with the same state; therefore, the first calls to `R1.bits` and `R2.bits` return the same value.

The second call to `R1.bits` moves `R1`'s state one step and returns the corresponding bits. The call to `R1.reset_state` sets the `R1`'s state to its initial value.

Calling `R2.bits` a second time shows the modules aren't sharing states. Otherwise, the value from the first calls to `bits` would have been returned.

Calling `R1.bits` a third time returns the same result as the first call, which demonstrates the state has indeed been reset.

## Conclusion

Functor application essentially works the same way as function application: passing parameters and getting results. The difference is that we are passing modules instead of values. Beyond comfort, it enables a design approach where concerns are not only separated in silos, which is enabled by modules, but also in stages stacked upon each other.
