open Ocamlorg
open Ocamlorg.Import

let http_or_404 ?(not_found = Ocamlorg_frontend.not_found) opt f =
  Option.fold ~none:(Dream.html ~code:404 (not_found ())) ~some:f opt

(* short-circuiting 404 error operator *)
let ( let</>? ) opt = http_or_404 opt

let index _req =
  Dream.html
    (Ocamlorg_frontend.home ~latest_release:Data.Release.latest
       ~lts_release:Data.Release.lts
       ~releases:(List.take 2 Data.Release.all)
       ~changelogs:(List.take 3 Data.Changelog.all))

let install _req = Dream.html (Ocamlorg_frontend.install ())

let learn _req =
  let papers = Data.Paper.featured in
  let latest_version = Data.Release.latest.version in
  Dream.html (Ocamlorg_frontend.learn ~papers ~latest_version)

let learn_get_started req =
  let tutorials =
    Data.Tutorial.all
    |> List.filter (fun (t : Data.Tutorial.t) -> t.section = GetStarted)
  in
  Dream.redirect req (Url.tutorial (List.hd tutorials).slug)

let learn_language req =
  let tutorials =
    Data.Tutorial.all
    |> List.filter (fun (t : Data.Tutorial.t) -> t.section = Language)
  in
  Dream.redirect req (Url.tutorial (List.hd tutorials).slug)

let learn_guides req =
  let tutorials =
    Data.Tutorial.all
    |> List.filter (fun (t : Data.Tutorial.t) -> t.section = Guides)
  in
  Dream.redirect req (Url.tutorial (List.hd tutorials).slug)

let learn_platform req =
  let tutorials =
    Data.Tutorial.all
    |> List.filter (fun (t : Data.Tutorial.t) -> t.section = Platform)
  in
  Dream.redirect req (Url.tutorial (List.hd tutorials).slug)

let community _req =
  let query = Dream.query _req "e" in
  let string_to_event_type s =
    match s with
    | "meetup" -> Some Data.Event.Meetup
    | "conference" -> Some Data.Event.Conference
    | "seminar" -> Some Data.Event.Seminar
    | "hackathon" -> Some Data.Event.Hackathon
    | "retreat" -> Some Data.Event.Retreat
    | _ -> None
  in
  let selected_event =
    match query with Some s -> string_to_event_type s | _ -> None
  in
  let current_date =
    let open Unix in
    let tm = localtime (Unix.gettimeofday ()) in
    Format.asprintf "%04d-%02d-%02d" (tm.tm_year + 1900) (tm.tm_mon + 1)
      tm.tm_mday
  in
  let upcoming_events =
    List.filter
      (fun (e : Data.Event.t) ->
        e.starts.yyyy_mm_dd >= current_date
        || Option.is_some e.ends
           && e.ends
              |> Option.map (fun (e : Data.Event.utc_datetime) -> e.yyyy_mm_dd)
              |> Option.get >= current_date)
      Data.Event.all
    |> (match query with
       | None | Some "All" -> fun e -> e
       | _ ->
           List.filter (fun (event : Data.Event.t) ->
               match selected_event with
               | None -> false
               | Some eventType -> event.event_type = eventType))
    |> Ocamlorg.Import.List.take 6
  in
  let event_types =
    Data.Event.all
    |> List.map (fun (event : Data.Event.t) ->
           match event.event_type with
           | Meetup -> "Meetup"
           | Conference -> "Conference"
           | Seminar -> "Seminar"
           | Hackathon -> "Hackathon"
           | Retreat -> "Retreat")
    |> List.sort_uniq String.compare
  in
  let events = (upcoming_events, event_types) in
  let old_conferences =
    match
      List.filter
        (fun (w : Data.Conference.t) -> w.date < current_date)
        Data.Conference.all
    with
    | [] -> []
    | x :: _ -> [ x ]
  in
  let jobs =
    match Data.Job.all with
    | [] -> []
    | [ a ] -> [ a ]
    | [ a; b ] -> [ a; b ]
    | a :: b :: c :: _ -> [ a; b; c ]
  in
  let jobs_with_count = (jobs, List.length Data.Job.all) in
  let outreachy_latest_project =
    match Data.Outreachy.all with
    | [] -> []
    | first_round :: _ -> (
        match first_round.projects with
        | [] -> []
        | first_project :: _ -> [ (first_round.name, first_project) ])
  in
  Dream.html
    (Ocamlorg_frontend.community ~old_conferences ~outreachy_latest_project
       ?selected_event:query ~events jobs_with_count)

type common_event =
  [ `Event of Data.Event.t | `Recurring of Data.Event.recurring_event ]

let events _req =
  let event_type = Dream.query _req "event_type" in
  let event_location = Dream.query _req "event_location" in
  let recurring_event_type = Dream.query _req "recurring_event_type" in
  let recurring_event_location = Dream.query _req "recurring_event_location" in
  let recurring_events = Data.Event.RecurringEvent.all in

  let current_date =
    let open Unix in
    let tm = localtime (Unix.gettimeofday ()) in
    Format.asprintf "%04d-%02d-%02d" (tm.tm_year + 1900) (tm.tm_mon + 1)
      tm.tm_mday
  in
  let upcoming_events =
    List.filter
      (fun (e : Data.Event.t) ->
        e.starts.yyyy_mm_dd >= current_date
        || Option.is_some e.ends
           && e.ends
              |> Option.map (fun (e : Data.Event.utc_datetime) -> e.yyyy_mm_dd)
              |> Option.get >= current_date)
      Data.Event.all
  in
  let string_of_event_type = function
    | Data.Event.Meetup -> "Meetup"
    | Data.Event.Conference -> "Conference"
    | Data.Event.Seminar -> "Seminar"
    | Data.Event.Hackathon -> "Hackathon"
    | Data.Event.Retreat -> "Retreat"
  in
  let extract_event_types (type a) (events : a list)
      (get_event_type : a -> Data.Event.event_type) =
    events
    |> List.map (fun event -> string_of_event_type (get_event_type event))
    |> List.sort_uniq String.compare
  in
  let upcoming_event_types =
    extract_event_types upcoming_events (fun event -> event.event_type)
  in
  let recurring_event_types =
    extract_event_types recurring_events (fun event -> event.event_type)
  in
  let recurring_event_locations =
    Data.Event.all
    |> List.map (fun (event : Data.Event.t) -> event.city)
    |> List.sort_uniq String.compare
  in
  let upcoming_event_locations =
    upcoming_events
    |> List.map (fun (event : Data.Event.t) -> event.city)
    |> List.sort_uniq String.compare
  in
  let matches_criteria (event : common_event) event_type location =
    let event_type_value, city =
      match event with
      | `Event e -> (e.event_type, e.city)
      | `Recurring e -> (e.event_type, e.city)
    in
    let matches_type =
      match event_type with
      | None | Some "All" -> true
      | Some e when e = "Meetup" -> event_type_value = Data.Event.Meetup
      | Some e when e = "Conference" -> event_type_value = Data.Event.Conference
      | Some e when e = "Seminar" -> event_type_value = Data.Event.Seminar
      | Some e when e = "Hackathon" -> event_type_value = Data.Event.Hackathon
      | Some e when e = "Retreat" -> event_type_value = Data.Event.Retreat
      | Some _ -> true
    in
    let matches_location =
      match location with
      | Some l when l = "All" -> true
      | Some l -> city = l
      | None -> true
    in
    matches_type && matches_location
  in

  let filtered_upcoming_events =
    List.filter_map
      (fun event ->
        let event = `Event event in
        if matches_criteria event event_type event_location then
          match event with `Event e -> Some e | _ -> None
        else None)
      upcoming_events
  in
  let filtered_recurring_events =
    List.filter_map
      (fun event ->
        let event = `Recurring event in
        if matches_criteria event recurring_event_type recurring_event_location
        then match event with `Recurring e -> Some e | _ -> None
        else None)
      recurring_events
  in

  Dream.html
    (Ocamlorg_frontend.events ~upcoming:filtered_upcoming_events
       ~recurring_events:filtered_recurring_events ?event_type ?event_location
       ?recurring_event_type ?recurring_event_location ~upcoming_event_types
       ~recurring_event_types upcoming_event_locations recurring_event_locations)

let paginate ~req ~n items =
  let items_per_page = n in
  let page =
    Option.bind (Dream.query req "p") int_of_string_opt
    |> Option.value ~default:1
  in
  let number_of_pages =
    int_of_float
      (Float.ceil
         (float_of_int (List.length items) /. float_of_int items_per_page))
  in
  let current_items =
    let skip = items_per_page * (page - 1) in
    items |> List.drop skip |> List.take items_per_page
  in
  (page, number_of_pages, current_items)

let query_param ~name value =
  match value with None -> [] | Some v -> [ (name, v) ]

let learn_documents_search req =
  let q = Dream.query req "q" in
  let search_results =
    Data.Tutorial.search_documents (q |> Option.value ~default:"")
  in
  let total = List.length search_results in
  let page_number, total_page_count, current_items =
    paginate ~req ~n:50 search_results
  in
  let pagination_info =
    Ocamlorg_frontend.Pagination.
      {
        total_page_count;
        page_number;
        base_url = Url.tutorial_search;
        queries = query_param ~name:"q" q;
      }
  in
  Dream.html
    (Ocamlorg_frontend.tutorial_search current_items ~total ~pagination_info
       ~search:(q |> Option.value ~default:""))

let changelog req =
  let current_tag = Dream.query req "t" in
  let tags =
    Data.Changelog.all
    |> List.concat_map (fun (change : Data.Changelog.t) -> change.tags)
    |> List.sort_uniq String.compare
  in
  let changes =
    match current_tag with
    | None | Some "" -> Data.Changelog.all
    | Some tag ->
        List.filter
          (fun (change : Data.Changelog.t) ->
            List.exists (( = ) tag) change.tags)
          Data.Changelog.all
  in

  let page_number, total_page_count, current_changes =
    paginate ~req ~n:50 changes
  in
  let pagination_info =
    Ocamlorg_frontend.Pagination.
      {
        total_page_count;
        page_number;
        base_url = Url.changelog;
        queries = query_param ~name:"t" current_tag;
      }
  in

  Dream.html
    (Ocamlorg_frontend.changelog ?current_tag ~tags ~pagination_info
       current_changes)

let changelog_entry req =
  let slug = Dream.param req "id" in
  let</>? change = Data.Changelog.get_by_slug slug in
  Dream.html (Ocamlorg_frontend.changelog_entry change)

let success_story req =
  let slug = Dream.param req "id" in
  let</>? success_story = Data.Success_story.get_by_slug slug in
  Dream.html (Ocamlorg_frontend.success_story success_story)

let industrial_users _req =
  let sort_by_priority_desc lst =
    List.sort
      (fun (a : Data.Success_story.t) (b : Data.Success_story.t) ->
        compare a.priority b.priority)
      lst
  in
  let top_story = List.hd (sort_by_priority_desc Data.Success_story.all) in
  let users = Data.Industrial_user.featured |> Ocamlorg.Import.List.take 6 in
  let success_stories =
    match sort_by_priority_desc Data.Success_story.all with
    | [] -> []
    | _ :: rest -> rest
  in
  let testimonials = Data.Testimonial.all in
  let jobs =
    match Data.Job.all with a :: b :: c :: d :: _ -> [ a; b; c; d ] | _ -> []
  in
  let jobs_with_count = (jobs, List.length Data.Job.all) in

  Dream.html
    (Ocamlorg_frontend.industrial_users ~users ~success_stories ~top_story
       ~testimonials ~jobs_with_count)

let industrial_businesses _req =
  let businesses = Data.Industrial_user.all in

  Dream.html (Ocamlorg_frontend.industrial_businesses ~businesses)

let academic_users _req =
  let featured_institutions = Data.Academic_institution.featured in
  let papers = Data.Paper.featured |> Ocamlorg.Import.List.take 3 in
  let books = Data.Book.all |> Ocamlorg.Import.List.take 2 in
  let testimonials = Data.Academic_testimonial.all in
  let books_with_count = (books, List.length Data.Book.all) in
  let extract_courses_with_university
      (institutions : Data.Academic_institution.t list) =
    List.fold_left
      (fun acc (institution : Data.Academic_institution.t) ->
        match
          List.find_opt
            (fun (course : Data.Academic_institution.course) ->
              match course.url with Some _ -> true | None -> false)
            institution.courses
        with
        | Some course ->
            (institution.name, course) :: acc (* Add the first course found *)
        | None -> acc)
      [] institutions
  in
  let top_courses =
    extract_courses_with_university featured_institutions
    |> Ocamlorg.Import.List.take 3
  in

  Dream.html
    (Ocamlorg_frontend.academic_users ~featured_institutions ~papers
       ~books:books_with_count ~testimonials ~top_courses)

let academic_institutions req =
  let query = Dream.query req "q" in
  let continent = Dream.query req "continent" in
  let resource_type = Dream.query req "resource_type" in
  let search_user pattern t =
    let open Data.Academic_institution in
    let pattern = String.lowercase_ascii pattern in
    let name_is_s { name; _ } = String.lowercase_ascii name = pattern in
    let name_contains_s { name; _ } = String.is_sub_ignore_case pattern name in
    let score user =
      if name_is_s user then -1
      else if name_contains_s user then 0
      else failwith "impossible user score"
    in
    t
    |> List.filter (fun p -> name_contains_s p)
    |> List.sort (fun user_1 user_2 -> compare (score user_1) (score user_2))
  in
  let users =
    match query with
    | None -> Data.Academic_institution.all
    | Some search -> search_user search Data.Academic_institution.all
  in
  let matches_criteria (institution : Data.Academic_institution.t) continent
      resource_type =
    let matches_resource_type =
      match resource_type with
      | None | Some "All" -> true
      | Some d when d = "lecture_notes" ->
          List.mem true
            (List.map
               (fun (x : Data.Academic_institution.course) ->
                 x.lecture_notes = true)
               institution.courses)
      | Some d when d = "exercises" ->
          List.mem true
            (List.map
               (fun (x : Data.Academic_institution.course) ->
                 x.exercises = true)
               institution.courses)
      | Some d when d = "video_recordings" ->
          List.mem true
            (List.map
               (fun (x : Data.Academic_institution.course) ->
                 x.video_recordings = true)
               institution.courses)
      | Some _ -> true
    in
    let matches_continent =
      match continent with
      | None | Some "All" -> true
      | Some c -> c = institution.continent
    in
    matches_continent && matches_resource_type
  in
  let filtered_institutions =
    List.filter
      (fun institution -> matches_criteria institution continent resource_type)
      users
  in
  let page_number, total_page_count, institutions =
    paginate ~req ~n:10 filtered_institutions
  in
  let pagination_info =
    Ocamlorg_frontend.Pagination.
      {
        total_page_count;
        page_number;
        base_url = Url.academic_institutions;
        queries =
          query_param ~name:"q" query
          @ query_param ~name:"resource_type" resource_type
          @ query_param ~name:"continent" continent;
      }
  in
  Dream.html
    (Ocamlorg_frontend.academic_institutions ?search:query ?continent
       ?resource_type ~pagination_info institutions)

let about _req = Dream.html (Ocamlorg_frontend.about ())

let books req =
  let language = Dream.query req "language" in
  let pricing = Dream.query req "pricing" in
  let difficulty = Dream.query req "difficulty" in
  let matches_criteria (book : Data.Book.t) language pricing difficulty =
    let matches_language =
      match language with
      | None | Some "All" -> true
      | Some lang -> List.mem true (List.map (fun x -> x = lang) book.language)
    in
    let matches_pricing =
      match pricing with
      | Some p when p = "All" -> true
      | Some p -> book.pricing = p
      | None -> true
    in
    let matches_difficulty =
      match difficulty with
      | Some d when d = "All" -> true
      | Some d when d = "beginner" -> book.difficulty = Data.Book.Beginner
      | Some d when d = "intermediate" ->
          book.difficulty = Data.Book.Intermediate
      | Some d when d = "advanced" -> book.difficulty = Data.Book.Advanced
      | Some _ -> true
      | None -> true
    in
    matches_language && matches_pricing && matches_difficulty
  in
  let filter_books books language pricing difficulty =
    List.filter
      (fun book -> matches_criteria book language pricing difficulty)
      books
  in
  let filtered_books = filter_books Data.Book.all language pricing difficulty in
  Dream.html
    (Ocamlorg_frontend.books ?language ?pricing ?difficulty filtered_books)

let releases req =
  let search_release pattern t =
    let open Data.Release in
    let is_version { version; _ } =
      String.(lowercase_ascii version = lowercase_ascii pattern)
    in
    let version_contains_s { version; _ } =
      String.is_sub_ignore_case pattern version
    in
    let body_contains_s { body_md; _ } =
      String.is_sub_ignore_case pattern body_md
    in
    let score release =
      if is_version release then -1
      else if version_contains_s release then 0
      else if body_contains_s release then 2
      else failwith "impossible release score"
    in
    t
    |> List.filter (fun p -> version_contains_s p)
    |> List.sort (fun release_1 release_2 ->
           compare (score release_1) (score release_2))
  in
  let search = Dream.query req "q" in
  let releases =
    match search with
    | None -> Data.Release.all
    | Some search -> search_release search Data.Release.all
  in
  Dream.html (Ocamlorg_frontend.releases ?search releases)

let release req =
  let version = Dream.param req "id" in
  let</>? version = Data.Release.get_by_version version in
  Dream.html (Ocamlorg_frontend.release version)

let conferences _req =
  let past_conferences = Data.Conference.all in
  let current_date =
    let open Unix in
    let tm = localtime (Unix.gettimeofday ()) in
    Format.asprintf "%04d-%02d-%02d" (tm.tm_year + 1900) (tm.tm_mon + 1)
      tm.tm_mday
  in
  let upcoming_conferences =
    List.filter
      (fun (e : Data.Event.t) ->
        e.event_type = Data.Event.Conference
        && (e.starts.yyyy_mm_dd >= current_date
           || Option.is_some e.ends
              && e.ends
                 |> Option.map (fun (e : Data.Event.utc_datetime) ->
                        e.yyyy_mm_dd)
                 |> Option.get >= current_date))
      Data.Event.all
    |> Ocamlorg.Import.List.take 6
  in
  Dream.html
    (Ocamlorg_frontend.conferences ~upcoming_conferences past_conferences)

let conference req =
  let slug = Dream.param req "id" in
  let</>? conference =
    List.find_opt
      (fun (x : Data.Conference.t) -> x.slug = slug)
      Data.Conference.all
  in
  Dream.html (Ocamlorg_frontend.conference conference)

let ocaml_planet req =
  let category = Dream.query req "category" in
  let matches_criteria (item : Data.Planet.entry) cat =
    match cat with
    | Some d when d = "All" -> true
    | Some d when d = "Article" -> (
        match item with BlogPost _ -> true | Video _ -> false)
    | Some d when d = "Video" -> (
        match item with BlogPost _ -> false | Video _ -> true)
    | Some _ -> true
    | None -> true
  in
  let filtered_entries =
    Data.Planet.all |> List.filter (fun item -> matches_criteria item category)
  in
  let page_number, total_page_count, current_items =
    paginate ~req ~n:10 filtered_entries
  in
  let pagination_info =
    Ocamlorg_frontend.Pagination.
      {
        total_page_count;
        page_number;
        base_url = Url.ocaml_planet;
        queries = query_param ~name:"category" category;
      }
  in

  Dream.html
    (Ocamlorg_frontend.ocaml_planet ~pagination_info ?category current_items)

let news req =
  let page_number, total_page_count, current_items =
    paginate ~req ~n:10 Data.News.all
  in
  let pagination_info =
    Ocamlorg_frontend.Pagination.
      { total_page_count; page_number; base_url = Url.news; queries = [] }
  in
  Dream.html (Ocamlorg_frontend.news ~pagination_info current_items)

let news_post req =
  let slug = Dream.param req "id" in
  let</>? news = Data.News.get_by_slug slug in
  Dream.html (Ocamlorg_frontend.news_post news)

let jobs req =
  let location = Dream.query req "c" in
  let jobs =
    match location with
    | None | Some "All" -> Data.Job.all
    | Some location ->
        List.filter
          (fun (job : Data.Job.t) -> List.exists (( = ) location) job.locations)
          Data.Job.all
  in
  let locations =
    Data.Job.all
    |> List.concat_map (fun (job : Data.Job.t) ->
           List.filter (( <> ) "Remote") job.locations)
    |> List.sort_uniq String.compare
  in

  Dream.html (Ocamlorg_frontend.jobs ?location ~locations jobs)

let page canonical (_req : Dream.request) =
  let page = Data.Page.get canonical in
  Dream.html
    (Ocamlorg_frontend.page ~title:page.title ~description:page.description
       ~meta_title:page.meta_title ~meta_description:page.meta_description
       ~content:page.body_html ~canonical)

let carbon_footprint = page Url.carbon_footprint
let privacy_policy = page Url.privacy_policy
let governance_policy = page Url.governance_policy
let code_of_conduct = page Url.code_of_conduct

let playground _req =
  let default = Data.Code_example.get "default.ml" in
  let default_code = default.body in
  Dream.html (Ocamlorg_frontend.playground ~default_code)

let governance _req =
  Dream.html
    (Ocamlorg_frontend.governance ~teams:Data.Governance.teams
       ~working_groups:Data.Governance.working_groups)

let governance_team req =
  let id = Dream.param req "id" in
  let</>? team = Data.Governance.get_by_id id in
  Dream.html (Ocamlorg_frontend.governance_team team)

let papers req =
  let search_paper pattern t =
    let open Data.Paper in
    let title_is_s { title; _ } =
      String.(lowercase_ascii title = lowercase_ascii pattern)
    in
    let title_contains_s { title; _ } =
      String.is_sub_ignore_case pattern title
    in
    let abstract_contains_s { abstract; _ } =
      String.is_sub_ignore_case pattern abstract
    in
    let has_tag_s { tags; _ } =
      List.exists (fun tag -> String.is_sub_ignore_case pattern tag) tags
    in
    let score paper =
      if title_is_s paper then -1
      else if title_contains_s paper then 0
      else if has_tag_s paper then 1
      else if abstract_contains_s paper then 2
      else failwith "impossible paper score"
    in
    t
    |> List.filter (fun p -> title_contains_s p)
    |> List.sort (fun paper_1 paper_2 ->
           compare (score paper_1) (score paper_2))
  in
  let search = Dream.query req "q" in
  let papers =
    match search with
    | None -> Data.Paper.all
    | Some search -> search_paper search Data.Paper.all
  in
  let recommended_papers = Data.Paper.featured in
  Dream.html (Ocamlorg_frontend.papers ?search ~recommended_papers papers)

let resources _req =
  Dream.html (Ocamlorg_frontend.resources ~resources:Data.Resource.all)

let tools req = Dream.redirect req ~code:307 Url.platform

let tools_platform _req =
  let tools = Data.Tool.all in
  Dream.html (Ocamlorg_frontend.tools_platform ~pages:Data.Tool_page.all tools)

let tool_page commit_hash req =
  let slug = Dream.param req "id" in
  let</>? page = Data.Tool_page.get_by_slug slug in
  let pages = Data.Tool_page.all in
  Dream.html
    (Ocamlorg_frontend.tool_page commit_hash ~pages
       ~canonical:(Url.tool_page page.slug) page)

let tutorial commit_hash req =
  let slug = Dream.param req "id" in
  let</>? tutorial = Data.Tutorial.get_by_slug slug in
  let all_tutorials = Data.Tutorial.all in

  let tutorials =
    all_tutorials
    |> List.filter (fun (t : Data.Tutorial.t) -> t.section = tutorial.section)
  in
  let all_exercises = Data.Exercise.all in
  let related_exercises =
    List.filter
      (fun (e : Data.Exercise.t) -> List.mem slug e.tutorials)
      all_exercises
  in

  let is_in_recommended_next (tested : Data.Tutorial.t) =
    List.exists (fun r -> r = tested.slug) tutorial.recommended_next_tutorials
  in

  let recommended_next_tutorials =
    all_tutorials |> List.filter is_in_recommended_next
  in

  let is_prerequisite (tested : Data.Tutorial.t) =
    List.exists (fun r -> r = tested.slug) tutorial.prerequisite_tutorials
  in

  let prerequisite_tutorials = all_tutorials |> List.filter is_prerequisite in

  Dream.html
    (Ocamlorg_frontend.tutorial commit_hash ~tutorials
       ~canonical:(Url.tutorial tutorial.slug)
       ~related_exercises ~recommended_next_tutorials ~prerequisite_tutorials
       tutorial)

let exercises req =
  let all_exercises = Data.Exercise.all in
  let difficulty_level = Dream.query req "difficulty_level" in
  let compare_difficulty = function
    | "beginner" -> ( = ) Data.Exercise.Beginner
    | "intermediate" -> ( = ) Data.Exercise.Intermediate
    | "advanced" -> ( = ) Data.Exercise.Advanced
    | _ -> Fun.const true
  in
  let by_difficulty level (exercise : Data.Exercise.t) =
    match level with
    | Some difficulty -> compare_difficulty difficulty exercise.difficulty
    | _ -> true
  in
  let filtered_exercises =
    List.filter (by_difficulty difficulty_level) all_exercises
  in
  Dream.html (Ocamlorg_frontend.exercises ?difficulty_level filtered_exercises)

let cookbook _req =
  let categories = Data.Cookbook.top_categories in
  Dream.html (Ocamlorg_frontend.cookbook categories)

let cookbook_task req =
  let task_slug = Dream.param req "task_slug" in
  let</>? task =
    List.find_opt
      (fun (t : Data.Cookbook.task) -> t.slug = task_slug)
      Data.Cookbook.tasks
  in
  let recipe_list = Data.Cookbook.get_by_task ~task_slug in
  Dream.html (Ocamlorg_frontend.cookbook_task task recipe_list)

let cookbook_recipe req =
  let task_slug = Dream.param req "task_slug" in
  let slug = Dream.param req "slug" in
  let</>? recipe = Data.Cookbook.get_by_slug ~task_slug slug in
  let other_recipes_for_this_task =
    Data.Cookbook.all
    |> List.filter (fun (c : Data.Cookbook.t) ->
           c.task.slug = recipe.task.slug && c.slug <> recipe.slug)
  in
  Dream.html
    (Ocamlorg_frontend.cookbook_recipe recipe other_recipes_for_this_task)

let outreachy _req = Dream.html (Ocamlorg_frontend.outreachy Data.Outreachy.all)

type package_kind = Package | Universe

module Package_helper = struct
  let package_info_to_frontend_package ~name ~version ?(on_latest_url = false)
      ?documentation_status ~latest_version ~versions info =
    let rev_deps =
      List.map
        (fun (name, _, _versions) -> Ocamlorg_package.Name.to_string name)
        info.Ocamlorg_package.Info.rev_deps
    in
    let owner name =
      Option.value
        (Data.Opam_user.find_by_name name)
        ~default:(Data.Opam_user.make ~name ())
    in
    Ocamlorg_frontend.Package.
      {
        name = Ocamlorg_package.Name.to_string name;
        version =
          (if on_latest_url then Latest
           else Specific (Ocamlorg_package.Version.to_string version));
        versions;
        latest_version =
          Option.value ~default:"???"
            (Option.map Ocamlorg_package.Version.to_string latest_version);
        synopsis = info.Ocamlorg_package.Info.synopsis;
        description =
          info.Ocamlorg_package.Info.description
          |> Cmarkit.Doc.of_string ~strict:true
          |> Cmarkit_html.of_doc ~safe:true;
        tags = info.tags;
        rev_deps;
        authors = List.map owner info.authors;
        maintainers = List.map owner info.maintainers;
        license = info.license;
        publication = info.publication;
        homepages = info.Ocamlorg_package.Info.homepage;
        source =
          Option.map
            (fun url ->
              (url.Ocamlorg_package.Info.uri, url.Ocamlorg_package.Info.checksum))
            info.Ocamlorg_package.Info.url;
        documentation_status =
          Option.value ~default:Unknown documentation_status;
      }

  (** Query all the versions of a package. *)
  let versions state name =
    Ocamlorg_package.get_versions state name
    |> List.map (fun (v : Ocamlorg_package.version_with_publication_date) ->
           Ocamlorg_frontend.Package.
             {
               version = Ocamlorg_package.Version.to_string v.version;
               publication = v.publication;
             })

  let search_index_digest ~kind state name =
    let open Lwt.Syntax in
    let* search_index_digest =
      Ocamlorg_package.search_index_digest ~kind state name
    in
    search_index_digest |> Option.map Dream.to_base64url |> Lwt.return

  let frontend_package ?on_latest_url ?documentation_status state
      (package : Ocamlorg_package.t) : Ocamlorg_frontend.Package.package =
    let name = Ocamlorg_package.name package
    and version = Ocamlorg_package.version package
    and info = Ocamlorg_package.info package in
    let versions = versions state name in
    let latest_version =
      Option.map
        (fun (p : Ocamlorg_package.t) -> Ocamlorg_package.version p)
        (Ocamlorg_package.get_latest state name)
    in
    package_info_to_frontend_package ~name ~version ?on_latest_url
      ?documentation_status ~latest_version ~versions info

  let of_name_version t name version =
    let package =
      if version = "latest" then Ocamlorg_package.get_latest t name
      else
        try
          Ocamlorg_package.get t name
            (Ocamlorg_package.Version.of_string version)
        with _ -> None
    in
    package
    |> Option.map (fun package ->
           ( package,
             frontend_package t package ~on_latest_url:(version = "latest") ))

  let package_sidebar_data ~kind t package =
    let open Lwt.Syntax in
    let* package_documentation_status =
      Ocamlorg_package.documentation_status ~kind t package
    in
    let readme_filename =
      Option.fold ~none:None
        ~some:(fun (s : Ocamlorg_package.Documentation_status.t) ->
          s.otherdocs.readme)
        package_documentation_status
    in
    let changes_filename =
      Option.fold ~none:None
        ~some:(fun (s : Ocamlorg_package.Documentation_status.t) ->
          s.otherdocs.changes)
        package_documentation_status
    in
    let license_filename =
      Option.fold ~none:None
        ~some:(fun (s : Ocamlorg_package.Documentation_status.t) ->
          s.otherdocs.license)
        package_documentation_status
    in
    let documentation_status =
      match package_documentation_status with
      | Some { failed = false; _ } -> Ocamlorg_frontend.Package.Success
      | Some { failed = true; _ } -> Failure
      | None -> Unknown
    in
    Lwt.return
      Ocamlorg_frontend.Package_overview.
        {
          documentation_status;
          readme_filename;
          changes_filename;
          license_filename;
        }

  let frontend_toc (xs : Ocamlorg_package.Documentation.toc list) :
      Ocamlorg_frontend.Toc.t =
    let rec aux acc = function
      | [] -> List.rev acc
      | Ocamlorg_package.Documentation.{ title; href; children } :: rest ->
          Ocamlorg_frontend.Toc.{ title; href; children = aux [] children }
          :: aux acc rest
    in
    aux [] xs
end

let is_ocaml_yet t id req =
  let</>? meta =
    List.find_opt
      (fun (x : Data.Is_ocaml_yet.t) -> x.id = id)
      Data.Is_ocaml_yet.all
  in
  let tutorials =
    Data.Tutorial.all
    |> List.filter (fun (t : Data.Tutorial.t) -> t.section = Guides)
  in
  let packages =
    meta.categories
    |> List.concat_map (fun (category : Data.Is_ocaml_yet.category) ->
           category.packages)
    |> List.filter_map (fun (p : Data.Is_ocaml_yet.package) ->
           let name = Ocamlorg_package.Name.of_string p.name in
           (* FIXME: Failure *)
           match Ocamlorg_package.get_latest t name with
           | Some x -> Some x
           | None ->
               if p.extern = None then
                 Dream.error (fun log ->
                     log ~request:req "Package not found: %s"
                       (Ocamlorg_package.Name.to_string name));
               None)
    |> List.map (Package_helper.frontend_package t)
    |> List.map (fun pkg -> (pkg.Ocamlorg_frontend.Package.name, pkg))
    |> List.to_seq |> Hashtbl.of_seq
  in
  Dream.html (Ocamlorg_frontend.is_ocaml_yet ~tutorials ~packages meta)

let packages state _req =
  let package { Ocamlorg_package.Statistics.name; version; info } =
    let versions = Package_helper.versions state name in
    let latest_version =
      Option.map
        (fun (p : Ocamlorg_package.t) -> Ocamlorg_package.version p)
        (Ocamlorg_package.get_latest state name)
    in
    Package_helper.package_info_to_frontend_package ~name ~version
      ~latest_version ~versions info
  in
  let package_pair (pkg, snd) = (package pkg, snd) in
  let stats =
    Ocamlorg_package.stats state
    |> Option.map (fun (t : Ocamlorg_package.Statistics.t) ->
           Ocamlorg_frontend.Package.
             {
               nb_packages = t.nb_packages;
               nb_update_week = t.nb_update_week;
               nb_packages_month = t.nb_packages_month;
               newest_packages = List.map package_pair t.newest_packages;
               recently_updated = List.map package t.recently_updated;
               most_revdeps = List.map package_pair t.most_revdeps;
             })
  in
  Dream.html (Ocamlorg_frontend.packages stats)

let is_author_match name pattern =
  let match_opt = function
    | Some s -> String.contains_s s pattern
    | None -> false
  in
  match Data.Opam_user.find_by_name name with
  | None -> String.contains_s name pattern
  | Some { name; email; github_username; _ } ->
      match_opt (Some name) || match_opt email || match_opt github_username

let documentation_status_of_package t (pkg : Ocamlorg_package.t) =
  let open Lwt.Syntax in
  let* package_documentation_status =
    Ocamlorg_package.documentation_status ~kind:`Package t pkg
  in
  Lwt.return
    (match package_documentation_status with
    | Some { failed = false; _ } -> Ocamlorg_frontend.Package.Success
    | Some { failed = true; _ } -> Failure
    | None -> Unknown)

let prepare_search_result_packages t packages =
  let open Lwt.Syntax in
  let* results =
    Lwt_list.map_p
      (fun pkg ->
        let+ documentation_status = documentation_status_of_package t pkg in
        Package_helper.frontend_package ~documentation_status t pkg)
      packages
  in
  Lwt.return results

let packages_search t req =
  let packages =
    match Dream.query req "q" with
    | Some search ->
        Ocamlorg_package.search ~is_author_match ~sort_by_popularity:true t
          search
    | None -> Ocamlorg_package.all_latest t
  in
  let total = List.length packages in

  let search =
    Dream.from_percent_encoded
      (match Dream.query req "q" with Some search -> search | None -> "")
  in

  let page_number, total_page_count, current_items =
    paginate ~req ~n:50 packages
  in
  let pagination_info =
    Ocamlorg_frontend.Pagination.
      {
        total_page_count;
        page_number;
        base_url = Url.packages_search;
        queries = [ ("q", search) ];
      }
  in

  let open Lwt.Syntax in
  let* results = prepare_search_result_packages t current_items in

  Dream.html
    (Ocamlorg_frontend.packages_search ~total ~search ~pagination_info results)

let packages_autocomplete_fragment t req =
  match Dream.query req "q" with
  | Some search when search <> "" ->
      let packages =
        Ocamlorg_package.search ~is_author_match ~sort_by_popularity:true t
          search
      in

      let open Lwt.Syntax in
      let* top_5 =
        packages |> List.take 5 |> prepare_search_result_packages t
      in

      let search = Dream.from_percent_encoded search in

      Dream.html
        (Ocamlorg_frontend.packages_autocomplete_fragment ~search
           ~total:(List.length packages) top_5)
  | _ -> Dream.html ""

let package_overview t kind req =
  let</>? name =
    Ocamlorg_package.Name.of_string_opt @@ Dream.param req "name"
  in
  let version_from_url = Dream.param req "version" in
  let</>? package, frontend_package =
    Package_helper.of_name_version t name version_from_url
  in
  let open Lwt.Syntax in
  let kind =
    match kind with
    | Package -> `Package
    | Universe -> `Universe (Dream.param req "hash")
  in
  let* sidebar_data = Package_helper.package_sidebar_data ~kind t package in

  let* search_index_digest =
    Package_helper.search_index_digest ~kind t package
  in

  let package_info = Ocamlorg_package.info package in
  let rev_dependencies =
    package_info.Ocamlorg_package.Info.rev_deps
    |> List.map (fun (name, x, version) ->
           Ocamlorg_frontend.Package_overview.
             {
               name = Ocamlorg_package.Name.to_string name;
               cstr = x;
               version = Some (Ocamlorg_package.Version.to_string version);
             })
  in
  let dependencies :
      Ocamlorg_frontend.Package_overview.dependency_or_conflict list =
    package_info.Ocamlorg_package.Info.dependencies
    |> List.map (fun (name, x) ->
           Ocamlorg_frontend.Package_overview.
             {
               name = Ocamlorg_package.Name.to_string name;
               cstr = x;
               version = None;
             })
  in
  let dev_dependencies, dependencies =
    dependencies
    |> List.partition
         (fun
           (item : Ocamlorg_frontend.Package_overview.dependency_or_conflict) ->
           let s = Option.value ~default:"" item.cstr in
           String.contains_s s "with-" || String.contains_s s "dev")
  in
  let conflicts =
    package_info.Ocamlorg_package.Info.conflicts
    |> List.map (fun (name, x) ->
           Ocamlorg_frontend.Package_overview.
             {
               name = Ocamlorg_package.Name.to_string name;
               cstr = x;
               version = None;
             })
  in
  let title_with_number title number =
    title ^ if number > 0 then " (" ^ string_of_int number ^ ")" else ""
  in
  let deps_and_conflicts :
      Ocamlorg_frontend.Package_overview.dependencies_and_conflicts list =
    [
      {
        title = title_with_number "Dependencies" (List.length dependencies);
        slug = "dependencies";
        items = dependencies;
        collapsible = false;
      };
      {
        title =
          title_with_number "Dev Dependencies" (List.length dev_dependencies);
        slug = "development-dependencies";
        items = dev_dependencies;
        collapsible = false;
      };
      {
        title = title_with_number "Used by" (List.length rev_dependencies);
        slug = "used-by";
        items = rev_dependencies;
        collapsible = true;
      };
      {
        title = title_with_number "Conflicts" (List.length conflicts);
        slug = "conflicts";
        items = conflicts;
        collapsible = false;
      };
    ]
  in
  let* readme =
    match sidebar_data.readme_filename with
    | Some path ->
        let* maybe_readme =
          Ocamlorg_package.file ~kind package (path ^ ".html")
        in
        Lwt.return
          (Option.map
             (fun (readme : Ocamlorg_package.Documentation.t) -> readme.content)
             maybe_readme)
    | None -> Lwt.return None
  in
  let toc =
    Ocamlorg_frontend.Toc.
      [ { title = "Description"; href = "#description"; children = [] } ]
    @ (match readme with
      | None -> []
      | Some _ ->
          [
            Ocamlorg_frontend.Toc.
              { title = "Readme"; href = "#readme"; children = [] };
          ])
    @ (deps_and_conflicts
      |> List.map
           (fun
             (section :
               Ocamlorg_frontend.Package_overview.dependencies_and_conflicts)
           ->
             Ocamlorg_frontend.Toc.
               {
                 title = section.title;
                 href = "#" ^ section.slug;
                 children = [];
               }))
  in
  Dream.html
    (Ocamlorg_frontend.package_overview ~sidebar_data ~readme
       ~search_index_digest ~toc ~deps_and_conflicts frontend_package)

let package_versions t _kind req =
  let</>? name =
    Ocamlorg_package.Name.of_string_opt @@ Dream.param req "name"
  in
  let version_from_url = Dream.param req "version" in
  let</>? _package, frontend_package =
    Package_helper.of_name_version t name version_from_url
  in
  Dream.html (Ocamlorg_frontend.package_versions frontend_package)

let package_documentation t kind req =
  let</>? name =
    Ocamlorg_package.Name.of_string_opt @@ Dream.param req "name"
  in
  let version_from_url = Dream.param req "version" in
  let</>? package, frontend_package =
    Package_helper.of_name_version t name version_from_url
  in
  let open Lwt.Syntax in
  let kind =
    match kind with
    | Package -> `Package
    | Universe -> `Universe (Dream.param req "hash")
  in
  let path = (Dream.path [@ocaml.warning "-3"]) req |> String.concat "/" in
  let hash = match kind with `Package -> None | `Universe u -> Some u in
  let root =
    Url.Package.documentation ?hash ~page:""
      ?version:(Ocamlorg_frontend.Package.url_version frontend_package)
      (Ocamlorg_package.Name.to_string name)
  in
  let* docs = Ocamlorg_package.documentation_page ~kind package path in
  match docs with
  | None ->
      let response_404_page =
        Dream.html ~code:404
          (Ocamlorg_frontend.package_documentation_not_found ~page:path
             ~search_index_digest:None
             ~path:(Ocamlorg_frontend.Package_breadcrumbs.Documentation Index)
             frontend_package)
      in
      if version_from_url = "latest" then
        let* latest_documented_version =
          Ocamlorg_package.latest_documented_version t name
        in
        match latest_documented_version with
        | None -> response_404_page
        | Some version ->
            Dream.redirect req ~code:302
              (Url.Package.documentation ?hash
                 ~version:(Ocamlorg_package.Version.to_string version)
                 ~page:path
                 (Ocamlorg_package.Name.to_string name))
      else response_404_page
  | Some doc ->
      let module Package_info = Ocamlorg_package.Package_info in
      let rec toc_of_module ~root
          (module' : Ocamlorg_package.Package_info.Module.t) :
          Ocamlorg_frontend.Navmap.toc =
        let title = Package_info.Module.name module' in
        let kind = Package_info.Module.kind module' in
        let href = Some (root ^ Package_info.Module.path module') in
        let children =
          module' |> Package_info.Module.submodules |> String.Map.bindings
          |> List.map (fun (_, module') -> toc_of_module ~root module')
        in
        let kind =
          match (kind : Package_info.Kind.t) with
          | Page -> Ocamlorg_frontend.Navmap.Page
          | Module -> Module
          | LeafPage -> Leaf_page
          | ModuleType -> Module_type
          | Parameter _ -> Parameter
          | Class -> Class
          | ClassType -> Class_type
          | File -> File
        in
        Ocamlorg_frontend.Navmap.{ title; href; kind; children }
      in
      let toc_of_map ~root (map : Ocamlorg_package.Package_info.t) :
          Ocamlorg_frontend.Navmap.t =
        let libraries = map.libraries in
        String.Map.bindings libraries
        |> List.map (fun (_, (library : Package_info.library)) ->
               let title = library.name in
               let href = None in
               let children =
                 String.Map.bindings library.modules
                 |> List.map (fun (_, module') -> toc_of_module ~root module')
               in
               Ocamlorg_frontend.Navmap.
                 { title; href; kind = Library; children })
      in
      let* module_map = Ocamlorg_package.module_map ~kind package in
      let* search_index_digest =
        Package_helper.search_index_digest ~kind t package
      in
      let toc = Package_helper.frontend_toc doc.toc in
      let (maptoc : Ocamlorg_frontend.Navmap.toc list) =
        toc_of_map ~root module_map
      in
      let (breadcrumb_path : Ocamlorg_frontend.Package_breadcrumbs.path) =
        let breadcrumbs = doc.breadcrumbs in
        if breadcrumbs != [] then
          let first_path_item = List.hd breadcrumbs in
          let doc_breadcrumb_to_library_path_item
              (p : Ocamlorg_package.Documentation.breadcrumb) =
            match p.kind with
            | Module ->
                Ocamlorg_frontend.Package_breadcrumbs.Module
                  { name = p.name; href = p.href }
            | ModuleType -> ModuleType { name = p.name; href = p.href }
            | Parameter i ->
                Parameter { name = p.name; href = p.href; number = i }
            | Class -> Class { name = p.name; href = p.href }
            | ClassType -> ClassType { name = p.name; href = p.href }
            | Page | LeafPage | File ->
                failwith "library paths do not contain Page, LeafPage or File"
          in

          match first_path_item.kind with
          | Page | LeafPage | File ->
              Ocamlorg_frontend.Package_breadcrumbs.Documentation
                (Page first_path_item.name)
          | Module | ModuleType | Parameter _ | Class | ClassType ->
              let library =
                List.find_opt
                  (fun (toc : Ocamlorg_frontend.Navmap.toc) ->
                    List.exists
                      (fun (t : Ocamlorg_frontend.Navmap.toc) ->
                        t.title = first_path_item.name)
                      toc.children)
                  maptoc
              in

              Ocamlorg_frontend.Package_breadcrumbs.Documentation
                (Library
                   ( (match library with Some l -> l.title | None -> "unknown"),
                     List.map doc_breadcrumb_to_library_path_item breadcrumbs ))
        else Ocamlorg_frontend.Package_breadcrumbs.Documentation Index
      in
      Dream.html
        (Ocamlorg_frontend.package_documentation ~page:(Some path)
           ~search_index_digest ~path:breadcrumb_path ~toc ~maptoc
           ~content:doc.content frontend_package)

let package_file t kind req =
  let</>? name =
    Ocamlorg_package.Name.of_string_opt @@ Dream.param req "name"
  in
  let version_from_url = Dream.param req "version" in
  let</>? package, frontend_package =
    Package_helper.of_name_version t name version_from_url
  in
  let open Lwt.Syntax in
  let kind =
    match kind with
    | Package -> `Package
    | Universe -> `Universe (Dream.param req "hash")
  in
  let path = (Dream.path [@ocaml.warning "-3"]) req |> String.concat "/" in
  let* sidebar_data = Package_helper.package_sidebar_data ~kind t package in
  let* search_index_digest =
    Package_helper.search_index_digest ~kind t package
  in
  let* maybe_doc = Ocamlorg_package.file ~kind package path in
  let</>? doc = maybe_doc in
  let content = doc.content in
  let toc = Package_helper.frontend_toc doc.toc in
  Dream.html
    (Ocamlorg_frontend.package_overview_file ~sidebar_data ~content
       ~search_index_digest ~content_title:path ~toc frontend_package)

let package_search_index t kind req =
  let</>? name =
    Ocamlorg_package.Name.of_string_opt @@ Dream.param req "name"
  in
  let version_from_url = Dream.param req "version" in
  let</>? package, _ = Package_helper.of_name_version t name version_from_url in
  let open Lwt.Syntax in
  let kind =
    match kind with
    | Package -> `Package
    | Universe -> `Universe (Dream.param req "hash")
  in
  let* maybe_search_index = Ocamlorg_package.search_index ~kind package in
  let</>? search_index = maybe_search_index in
  Lwt.return
    (Dream.response
       ~headers:
         [
           ("Content-type", "application/javascript");
           ("Cache-Control", "max-age=31536000, immutable");
         ]
       search_index)

let sitemap _request =
  let open Lwt.Syntax in
  Dream.stream
    ~headers:[ ("Content-Type", "application/xml; charset=utf-8") ]
    (fun stream ->
      let* _ = Lwt_seq.iter_s (Dream.write stream) Sitemap.data in
      Dream.flush stream)

let logos _req = Dream.html (Ocamlorg_frontend.logos ())

let v2_asset req =
  let</>? path =
    try Some (Config.v2_path ^ Dream.target req) with _ -> None
  in
  let</>? () = if Sys.file_exists path then Some () else None in
  Filename.(Dream.from_filesystem (dirname path) (basename path) req)
