(** This module enables parsing the `package.json` file generated by
    ocaml-docs-ci. If the documentation generation is successful, this file
    should exist and contain a "map" of the documentation pages present in the
    package: a tree of pages (modules) starting from the libraries defining
    them. *)

open Ocamlorg.Import

(** Page kinds as defined by odoc. *)
type kind =
  | Module
  | Page
  | Leaf_page
  | Module_type
  | Parameter of int
  | Class
  | Class_type
  | File

(** An odoc module, corresponding to a single page. *)
module Module : sig
  type t

  val name : t -> string
  (** [name t] is [t]'s page name. *)

  val parent : t -> t option
  (** [parent t] is [t]'s parent if it exists. *)

  val submodules : t -> t String.Map.t
  (** [submodules t] is [t]'s child pages. *)

  val kind : t -> kind
  (** [kind t] is [t]'s kind (an OCaml module, an interface, a class, ..)*)

  val path : t -> string
  (** [path t] is the relative path to the page. *)
end

type library = {
  name : string;
  dependencies : string list;
  modules : Module.t String.Map.t;
}
(** The type for a library. It contains its name, dependencies and root modules *)

type t = { libraries : library String.Map.t }
(** The type for a package map. *)

val of_yojson : Yojson.Safe.t -> t
(** Parse the package map from the JSON format of `package.json` *)
