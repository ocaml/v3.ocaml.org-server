open Ocamlorg

type package_dep =
  { name : string
  ; constraints : string option
  }

type packages_result =
  { total_packages : int
  ; packages : Package.t list
  }

let starts_with s1 s2 =
  let len1 = String.length s1 in
  if len1 > String.length s2 then
    false
  else
    let s1 = String.lowercase_ascii s1 in
    let s2 = String.lowercase_ascii s2 in
    String.(equal (sub s2 0 (length s1)) s1)

let is_package s1 s2 =
  let len1 = String.length s1 in
  if len1 <> String.length s2 then
    false
  else
    let s1 = String.lowercase_ascii s1 in
    let s2 = String.lowercase_ascii s2 in
    String.(equal s2 s1)

let get_packages_result total_packages offset limit filter packages =
  if filter = "sortByName" then
    let packages =
      List.filteri (fun i _ -> offset <= i && i <= offset + limit) packages
    in
    let packages_result = { total_packages; packages } in
    packages_result
  else
    let packages =
      List.filter
        (fun package ->
          starts_with filter (Package.Name.to_string (Package.name package)))
        packages
    in
    let packages_result = { total_packages; packages } in
    packages_result

let get_deps deps =
  let pkg =
    List.map
      (fun (name, constraints) ->
        { name = Package.Name.to_string name; constraints })
      deps
  in
  pkg

let deps =
  Graphql_lwt.Schema.(
    obj "deps" ~fields:(fun _ ->
        [ field
            "name"
            ~doc:"Unique dependency name"
            ~args:Arg.[]
            ~typ:(non_null string)
            ~resolve:(fun _ p -> p.name)
        ; field
            "constraints"
            ~doc:"Dependency constraints"
            ~args:Arg.[]
            ~typ:string
            ~resolve:(fun _ p -> p.constraints)
        ]))

let owners =
  Graphql_lwt.Schema.(
    obj "owners" ~fields:(fun _ ->
        [ field
            "name"
            ~doc:"Owner's name"
            ~args:Arg.[]
            ~typ:(non_null string)
            ~resolve:(fun _ user -> user.Opam_user.name)
        ; field
            "handle"
            ~doc:"Owner's handle"
            ~args:Arg.[]
            ~typ:string
            ~resolve:(fun _ user -> user.Opam_user.handle)
        ; field
            "image"
            ~doc:"Owner's image"
            ~args:Arg.[]
            ~typ:string
            ~resolve:(fun _ user -> user.Opam_user.image)
        ]))

let url =
  Graphql_lwt.Schema.(
    obj "url" ~fields:(fun _ ->
        [ field
            "uri"
            ~doc:"Package URI"
            ~args:Arg.[]
            ~typ:(non_null string)
            ~resolve:(fun _ p -> p.Package.Info.uri)
        ; field
            "checksum"
            ~doc:"Package checksum"
            ~args:Arg.[]
            ~typ:(non_null (list (non_null string)))
            ~resolve:(fun _ p -> p.Package.Info.checksum)
        ]))

let package =
  Graphql_lwt.Schema.(
    obj "package" ~fields:(fun _ ->
        [ field
            "name"
            ~doc:"Unique package name"
            ~args:Arg.[]
            ~typ:(non_null string)
            ~resolve:(fun _ p -> Package.Name.to_string (Package.name p))
        ; field
            "version"
            ~doc:"Package latest release version"
            ~args:Arg.[]
            ~typ:(non_null string)
            ~resolve:(fun _ p -> Package.Version.to_string (Package.version p))
        ; field
            "synopsis"
            ~doc:"The synopsis of the package"
            ~args:Arg.[]
            ~typ:(non_null string)
            ~resolve:(fun _ p ->
              let info = Package.info p in
              info.Package.Info.synopsis)
        ; field
            "description"
            ~doc:"The description of the package"
            ~args:Arg.[]
            ~typ:(non_null string)
            ~resolve:(fun _ p ->
              let info = Package.info p in
              info.Package.Info.description)
        ; field
            "license"
            ~doc:"The license of the package"
            ~args:Arg.[]
            ~typ:(non_null string)
            ~resolve:(fun _ p ->
              let info = Package.info p in
              info.Package.Info.license)
        ; field
            "homepage"
            ~doc:"The homepage of the package"
            ~args:Arg.[]
            ~typ:(non_null (list (non_null string)))
            ~resolve:(fun _ p ->
              let info = Package.info p in
              info.Package.Info.homepage)
        ; field
            "tags"
            ~doc:"The tags of the package"
            ~args:Arg.[]
            ~typ:(non_null (list (non_null string)))
            ~resolve:(fun _ p ->
              let info = Package.info p in
              info.Package.Info.tags)
        ; field
            "authors"
            ~doc:"The authors of the package"
            ~args:Arg.[]
            ~typ:(non_null (list (non_null owners)))
            ~resolve:(fun _ p ->
              let info = Package.info p in
              info.Package.Info.authors)
        ; field
            "maintainers"
            ~doc:"The maintainers of the package"
            ~args:Arg.[]
            ~typ:(non_null (list (non_null owners)))
            ~resolve:(fun _ p ->
              let info = Package.info p in
              info.Package.Info.maintainers)
        ; field
            "dependencies"
            ~doc:"The dependencies of the package"
            ~args:Arg.[]
            ~typ:(non_null (list (non_null deps)))
            ~resolve:(fun _ p ->
              let info = Package.info p in
              get_deps info.Package.Info.dependencies)
        ; field
            "depopts"
            ~doc:"The depopts of the package"
            ~args:Arg.[]
            ~typ:(non_null (list (non_null deps)))
            ~resolve:(fun _ p ->
              let info = Package.info p in
              get_deps info.Package.Info.depopts)
        ; field
            "conflicts"
            ~doc:"The conflicts of the package"
            ~args:Arg.[]
            ~typ:(non_null (list (non_null deps)))
            ~resolve:(fun _ p ->
              let info = Package.info p in
              get_deps info.Package.Info.conflicts)
        ; field
            "url"
            ~doc:"The url of the package"
            ~args:Arg.[]
            ~typ:url
            ~resolve:(fun _ p ->
              let info = Package.info p in
              info.Package.Info.url)
        ]))

let packages_result =
  Graphql_lwt.Schema.(
    obj "allPackages" ~fields:(fun _ ->
        [ field
            "totalPackages"
            ~doc:"total number of packages"
            ~args:Arg.[]
            ~typ:(non_null int)
            ~resolve:(fun _ p -> p.total_packages)
        ; field
            "packages"
            ~doc:"list of all packages"
            ~args:Arg.[]
            ~typ:(non_null (list (non_null package)))
            ~resolve:(fun _ p -> p.packages)
        ]))

let schema : Dream.request Graphql_lwt.Schema.schema =
  Graphql_lwt.Schema.(
    schema
      [ field
          "allPackages"
          ~typ:(non_null packages_result)
          ~doc:
            "Filter packages in ascending order by name or based on search \
             query. Packages can also be paginated by setting the offset and \
             limit as desired"
          ~args:
            Arg.
              [ arg'
                  ~doc:
                    "Filter packages in ascending order by name by passing \
                     sortByName or based on search query"
                  "filter"
                  ~typ:string
                  ~default:"sortByName"
              ; arg'
                  ~doc:
                    "Specifies at what index packages can start, set to 0 by \
                     default which means start from the first package"
                  "offset"
                  ~typ:int
                  ~default:0
              ; arg'
                  ~doc:
                    "Specifies the limit which means the number of packages \
                     you want to return if you do not want all packages \
                     returned at once. By default, all the packages are \
                     returned"
                  "limit"
                  ~typ:int
                  ~default:0
              ]
          ~resolve:(fun _ () filter offset limit ->
            let packages = Package.all_packages_latest () in
            let totalPackages = List.length packages in
            if limit = 0 then
              let limit = totalPackages in
              let packages_result =
                get_packages_result totalPackages offset limit filter packages
              in
              packages_result
            else
              let limit = limit in
              let packages_result =
                get_packages_result totalPackages offset limit filter packages
              in
              packages_result)
      ; field
          "package"
          ~typ:package
          ~doc:
            "Returns details of a specified package. It returns the latest \
             version if no version is specifed or returns a particular version \
             of the package if a specified"
          ~args:
            Arg.
              [ arg
                  ~doc:"Get a single package by name"
                  "name"
                  ~typ:(non_null string)
              ]
          ~resolve:(fun _ () name ->
            let all_packages = Package.all_packages_latest () in
            List.find_opt
              (fun package ->
                is_package name (Package.Name.to_string (Package.name package)))
              all_packages)
      ])
