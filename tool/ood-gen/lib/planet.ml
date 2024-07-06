open Ocamlorg.Import
open Data_intf.Planet

module Local = struct
  (* blogs hosted on ocaml.org, e.g. Opam blog *)

  module Source = struct
    type t = { id : string; name : string; description : string }
    [@@deriving yaml]

    type sources = t list [@@deriving yaml]

    let all () : source list =
      let file = "planet-local-blogs.yml" in
      let result =
        let ( let* ) = Result.bind in
        let* yaml = Utils.yaml_file file in
        let* sources =
          sources_of_yaml yaml |> Result.map_error (Utils.where file)
        in
        Ok
          (sources
          |> List.map (fun s ->
                 {
                   id = s.id;
                   name = s.name;
                   url = "https://ocaml.org/blog/" ^ s.id;
                   description = s.description;
                   disabled = false;
                 }))
      in
      result
      |> Result.get_ok ~error:(fun (`Msg msg) ->
             Exn.Decode_error (file ^ ": " ^ msg))
  end

  module Post = struct
    type metadata = {
      title : string;
      description : string;
      date : string;
      preview_image : string option;
      authors : string list option;
    }
    [@@deriving yaml]

    let all_sources = Source.all ()

    let of_metadata ~slug ~source ~body_html m : Post.t =
      {
        title = m.title;
        source;
        slug;
        url = None;
        description = Some m.description;
        authors = Option.value ~default:[] m.authors;
        date = m.date;
        preview_image = m.preview_image;
        body_html;
      }

    let decode (fpath, (head, body_md)) =
      let metadata =
        metadata_of_yaml head |> Result.map_error (Utils.where fpath)
      in
      let body_html =
        body_md |> Markdown.Content.of_string
        |> Markdown.Content.render ~syntax_highlighting:true
      in
      let source, slug =
        match Str.split (Str.regexp_string "/") fpath with
        | [ _; second; slug ] ->
            let source =
              match
                List.find_opt (fun (s : source) -> s.id = second) all_sources
              with
              | Some source -> source
              | None -> failwith ("No source found for: " ^ fpath)
            in
            let slug = String.sub slug 0 (String.length slug - 3) in
            (source, slug)
        | _ ->
            failwith
              ("Trying to determine the source for " ^ fpath
             ^ " but the path is not long enough (should start with \
                planet-local-blogs/SOURCE_NAME/...)")
      in
      metadata
      |> Result.map_error (Utils.where fpath)
      |> Result.map (of_metadata ~slug ~source ~body_html)

    let all () : Post.t list =
      Utils.map_md_files decode "planet-local-blogs/*/*.md"
      |> List.sort (fun (a : Post.t) (b : Post.t) ->
             String.compare b.date a.date)
  end
end

module External = struct
  (* external RSS feeds that we aggregate - they will all be scraped by the
     scrape.yml workflow *)

  module Source = struct
    type t = {
      id : string;
      name : string;
      url : string;
      disabled : bool option;
    }
    [@@deriving yaml]

    type sources = t list [@@deriving yaml]

    let all () : source list =
      let file = "planet-sources.yml" in
      let result =
        let ( let* ) = Result.bind in
        let* yaml = Utils.yaml_file file in
        let* sources =
          sources_of_yaml yaml |> Result.map_error (Utils.where file)
        in
        Ok
          (sources
          |> List.map (fun { id; name; url; disabled } ->
                 {
                   id;
                   name;
                   url;
                   description = "";
                   disabled = Option.value ~default:false disabled;
                 }))
      in
      result
      |> Result.get_ok ~error:(fun (`Msg msg) ->
             Exn.Decode_error (file ^ ": " ^ msg))
  end

  module Post = struct
    type source_on_external_post = { name : string; url : string }
    [@@deriving yaml]

    type metadata = {
      title : string;
      description : string option;
      url : string;
      date : string;
      preview_image : string option;
      authors : string list option;
      source : source_on_external_post option;
    }
    [@@deriving yaml]

    let all_sources = Source.all ()

    let of_metadata ~source ~body_html m : Post.t =
      {
        title = m.title;
        source =
          (match source with
          | Ok s -> s
          | Error (`Msg e) -> (
              match m.source with
              | Some { name; url } ->
                  { id = ""; name; url; description = ""; disabled = false }
              | None ->
                  failwith
                    (e ^ " and there is no source defined in the markdown file")
              ));
        url = Some m.url;
        slug = "";
        description = m.description;
        authors = Option.value ~default:[] m.authors;
        date = m.date;
        preview_image = m.preview_image;
        body_html;
      }

    let pp_meta ppf v =
      Fmt.pf ppf {|---
%s---
|}
        (metadata_to_yaml v |> Yaml.to_string
        |> Result.get_ok ~error:(fun (`Msg m) -> Exn.Decode_error m))

    let decode (fpath, (head, body_md)) =
      let metadata =
        metadata_of_yaml head |> Result.map_error (Utils.where fpath)
      in
      let body_html =
        body_md |> Markdown.Content.of_string
        |> Markdown.Content.render ~syntax_highlighting:true
      in
      let source =
        match Str.split (Str.regexp_string "/") fpath with
        | _ :: second :: _ -> (
            match
              List.find_opt (fun (s : source) -> s.id = second) all_sources
            with
            | Some source -> Ok source
            | None -> Error (`Msg ("No source found for: " ^ fpath)))
        | _ ->
            failwith
              ("Trying to determine the source for " ^ fpath
             ^ " but the path is not long enough (should start with \
                planet/SOURCE_NAME/...)")
      in
      metadata
      |> Result.map_error (Utils.where fpath)
      |> Result.map (of_metadata ~source ~body_html)

    let all () : Post.t list =
      Utils.map_md_files decode "planet/*/*.md"
      |> List.sort (fun (a : Post.t) (b : Post.t) ->
             String.compare b.date a.date)
  end
end

let feed_authors source authors =
  match List.map Syndic.Atom.author authors with
  | x :: xs -> (x, xs)
  | [] -> (Syndic.Atom.author source.name, [])

module LocalBlog = struct
  let create_entry (post : Post.t) =
    let content = Syndic.Atom.Html (None, post.body_html) in
    let id =
      Uri.of_string
        ("https://ocaml.org/blog/" ^ post.source.id ^ "/" ^ post.slug)
    in
    let authors = feed_authors post.source post.authors in
    let updated = Syndic.Date.of_rfc3339 post.date in
    Syndic.Atom.entry ~content ~id ~authors ~title:(Syndic.Atom.Text post.title)
      ~updated
      ~links:[ Syndic.Atom.link id ]
      ()

  let create_feed source posts =
    let open Rss in
    posts
    |> create_feed
         ~id:("blog/" ^ source.id ^ "/feed.xml")
         ~title:(source.name ^ " @ OCaml.org")
         ~create_entry
    |> feed_to_string

  let all () =
    let all_posts = Local.Post.all () in
    Local.Source.all ()
    |> List.map (fun (source : source) : LocalBlog.t ->
           let posts =
             all_posts
             |> List.filter (fun (p : Post.t) -> p.source.id = source.id)
           in
           { source; posts; rss_feed = create_feed source posts })
end

let all () =
  Local.Post.all () @ External.Post.all ()
  |> List.sort (fun (a : Post.t) (b : Post.t) -> String.compare b.date a.date)

let template () =
  Format.asprintf
    {ocaml|
include Data_intf.Planet
let post_all = %a
let local_blog_all = %a
|ocaml}
    (Fmt.brackets (Fmt.list Post.pp ~sep:Fmt.semi))
    (all ())
    (Fmt.brackets (Fmt.list Data_intf.Planet.LocalBlog.pp ~sep:Fmt.semi))
    (LocalBlog.all ())

module GlobalFeed = struct
  let create_entry (post : Post.t) =
    let content = Syndic.Atom.Html (None, post.body_html) in
    let url = Uri.of_string post.source.url in
    let source : Syndic.Atom.source =
      Syndic.Atom.source ~authors:[] ~id:url
        ~title:(Syndic.Atom.Text post.source.name)
        ~links:[ Syndic.Atom.link url ]
        ?updated:None ?categories:None ?contributors:None ?generator:None
        ?icon:None ?logo:None ?rights:None ?subtitle:None
    in
    let id =
      Uri.of_string
        (match post.url with
        | Some url -> url
        | None -> "https://ocaml.org/blog/" ^ post.source.id ^ "/" ^ post.slug)
    in
    let authors = feed_authors post.source post.authors in
    let updated = Syndic.Date.of_rfc3339 post.date in
    Syndic.Atom.entry ~content ~source ~id ~authors
      ~title:(Syndic.Atom.Text post.title) ~updated
      ~links:[ Syndic.Atom.link id ]
      ()

  let create_feed () =
    let open Rss in
    () |> all
    |> create_feed ~id:"planet.xml" ~title:"The OCaml Planet" ~create_entry
         ~span:90
    |> feed_to_string
end

module Scraper = struct
  let fetch_feed (id, source) =
    try Some (id, River.fetch source)
    with e ->
      print_endline
        (Printf.sprintf "failed to scrape %s: %s" id (Printexc.to_string e));
      None

  let scrape_post ~source (post : River.post) =
    let title = River.title post in
    let slug = Utils.slugify title in
    let source_path = "data/planet/" ^ source.id in
    let output_file = source_path ^ "/" ^ slug ^ ".md" in
    if not (Sys.file_exists output_file) then
      let url = River.link post in
      let date = River.date post |> Option.map Syndic.Date.to_rfc3339 in
      match (url, date) with
      | None, _ ->
          print_endline
            (Printf.sprintf "skipping %s/%s: item does not have a url" source.id
               slug)
      | _, None ->
          print_endline
            (Printf.sprintf "skipping %s/%s: item does not have a date"
               source.id slug)
      | Some url, Some date ->
          if not (Sys.file_exists source_path) then Sys.mkdir source_path 0o775;
          let oc = open_out output_file in
          let content = River.content post in
          let url = String.trim (Uri.to_string url) in
          let preview_image = River.seo_image post in
          let description = River.meta_description post in
          let author = River.author post in
          let metadata : External.Post.metadata =
            {
              title;
              url;
              date;
              preview_image;
              description;
              authors = Some [ author ];
              source = None;
            }
          in
          let s =
            Format.asprintf "%a\n%s\n" External.Post.pp_meta metadata content
          in
          Printf.fprintf oc "%s" s;
          close_out oc

  let scrape_source source =
    try
      [ River.fetch { name = source.name; url = source.url } ]
      |> River.posts
      |> List.iter (scrape_post ~source)
    with e ->
      print_endline
        (Printf.sprintf "failed to scrape %s: %s" source.id
           (Printexc.to_string e))

  let scrape () =
    let sources = External.Source.all () in
    sources
    |> List.filter (fun ({ disabled; _ } : source) -> not disabled)
    |> List.iter scrape_source
end
