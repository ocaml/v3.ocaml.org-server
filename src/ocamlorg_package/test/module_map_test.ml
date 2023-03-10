let json =
  {|{
    "libraries": [
      {
        "name": "logs",
        "modules": [
          {
            "name": "Logs",
            "submodules": [
              {
                "name": "LOG",
                "submodules": [],
                "kind": "module-type"
              },
              {
                "name": "Make",
                "submodules": [
                  {
                    "name": "1-X",
                    "submodules": [],
                    "kind": "argument"
                  }
                ],
                "kind": "module"
              },
              {
                "name": "dummy_generator",
                "submodules": [],
                "kind": "class"
              },
              {
                "name": "generator",
                "submodules": [],
                "kind": "class-type"
              }
            ],
            "kind": "module"
          }
        ]
      }
    ]
  }
|}

open Ocamlorg.Import
open Ocamlorg_package

let test_case n = Alcotest.test_case n `Quick

let () =
  Alcotest.run "ocamlorg"
    [
      ( "test parsing and path generation",
        [
          test_case "simple json" (fun () ->
              let json = Yojson.Safe.from_string json in
              let t = Module_map.of_yojson json in
              Alcotest.(check int)
                "single library"
                (String.Map.cardinal t.libraries)
                1;
              let name, library = String.Map.choose t.libraries in
              Alcotest.(check string) "name is correct" "logs" name;
              Alcotest.(check string)
                "library name matches too" "logs" library.name;
              Alcotest.(check int)
                "single module in library"
                (String.Map.cardinal library.modules)
                1;
              let name, module' = String.Map.choose library.modules in
              Alcotest.(check string) "name is correct" "Logs" name;
              Alcotest.(check string)
                "module' name matches too" "Logs"
                (Module_map.Module.name module');
              Alcotest.(check int)
                "4 submodules" 4
                (String.Map.cardinal (Module_map.Module.submodules module'));
              Alcotest.(check (list string))
                "module paths are correct"
                [
                  "Logs/module-type-LOG/index.html";
                  "Logs/Make/index.html";
                  "Logs/class-dummy_generator/index.html";
                  "Logs/class-type-generator/index.html";
                ]
                (Module_map.Module.submodules module'
                |> String.Map.bindings
                |> List.map (fun (_, v) -> Module_map.Module.path v)));
        ] );
    ]
