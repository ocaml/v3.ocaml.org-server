---
packages:
- name: "camlzip"
  tested_version: "1.11"
  used_libraries:
  - camlzip
---

(*
  The [Zip](/p/camlzip/latest/doc/Zip/index.html) module doesn't provide a function that works on a directory.

  Thus, we write a helper-function to traverse the file-system.
  Here the given function `f` is called for each regular file with its name as a parameter.
  
   *)
let rec traverse_fs f directory =
  if Sys.is_directory directory then
    Sys.readdir directory
    |> Array.iter
         (fun entry ->
            traverse
              f (directory ^ "/" ^ entry))
  else
    f directory


(* First, we open the ZIP file for writing. *)
let zip zip_filename directory_name =
  let zip_file = Zip.open_out zip_filename in

(* Then, we use `Zip.copy_file_to_entry` to add every file in the directory to the ZIP file. *)
  traverse_fs
    (fun name ->
      Zip.copy_file_to_entry name zip_file name)
    directory_name;
(* To finalize the archive, we close the ZIP file. *)
  Zip.close_out zip_file

