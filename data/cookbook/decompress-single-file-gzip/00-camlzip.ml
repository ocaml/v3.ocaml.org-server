---
packages:
- name: "camlzip"
  tested_version: "1.11"
  used_libraries:
  - camlzip
---

(* To decompress a single file using the [Gzip](/p/camlzip/latest/doc/Gzip/index.html) module from `camlzip`,
   we open both files (`source` with `Gzip.open_in` and `dest` with `Out_channel.open_bin`) and transfer bytes through a bytes buffer. *)

let buffer_size = 4096

let gunzip source dest =
  let gz_file = Gzip.open_in source in
  let buffer = Bytes.make buffer_size '*' in
  let oc = Out_channel.open_bin dest in
  let rec aux () =
    let len = Gzip.input gz_file buffer 0 buffer_size in
    if len <> 0 then
      begin
        Out_channel.output oc buffer 0 len;
        aux ()
      end
  in
  aux ();
  Gzip.close_in gz_file;
  Out_channel.close oc
