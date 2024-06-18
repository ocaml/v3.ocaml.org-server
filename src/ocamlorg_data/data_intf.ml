module Academic_institution = struct
  type location = { lat : float; long : float } [@@deriving of_yaml, show]

  type course = {
    name : string;
    acronym : string option;
    online_resource : string option;
  }
  [@@deriving of_yaml, show]

  type t = {
    name : string;
    slug : string;
    description : string;
    url : string;
    logo : string option;
    continent : string;
    courses : course list;
    location : location option;
    body_md : string;
    body_html : string;
  }
  [@@deriving show]
end

module Book = struct
  type difficulty = Beginner | Intermediate | Advanced [@@deriving show]

  let difficulty_of_string = function
    | "beginner" -> Ok Beginner
    | "intermediate" -> Ok Intermediate
    | "advanced" -> Ok Advanced
    | s -> Error (`Msg ("Unknown difficulty type: " ^ s))

  let difficulty_of_yaml = function
    | `String s -> difficulty_of_string s
    | _ -> Error (`Msg "Expected a string for difficulty type")

  type link = { description : string; uri : string } [@@deriving of_yaml, show]

  type t = {
    title : string;
    slug : string;
    description : string;
    recommendation : string option;
    authors : string list;
    language : string list;
    published : string;
    cover : string;
    isbn : string option;
    links : link list;
    difficulty : difficulty;
    pricing : string;
    body_md : string;
    body_html : string;
  }
  [@@deriving show]
end

module Changelog = struct
  type t = {
    title : string;
    slug : string;
    date : string;
    tags : string list;
    changelog_html : string option;
    body_html : string;
    body : string;
    authors : string list;
  }
  [@@deriving of_yaml, show]
end

module Code_examples = struct
  type t = { title : string; body : string }
  [@@deriving show { with_path = false }]
end

module Community_metric = struct
  type datapoint = { label : string; value : float } [@@deriving of_yaml, show]

  type metric = { name : string; chart : string; data : datapoint list }
  [@@deriving of_yaml, show]

  type overview_item = { name : string; value : int } [@@deriving of_yaml, show]

  type section = { name : string; metrics : metric list }
  [@@deriving of_yaml, show]

  type t = { overview : overview_item list; sections : section list }
  [@@deriving of_yaml, show]
end

module Cookbook = struct
  type category = {
    title : string;
    slug : string;
    subcategories : category list;
  }
  [@@deriving show]

  type task = {
    title : string;
    slug : string;
    category_path : string list;
    description : string option;
  }
  [@@deriving show]

  type code_block_with_explanation = { code : string; explanation : string }
  [@@deriving show]

  type package = {
    name : string;
    tested_version : string;
    used_libraries : string list;
  }
  [@@deriving of_yaml, show]

  type t = {
    slug : string;
    filepath : string;
    task : task;
    packages : package list;
    code_blocks : code_block_with_explanation list;
    code_plaintext : string;
    discussion_html : string;
  }
  [@@deriving show]
end

module Exercise = struct
  type difficulty = Beginner | Intermediate | Advanced [@@deriving show]

  let of_string = function
    | "beginner" -> Ok Beginner
    | "intermediate" -> Ok Intermediate
    | "advanced" -> Ok Advanced
    | s -> Error (`Msg ("Unknown difficulty type: " ^ s))

  let difficulty_of_yaml = function
    | `String s -> of_string s
    | _ -> Error (`Msg "Expected a string for difficulty type")

  type t = {
    title : string;
    slug : string;
    difficulty : difficulty;
    tags : string list;
    description : string;
    statement : string;
    solution : string;
    tutorials : string list;
  }
  [@@deriving show]
end

module Governance = struct
  module Member = struct
    type t = { name : string; github : string; role : string }
    [@@deriving of_yaml, show]

    let compare a b = String.compare a.github b.github
  end

  type contact_kind = GitHub | Email | Discord | Chat [@@deriving show]

  let contact_kind_of_yaml = function
    | `String "github" -> Ok GitHub
    | `String "email" -> Ok Email
    | `String "discord" -> Ok Discord
    | `String "chat" -> Ok Chat
    | x -> (
        match Yaml.to_string x with
        | Ok str ->
            Error
              (`Msg
                ("\"" ^ str
               ^ "\" is not a valid contact_kind! valid options are: github, \
                  email, discord, chat"))
        | Error _ -> Error (`Msg "Invalid Yaml value"))

  let contact_kind_to_yaml = function
    | GitHub -> `String "github"
    | Email -> `String "email"
    | Discord -> `String "discord"
    | Chat -> `String "chat"

  type contact = { name : string; link : string; kind : contact_kind }
  [@@deriving of_yaml, show]

  type dev_meeting = {
    date : string;
    time : string;
    link : string;
    calendar : string option;
    notes : string;
  }
  [@@deriving of_yaml, show]

  type team = {
    id : string;
    name : string;
    description : string;
    contacts : contact list;
    dev_meeting : dev_meeting option; [@default None] [@key "dev-meeting"]
    members : Member.t list; [@default []]
    subteams : team list; [@default []]
  }
  [@@deriving of_yaml, show]
end

module Industrial_user = struct
  type t = {
    name : string;
    slug : string;
    description : string;
    logo : string option;
    url : string;
    locations : string list;
    consortium : bool;
    featured : bool;
    body_md : string;
    body_html : string;
  }
  [@@deriving show]
end

module Is_ocaml_yet = struct
  type external_package = { url : string; synopsis : string }
  [@@deriving of_yaml, show]

  type package = { name : string; extern : external_package option }
  [@@deriving of_yaml, show]

  type category = {
    name : string;
    status : string;
    description : string;
    packages : package list;
    slug : string;
  }
  [@@deriving show]

  type t = {
    id : string;
    question : string;
    answer : string;
    categories : category list;
    body_html : string;
  }
  [@@deriving show]
end

module Job = struct
  type t = {
    title : string;
    link : string;
    locations : string list;
    publication_date : string option;
    company : string;
    company_logo : string;
  }
  [@@deriving of_yaml, show]
end

module News = struct
  type t = {
    title : string;
    description : string;
    date : string;
    slug : string;
    tags : string list;
    body_html : string;
    authors : string list;
  }
  [@@deriving show]
end

module Opam_user = struct
  type t = {
    name : string;
    email : string option;
    github_username : string option;
    avatar : string option;
  }
  [@@deriving of_yaml, show]
end

module Outreachy = struct
  type project = {
    title : string;
    description : string;
    mentee : string;
    blog : string option;
    source : string;
    mentors : string list;
    video : string option;
  }
  [@@deriving of_yaml, show]

  type t = { name : string; projects : project list } [@@deriving of_yaml, show]
end

module Survey = struct
  type result = { label : string; value : float } [@@deriving of_yaml, show]

  type question = { question : string; chart : string; data : result list }
  [@@deriving of_yaml, show]

  type section = { name : string; questions : question list }
  [@@deriving of_yaml, show]

  type t = {
    id : string;
    name : string;
    discuss : string;
    link : string;
    sections : section list;
  }
  [@@deriving of_yaml, show]
end
