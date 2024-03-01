---
id: first-class-modules
title: First-Class Modules
description: >
  First-Class Modules permits the use of modules as if they are usual values.
category: "Module System"
---
## Introduction

This tutorial details how to use first-class modules in a program. This
can dispense the user of a library to use functors in order to create some
modules.

We will use a dummy database driver implementation with functors and first-class modules in this tutorial.

**Prerequisites**: [Modules](/docs/modules), [Functors](/doc/functors).

## An Example With Functors

Let's suppose we want to have a program that can be used with multiple
databases. Each database has a specific set of parameters (host, credentials,
database name...) and a set of functions (prepare query, execute
query...) which can be implemented differently.

One implementation would be to define a generic module signature and
provide specific modules, one for each database type. The program can be
presented like this:

```ocaml
(* Database library *)

module type Database = sig
  val execute : string -> string list
end

module type Postgres_Connection = sig
  val hostname : string
  val database_name : string
end

module Postgres(Cnx : Postgres_Connection) : Database = struct
  let execute query =
    Printf.printf "[%s@%s] exec %s\n"
      Cnx.database_name Cnx.hostname query;
    [ "A dummy result" ]
end

(* Main program *)

module My_Database =
  Postgres(struct
    let hostname = "localhost"
    let database_name = "dummy"
  end)

let () =
  ignore @@ My_Database.execute "SELECT * FROM table"
```

Here, we would just have to change the `My_Database` definition if we want
to use a database from an other type.

We can also define multiple `My_Database` modules if we want our program
to work simultaneously with multiple databases which may have different drivers.

## First-Class Modules

In the previous example, we have seen that we can have a modular program
where changing a database would just need a change of a couple lines. However,
the `My_Database` module is only visible from the module where it is declared.

Defining a generic `transaction` function which would send `start`, `commit`
and/or `rollback` would also need to access this module. This can't be always practicle.

First-class modules can make it possible to call this `transaction` function
with a module as a parameter. The idea is
to pass a module as if it was an argument of usual type... and convert back
the argument to a module if we want to use its exported values.

We have the following expressions:

```ocaml
let variable = (module M:ModuleType) in ...
let module M = (val argument:ModuleType) in ...
```

The first expression converts a module into
a variable of type `(module ModuleType)`. (We can replace `M` with a `struct ... end`
definition or a functor call).

The second expression converts back such a value into a module `M` which
can be used in the expression (expression of the form `M.function`).

If a function just needs to get a first-class module and uses its exported values,
we can just declare this function in the following way:

```ocaml
let f (module M:ModuleType) =
  ...
```

Then the conversion is implicit and the body of the function can use
the module `M`.

The following program illustrates the use of first-class modules:

```ocaml
(* Database library *)

module type Database = sig
  val execute : string -> string list
end

let postgress_connect _hostname _database_name =
  (module struct
    let hostname = _hostname
    let database_name = _database_name
    let execute query =
       Printf.printf "[%s@%s] exec %s\n" database_name hostname query;
       ["Dummy result"]
  end:Database)

let execute (module D:Database) query =
  D.execute query

(* Main program *)

let () =
  let database = postgress_connect "localhost" "dummy" in
  ignore @@ execute database "SELECT * FROM table_a"
```

The program is a little simpler since we don't have to define a dedicated
module which contains database connection informations and the programmer
who has to use the database library can even use it
without having to call functors directly. The database variable can be used
as if it had a usual type and passed to any function that needs to use the database.

Note, we can also define `execute` in the following way:

```ocaml
let execute database query =
  let module D = (val database:Database) in
  D.execute query
```

Here, the `database` argument can be used if we have to call other functions
which need it as a first-class module argument (let's say a commit/rollback
function).

We have seen that OCaml modules can be seen as usual values. The database
example shows a use with a function argument, but we can also consider a list
of modules (ex: modules that represent drawable forms).

## Comparison to Object Programming

First-class modules can be compared with object instances from the object-programming
paradigm. It has in common:

- Encapsulation: the internal variables of the `Postgress` module are not
  accessible,
- polymorphism: the `execute` function can be used with different types
  of databases and will behave differently.

However, the first-class module we have implemented lack inheritence. It may be
compared to a Java class which implements a single interface. The `include`
statement may bring some inheritence features, but imported functions won't call
overidden functions. Then we can't consider the use of first-class modules as 
strictly equivent to the oriented object paradigm.
