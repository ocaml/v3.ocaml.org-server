module Academic_institution : sig
  include module type of Data_intf.Academic_institution

  val all : t list
  val get_by_slug : string -> t option
end

module Book : sig
  include module type of Data_intf.Book

  val all : t list
  val get_by_slug : string -> t option
end

module Changelog : sig
  include module type of Data_intf.Changelog

  val all : t list
  val get_by_slug : string -> t option
end

module Code_example : sig
  type t = { title : string; body : string }

  val get : string -> t
end

module Community_metric : sig
  type datapoint = { label : string; value : float }
  type metric = { name : string; chart : string; data : datapoint list }
  type overview_item = { name : string; value : int }
  type section = { name : string; metrics : metric list }
  type t = { overview : overview_item list; sections : section list }

  val t : t
end

module Cookbook : sig
  include module type of Data_intf.Cookbook

  val top_categories : category list
  val tasks : task list
  val all : t list
  val get_task_path_titles : category list -> string list -> string list
  val get_tasks_by_category : category_slug:string -> task list
  val get_by_task : task_slug:string -> t list
  val get_by_slug : task_slug:string -> string -> t option
  val full_title_of_recipe : t -> string
  val main_package_of_recipe : t -> string
end

module Event : sig
  type event_type = Meetup | Conference | Seminar | Hackathon | Retreat
  type location = { lat : float; long : float }

  module RecurringEvent : sig
    type t = {
      slug : string;
      title : string;
      url : string;
      textual_location : string;
      location : location option;
      event_type : event_type;
    }

    val all : t list
    val get_by_slug : string -> t option
  end

  type utc_datetime = { yyyy_mm_dd : string; utc_hh_mm : string option }

  type t = {
    title : string;
    url : string;
    slug : string;
    textual_location : string;
    location : location option;
    starts : utc_datetime;
    ends : utc_datetime option;
    body_md : string;
    body_html : string;
    recurring_event : RecurringEvent.t option;
    event_type : event_type;
  }

  val all : t list
  val get_by_slug : string -> t option
end

module Exercise : sig
  include module type of Data_intf.Exercise

  val all : t list
  val filter_tag : ?tag:string -> t list -> t list
  val get_by_slug : string -> t option
end

module Governance : sig
  include module type of Data_intf.Governance

  val teams : team list
  val working_groups : team list
  val get_by_id : string -> team option
end

module Industrial_user : sig
  include module type of Data_intf.Industrial_user

  val all : t list
  val featured : t list
  val get_by_slug : string -> t option
end

module Is_ocaml_yet : sig
  include module type of Data_intf.Is_ocaml_yet

  val all : t list
end

module Job : sig
  include module type of Data_intf.Job

  val all : t list
end

module News : sig
  include module type of Data_intf.News

  val all : t list
  val get_by_slug : string -> t option
end

module Opam_user : sig
  include module type of Data_intf.Opam_user

  val all : t list

  val make :
    name:string ->
    ?email:string ->
    ?github_username:string ->
    ?avatar:string ->
    unit ->
    t

  val find_by_name : string -> t option
end

module Outreachy : sig
  include module type of Data_intf.Outreachy

  val all : t list
end

module Page : sig
  type t = {
    slug : string;
    title : string;
    description : string;
    meta_title : string;
    meta_description : string;
    body_md : string;
    body_html : string;
  }

  val get : string -> t
end

module Paper : sig
  type link = { description : string; uri : string }

  type t = {
    title : string;
    slug : string;
    publication : string;
    authors : string list;
    abstract : string;
    tags : string list;
    year : int;
    links : link list;
    featured : bool;
  }

  val all : t list
  val featured : t list
  val get_by_slug : string -> t option
end

module Planet : sig
  type source = {
    id : string;
    name : string;
    url : string;
    description : string;
    disabled : bool;
  }

  module Post : sig
    type t = {
      title : string;
      url : string option;
      slug : string;
      source : source;
      description : string option;
      authors : string list;
      date : string;
      preview_image : string option;
      body_html : string;
    }

    val all : t list
  end

  module LocalBlog : sig
    type t = { source : source; posts : Post.t list; rss_feed : string }

    val all : t list
    val get_by_id : string -> t option
  end

  val local_posts : Post.t list
end

module Release : sig
  type kind = [ `Compiler ]

  type t = {
    kind : kind;
    version : string;
    date : string;
    is_latest : bool;
    is_lts : bool;
    intro_md : string;
    intro_html : string;
    highlights_md : string;
    highlights_html : string;
    body_md : string;
    body_html : string;
  }

  val all : t list
  val get_by_version : string -> t option
  val latest : t
  val lts : t
end

module Resource : sig
  type t = {
    title : string;
    description : string;
    image : string;
    online_url : string;
    source_url : string option;
    featured : bool;
  }

  val all : t list
  val featured : t list
end

module Success_story : sig
  type t = {
    title : string;
    slug : string;
    logo : string;
    background : string;
    theme : string;
    synopsis : string;
    url : string;
    body_md : string;
    body_html : string;
  }

  val all : t list
  val get_by_slug : string -> t option
end

module Survey : sig
  type result = { label : string; value : float }
  type question = { question : string; chart : string; data : result list }
  type section = { name : string; questions : question list }

  type t = {
    id : string;
    name : string;
    discuss : string;
    link : string;
    sections : section list;
  }

  val all : t list
  val get_by_id : string -> t option
end

module Tool : sig
  type lifecycle = [ `Incubate | `Active | `Sustain | `Deprecate ]

  type t = {
    name : string;
    slug : string;
    source : string;
    license : string;
    synopsis : string;
    description : string;
    lifecycle : lifecycle;
  }

  val all : t list
  val get_by_slug : string -> t option
end

module Tool_page : sig
  type toc = { title : string; href : string; children : toc list }
  type contribute_link = { url : string; description : string }

  type t = {
    title : string;
    short_title : string;
    fpath : string;
    slug : string;
    description : string;
    category : string;
    body_md : string;
    toc : toc list;
    body_html : string;
  }

  val all : t list
  val get_by_slug : string -> t option
end

module Tutorial : sig
  module Section : sig
    type t = GetStarted | Language | Platform | Guides
  end

  type toc = { title : string; href : string; children : toc list }
  type contribute_link = { url : string; description : string }
  type banner = { image : string; url : string; alt : string }

  type external_tutorial = {
    tag : string;
    banner : banner;
    contribute_link : contribute_link;
  }

  type recommended_next_tutorials = string list
  type prerequisite_tutorials = string list
  type search_document_section = { title : string; id : string }

  type search_document = {
    title : string;
    category : string;
    section : search_document_section option;
    content : string;
    slug : string;
  }

  type t = {
    title : string;
    short_title : string;
    fpath : string;
    slug : string;
    description : string;
    section : Section.t;
    category : string;
    external_tutorial : external_tutorial option;
    body_md : string;
    toc : toc list;
    body_html : string;
    recommended_next_tutorials : recommended_next_tutorials;
    prerequisite_tutorials : prerequisite_tutorials;
  }

  val all : t list
  val all_search_documents : search_document list
  val get_by_slug : string -> t option
  val search_documents : string -> search_document list
end

module Watch : sig
  type t = {
    name : string;
    embed_path : string;
    thumbnail_path : string;
    description : string option;
    published_at : string;
    language : string;
    category : string;
  }

  val all : t list
end

module Workshop : sig
  type role = [ `Co_chair | `Chair ]

  val role_to_string : role -> string
  val role_of_string : string -> (role, [> `Msg of string ]) result

  type important_date = { date : string; info : string }

  type committee_member = {
    name : string;
    role : role option;
    affiliation : string option;
    picture : string option;
  }

  type presentation = {
    title : string;
    authors : string list;
    link : string option;
    video : string option;
    slides : string option;
    poster : bool;
    additional_links : string list;
  }

  type t = {
    title : string;
    slug : string;
    location : string;
    date : string;
    important_dates : important_date list;
    presentations : presentation list;
    program_committee : committee_member list;
    organising_committee : committee_member list;
    body_md : string;
    body_html : string;
  }

  val all : t list
  val get_by_slug : string -> t option
end
