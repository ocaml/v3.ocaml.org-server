let index = "/"
let install = "/install"
let packages = "/packages"
let packages_search = "/packages/search"
let packages_autocomplete_fragment = "/packages/autocomplete"

module Package : sig
  val overview : ?hash:string -> ?version:string -> string -> string
  val versions : ?hash:string -> ?version:string -> string -> string

  val documentation :
    ?hash:string -> ?version:string -> ?page:string -> string -> string

  val file :
    ?hash:string -> ?version:string -> filepath:string -> string -> string

  val search_index : ?version:string -> digest:string -> string -> string
end = struct
  let with_hash = Option.fold ~none:"/p" ~some:(( ^ ) "/u/")
  let with_version = Option.fold ~none:"/latest" ~some:(( ^ ) "/")

  let base ?hash ?version page name =
    with_hash hash ^ "/" ^ name ^ with_version version ^ page

  let overview ?hash ?version = base ?hash ?version ""
  let versions ?hash ?version = base ?hash ?version "/versions"

  let documentation ?hash ?version ?(page = "index.html") =
    base ?hash ?version ("/doc/" ^ page)

  let file ?hash ?version ~filepath = base ?hash ?version ("/" ^ filepath)
  let search_index ?version ~digest = base ?version ("/search-index/" ^ digest)
end

let sitemap = "/sitemap.xml"
let community = "/community"
let ocaml_in_numbers = "/ocaml-in-numbers"
let resources = "/resources"
let events = "/events"
let success_story v = "/success-stories/" ^ v
let industrial_users = "/industrial-users"
let academic_users = "/academic-users"
let about = "/about"

let minor v =
  match String.split_on_char '.' v with
  | x :: y :: _ -> x ^ "." ^ y
  | _ -> invalid_arg (v ^ ": invalid OCaml version")

let v2 = "https://v2.ocaml.org"
let manual_with_version v = "/manual/" ^ minor v ^ "/index.html"
let manual = "/manual"
let api_with_version v = "/manual/" ^ minor v ^ "/api/index.html"
let api = "/api"
let books = "/books"
let changelog = "/changelog"
let changelog_entry id = "/changelog/" ^ id
let releases = "/releases"
let release v = "/releases/" ^ v
let workshops = "/workshops"
let workshop v = "/workshops/" ^ v
let ocaml_planet = "/ocaml-planet"
let local_blog source = "/blog/" ^ source
let blog_post source v = "/blog/" ^ source ^ "/" ^ v
let news = "/news"
let news_post v = "/news/" ^ v
let jobs = "/jobs"
let governance = "/governance"
let governance_team id = "/governance/" ^ id
let carbon_footprint = "/policies/carbon-footprint"
let privacy_policy = "/policies/privacy-policy"
let governance_policy = "/policies/governance"
let code_of_conduct = "/policies/code-of-conduct"
let playground = "/play"
let papers = "/papers"
let learn = "/docs"
let learn_get_started = "/docs/get-started"
let learn_language = "/docs/language"
let learn_guides = "/docs/guides"
let learn_platform = "/docs/tools"
let tools = "/tools"
let platform = "/platform"
let tool_page name = "/tools/" ^ name
let tutorial name = "/docs/" ^ name
let tutorial_search = "/docs/search"
let getting_started = "/docs/get-started"
let installing_ocaml = "/docs/installing-ocaml"
let exercises = "/exercises"
let outreachy = "/outreachy"
let logos = "/logo"
let cookbook = "/cookbook"
let cookbook_task task_slug = cookbook ^ "/" ^ task_slug
let cookbook_recipe ~task_slug slug = "/cookbook/" ^ task_slug ^ "/" ^ slug

let github_opam_file package_name package_version =
  Printf.sprintf
    "https://github.com/ocaml/opam-repository/blob/master/packages/%s/%s.%s/opam"
    package_name package_name package_version

let is_ocaml_yet id = Printf.sprintf "/docs/is-ocaml-%s-yet" id
let survey id = Printf.sprintf "/surveys/%s" id
