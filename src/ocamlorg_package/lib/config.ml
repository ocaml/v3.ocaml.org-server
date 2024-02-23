let env_with_default k v = Sys.getenv_opt k |> Option.value ~default:v

let opam_polling =
  env_with_default "OCAMLORG_OPAM_POLLING" "3600" |> int_of_string

let documentation_url =
  Sys.getenv_opt "OCAMLORG_DOC_URL"
  |> Option.value ~default:"https://docs-data.ocaml.org/live/"

let documentation_status_cache_ttl =
  env_with_default "OCAMLORG_DOC_STATUS_CACHE_TTL" "3600" |> float_of_string

let default_cache_dir =
  match Sys.os_type with
  | "Unix" -> Fpath.(v (Sys.getenv "HOME") / ".cache" / "ocamlorg")
  | _ -> Fpath.(v (Sys.getenv "APPDATA") / "ocamlorg" / "cache")

let opam_repository_path =
  Sys.getenv_opt "OCAMLORG_REPO_PATH"
  |> Option.map (fun x -> Result.get_ok (Fpath.of_string x))
  |> Option.value ~default:Fpath.(default_cache_dir / "opam-repository")

let package_state_path =
  Sys.getenv_opt "OCAMLORG_PKG_STATE_PATH"
  |> Option.map (fun x -> Result.get_ok (Fpath.of_string x))
  |> Option.value ~default:Fpath.(default_cache_dir / "package.state")
