(* This module manages the synchronisation of a local clone of
   opam-monorepository to access the opam packages and their metadata. It also
   uses the output of the occurent documentation pipeline to render packages
   documentation. *)

module Import = Import

(** The name of an opam package. *)
module Name : sig
  type t

  val compare : t -> t -> int
  val to_string : t -> string
  val of_string : string -> t

  module Map : OpamStd.MAP with type key := t
end

(** The version of an opam package. *)
module Version : sig
  type t

  val compare : t -> t -> int
  val to_string : t -> string
  val of_string : string -> t

  module Map : OpamStd.MAP with type key := t
end

(** The information of a package. Typically, this is read from the opam file in
    the opam-repository. *)
module Info : sig
  type url = { uri : string; checksum : string list }

  type t = {
    synopsis : string;
    description : string;
    authors : string list;
    maintainers : string list;
    license : string;
    homepage : string list;
    tags : string list;
    dependencies : (Name.t * string option) list;
    rev_deps : (Name.t * string option * Version.t) list;
    depopts : (Name.t * string option) list;
    conflicts : (Name.t * string option) list;
    url : url option;
    publication : float;
    flags : OpamTypes.package_flag list;
  }
end

module Statistics : sig
  type package_stat = { name : Name.t; version : Version.t; info : Info.t }

  type t = {
    nb_packages : int;  (** Total number of packages. *)
    nb_update_week : int;
        (** Number of packages updated during the last 7 days. *)
    nb_packages_month : int;  (** Number of packages added the last 30 days. *)
    newest_packages : (package_stat * string) list;
        (** The 5 newest packages and date, in Git's relative format. *)
    recently_updated : package_stat list;
        (** The 5 most recently updated packages. *)
    most_revdeps : (package_stat * int) list;
        (** The 5 packages with the most number of revdeps. *)
  }
end

module Documentation : sig
  type toc = { title : string; href : string; children : toc list }

  type breadcrumb_kind =
    | Page
    | LeafPage
    | Module
    | ModuleType
    | Parameter of int
    | Class
    | ClassType
    | File

  type breadcrumb = { name : string; href : string; kind : breadcrumb_kind }

  type t = {
    uses_katex : bool;
    toc : toc list;
    breadcrumbs : breadcrumb list;
    content : string;
  }
end

module Package_info = Package_info

type state
type t

val mockup_state : t list -> state
(** [mockup_state ts] produces the opam-repository state from a list of packages *)

val name : t -> Name.t
(** Get the name of a package. *)

val version : t -> Version.t
(** Get the version of a package. *)

val info : t -> Info.t
(** Get the info of a package. *)

val create : name:Name.t -> version:Version.t -> Info.t -> t
(** This is added to enable demo test package to use Package.t with abstraction *)

module Documentation_status : sig
  type otherdocs = {
    readme : string option;
    license : string option;
    changes : string option;
  }

  type t = { failed : bool; otherdocs : otherdocs }
end

val documentation_status :
  kind:[< `Package | `Universe of string ] ->
  state ->
  t ->
  Documentation_status.t option Lwt.t
(** Get the build status of the documentation of a package *)

val module_map :
  kind:[< `Package | `Universe of string ] -> t -> Package_info.t Lwt.t
(** Get the module map of a package *)

val documentation_page :
  kind:[< `Package | `Universe of string ] ->
  t ->
  string ->
  Documentation.t option Lwt.t
(** Get the rendered content of an HTML page for a package given its URL
    relative to the root page of the documentation. *)

val file :
  kind:[< `Package | `Universe of string ] ->
  t ->
  string ->
  Documentation.t option Lwt.t
(** Get the rendered content of an HTML page for a file accompanying a package
    given its URL relative to the root of the package. *)

val search_index :
  kind:[< `Package | `Universe of string ] -> t -> string option Lwt.t
(** Retrieve the search index of a given package. *)

val init : ?disable_polling:bool -> unit -> state
(** [init ()] initialises the opam-repository state. By default
    [disable_polling] is set to [false], but can be disabled for tests. *)

val all_latest : state -> t list
(** Get the list of the latest version of every opam packages. The name and
    versions of the packages are read from the file system, the metadata are
    loaded lazily to improve performance. *)

val stats : state -> Statistics.t option
(** Return the statistics computed from the opam-repository. These statistics
    are continuously updated in the background. Returns [None] if the stats are
    still being computed. *)

val get_by_name : state -> Name.t -> t list option
(** Get the list of packages with the given name. *)

type version_with_publication_date = {
  version : Version.t;
  publication : float;
}

val get_versions : state -> Name.t -> version_with_publication_date list
(** Get the list of versions for a package name, newest coming first. *)

val get_latest : state -> Name.t -> t option
(** Get the latest version of a package given a package name. *)

val get : state -> Name.t -> Version.t -> t option
(** Get a package given its name and version. *)

val latest_documented_version : state -> Name.t -> Version.t option Lwt.t
(** Find the latest documented version of a package. **)

val is_latest_version : state -> Name.t -> Version.t -> bool
(** Returns a bool if the given version is the latest version of a package. **)

val search :
  is_author_match:(string -> string -> bool) ->
  ?sort_by_popularity:bool ->
  state ->
  string ->
  t list
(** Search package that match the given string.

    Packages returned contain the string either in the name, tags, synopsis or
    description. They are ordered in the following way:

    - Packages whose name is exactly the given string - packages whose name
      contain the given string - packages having the given string as a tag -
      packages whose synopsis contain the given string - packages whose
      description contain the given string.

    - Function is_author_match is used decide if a search string correspond to a
      package author

    A call to this function call Lazy.force on every package info. *)
