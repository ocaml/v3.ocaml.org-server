---
id: debugging
title: Debugging
description: >
  Learn to debug OCaml programs using tracing and ocamldebug
category: "Guides"
---

This tutorial presents four techniques for debugging OCaml programs:

* [Tracing functions calls](#tracing-functions-calls-in-the-toplevel),
  which work in the interactive toplevel.
* The [OCaml debugger](#the-ocaml-debugger), which allows analysing programs
  compiled with `ocamlc`.
* [How to get a back trace for an uncaught
  exception](#printing-a-back-trace-for-an-uncaught-exception) in an
  OCaml program
* [Using Thread Sanitizer to detect a data race](#detecting-a-data-race-with-thread-sanitizer) in an OCaml 5 program


## Tracing Functions Calls in the Toplevel

The simplest way to debug programs in the toplevel is to follow the function
calls, by “tracing” the faulty function:

```ocaml
# let rec fib x = if x <= 1 then 1 else fib (x - 1) + fib (x - 2);;
val fib : int -> int = <fun>
# #trace fib;;
fib is now traced.
# fib 3;;
fib <-- 3
fib <-- 1
fib --> 1
fib <-- 2
fib <-- 0
fib --> 1
fib <-- 1
fib --> 1
fib --> 2
fib --> 3
- : int = 3
# #untrace fib;;
fib is no longer traced.
```

### Polymorphic Functions

A difficulty with polymorphic functions is that the output of the trace system
is not very informative in case of polymorphic arguments and/or results.
Consider a sorting algorithm (say bubble sort):

```ocaml
# let exchange i j v =
  let aux = v.(i) in
    v.(i) <- v.(j);
    v.(j) <- aux;;
val exchange : int -> int -> 'a array -> unit = <fun>
# let one_pass_vect fin v =
  for j = 1 to fin do
    if v.(j - 1) > v.(j) then exchange (j - 1) j v
  done;;
val one_pass_vect : int -> 'a array -> unit = <fun>
# let bubble_sort_vect v =
  for i = Array.length v - 1 downto 0 do
    one_pass_vect i v
  done;;
val bubble_sort_vect : 'a array -> unit = <fun>
# let q = [|18; 3; 1|];;
val q : int array = [|18; 3; 1|]
# #trace one_pass_vect;;
one_pass_vect is now traced.
# bubble_sort_vect q;;
one_pass_vect <-- 2
one_pass_vect --> <fun>
one_pass_vect* <-- [|<poly>; <poly>; <poly>|]
one_pass_vect* --> ()
one_pass_vect <-- 1
one_pass_vect --> <fun>
one_pass_vect* <-- [|<poly>; <poly>; <poly>|]
one_pass_vect* --> ()
one_pass_vect <-- 0
one_pass_vect --> <fun>
one_pass_vect* <-- [|<poly>; <poly>; <poly>|]
one_pass_vect* --> ()
- : unit = ()
```

The function `one_pass_vect` being polymorphic, its vector argument is printed
as a vector containing polymorphic values, `[|<poly>; <poly>; <poly>|]`, and
thus we cannot properly follow the computation.

A simple way to overcome this problem is to define a monomorphic version of the
faulty function. This is fairly easy using a *type constraint*.  Generally
speaking, this allows a proper understanding of the error in the definition of
the polymorphic function. Once this has been corrected, you just have to
suppress the type constraint to revert to a polymorphic version of the
function.

For our sorting routine, a single type constraint on the argument of the
`exchange` function warranties a monomorphic typing, that allows a proper trace
of function calls:

```ocaml
# let exchange i j (v : int array) =    (* notice the type constraint *)
  let aux = v.(i) in
    v.(i) <- v.(j);
    v.(j) <- aux;;
val exchange : int -> int -> int array -> unit = <fun>
# let one_pass_vect fin v =
  for j = 1 to fin do
    if v.(j - 1) > v.(j) then exchange (j - 1) j v
  done;;
val one_pass_vect : int -> int array -> unit = <fun>
# let bubble_sort_vect v =
  for i = Array.length v - 1 downto 0 do
    one_pass_vect i v
  done;;
val bubble_sort_vect : int array -> unit = <fun>
# let q = [| 18; 3; 1 |];;
val q : int array = [|18; 3; 1|]
# #trace one_pass_vect;;
one_pass_vect is now traced.
# bubble_sort_vect q;;
one_pass_vect <-- 2
one_pass_vect --> <fun>
one_pass_vect* <-- [|18; 3; 1|]
one_pass_vect* --> ()
one_pass_vect <-- 1
one_pass_vect --> <fun>
one_pass_vect* <-- [|3; 1; 18|]
one_pass_vect* --> ()
one_pass_vect <-- 0
one_pass_vect --> <fun>
one_pass_vect* <-- [|1; 3; 18|]
one_pass_vect* --> ()
- : unit = ()
```

### Limitations

To keep track of assignments to data structures and mutable variables in a
program, the trace facility is not powerful enough. You need an extra mechanism
to stop the program in any place and ask for internal values: that is a
symbolic debugger with its stepping feature.

Stepping a functional program has a meaning which is a bit weird to define and
understand. We will use the notion of *runtime events* that happen
when a parameter is passed to a function, when entering a pattern
matching, or selecting a clause in a pattern matching. Computation
progress is taken into account by these events, independently of the
instructions executed on the hardware.

Although this is difficult to implement, there exists such a debugger for OCaml
under Unix: `ocamldebug`. Its use is illustrated in the next section.

In fact, for complex programs, it is likely the case that the programmer will
use explicit printing to find the bugs, since this methodology allows the
reduction of the trace material: only useful data are printed and special
purpose formats are more suited to get the relevant information, than what can
be output automatically by the generic pretty-printer used by the trace
mechanism.

Print debugging is assisted by compiler builtins that allow a printed error 
message to refer to the program location that the error was raised from. 
For example,
```ocaml
match Message.unpack response with
| Some y -> y
| None -> Printf.printf "Invalid message at %s" __LOC__; flush stdout;
          raise Invalid_argument
```
The compiler builtin `__LOC__` is substituted at compile time with the 
location it occurs in the program, described as a string 
"File %S, line %d, characters %d-%d".
One can also get the file name, line number, start character and
end character directly through the __POS__ builtin:
```ocaml
match Message.unpack response with
| Some y -> y
| None ->
    let fname, lnum, _cstart, _cend = __POS__ in
    Printf.printf "At line %d in file %s, an incorrect response was passed to Message.unpack"
    lnum fname;
    flush stdout; raise Invalid_argument
```

Documentation for all debugging compiler builtins is in the 
[standard library documentation](https://ocaml.org/manual/5.2/api/Stdlib.html#1_Debugging).

## The OCaml Debugger

We now give a quick tutorial for the OCaml debugger (`ocamldebug`).  Before
starting, please note that
- `ocamldebug` runs on `ocamlc` bytecode programs (it does not work on
  native code executables), and
- it does not work under native Windows ports of OCaml (but it runs
  under the Cygwin port).

### Launching the Debugger

Consider the following obviously wrong program written in the file
`uncaught.ml`:

```ocaml
(* file uncaught.ml *)
let l = ref []
let find_address name = List.assoc name !l
let add_address name address = l := (name, address) :: ! l

let () =
  add_address "IRIA" "Rocquencourt";;
  print_string (find_address "INRIA"); print_newline ();;
```
```mdx-error
val l : (string * string) list ref = {contents = [("IRIA", "Rocquencourt")]}
val find_address : string -> string = <fun>
val add_address : string -> string -> unit = <fun>
Exception: Not_found.
```

At runtime, the program raises an uncaught exception `Not_found`.  Suppose we
want to find where and why this exception has been raised, we can proceed as
follows. First, we compile the program in debug mode:

```
ocamlc -g uncaught.ml
```

We launch the debugger:

```
ocamldebug a.out
```

Then the debugger answers with a banner and a prompt:

```
OCaml Debugger version 4.14.0

(ocd)
```

### Finding the Cause of a Spurious Exception

Type `r` (for *run*); you get

```
(ocd) r
Loading program... done.
Time : 27
Program end.
Uncaught exception: Not_found
(ocd)
```

Self-explanatory, isn't it? So, you want to step backward to set the program
counter before the time the exception is raised; hence type in `b` as
*backstep*, and you get

```
(ocd) b
Time: 26 - pc: 0:29628 - module Stdlib__List
191     [] -> raise Not_found<|a|>
```

The debugger tells you that you are in `Stdlib`'s module `List`,
inside a pattern matching on a list that already chose the `[]` case
and just executed `raise Not_found`, since the program is stopped just
after this expression (as witnessed by the `<|a|>` mark).

But, as you know, you want the debugger to tell you which procedure calls the
one from `List`, and also who calls the procedure that calls the one from
`List`; hence, you want a backtrace of the execution stack:

```
(ocd) bt
Backtrace:
#0 Stdlib__List list.ml:191:26
#1 Uncaught uncaught.ml:8:38
```

So the last function called is from module `List` on line 191, character 26, that is:

<!-- $MDX skip -->
```ocaml
let rec assoc x = function
  | [] -> raise Not_found
          ^
  | (a,b)::l -> if a = x then b else assoc x l
```

The function that calls it is in module `Uncaught`, file `uncaught.ml`
line 8, char 38:


<!-- $MDX skip -->
```ocaml
print_string (find_address "INRIA"); print_newline ();;
                                  ^
```

To sum up: if you're developing a program you can compile it with the `-g`
option, to be ready to debug the program if necessary. Hence, to find a
spurious exception you just need to type `ocamldebug a.out`, then `r`, `b`, and
`bt` gives you the backtrace.

### Getting Help and Info in the Debugger

To get more info about the current status of the debugger you can ask it
directly at the toplevel prompt of the debugger; for instance:

```
(ocd) info breakpoints
No breakpoint.

(ocd) help break
break: Set breakpoint.
Syntax: break
        break function-name
        break @ [module] linenum
        break @ [module] linenum columnnum
        break @ [module] # characternum
        break frag:pc
        break pc
```

### Setting Break Points

Let's set up a breakpoint and rerun the entire program from the
beginning (`(g)oto 0` then `(r)un`):

```
(ocd) break @Uncaught 7
Breakpoint 1 at 0:42856: file uncaught.ml, line 7, characters 3-36

(ocd) g 0
Time : 0
Beginning of program.

(ocd) r
Time: 20 - pc: 0:42856 - module Uncaught
Breakpoint: 1
7   add_address "IRIA" "Rocquencourt"<|a|>;;
```

Then, we can step and find what happens just before (`<|b|>`)
`List.assoc` is about to be called in `find_address`:

```
(ocd) s
Time: 21 - pc: 0:42756 - module Uncaught
3 let find_address name = <|b|>List.assoc name !l

(ocd) p name
name : string = "INRIA"

(ocd) p !l
$1 : (string * string) list = ["IRIA", "Rocquencourt"]
(ocd)
```

Now we can guess why `List.assoc` will fail to find "INRIA" in the list...

### Using the Debugger Under Emacs

Under Emacs you call the debugger using `ESC-x` `ocamldebug a.out`. Then Emacs
will send you directly to the file and character reported by the debugger, and
you can step back and forth using `ESC-b` and `ESC-s`. Plus, you can set up break
points using `CTRL-X space`, and so on...

## Printing a Back Trace for an Uncaught Exception

Getting a back trace for an uncaught exception can be informative to
understand in which context a problem occurs. However, by default,
programs compiled with both `ocamlc` and `ocamlopt` will not print it:

```
ocamlc -g uncaught.ml
./a.out
Fatal error: exception Not_found
ocamlopt -g uncaught.ml
./a.out
Fatal error: exception Not_found
```

By running with the environment variable `OCAMLRUNPARAM` set to `b`
(for back trace) we get something more informative:

```
OCAMLRUNPARAM=b ./a.out
Fatal error: exception Not_found
Raised at Stdlib__List.assoc in file "list.ml", line 191, characters 10-25
Called from Uncaught.find_address in file "uncaught.ml" (inlined), line 3, characters 24-42
Called from Uncaught in file "uncaught.ml", line 8, characters 15-37
```

From this back trace it should be clear that we receive a `Not_found`
exception in `List.assoc` from the `Stdlib` when calling
`find_address` on line 8.


The environment variable `OCAMLRUNPARAM` also works when working on a
program built with `dune`:

```
;; file dune
(executable
 (name uncaught)
 (modules uncaught)
)
```
```
OCAMLRUNPARAM=b dune exec ./uncaught.exe
Fatal error: exception Not_found
Raised at Stdlib__List.assoc in file "list.ml", line 191, characters 10-25
Called from Dune__exe__Uncaught.find_address in file "uncaught.ml" (inlined), line 3, characters 24-42
Called from Dune__exe__Uncaught in file "uncaught.ml", line 8, characters 15-37
```


## Detecting a Data Race with Thread Sanitizer

With the introduction of Multicore parallelism in OCaml 5, comes the
risk of introducing data races among the involved `Domain`s. Luckily
the Thread Sanitizer (TSan) mode for OCaml is helpful to catch and
report these.

### Installing a TSan Switch

To install the TSan mode, create a dedicated TSan switch by running the
following command (here we create a 5.2.0 switch):
```
opam switch create 5.2.0+tsan ocaml-variants.5.2.0+options ocaml-option-tsan
```

To confirm that the TSan switch is installed correctly, run `opam
switch show` and confirm that it prints `5.2.0+tsan`.

Note: TSan is supported on all architectures with a native code
compiler since OCaml 5.2.0.

Troubleshooting:
- If the above fails during installation of `conf-unwind` with `No
  package 'libunwind' found`, try setting the environment variable
  `PKG_CONFIG_PATH` to point to the location of `libunwind.pc`, for
  example, `PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig`
- If the above fails with an error along the lines of
  `FATAL: ThreadSanitizer: unexpected memory mapping 0x61a1a94b2000-0x61a1a94ca000`,
  this is [a known issue with older versions of TSan](https://github.com/google/sanitizers/issues/1716)
  and can be addressed by reducing ASLR entropy by running
  `sudo sysctl vm.mmap_rnd_bits=28`

### Detecting a Data Race

Now consider the following OCaml program written in the file `race.ml`:

```ocaml
(* file race.ml *)
type t = { mutable x : int }

let v = { x = 0 }

let () =
  let t1 = Domain.spawn (fun () -> v.x <- 10; Unix.sleep 1) in
  let t2 = Domain.spawn (fun () -> v.x <- 11; Unix.sleep 1) in
  Domain.join t1;
  Domain.join t2;
  Printf.printf "v.x is %i\n" v.x
```

It builds a record `v` with a mutable field `x` initialised to `0`.
Next, it spawns two parallel `Domain`s `t1` and `t2` that both update
the field `v.x`.

Here is a corresponding `dune` file:
```dune
(executable
 (name race)
 (modules race)
 (libraries unix))
```

If we compile and run the program using `dune` under a regular `5.2.0` switch the
program appears to work:
```
$ opam exec -- dune build ./race.exe
$ opam exec -- dune exec ./race.exe
v.x is 11
```

However, if we compile and run the program with Dune from the new
`5.2.0+tsan` switch TSan warns us of a data race:
```
$ opam switch 5.2.0+tsan
$ opam exec -- dune build ./race.exe
$ opam exec -- dune exec ./race.exe
==================
WARNING: ThreadSanitizer: data race (pid=19414)
  Write of size 8 at 0x7fb9d72fe498 by thread T4 (mutexes: write M87):
    #0 camlDune__exe__Race__fun_560 /home/user/race/_build/default/race.ml:6 (race.exe+0x60c65)
    #1 camlStdlib__Domain__body_696 /home/user/.opam/5.2.0+tsan/.opam-switch/build/ocaml-variants.5.2.0+tsan/stdlib/domain.ml:202 (race.exe+0x9c38c)
    #2 caml_start_program <null> (race.exe+0x110117)
    #3 caml_callback_exn runtime/callback.c:201 (race.exe+0xe00fe)
    #4 domain_thread_func runtime/domain.c:1215 (race.exe+0xe3e83)

  Previous write of size 8 at 0x7fb9d72fe498 by thread T1 (mutexes: write M83):
    #0 camlDune__exe__Race__fun_556 /home/user/race/_build/default/race.ml:5 (race.exe+0x60c05)
    #1 camlStdlib__Domain__body_696 /home/user/.opam/5.2.0+tsan/.opam-switch/build/ocaml-variants.5.2.0+tsan/stdlib/domain.ml:202 (race.exe+0x9c38c)
    #2 caml_start_program <null> (race.exe+0x110117)
    #3 caml_callback_exn runtime/callback.c:201 (race.exe+0xe00fe)
    #4 domain_thread_func runtime/domain.c:1215 (race.exe+0xe3e83)

  Mutex M87 (0x560c0b4fc438) created at:
    #0 pthread_mutex_init ../../../../src/libsanitizer/tsan/tsan_interceptors_posix.cpp:1295 (libtsan.so.2+0x50468)
    #1 caml_plat_mutex_init runtime/platform.c:57 (race.exe+0x1022f8)
  [...]

SUMMARY: ThreadSanitizer: data race (/tmp/race/race.exe+0x4efb15) in camlRace__fun_560
==================
v.x is 11
ThreadSanitizer: reported 1 warnings
```

Note that since TSan instrumentation operates in a separate switch;
this required no change to our `dune` file.

The TSan report warns of a data race between two uncoordinated writes
happening in parallel and prints a back trace for both:
- The first back trace reports a write at `race.ml` in line
  6 of `thread T4` and
- the second back trace reports a previous write at
  `race.ml` in line 5 of `thread T1`

Looking again at our program, we realize that these two writes are in
fact not coordinated. One possible fix is to replace our mutable
record field with an [`Atomic`](/manual/api/Atomic.html) that guarantees each
such write to happen fully, one after the other:

```ocaml
(* file race.ml *)
let v = Atomic.make 0

let () =
  let t1 = Domain.spawn (fun () -> Atomic.set v 10; Unix.sleep 1) in
  let t2 = Domain.spawn (fun () -> Atomic.set v 11; Unix.sleep 1) in
  Domain.join t1;
  Domain.join t2;
  Printf.printf "v is %i\n" (Atomic.get v)
```

If we recompile and run our program with this change, it now completes
without TSan warnings:
```
$ opam exec -- dune build ./race.exe
$ opam exec -- dune exec ./race.exe
v is 11
```

The TSan instrumentation benefits from compiling programs with debug
information, which happens by default under `dune`. To manually invoke
the `ocamlopt` compiler under our `5.2.0+tsan` switch it is thus
suffient to pass it the `-g` flag:
```
$ ocamlopt -g -o race.exe -I +unix unix.cmxa race.ml
```
