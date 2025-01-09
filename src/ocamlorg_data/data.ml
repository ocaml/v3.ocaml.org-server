module Academic_institution = struct
  include Academic_institution

  let featured =
    all
    |> List.filter (fun institution ->
           match institution.featured with Some true -> true | _ -> false)

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Academic_testimonial = Academic_testimonial

module Book = struct
  include Book

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Changelog = struct
  include Changelog

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Code_example = struct
  include Code_example

  let get title = List.find (fun x -> String.equal x.title title) all
end

module Cookbook = struct
  include Cookbook

  let rec get_task_path_titles categories = function
    | [] -> []
    | slug :: path ->
        let cat =
          List.find (fun (cat : category) -> cat.slug = slug) categories
        in
        cat.title :: get_task_path_titles cat.subcategories path

  let get_tasks_by_category ~category_slug =
    tasks
    |> List.filter (fun (x : task) ->
           List.(x.category_path |> rev |> hd) = category_slug)

  let get_by_task ~task_slug =
    all |> List.filter (fun (x : t) -> String.equal task_slug x.task.slug)

  let get_by_slug ~task_slug slug =
    List.find_opt
      (fun x -> String.equal slug x.slug && String.equal task_slug x.task.slug)
      all

  let main_package_of_recipe (recipe : t) =
    recipe.packages |> Fun.flip List.nth_opt 0
    |> Option.map (fun (p : package) -> p.name)
    |> Option.value ~default:"the Standard Library"

  let full_title_of_recipe (recipe : t) =
    recipe.task.title ^ " using " ^ main_package_of_recipe recipe
end

module Event = struct
  include Event

  module RecurringEvent = struct
    type t = recurring_event

    let all = recurring_event_all

    let get_by_slug slug =
      List.find_opt (fun (x : t) -> String.equal slug x.slug) all
  end

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Exercise = struct
  include Exercise

  let filter_tag ?tag =
    let f x =
      Option.fold ~none:(x.tags = []) ~some:(Fun.flip List.mem x.tags) tag
    in
    List.filter f

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Governance = struct
  include Governance

  let get_by_id id =
    List.find_opt (fun x -> String.equal id x.id) (teams @ working_groups)
end

module Industrial_user = struct
  include Industrial_user

  let featured = all |> List.filter (fun user -> user.featured)
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Is_ocaml_yet = Is_ocaml_yet
module Job = Job
module Testimonial = Testimonial

module News = struct
  include News

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Opam_user = struct
  include Opam_user

  let make ~name ?email ?github_username ?avatar () =
    { name; email; github_username; avatar }

  let find_by_name s =
    let pattern = String.lowercase_ascii s in
    let contains s1 s2 =
      try
        let len = String.length s2 in
        for i = 0 to String.length s1 - len do
          if String.sub s1 i len = s2 then raise Exit
        done;
        false
      with Exit -> true
    in
    all
    |> List.find_opt (fun { name; _ } ->
           contains pattern (String.lowercase_ascii name))
end

module Outreachy = Outreachy

module Page = struct
  include Page

  let get path =
    let slug = Filename.basename path in
    List.find (fun x -> String.equal slug x.slug) all
end

module Paper = struct
  include Paper

  let featured = all |> List.filter (fun paper -> paper.featured)
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Planet = struct
  include Planet
end

module Release = struct
  include Release

  let get_by_version version =
    if version = "lts" then Some lts
    else if version = "latest" then Some latest
    else
      match
        List.filter (fun x -> String.starts_with ~prefix:version x.version) all
      with
      | [] -> None
      | [ release ] -> Some release
      | u :: v ->
          let version r =
            r.version |> String.split_on_char '.' |> List.map int_of_string
          in
          Some
            (List.fold_left
               (fun r1 r2 -> if version r1 > version r2 then r1 else r2)
               u v)
end

module Resource = Resource

module Success_story = struct
  include Success_story

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Tool = struct
  include Tool

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Tool_page = struct
  include Tool_page

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Tutorial = struct
  include Tutorial

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all

  let search_documents q =
    let score_document (doc : search_document) =
      let regexp =
        Str.global_replace (Str.regexp "[ \t]+") "\\|" (String.trim q)
        |> Str.regexp_case_fold
      in
      let search_in_field field weight =
        Float.log (float_of_int (List.length (Str.split regexp field)))
        *. weight
      in
      search_in_field doc.title 1.2
      +. search_in_field
           (doc.section
           |> Option.map (fun (s : search_document_section) -> s.title)
           |> Option.value ~default:"")
           2.0
      +. search_in_field doc.content 1.0
    in
    List.filter_map
      (fun doc ->
        let score = score_document doc in
        if score > 0.0 then Some (doc, score) else None)
      all_search_documents
    |> List.sort (fun (_, score1) (_, score2) -> Float.compare score2 score1)
    |> List.map fst
end

module Video = Video

module Conference = struct
  include Conference

  let all = Conference.all
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module V2 = V2
