open Ocamlorg

let fwd_v2 target = (target, Url.v2 ^ target)

(* For assets previously hosted on V2, we redirect the requests to
   v2.ocaml.org. *)
let v2_assets =
  [
    "/meetings/ocaml/2013/proposals/core-bench.pdf";
    "/meetings/ocaml/2013/proposals/ctypes.pdf";
    "/meetings/ocaml/2013/proposals/formats-as-gadts.pdf";
    "/meetings/ocaml/2013/proposals/frenetic.pdf";
    "/meetings/ocaml/2013/proposals/goji.pdf";
    "/meetings/ocaml/2013/proposals/gpgpu.pdf";
    "/meetings/ocaml/2013/proposals/injectivity.pdf";
    "/meetings/ocaml/2013/proposals/merlin.pdf";
    "/meetings/ocaml/2013/proposals/ocamlot.pdf";
    "/meetings/ocaml/2013/proposals/optimizations.pdf";
    "/meetings/ocaml/2013/proposals/platform.pdf";
    "/meetings/ocaml/2013/proposals/profiling-memory.pdf";
    "/meetings/ocaml/2013/proposals/runtime-types.pdf";
    "/meetings/ocaml/2013/proposals/weather-related-data.pdf";
    "/meetings/ocaml/2013/proposals/wxocaml.pdf";
    "/meetings/ocaml/2013/slides/bourgoin.pdf";
    "/meetings/ocaml/2013/slides/bozman.pdf";
    "/meetings/ocaml/2013/slides/canou.pdf";
    "/meetings/ocaml/2013/slides/carty.pdf";
    "/meetings/ocaml/2013/slides/chambart.pdf";
    "/meetings/ocaml/2013/slides/garrigue.pdf";
    "/meetings/ocaml/2013/slides/guha.pdf";
    "/meetings/ocaml/2013/slides/henry.pdf";
    "/meetings/ocaml/2013/slides/james.pdf";
    "/meetings/ocaml/2013/slides/lefessant.pdf";
    "/meetings/ocaml/2013/slides/leroy.pdf";
    "/meetings/ocaml/2013/slides/madhavapeddy.pdf";
    "/meetings/ocaml/2013/slides/padioleau.pdf";
    "/meetings/ocaml/2013/slides/sheets.pdf";
    "/meetings/ocaml/2013/slides/vaugon.pdf";
    "/meetings/ocaml/2013/slides/white.pdf";
  ]

let from_v2 =
  [
    ("/about.fr.html", Url.about);
    ("/about.html", Url.about);
    ("/caml-light/faq.html", Url.index);
    ("/caml-light/index.html", Url.index);
    ("/caml-light", Url.index);
    ("/caml-light/license.html", Url.index);
    ("/caml-light/releases/0.75.html", Url.index);
    ("/community/announcements/CompCert_award.html", Url.community);
    ("/community/cwn/index.html", Url.community);
    ("/community/cwn", Url.community);
    ("/community/history/forge.html", Url.community);
    ("/community/index.fr.html", Url.community);
    ("/community/index.html", Url.community);
    ("/community/mailing_lists.fr.html", Url.community);
    ("/community/mailing_lists.html", Url.community);
    ("/community/media.html", Url.community);
    ("/community/planet.html", Url.ocaml_planet);
    ("/community/planet/index.html", Url.ocaml_planet);
    ("/community/planet", Url.ocaml_planet);
    ("/community/planet/older.html", Url.ocaml_planet);
    ("/community/planet/syndication.html", Url.ocaml_planet);
    ("/community/support.fr.html", Url.community);
    ("/community/support.html", Url.community);
    ("/consortium/index.fr.html", Url.index);
    ("/consortium/index.html", Url.index);
    ("/consortium", Url.index);
    ("/contributors.fr.html", Url.index);
    ("/contributors.html", Url.index);
    ("/docs/cheat_sheets.html", Url.learn);
    ("/docs/consortium-license.html", Url.index);
    ("/docs/index.fr.html", Url.learn);
    ("/docs/index.html", Url.learn);
    ("/docs/up-and-running", Url.getting_started);
    ("/docs/install.fr.html", Url.getting_started);
    ("/docs/install.html", Url.getting_started);
    ("/docs/license.fr.html", Url.index);
    ("/docs/license.html", Url.index);
    ("/docs/logos.html", Url.index);
    ("/docs/papers.html", Url.papers);
    ("/governance.html", Url.governance);
    ("/index.fr.html", Url.index);
    ("/index.html", Url.index);
    ("/learn/books.html", Url.books);
    ("/learn/companies.html", Url.industrial_users);
    ("/learn/description.html", Url.about);
    ("/learn/faq.html", Url.learn);
    ("/learn/history.fr.html", Url.about);
    ("/learn/history.html", Url.about);
    ("/learn/index.fr.html", Url.learn);
    ("/learn/index.html", Url.learn);
    ("/learn", Url.learn);
    ("/learn/libraries.html", Url.packages);
    ("/learn/portability.html", Url.learn);
    ("/learn/success.fr.html", Url.industrial_users);
    ("/learn/success.html", Url.industrial_users);
    ("/learn/taste.fr.html", Url.learn);
    ("/learn/taste.html", Url.learn);
    ("/learn/teaching-ocaml.html", Url.academic_users);
    ("/learn/tutorials/99problems.html", Url.exercises);
    ( "/learn/tutorials/a_first_hour_with_ocaml.html",
      Url.tutorial "tour-of-ocaml" );
    ( "/learn/tutorials/calling_c_libraries.html",
      Url.tutorial "calling-c-libraries" );
    ( "/learn/tutorials/calling_fortran_libraries.html",
      Url.tutorial "calling-fortran-libraries" );
    ("/learn/tutorials/camlp5.html", Url.learn);
    ( "/learn/tutorials/command-line_arguments.ja.html",
      Url.tutorial "cli-arguments" );
    ( "/learn/tutorials/command-line_arguments.html",
      Url.tutorial "cli-arguments" );
    ( "/learn/tutorials/command-line_arguments.zh.html",
      Url.tutorial "cli-arguments" );
    ( "/learn/tutorials/common_error_messages.fr.html",
      Url.tutorial "common-errors" );
    ( "/learn/tutorials/common_error_messages.ja.html",
      Url.tutorial "common-errors" );
    ("/learn/tutorials/common_error_messages.html", Url.tutorial "common-errors");
    ( "/learn/tutorials/common_error_messages.zh.html",
      Url.tutorial "common-errors" );
    ( "/learn/tutorials/comparison_of_standard_containers.ja.html",
      Url.tutorial "data-structures-comparison" );
    ( "/learn/tutorials/comparison_of_standard_containers.ko.html",
      Url.tutorial "data-structures-comparison" );
    ( "/learn/tutorials/comparison_of_standard_containers.html",
      Url.tutorial "data-structures-comparison" );
    ( "/learn/tutorials/comparison_of_standard_containers.zh.html",
      Url.tutorial "data-structures-comparison" );
    ( "/learn/tutorials/compiling_ocaml_projects.ja.html",
      Url.tutorial "using-the-ocaml-compiler-toolchain" );
    ( Url.tutorial "compiling-ocaml-projects",
      Url.tutorial "using-the-ocaml-compiler-toolchain" );
    ( "/learn/tutorials/compiling_ocaml_projects.html",
      Url.tutorial "using-the-ocaml-compiler-toolchain" );
    ( "/learn/tutorials/data_types_and_matching.fr.html",
      Url.tutorial "basic-data-types" );
    ( "/learn/tutorials/data_types_and_matching.it.html",
      Url.tutorial "basic-data-types" );
    ( "/learn/tutorials/data_types_and_matching.ja.html",
      Url.tutorial "basic-data-types" );
    ( "/learn/tutorials/data_types_and_matching.html",
      Url.tutorial "basic-data-types" );
    ( "/learn/tutorials/data_types_and_matching.zh.html",
      Url.tutorial "basic-data-types" );
    (Url.tutorial "data-types", Url.tutorial "basic-data-types");
    ("/learn/tutorials/debug.html", Url.tutorial "debugging");
    ("/learn/tutorials/error_handling.html", Url.tutorial "error-handling");
    ( "/learn/tutorials/file_manipulation.ja.html",
      Url.tutorial "file-manipulation" );
    ("/learn/tutorials/file_manipulation.html", Url.tutorial "file-manipulation");
    ( "/learn/tutorials/file_manipulation.zh.html",
      Url.tutorial "file-manipulation" );
    ("/learn/tutorials/format.fr.html", Url.tutorial "formatting-text");
    ("/learn/tutorials/format.html", Url.tutorial "formatting-text");
    (* FIXME: uncomment when higher-order-functions is merged (
       "/learn/tutorials/functional_programming.fr.html", Url.tutorial
       "higher-order-functions" ); (
       "/learn/tutorials/functional_programming.it.html", Url.tutorial
       "higher-order-functions" ); (
       "/learn/tutorials/functional_programming.ja.html", Url.tutorial
       "higher-order-functions" ); (
       "/learn/tutorials/functional_programming.html", Url.tutorial
       "higher-order-functions" ); (
       "/learn/tutorials/functional_programming.zh.html", Url.tutorial
       "higher-order-functions" ); *)
    ("/learn/tutorials/functors.html", Url.tutorial "functors");
    ( "/learn/tutorials/garbage_collection.ja.html",
      Url.tutorial "garbage-collection" );
    ( "/learn/tutorials/garbage_collection.html",
      Url.tutorial "garbage-collection" );
    ( "/learn/tutorials/garbage_collection.zh.html",
      Url.tutorial "garbage-collection" );
    ("/learn/tutorials/guidelines.html", Url.tutorial "guidelines");
    ("/learn/tutorials/hashtbl.ja.html", Url.tutorial "hash-tables");
    ("/learn/tutorials/hashtbl.html", Url.tutorial "hash-tables");
    ("/learn/tutorials/hashtbl.zh.html", Url.tutorial "hash-tables");
    ("/learn/tutorials/humor_proof.html", Url.learn);
    ( "/learn/tutorials/if_statements_loops_and_recursion.fr.html",
      Url.tutorial "loops-recursion" );
    ( "/learn/tutorials/if_statements_loops_and_recursion.it.html",
      Url.tutorial "loops-recursion" );
    ( "/learn/tutorials/if_statements_loops_and_recursion.ja.html",
      Url.tutorial "loops-recursion" );
    ( "/learn/tutorials/if_statements_loops_and_recursion.ko.html",
      Url.tutorial "loops-recursion" );
    ( "/learn/tutorials/if_statements_loops_and_recursion.html",
      Url.tutorial "loops-recursion" );
    ( "/learn/tutorials/if_statements_loops_and_recursion.zh.html",
      Url.tutorial "loops-recursion" );
    ( "/learn/tutorials/mutability-loops-and-imperative",
      Url.tutorial "mutability-imperative-control-flow" );
    ("/learn/tutorials/index.de.html", Url.learn);
    ("/learn/tutorials/index.fr.html", Url.learn);
    ("/learn/tutorials/index.it.html", Url.learn);
    ("/learn/tutorials/index.ja.html", Url.learn);
    ("/learn/tutorials/index.ko.html", Url.learn);
    ("/learn/tutorials/index.html", Url.learn);
    ("/learn/tutorials", Url.learn);
    ("/learn/tutorials/index.zh.html", Url.learn);
    ("/learn/tutorials/introduction_to_gtk.html", Url.learn);
    ("/learn/tutorials/labels.ja.html", Url.tutorial "labels");
    ("/learn/tutorials/labels.html", Url.tutorial "labels");
    ("/learn/tutorials/labels.zh.html", Url.tutorial "labels");
    ("/learn/tutorials/lists.html", Url.tutorial "lists");
    ("/learn/tutorials/map.fr.html", Url.tutorial "map");
    ("/learn/tutorials/map.ja.html", Url.tutorial "map");
    ("/learn/tutorials/map.html", Url.tutorial "map");
    ("/learn/tutorials/map.zh.html", Url.tutorial "map");
    ("/learn/tutorials/modules.fr.html", Url.tutorial "modules");
    ("/learn/tutorials/modules.ja.html", Url.tutorial "modules");
    ("/learn/tutorials/modules.ko.html", Url.tutorial "modules");
    ("/learn/tutorials/modules.html", Url.tutorial "modules");
    ("/learn/tutorials/modules.zh.html", Url.tutorial "modules");
    ("/learn/tutorials/objects.ja.html", Url.tutorial "objects");
    ("/learn/tutorials/objects.html", Url.tutorial "objects");
    ("/learn/tutorials/objects.zh.html", Url.tutorial "objects");
    ( "/learn/tutorials/performance_and_profiling.ja.html",
      Url.tutorial "profiling" );
    ("/learn/tutorials/performance_and_profiling.html", Url.tutorial "profiling");
    ( "/learn/tutorials/performance_and_profiling_discussion.html",
      Url.tutorial "profiling" );
    ("/learn/tutorials/set.fr.html", Url.tutorial "sets");
    ("/learn/tutorials/set.ja.html", Url.tutorial "sets");
    ("/learn/tutorials/set.html", Url.tutorial "sets");
    ("/learn/tutorials/set.zh.html", Url.tutorial "sets");
    ("/learn/tutorials/streams.html", Url.tutorial "sequences");
    ("/learn/tutorials/up_and_running.html", Url.tutorial "up-and-running");
    (Url.tutorial "first-hour", Url.tutorial "tour-of-ocaml");
    ("/meetings/index.fr.html", Url.community);
    ("/meetings/index.html", Url.community);
    ("/meetings", Url.community);
    ( "/meetings/ocaml/2008/index.html",
      Url.conference "ocaml-users-and-developers-conference-2008" );
    ( "/meetings/ocaml/2008",
      Url.conference "ocaml-users-and-developers-conference-2008" );
    ( "/meetings/ocaml/2008/index.html",
      Url.conference "ocaml-users-and-developers-conference-2008" );
    ( "/meetings/ocaml/2008",
      Url.conference "ocaml-users-and-developers-conference-2008" );
    ( "/meetings/ocaml/2009/index.html",
      Url.conference "ocaml-users-and-developers-conference-2009" );
    ( "/meetings/ocaml/2009",
      Url.conference "ocaml-users-and-developers-conference-2009" );
    ( "/meetings/ocaml/2010/index.html",
      Url.conference "ocaml-users-and-developers-conference-2010" );
    ( "/meetings/ocaml/2010",
      Url.conference "ocaml-users-and-developers-conference-2010" );
    ( "/meetings/ocaml/2011/index.html",
      Url.conference "ocaml-users-and-developers-conference-2011" );
    ( "/meetings/ocaml/2011",
      Url.conference "ocaml-users-and-developers-conference-2011" );
    ( "/meetings/ocaml/2012/index.html",
      Url.conference "ocaml-users-and-developers-conference-2012" );
    ( "/meetings/ocaml/2013/call.html",
      Url.conference "ocaml-users-and-developers-conference-2013" );
    ( "/meetings/ocaml/2013",
      Url.conference "ocaml-users-and-developers-conference-2013" );
    ( "/meetings/ocaml/2013/index.html",
      Url.conference "ocaml-users-and-developers-conference-2013" );
    ( "/meetings/ocaml/2013/program.html",
      Url.conference "ocaml-users-and-developers-conference-2013" );
    ( "/meetings/ocaml/2013",
      Url.conference "ocaml-users-and-developers-conference-2013" );
    ( "/meetings/ocaml/2013/talks/index.html",
      Url.conference "ocaml-users-and-developers-conference-2013" );
    ( "/meetings/ocaml/2014/cfp.html",
      Url.conference "ocaml-users-and-developers-conference-2014" );
    ( "/meetings/ocaml/2014",
      Url.conference "ocaml-users-and-developers-conference-2014" );
    ( "/meetings/ocaml/2014/index.html",
      Url.conference "ocaml-users-and-developers-conference-2014" );
    ( "/meetings/ocaml/2014/ocaml2014_10.html",
      Url.conference "ocaml-users-and-developers-conference-2014" );
    ( "/meetings/ocaml/2014/program.html",
      Url.conference "ocaml-users-and-developers-conference-2014" );
    ( "/meetings/ocaml/2015/cfp.html",
      Url.conference "ocaml-users-and-developers-conference-2015" );
    ( "/meetings/ocaml/2015",
      Url.conference "ocaml-users-and-developers-conference-2015" );
    ( "/meetings/ocaml/2015/index.html",
      Url.conference "ocaml-users-and-developers-conference-2015" );
    ( "/meetings/ocaml/2015",
      Url.conference "ocaml-users-and-developers-conference-2015" );
    ( "/meetings/ocaml/2015/program.html",
      Url.conference "ocaml-users-and-developers-conference-2015" );
    ( "/meetings/ocaml/2015",
      Url.conference "ocaml-users-and-developers-conference-2015" );
    ( "/meetings/ocaml/2015/program.txt",
      Url.conference "ocaml-users-and-developers-conference-2015" );
    ( "/meetings/ocaml/2015",
      Url.conference "ocaml-users-and-developers-conference-2015" );
    ( "/meetings/ocaml/2016/index.html",
      Url.conference "ocaml-users-and-developers-conference-2016" );
    ( "/meetings/ocaml/2016",
      Url.conference "ocaml-users-and-developers-conference-2016" );
    ( "/meetings/ocaml/2017/index.html",
      Url.conference "ocaml-users-and-developers-conference-2017" );
    ( "/meetings/ocaml/2017",
      Url.conference "ocaml-users-and-developers-conference-2017" );
    ( "/meetings/ocaml/2018/index.html",
      Url.conference "ocaml-users-and-developers-conference-2018" );
    ( "/meetings/ocaml/2018",
      Url.conference "ocaml-users-and-developers-conference-2018" );
    ( "/meetings/ocaml/2019/index.html",
      Url.conference "ocaml-users-and-developers-conference-2019" );
    ( "/meetings/ocaml/2019",
      Url.conference "ocaml-users-and-developers-conference-2019" );
    ( "/meetings/ocaml/2020/index.html",
      Url.conference "ocaml-users-and-developers-conference-2020" );
    ( "/meetings/ocaml/2020",
      Url.conference "ocaml-users-and-developers-conference-2020" );
    ("/meetings/ocaml/index.html", Url.community);
    ("/meetings/ocaml", Url.community);
    ("/ocamllabs/index.html", Url.index);
    ("/ocamllabs", Url.index);
    ("/platform/index.html", Url.learn_platform);
    ("/platform/ocaml_on_windows.html", "/docs/ocaml-on-windows");
    ("/releases/caml-light/faq.html", Url.index);
    ("/releases/caml-light/index.html", Url.index);
    ("/releases/caml-light", Url.index);
    ("/releases/caml-light/license.html", Url.index);
    ("/releases/caml-light/releases/0.75.html", Url.index);
    ("/releases/index.fr.html", Url.releases);
    ("/docs/platform", Url.platform);
    ("/docs/platform-principles", Url.tool_page "platform-principles");
    ("/docs/platform-users", Url.tool_page "platform-users");
    ("/docs/platform-roadmap", Url.tool_page "platform-roadmap");
    ("/success-stories/peta-byte-scale-web-crawler", Url.success_story "marketing-analysis-tools-powered-by-big-data");
  ]

let make ?(permanent = false) t =
  let status = if permanent then `Moved_Permanently else `See_Other in
  Dream.scope ""
    [ Dream_encoding.compress ]
    (List.filter_map
       (fun (origin, new_) ->
         if origin = new_ then None
         else
           Some (Dream.get origin (fun req -> Dream.redirect ~status req new_)))
       t)

let ocaml_workshops =
  List.map
    (fun (slug : string) ->
      make ~permanent:true [ ("/workshop/" ^ slug, Url.conference slug) ])
    [
      "ocaml-users-and-developers-conference-2008";
      "ocaml-users-and-developers-conference-2009";
      "ocaml-users-and-developers-conference-2010";
      "ocaml-users-and-developers-conference-2011";
      "ocaml-users-and-developers-conference-2012";
      "ocaml-users-and-developers-conference-2013";
      "ocaml-users-and-developers-conference-2014";
      "ocaml-users-and-developers-conference-2015";
      "ocaml-users-and-developers-conference-2016";
      "ocaml-users-and-developers-conference-2017";
      "ocaml-users-and-developers-conference-2018";
      "ocaml-users-and-developers-conference-2019";
      "ocaml-users-and-developers-conference-2020";
      "ocaml-users-and-developers-conference-2020";
      "ocaml-users-and-developers-conference-2021";
      "ocaml-users-and-developers-conference-2022";
      "ocaml-users-and-developers-conference-2023";
    ]

let package req =
  let package = Dream.param req "name" in
  Dream.redirect req (Url.Package.overview package)

let package_docs req =
  let package = Dream.param req "name" in
  Dream.redirect req (Url.Package.documentation package)

let t =
  Dream.scope "" []
    ([
       make ~permanent:true [ ("feed.xml", "planet.xml") ];
       make from_v2;
       make (List.map fwd_v2 v2_assets);
       make [ ("/blog", "/ocaml-planet") ];
       make ~permanent:true [ ("/opportunities", "/jobs") ];
       make ~permanent:true
         [ ("/carbon-footprint", "/policies/carbon-footprint") ];
       make ~permanent:true [ ("/privacy-policy", "/policies/privacy-policy") ];
       make ~permanent:true
         [ ("/code-of-conduct", "/policies/code-of-conduct") ];
       make ~permanent:true [ ("/opportunities", "/jobs") ];
       (* make ~permanent:false [ (Url.conferences, Url.community ^
          "#conferences") ]; *)
       Dream.get "/p/:name" package;
       Dream.get "/u/:hash/p/:name" package;
       Dream.get "/p/:name/doc" package_docs;
     ]
    @ ocaml_workshops)
