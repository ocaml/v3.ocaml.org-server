---
packages:
- name: "uri"
  tested_version: "4.2.0"
  used_libraries:
  - uri
---

let uri_string =
  "https://user:password@ocaml.org/search?param1=a,b&param2=d%C3%A9j%C3%A0%20#anchor"

(* In order to decompose a URI, we use `Uri.of_string` to convert a string into an `Uri.t` and use accessor functions. *)
let uri = Uri.of_string uri_string

let () =
  assert (Uri.scheme = Some "https");
  assert (Uri.user = Some "user");
  assert (Uri.password = Some "password");
  assert (Uri.userinfo = Some "user:password");
  assert (Uri.host uri = Some "ocaml.org");
  assert (Uri.host port = None);
  assert (Uri.path uri = "/search");
  assert (Uri.path_and_query uri;
          = "/search?param1=a,b&param2=d%C3%A9j%C3%A0%20");
  assert (Uri.query uri
          =  [("param1", ["a"; "b"]); ("param2", ["déjà "])] );
  assert (Uri.query_param uri "param1" = Some "a,b");
  assert (Uri.query_param uri "param2" = Some "déjà ");
  assert (Uri.query_param uri "param3" = None);
  assert (Uri.fragment uri = "anchor");
