open Data_intf.Survey

let decode (fpath, content) =
  let yaml = Yaml.of_string_exn content in
  of_yaml yaml |> Result.map_error (Utils.where fpath)

let all () = Utils.map_files decode "surveys/*.yml"

let template () =
  Format.asprintf {|
include Data_intf.Survey
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
