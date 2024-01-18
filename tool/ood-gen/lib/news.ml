type metadata = {
  title : string;
  description : string;
  date : string;
  tags : string list;
  authors : string list option;
}
[@@deriving of_yaml]

type t = {
  title : string;
  description : string;
  date : string;
  slug : string;
  tags : string list;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata ~add:[ authors ] ~remove:[ slug; body_html ],
    show { with_path = false }]

let decode (fname, (head, body)) =
  let slug = Filename.basename (Filename.remove_extension fname) in
  let metadata = metadata_of_yaml head |> Result.map_error (Utils.where fname) in
  let body_html =
    Cmarkit.Doc.of_string ~strict:true (String.trim body)
    |> Hilite.Md.transform
    |> Cmarkit_html.of_doc ~safe:false
  in
  Result.map (of_metadata ~slug ~body_html) metadata

let all () =
  Utils.map_files decode "news/*/*.md"
  |> List.sort (fun a b -> String.compare b.date a.date)

let template () =
  Format.asprintf
    {|
type t =
  { title : string
  ; slug : string
  ; description : string
  ; date : string
  ; tags : string list
  ; body_html : string
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
