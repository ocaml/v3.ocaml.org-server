---
id: libraries-dune
title: Libraries With Dune
description: >
  Dune provides several means to arrange modules into libraries. We look at Dune's mechanisms for structuring projects with libraries that contain modules.
category: "Module System"
prerequisite_tutorials:
  - modules
  - functors
---

## Introduction

Dune provides several means to arrange modules into libraries. We look at Dune's mechanisms for structuring projects with libraries that contain modules.

This tutorial uses the [Dune](https://dune.build) build tool. Make sure you have version 3.7 or later installed.

## Minimum Project Setup

This section details the structure of an almost-minimum Dune project setup. Check [Your First OCaml Program](/docs/your-first-program) for automatic setup using the `dune init proj` command.
```shell
$ mkdir mixtli; cd mixtli
```

In this directory, create four more files: `dune-project`, `dune`, `cloud.ml`, and `wmo.ml`:

**`dune-project`**
```lisp
(lang dune 3.7)
(package (name wmo-clouds))
```

This file contains the global project configuration. It's kept almost to the minimum, including the `lang dune` stanza that specifies the required Dune version and the `package` stanza that makes this tutorial simpler.

**`dune`**
```lisp
(executable
  (name cloud)
  (public_name nube))
```

Each directory that requires some sort of build must contain a `dune` file. The `executable` stanza means an executable program is built.
- The `name cloud` stanza means the file `cloud.ml` contains the executable.
- The `public_name nube` stanza means the executable is made available using the name `nube`.

**`wmo.ml`**
```ocaml
module Stratus = struct
  let nimbus = "Nimbostratus (Ns)"
end

module Cumulus = struct
  let nimbus = "Cumulonimbus (Cb)"
end
```

**`cloud.ml`**
```ocaml
let () =
  Wmo.Stratus.nimbus |> print_endline;
  Wmo.Cumulus.nimbus |> print_endline
```

Here is the resulting output:
```shell
$ opam exec -- dune exec nube
Nimbostratus (Ns)
Cumulonimbus (Cb)
```


Here is the directory contents:
```shell
$ tree
.
├── dune
├── dune-project
├── cloud.ml
└── wmo.ml
```

Dune stores the files it creates in a directory named `_build`. In a project managed using Git, the `_build` directory should be ignored
```shell
$ echo _build >> .gitignore
```

In OCaml, each `.ml` file defines a module. In the `mixtli` project, the file `cloud.ml` defines the `Cloud` module, the file `wmo.ml` defines the `Wmo` module that contains two submodules: `Stratus` and `Cumulus`.

Here are the different names:
* `mixtli` is the project's name (it means *cloud* in Nahuatl).
* `cloud.ml` is the OCaml source file's name, referred as `cloud` in the `dune` file.
* `nube` is the executable command's name (it means *cloud* in Spanish).
* `Cloud` is the name of the module associated with the file `cloud.ml`.
* `Wmo` is the name of the module associated with the file `wmo.ml`.
* `wmo-clouds` is the name of the package built by this project.

The `dune describe` command allows having a look at the project's module structure. Here is its output:
```lisp
((root /home/cuihtlauac/caml/mixtli-dune)
 (build_context _build/default)
 (executables
  ((names (cloud))
   (requires ())
   (modules
    (((name Wmo)
      (impl (_build/default/wmo.ml))
      (intf ())
      (cmt (_build/default/.cloud.eobjs/byte/wmo.cmt))
      (cmti ()))
     ((name Cloud)
      (impl (_build/default/cloud.ml))
      (intf ())
      (cmt (_build/default/.cloud.eobjs/byte/cloud.cmt))
      (cmti ()))))
   (include_dirs (_build/default/.cloud.eobjs/byte)))))
```
<!-- FIXME: update with wmo -->

## Libraries

<!--This contrasts with the `struct ... end` syntax where modules are aggregated top-down by nesting submodules into container modules. -->
In OCaml, a library is a collection of modules. By default, when Dune builds a library, it wraps the bundled modules into a module. This allows having several modules with the same name, inside different libraries, in the same project. That feature is known as [_namespaces_](https://en.wikipedia.org/wiki/Namespace) for module names. This is similar to what module do for definitions; they avoid name clashes.

Dune creates libraries from directories. Let's look at an example. Here the directory is `lib`:
```shell
$ mkdir lib
```

The `lib` directory is populated with the following files:

**`lib/dune`**
```lisp
(library (name wmo))
```

**`lib/cumulus.mli`**
```ocaml
val nimbus : string
```
<!-- FIXME: <> strings, no behaviour -->
**`lib/cumulus.ml`**
```ocaml
let nimbus = "Cumulonimbus (Cb)"
```

**`lib/stratus.mli`**
```ocaml
val nimbus : string
```

**`lib/stratus.ml`**
```ocaml
let nimbus = "Nimbostratus (Ns)"
```

All the modules found in the `lib` directory are bundled into the `Wmo` module. This module is the same as what we had in the `wmo.ml` file. To avoid redundancy, we delete it:
```shell
$ rm wmo.ml
```

We update the `dune` file building the executable to use the library as a dependency.

**`dune`**
```lisp
(executable
  (name cloud)
  (public_name nube)
  (libraries wmo))
```

**Observations**:
* Dune creates a module `Wmo` from the contents of directory `lib`.
* The directory's name (here `lib`) is irrelevant.
* The library name appears uncapitalised (`wmo`) in `dune` files:
  - In its definition, in `lib/dune`
  - When used as a dependency in `dune`

## Library Wrapper Modules

By default, when Dune bundles modules into a library, they are automatically wrapped into a module. It is possible to manually write the wrapper file. The wrapper file must have the same name as the library.

Here, we are creating a wrapper file for the `wmo` library from the previous section.

**`lib/wmo.ml`**
```ocaml
module Cumulus = Cumulus
module Stratus = Stratus
```

Here is how to make sense of these module definitions:
- On the left-hand side, `module Cumulus` means module `Wmo` contains a submodule named `Cumulus`.
- On the right-hand side, `Cumulus` refers to the module defined in the file `lib/cumulus.ml`.
<!-- TODO: Detail the semantics of this kind of module definition in the module doc -->

Run `dune exec nube` to see that the behaviour of the program is the same as in the previous section.

When a library directory contains a wrapper module (here `wmo.ml`), it is the only one exposed. All other file-based modules from that directory that do not appear in the wrapper module are private.

Using a wrapper file makes several things possible:
- Have different public and internal names, `module CumulusCloud = Cumulus`
- Define values in the wrapper module, `let ... = `
- Expose module resulting from functor application, `module StringSet = Set.Make(String)`
- Apply the same interface type to several modules without duplicating files
- Hide modules by not listing them

## Include Subdirectories

By default, Dune builds a library from the modules found in the same directory as the `dune` file, but it doesn't look into subdirectories. It is possible to change this behaviour.

In this example, we create subdirectories and move files there.
```shell
$ mkdir lib/cumulus lib/stratus
$ mv lib/cumulus.ml lib/cumulus/m.ml
$ mv lib/cumulus.mli lib/cumulus/m.mli
$ mv lib/stratus.ml lib/stratus/m.ml
$ mv lib/stratus.mli lib/stratus/m.mli
```

Change from the default behaviour with the `include_subdirs` stanza.

**`lib/dune`**
```lisp
(include_subdirs qualified)
(library (name wmo))
```

Update the library wrapper to expose the modules created from the subdirectories.

**`wmo.ml`**
```ocaml
module Cumulus = Cumulus.M
module Stratus = Stratus.M
```

Run `dune exec nube` to see that the behaviour of the program is the same as in the two previous sections.

The `include_subdirs qualified` stanza works recursively, except on subdirectories containing a `dune` file. See the [Dune](https://dune.readthedocs.io/en/stable/dune-files.html#include-subdirs) [documentation](https://github.com/ocaml/dune/issues/1084) for [more](https://discuss.ocaml.org/t/upcoming-dune-feature-include-subdirs-qualified) on this [topic](https://github.com/ocaml/dune/tree/main/test/blackbox-tests/test-cases/include-qualified).

<!--
## Starting a Project from a Single File

It is possible to start an empty Dune project from a single file.

Create a fresh directory.
```shell
$ mkdir foo.dir; cd foo.dir
```

Create a `dune-prtoject` file looking like this.

**`dune-project`**
```lisp
(lang dune 3.7)
(package (name foo) (allow_empty))
(generate_opam_files)
```

This is sufficient for `dune build` to work. It will not build anything.
- `(package (name foo) (allow_empty))` this means we're creating an Opam package named `foo` and we allow it to be empty
- `(generate_opam_files)` we ask Dune to setup the opam configuration automatically

Here `foo` is the project name and `foo.dir` is its container directory, the names don't have to be the same.
-->

## Remove Duplicated Interfaces

In the previous stages, interfaces were duplicated. In the
“[Libraries](#libraries)” section of this tutorial, two files are the same:
`lib/cumulus.mli` and `lib/status.mli`. Later, in the “[Include
Subdirectories](#include-subdirectories)” section, the files `lib/cumulus/m.mli`
and `lib/status/m.mli` are also the same.

Here is a possible way to fix this using named module types (also known as
signatures). First, delete the files `lib/cumulus/m.mli` and `lib/status/m.mli`.
Then modify module `Wmo` interface and implementation.

**`wmo.mli`**
```ocaml
module type Nimbus = sig
  val nimbus : string
end

module Cumulus : Nimbus
module Stratus : Nimbus
```

**`wmo.ml`**
```ocaml
module type Nimbus = sig
  val nimbus : string
end

module Cumulus = Cumulus.M
module Stratus = Stratus.M
```

This result is the same, except implementations `Cumulus.M` and `Stratus.M` are
explicitly bound to the same interface, defined in module `Wmo`.

## Conclusion

The OCaml module system allows organising a project in many ways. Dune provides several means to arrange modules into libraries.

