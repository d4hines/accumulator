open Encoding

type t = { metadata : string; id : int } [@@deriving show]

let hash { metadata; id } =
  let metadata = Pack.string metadata in
  let id = Pack.nat (Z.of_int id) in
  Pack.pair id metadata |> Pack.to_bytes |> Bytes.to_string |> BLAKE2b.hash
