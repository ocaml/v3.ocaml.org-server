---
packages:
- name: "camlzip"
  tested_version: "1.11"
  used_libraries:
  - camlzip
---

(* We open both files (`source` with `In_channel.open_bin` and `dest` with `Gzip.open_out`)
   and transfer bytes through a bytes buffer. *)

let buffer_size = 4096

let gzip source dest =
  let gz_file = Gzip.open_out ~level:9 dest in
  let buffer = Bytes.make buffer_size '*' in
  let ic = In_channel.open_bin source in
  let rec aux () =
    let len = In_channel.input ic buffer 0 buffer_size in
    if len <> 0 then
      begin
        Gzip.output gz_file buffer 0 len;
        aux ()
      end
  in
  aux ();
  Gzip.close_out gz_file;
  In_channel.close ic
