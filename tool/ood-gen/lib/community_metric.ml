open Ocamlorg.Import
open Data_intf.Community_metric

let all () =
  Utils.yaml_file "community-metrics.yml"
  |> Result.get_ok ~error:(fun (`Msg msg) -> Exn.Decode_error msg)
  |> of_yaml
  |> Result.get_ok ~error:(fun (`Msg msg) -> Exn.Decode_error msg)

let template () =
  Format.asprintf {|
include Data_intf.Community_metric
let t = %a
|} pp
    (all ())
