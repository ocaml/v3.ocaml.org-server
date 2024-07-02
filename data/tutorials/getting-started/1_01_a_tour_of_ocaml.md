---
id: tour-of-ocaml
title: A Tour of OCaml
description: >
  Hop on the OCaml sightseeing bus. This absolute beginner tutorial will drive you through the marvels and wonders of OCaml. We'll have a look at the most commonly used language features.
category: "First Steps"
recommended_next_tutorials:
  - "values-and-functions"
  - "basic-data-types"
  - "loops-recursion"
  - "lists"
---

This tutorial introduces OCaml's basic features: values, expressions, lists, functions, pattern matching, and more.

No OCaml or any functional programming knowledge is required; however, it is assumed the reader has some basic software development knowledge.
Please ensure you've installed OCaml and set up the environment, as described on the [Install OCaml](/docs/installing-ocaml) page.

We recommend that you execute the examples we provide, and to experiment with them, to get a feel for coding in OCaml.
To do this, you can use UTop (Universal Toplevel).

UTop allows users to interact with OCaml by reading and evaluating OCaml phrases, like expressions or value definitions, and printing the result on the screen. Use the `utop` command to run UTop. Exit it by pressing `Ctrl+D`. For more information, you can read the [Introduction to the OCaml Toplevel](/docs/toplevel-introduction).

<!--
The goal of this tutorial is to provide the following capabilities:
- Use UTop to evaluate OCaml expressions interactively
- Trigger evaluation of expressions, understand the output displayed, values and typing
- Write definitions of values and functions
- Write list literals, use basic list operation, pattern match on list values
- Write simple float expressions without typing errors
- Write and patch-match pair and tuples values
- Define a variant types, create and pattern match on values
- Define an immutable record type, create a values, access the fields
- Raise and catch an exception
- Return an error-as-data result, process it using pattern matching
- Declare and update a mutable basic mutable values: references and arrays
- Call functions defined in modules of the OCaml standard library
-->

## Expressions and Definitions

Let's start with a simple expression:
```ocaml
# 50 * 50;;
- : int = 2500
```

In OCaml, everything has a value, and every value has a type. The above example says, “`50 * 50` is an expression that has type `int` (integer) and evaluates to `2500`.” Since it is an anonymous expression, the character `-` appears instead of a name.

The double semicolon `;;` at the end tells the toplevel to evaluate and print the result of the given phrase.

Here are examples of other primitive values and types:
```ocaml
# 6.28;;
- : float = 6.28

# "This is really disco!";;
- : string = "This is really disco!"

# true;;
- : bool = true
```

OCaml has _type inference_. It automatically determines the type of an expression without much guidance from the programmer. _Lists_ have a [dedicated tutorial](/docs/lists). For the time being, the following two expressions are both lists. The former contains integers, and the latter, strings.
```ocaml
# let u = [1; 2; 3; 4];;
val u : int list = [1; 2; 3; 4]

# ["this"; "is"; "mambo"];;
- : string list = ["this"; "is"; "mambo"]
```

The lists' types, `int list` and `string list`, have been inferred from the type of their elements. Lists can be empty `[]` (pronounced “nil”). Note that the first list has been given a name using the `let … = …` construction, which is detailed below. The most primitive operation on lists is to add a new element at the front of an existing list. This is done using the “cons” operator, written with the double colon operator `::`.
```ocaml
# 9 :: u;;
- : int list = [9; 1; 2; 3; 4]
```

In OCaml, `if … then … else …` is not a statement; it is an expression.
```ocaml
# 2 * if "hello" = "world" then 3 else 5;;
- : int = 10
```

The source beginning at `if` and ending at `5` is parsed as a single integer expression that is multiplied by 2. OCaml has no need for two different test constructions.The [ternary conditional operator](https://en.wikipedia.org/wiki/Ternary_conditional_operator) and the `if … then … else …` are the same. Also note parentheses are not needed here, which is often the case in OCaml.

Values can be given names using the `let` keyword. This is called _binding_ a value to a name. For example:
```ocaml
# let x = 50;;
val x : int = 50

# x * x;;
- : int = 2500
```

When entering `let x = 50;;`, OCaml responds with `val x : int = 50`, meaning that `x` is an identifier bound to value `50`. So `x * x;;` evaluates to the same as `50 * 50;;`.

Bindings in OCaml are _immutable_, meaning that the value assigned to a name never changes. Although `x` is often called a variable, it is not the case. It is in fact a constant. Using over-simplifying but acceptable words, all variables are immutable in OCaml. It is possible to give names to values that can be updated. In OCaml, this is called a _reference_ and will be discussed in the [Working With Mutable State](/docs/tour-of-ocaml#working-with-mutable-state) section.

There is no overloading in OCaml, so inside a lexical scope, names have a single value, which only depends on its definition.

Do not use dashes in names; use underscores instead. For example: `x_plus_y` works, `x-plus-y` does not.

Names can be defined locally, within an expression, using the `let … = … in …` syntax:
```ocaml
# let y = 50 in y * y;;
- : int = 2500

# y;;
Error: Unbound value y
```

This example defines the name `y` and binds it to the value `50`. It is then used in the expression `y * y`, resulting in the value `2500`. Note that `y` is only defined in the expression following the `in` keyword.

Since `let … = … in …` is an expression, it can be used within another expression in order to have several values with their own names:
```ocaml
# let a = 1 in
  let b = 2 in
    a + b;;
- : int = 3
```

This defines two names: `a` with value `1` and `b` with value `2`. Then the example uses them in the expression `a + b`, resulting in the value of `3`.

In OCaml, the equality symbol has two meanings. It is used in definitions and equality tests.
```ocaml
# let dummy = "hi" = "hello";;
val dummy : bool = false
```

This is interpreted as: “define `dummy` as the result of the structural equality test between the strings `"hi"` and `"hello"`.” OCaml also has a double equal operator `==`, which stands for physical equality, but it is not used in this tutorial. The operator `<>` is the negation of `=`, while `!=` is the negation of `==`.

## Functions

In OCaml, since everything is a value, functions are values too. Functions are defined using the `let` keyword:
```ocaml
# let square x = x * x;;
val square : int -> int = <fun>

# square 50;;
- : int = 2500
```

This example defines a function named `square` with the single parameter `x`. Its _function body_ is the expression `x * x`. There is no “return” keyword in OCaml.

When `square` is applied to `50`, it evaluates `x * x` into `50 * 50`, which leads to `2500`.

The REPL indicates that the type of `square` is `int -> int`. This means it is a function taking an `int` as argument (input) and returning an `int` as result (output). A function value can't be displayed, which is why `<fun>` is printed instead.

```ocaml
# String.ends_with;;
- : suffix:string -> string -> bool = <fun>

# String.ends_with ~suffix:"less" "stateless";;
- : bool = true
```

Some functions, such as `String.ends_with` have labelled parameters. Labels are useful when a function has several parameters of the same type; naming arguments allows to guess their purpose. Above, `~suffix:"less"` indicates `"less"` is passed as labelled argument `suffix`. Labelled arguments are detailed in the [Labelled Arguments](/docs/labels) tutorial. 

### Anonymous Functions

_Anonymous_ functions do not have a name, and they are defined with the `fun` keyword:
```ocaml
# fun x -> x * x;;
- : int -> int = <fun>
```

We can write anonymous functions and immediately apply them to a value:
```ocaml
# (fun x -> x * x) 50;;
- : int = 2500
```

### Functions with Multiple Parameters and Partial Application

A function may have several parameters, separated by spaces.
```ocaml
# let cat a b = a ^ " " ^ b;;
val cat : string -> string -> string = <fun>
```

The function `cat` has two `string` parameters, `a` and `b`, and returns a value of type `string`.
```ocaml
# cat "ha" "ha";;
- : string = "ha ha"
```

Functions don't have to be called with all the arguments they expect. It is possible to only pass `a` to `cat` without passing `b`.
```ocaml
# let cat_hi = cat "hi";;
val cat_hi : string -> string = <fun>
```

This returns a function that expects a single string, here the `b` from the definition of `cat`. This is called a _partial application_. In the above, `cat` was partially applied to `"hi"`.

The function `cat_hi`, which resulted from the partial application of `cat`, behaves as follows:
```ocaml
# cat_hi "friend";;
- : string = "hi friend"
```

### Type Parameters and Higher-Order Functions

A function may expect a function as a parameter, which is called a _higher-order_ function. A well-known example of higher-order function is `List.map`. Here is how it can be used:
```ocaml
# List.map;;
- : ('a -> 'b) -> 'a list -> 'b list = <fun>

# List.map (fun x -> x * x);;
- : int list -> int list = <fun>

# List.map (fun x -> x * x) [0; 1; 2; 3; 4; 5];;
- : int list = [0; 1; 4; 9; 16; 25]
```

The name of this function begins with `List.` because it is part of the predefined library of functions acting on lists. This matter will be discussed more later. Function `List.map` has two parameters: the second is a list, and the first is a function that can be applied to the list's elements, whatever they may be. `List.map` returns a list formed by applying the function provided as argument to each of the elements of the input list.

The function `List.map` can be applied on any kind of list. Here it is given a list of integers, but it could be a list of floats, strings, or anything. This is known as _polymorphism_. The `List.map` function is polymorphic, meaning it has two implicit _type variables_: `'a` and `'b` (pronounced “alpha” and “beta”). They both can be anything; however, in regard to the function passed to `List.map`:

1. Input list elements have the same type of its input.
2. Output list elements have the same type of its output.

### Side-Effects and the `unit` Type

Performing operating system level input-output operations is done using functions. Here is an example of each:
```ocaml
# read_line;;
- : unit -> string = <fun>

# read_line ();;
caramba
- : string = "caramba"

# print_endline;;
- : string -> unit = <fun>

# print_endline "¿Cuándo se come aquí?";;
¿Cuándo se come aquí?
- : unit = ()
```

The function `read_line` reads characters on standard input and returns them as a string when end-of-line (EOL) is reached. The function `print_endline` prints a string on standard output, followed by an EOL.

The function `read_line` doesn't need any data to proceed, and the function `print_endline` doesn't have any meaningful data to return. Indicating this absence of data is the role of the `unit` type, which appears in their signature. The type `unit` has a single value, written `()` and pronounced “unit.” It is used as a placeholder when no data is passed or returned, but some token still has to be passed to start processing or indicate processing has terminated.

Input-output is an example of something taking place when executing a function but which does not appear in the function type. This is called a _side-effect_ and does not stop at I/O. The `unit` type is often used to indicate the presence of side-effects, although it's not always the case.

### Recursive Functions

A recursive function calls itself in its own body. Such functions must be declared using `let rec … = …` instead of just `let`. Recursion is not the only means to perform iterative computation on OCaml. Loops such as `for` and `while` are available, but they are meant to be used when writing imperative OCaml in conjunction with mutable data. Otherwise, recursive functions should be preferred.

Here is an example of a function which creates a list of consecutive integers between two bounds.
```ocaml
# let rec range lo hi =
    if lo > hi then
      []
    else
      lo :: range (lo + 1) hi;;
val range : int -> int -> int list = <fun>

# range 2 5;;
- : int list = [2; 3; 4; 5]
```

As indicated by its type `int -> int -> int list`, the function `range` takes two integers as arguments and returns a list of integers as result. The first `int` parameter, `lo`, is the range's lower bound; the second `int` parameter, `hi`, is the higher bound. If `lo > hi`, the empty range is returned. That's the first branch of the `if … then … else` expression. Otherwise, the `lo` value is prepended to the list created by calling `range` itself; this is recursion. Prepending is achieved using `::`, the cons operator in OCaml. It constructs a new list by adding an element at the front of an existing list. Progress is made at each call; since `lo` has just been prepended at the head of the list, `range` is called with `lo + 1`. This can be visualised this way (this is not OCaml syntax):

```
   range 2 5
=> 2 :: range 3 5
=> 2 :: 3 :: range 4 5
=> 2 :: 3 :: 4 :: range 5 5
=> 2 :: 3 :: 4 :: 5 :: range 6 5
=> 2 :: 3 :: 4 :: 5 :: []
=> [2; 3; 4; 5]
```

Each `=>` sign corresponds to the computation of a recursive step, except the last one. OCaml handles lists internally, as shown in the penultimate expression, but displays them as the last expression. This is just pretty printing. No computation takes place between the two last steps.

## Data and Typing

### Type Conversion and Type-Inference

OCaml has floating-point values of type `float`. To add floats, one must use `+.` instead of `+`:
```ocaml
# 2.0 +. 2.0;;
- : float = 4.
```

In OCaml, `+.` is the addition between floats, while `+` is the addition between integers.

In many programming languages, values can be automatically converted from one type into another. This includes _implicit type conversion_ and _promotion_. For example, in such a language, if you write `1 + 2.5`, the first argument (an integer) is promoted to a floating point number, making the result a floating point number, too.

OCaml never implicitly converts values from one type to another. It is not possible to perform the addition of a float and integer. Both examples below throw an error:
```ocaml
# 1 + 2.5;;
Error: This expression has type float but an expression was expected of type
         int

# 1 +. 2.5;;
Error: This expression has type int but an expression was expected of type
         float
  Hint: Did you mean `1.'?
```
In the first example, `+` is intended to be used with integers, so it can't be used with the `2.5` float. In the second example, `+.` is intended to be used with floats, so it can't be used with the `1` integer.

In OCaml you need to explicitly convert the integer to a floating point number using the `float_of_int` function:
```ocaml
# float_of_int 1 +. 2.5;;
- : float = 3.5
```

There are several reasons why OCaml requires explicit conversions. Most importantly, it enables types to be worked out automatically. OCaml's _type inference_ algorithm computes a type for each expression and requires very little annotation, in comparison to other languages. Arguably, this saves more time than we lose by being more explicit.

### Lists

Lists may be the most common data type in OCaml. They are ordered collections of values having the same type. Here are a few examples.
```ocaml
# [];;
- : 'a list = []

# [1; 2; 3];;
- : int list = [1; 2; 3]

# [false; false; true];;
- : bool list = [false; false; true]

# [[1; 2]; [3]; [4; 5; 6]];;
- : int list list = [[1; 2]; [3]; [4; 5; 6]]
```

The examples above read the following way:
1. The empty list, nil
1. A list containing the numbers 1, 2, and 3
1. A list containing the Booleans `false`, `true`, and `false`. Repetitions are allowed.
1. A list of lists

Lists are defined as being either empty, written `[]`, or being an element `x` added at the front of another list `u`, which is written `x :: u` (the double colon operator is pronounced “cons”).
```ocaml
# 1 :: [2; 3; 4];;
- : int list = [1; 2; 3; 4]
```

In OCaml, _pattern matching_ provides a means to inspect data of any kind, except functions. In this section, it is introduced on lists, and it will be generalised to other data types in the next section. Here is how pattern matching can be used to define a recursive function that computes the sum of a list of integers:
```ocaml
# let rec sum u =
    match u with
    | [] -> 0
    | x :: v -> x + sum v;;
val sum : int list -> int = <fun>

# sum [1; 4; 3; 2; 5];;
- : int = 15
```

#### Polymorphic Functions on Lists

Here is how to write a recursive function that computes the length of a list:
```ocaml
# let rec length u =
    match u with
    | [] -> 0
    | _ :: v -> 1 + length v;;
val length : 'a list -> int = <fun>

# length [1; 2; 3; 4];;
- : int = 4

# length ["cow"; "sheep"; "cat"];;
- : int = 3

# length [[]];;
- : int = 1
```

This function operates not just on lists of integers but on any kind of list. It is a polymorphic function. Its type indicates input of type `'a list` where `'a` is a type variable standing for any type. The empty list pattern `[]` can be of any element type. So the `_ :: v` pattern, as the value at the head of the list, is irrelevant because the `_` pattern indicates it is not inspected. Since both patterns must be of the same type, the typing algorithm infers the `'a list -> int` type.

#### Defining a Higher-Order Function

It is possible to pass a function as argument to another function. Functions having other functions as parameters are called _higher-order_ functions. This was illustrated earlier using function `List.map`. Here is how `map` can be written using pattern matching on lists.
```ocaml
# let square x = x * x;;
val square : int -> int

# let rec map f u =
    match u with
    | [] -> []
    | x :: u -> f x :: map f u;;
val map : ('a -> 'b) -> 'a list -> 'b list = <fun>

# map square [1; 2; 3; 4;];;
- : int list = [1; 4; 9; 16]
```

### Pattern Matching, Cont'd

Pattern matching isn't limited to lists. Any kind of data can be inspected using it, except functions. Patterns are expressions that are compared to an inspected value. It could be performed using `if … then … else …`, but pattern matching is more convenient. Here is an example using the `option` data type that will be detailed in the [Modules and the Standard Library](#modules-and-the-standard-library) section.
```ocaml
# #show option;;
type 'a option = None | Some of 'a

# let f opt = match opt with
    | None -> None
    | Some None -> None
    | Some (Some x) -> Some x;;
val f : 'a option option-> 'a option = <fun>
```

The inspected value is `opt` of type `option`. It is compared against the patterns from top to bottom. If `opt` is the `None` option, it is a match with the first pattern. If `opt` is the `Some None` option, it's a match with the second pattern. If `opt` is a double-wrapped option with a value, it's a match with the third pattern. Patterns can introduce names, just as `let` does. In the third pattern, `x` designates the data inside the double-wrapped option.

Pattern matching is detailed in the [Basic Datatypes](/docs/basic-data-types) tutorial as well as in per data type tutorials.

In this other example, the same comparison is made, using `if … then … else …` and pattern matching.
```ocaml
# let g x =
  if x = "foo" then 1
  else if x = "bar" then 2
  else if x = "baz" then 3
  else if x = "qux" then 4
  else 0;;
val g : string -> int = <fun>

# let g' x = match x with
    | "foo" -> 1
    | "bar" -> 2
    | "baz" -> 3
    | "qux" -> 4
    | _ -> 0;;
val g' : string -> int = <fun>
```

The underscore symbol is a catch-all pattern; it matches with anything.

Note that OCaml throws a warning when pattern matching does not catch all cases:
```ocaml
# fun i -> match i with 0 -> 1;;
Line 1, characters 9-28:
Warning 8 [partial-match]: this pattern-matching is not exhaustive.
Here is an example of a case that is not matched:
1
- : int -> int = <fun>
```

### Pairs and Tuples

Tuples are fixed-length collections of elements of any type. Pairs are tuples that have two elements. Here is a 3-tuple and a pair:
```ocaml
# (1, "one", 'K');;
- : int * string * char = (1, "one", 'K')

# ([], false);;
- : 'a list * bool = ([], false)
```

Access to the components of tuples is done using pattern matching. For instance, the predefined function `snd` returns the second component of a pair:
```ocaml
# let snd p =
    match p with
    | (_, y) -> y;;
val snd : 'a * 'b -> 'b = <fun>

# snd (42, "apple");;
- : string = "apple"
```

Note: The function `snd` is predefined in the OCaml standard library.

The type of tuples is written using `*` between the components' types.

### Variant Types

Like pattern matching generalises `switch` statements, variant types generalise enumerated and union types.

Here is the definition of a variant type acting as an enumerated data type:
```ocaml
# type primary_colour = Red | Green | Blue;;
type primary_colour = Red | Green | Blue

# [Red; Blue; Red];;
- : primary_colour list = [Red; Blue; Red]
```

Here is the definition of a variant type acting as a union type:
```ocaml
# type http_response =
    | Data of string
    | Error_code of int;;
type http_response = Data of string | Error_code of int

# Data "<!DOCTYPE html>
<html lang=\"en\">
  <head>
    <meta charset=\"utf-8\">
    <title>Dummy</title>
  </head>
  <body>
    Dummy Page
  </body>
</html>";;

- : http_response =
Data
 "<!DOCTYPE html>\n<html lang=\"en\">\n  <head>\n    <meta charset=\"utf-8\">\n    <title>Dummy</title>\n  </head>\n  <body>\n    Dummy Page\n  </body>\n</html>"

# Error_code 404;;
- : http_response = Error_code 404
```

Here is something sitting in between:
```ocaml
# type page_range =
    | All
    | Current
    | Range of int * int;;
type page_range = All | Current | Range of int * int
```

In the previous definitions, the capitalised identifiers are called _constructors_. They allow the creation of variant values. This is unrelated to object-oriented programming.

As suggested in the first sentence of this section, variants go along with pattern matching. Here are some examples:
```ocaml
# let colour_to_rgb colour =
    match colour with
    | Red -> (0xff, 0, 0)
    | Green -> (0, 0xff, 0)
    | Blue -> (0, 0, 0xff);;
val colour_to_rgb : primary_colour -> int * int * int = <fun>

# let http_status_code response =
    match response with
    | Data _ -> 200
    | Error_code code -> code;;
val http_status_code : http_response -> int = <fun>

# let is_printable page_count cur range =
    match range with
    | All -> true
    | Current -> 0 <= cur && cur < page_count
    | Range (lo, hi) -> 0 <= lo && lo <= hi && hi < page_count;;
val is_printable : int -> int -> page_range -> bool = <fun>
```

Like a function, a variant can be recursive if it refers to itself in its own definition. The predefined type `list` provides an example of such a variant:
```ocaml
# #show list;;
type 'a list = [] | (::) of 'a * 'a list
```

As previously shown, `sum`, `length`, and `map` functions provide examples of pattern matching over the list variant type.

### Records

Like tuples, records also pack elements of several types together. However, each element is given a name. Like variant types, records types must be defined before being used. Here are examples of a record type, a value, access to a component, and pattern matching on the same record.
```ocaml
# type person = {
    first_name : string;
    surname : string;
    age : int
  };;
type person = { first_name : string; surname : string; age : int; }

# let gerard = {
     first_name = "Gérard";
     surname = "Huet";
     age = 76
  };;
val gerard : person = {first_name = "Gérard"; surname = "Huet"; age = 76}
```

When defining `gerard`, no type needs to be declared. The type checker will search for a record which has exactly three fields with matching names and types. Note that there are no typing relationships between records. It is not possible to declare a record type that extends another by adding fields. Record type search will succeed if it finds an exact match and fails in any other case.
```ocaml
# let s = gerard.surname;;
val s : string = "Huet"

# let is_teenager person =
    match person with
    | { age = x; _ } -> 13 <= x && x <= 19;;
val is_teenager : person -> bool = <fun>

# is_teenager gerard;;
- : bool = false
```

Here, the pattern `{ age = x; _ }` is typed with the most recently declared record type that has an `age` field of type `int`. The type `int` is inferred from the expression `13 <= x && x <= 19`. The function `is_teenager` will only work with the found record type, here `person`.

## Dealing With Errors

### Exceptions

When a computation is interrupted, an exception is thrown. For instance:
```ocaml
# 10 / 0;;
Exception: Division_by_zero.
```

Exceptions are raised using the `raise` function.
```ocaml
# let id_42 n = if n <> 42 then raise (Failure "Sorry") else n;;
val id_42 : int -> int = <fun>

# id_42 42;;
- : int = 42

# id_42 0;;
Exception: Failure "Sorry".
```

Note that exceptions do not appear in function types.

Exceptions are caught using the `try … with …` construction:
```ocaml
# try id_42 0 with Failure _ -> 0;;
- : int = 0
```

The standard library provides several predefined exceptions. It is possible to define exceptions.

### Using the `result` Type

Another way to deal with errors in OCaml is by returning value of type `result`,
which can represent either the correct result or an error. Here is how it is defined:
```ocaml
# #show result;;
type ('a, 'b) result = Ok of 'a | Error of 'b
```

So one may write:
```ocaml
# let id_42_res n = if n <> 42 then Error "Sorry" else Ok n;;
val id_42_res : int -> (int, string) result = <fun>

# id_42_res 42;;
- : (int, string) result = Ok 42

# id_42_res 0;;
- : (int, string) result = Error "Sorry"

# match id_42_res 0 with
  | Ok n -> n
  | Error _ -> 0;;
- : int = 0
```

## Working with Mutable State

OCaml supports imperative programming. Usually, the `let … = …` syntax does not define variables, it defines constants. However, mutable variables exist in OCaml. They are called _references_. Here's how we create a reference to an integer:
```ocaml
# let r = ref 0;;
val r : int ref = {contents = 0}
```

It is syntactically impossible to create an uninitialised or null reference. The `r`
reference is initialised with the integer zero. Accessing a reference's content
is done using the `!` de-reference operator.
```ocaml
# !r;;
- : int = 0
```

Note that `!r` and `r` have different types: `int` and `int ref`, respectively.
Just like it is not possible to perform multiplication of an integer and a float,
it is not possible to update an integer or multiply a reference.

Let's update the content of `r`. Here `:=` is the assignment operator; it is
pronounced “receives”.
```ocaml
# r := 42;;
- : unit = ()
```

This returns `()` because changing the content of a reference is a side-effect.
```ocaml
# !r;;
- : int = 42
```

Execute an expression after another with the `;` operator. Writing `a; b` means: execute `a`. Once done, execute `b`, only returns the value of `b`.
```ocaml
# let text = ref "hello ";;
val text : string ref = {contents = "hello "}

# print_string !text; text := "world!"; print_endline !text;;
hello world!
- : unit = ()
```

Here are the side effects that occur in the second line:
1. Display the contents of the reference `text` on standard output
1. Update the contents of the reference `text`
1. Display the contents of the reference `text` on standard output

This behaviour is the same as in an imperative language. However, although `;` is not defined as a function, it behaves as if it were a function of type `unit -> unit -> unit`.

## Modules and the Standard Library

Organising source code in OCaml is done using something called _modules_. A module is a group of definitions. The _standard library_ is a set of modules available to all OCaml programs. Here are how the definitions contained in the `Option` module of the standard library can be listed:
```ocaml
# #show Option;;
module Option :
  sig
    type 'a t = 'a option = None | Some of 'a
    val none : 'a t
    val some : 'a -> 'a t
    val value : 'a t -> default:'a -> 'a
    val get : 'a t -> 'a
    val bind : 'a t -> ('a -> 'b t) -> 'b t
    val join : 'a t t -> 'a t
    val map : ('a -> 'b) -> 'a t -> 'b t
    val fold : none:'a -> some:('b -> 'a) -> 'b t -> 'a
    val iter : ('a -> unit) -> 'a t -> unit
    val is_none : 'a t -> bool
    val is_some : 'a t -> bool
    val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
    val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int
    val to_result : none:'e -> 'a t -> ('a, 'e) result
    val to_list : 'a t -> 'a list
    val to_seq : 'a t -> 'a Seq.t
  end
```

Definitions provided by modules are referred to by adding the module name as a prefix to their name.
```ocaml
# Option.map;;
- : ('a -> 'b) -> 'a option -> 'b option = <fun>

# Option.map (fun x -> x * x);;
- : int option -> int option = <fun>

# Option.map (fun x -> x * x) None;;
- : int option = None

# Option.map (fun x -> x * x) (Some 8);;
- : int option = Some 64
```

Here, usage of the function `Option.map` is illustrated in several steps.
1. Display its type. It has two parameters: a function of type `'a -> 'b` and an `'a option`.
1. Using partial application, only pass `fun x -> x * x`. Check the type of the resulting function.
1. Apply with `None`.
1. Apply with `Some 8`.

When the option value provided contains an actual value (i.e., it is `Some` something), it applies the provided function and returns its result wrapped in an option. When the option value provided doesn't contain anything (i.e., it is `None`), the result doesn't contain anything as well (i.e., it is `None` too).

The `List.map` function which was used earlier in this section is also part of a module, the `List` module.
```ocaml
# List.map;;
- : ('a -> 'b) -> 'a list -> 'b list = <fun>

# List.map (fun x -> x * x);;
- : int list -> int list = <fun>
```

This illustrates the first feature of the OCaml module system. It provides a means to separate concerns by preventing name clashes. Two functions having different type may have the same name if they are provided by different modules.

Modules also allow for efficient separate compilation. This is illustrated in the next tutorial.

## Conclusion

<!--
1. Values and Functions
1. Functions
1. Type-Inference
-->

In this tutorial, OCaml was used interactively. The next tutorial, [Your First OCaml Program](/docs/your-first-program), shows you how to write OCaml files, how to compile them, and how to kickstart a project.
