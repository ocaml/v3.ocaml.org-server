---
packages:
- name: "camlzip"
  tested_version: "1.11"
  used_libraries:
  - camlzip
---

(* When unzipping a file from a ZIP archive, we need to create the directory
   it is contained in, if it doesn't exist yet.  *)
let create_dir_if_not_exists filename =
  let rec aux_ensure base l =
    if not (Sys.file_exists base) then
      Sys.mkdir base 0o755
    else
      if not (Sys.is_directory base) then
        failwith "Error, file exists instead of a directory";
    match l with
    | [] -> failwith "Should not happen"
    | [ _filename ] -> ()
    | directory :: l' -> aux_ensure (base ^ "/" ^ directory) l'
  in
  match String.split_on_char '/' filename with
  | [ ] -> failwith "Should not happen (null filename)"
  | [ _filename ] -> ()
  | directory :: l -> aux_ensure directory l

(* Open the ZIP file for reading. *)
let unzip zip_filename =
  let zip = Zip.open_in zip_filename in

(* Iterate over all entries within the ZIP file. *)
  let entries = Zip.entries zip in
  entries
  |> List.iter (fun entry ->
         Printf.printf "%s\n" entry.Zip.filename;
         create_dir_if_not_exists entry.Zip.filename;
(* If the entry is a directory, just create the directory. *)
         if entry.Zip.is_directory then
           Sys.mkdir entry.Zip.filename 0o755

(* If the entry is a regular file, decompress it. *)
         else
           Zip.copy_entry_to_file
             zip
             entry
             entry.Zip.filename);
(* Finally, close the ZIP file. *)
  Zip.close_in zip
