module Url = Ocamlorg.Url

type urlable = Urlable : 'a list * ('a -> string) -> urlable

(* Keep it in alphabetical order. *)
let urls =
  [
    Url.about;
    Url.academic_users;
    Url.ocaml_planet;
    Url.books;
    Url.carbon_footprint;
    Url.changelog;
    Url.code_of_conduct;
    Url.community;
    Url.events;
    Url.exercises;
    Url.getting_started;
    Url.governance;
    Url.governance_policy;
    Url.index;
    Url.industrial_users;
    Url.jobs;
    Url.learn;
    Url.news;
    Url.ocaml_in_numbers;
    Url.outreachy;
    Url.packages;
    Url.packages_search;
    Url.papers;
    Url.platform;
    Url.playground;
    Url.privacy_policy;
    Url.releases;
    Url.workshops;
  ]

let to_url u = "\n<url><loc>https://ocaml.org" ^ u ^ "</loc></url>"

let urlables =
  let open Data in
  List.to_seq
    [
      Urlable (urls, to_url);
      Urlable (Changelog.all, fun r -> to_url @@ Url.changelog_entry r.slug);
      Urlable (Governance.teams, fun r -> to_url @@ Url.governance_team r.id);
      Urlable (Is_ocaml_yet.all, fun r -> to_url @@ Url.is_ocaml_yet r.id);
      Urlable (News.all, fun r -> to_url @@ Url.news_post r.slug);
      Urlable
        (Planet.local_posts, fun r -> to_url @@ Url.blog_post r.source.id r.slug);
      Urlable (Release.all, fun r -> to_url @@ Url.release r.version);
      Urlable (Success_story.all, fun r -> to_url @@ Url.success_story r.slug);
      Urlable (Tool_page.all, fun r -> to_url @@ Url.tool_page r.slug);
      Urlable (Tutorial.all, fun r -> to_url @@ Url.tutorial r.slug);
      Urlable (Workshop.all, fun r -> to_url @@ Url.workshop r.slug);
      Urlable (Survey.all, fun r -> to_url @@ Url.survey r.id);
    ]

let manual =
  let path_to_url path =
    path |> Fpath.to_string |> ( ^ ) "/manual/" |> to_url
  in
  let add_url manual path urls =
    Fpath.relativize ~root:manual path
    |> Option.fold
         ~some:(fun path -> path |> path_to_url |> Fun.flip List.cons urls)
         ~none:urls
  in
  let releases =
    let open Data.Release in
    List.map (fun (r : t) -> Url.minor r.version) all |> List.sort_uniq compare
  in
  Fpath.of_string Config.manual_path
  |> Fun.flip Result.bind (fun manual ->
         Bos.OS.Path.fold ~elements:`Files (add_url manual) []
           (List.map (Fpath.add_seg manual) releases))
  |> Result.value ~default:[] |> List.to_seq

let urlset (Urlable (all, show)) = Seq.map show (List.to_seq all)

let data =
  let header =
    {|<?xml version="1.0" encoding="utf-8"?>
<urlset
  xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
  xmlns:image="http://www.google.com/schemas/sitemap-image/1.1"
  xmlns:xhtml="http://www.w3.org/1999/xhtml">|}
  in
  Lwt_seq.of_seq
    Seq.(
      concat
        (List.to_seq
           [
             return header;
             concat_map urlset urlables;
             manual;
             return "\n</urlset>\n";
           ]))
