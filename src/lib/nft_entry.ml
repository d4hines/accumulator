type t = { metadata : string; id : int } [@@deriving show]

let hash { metadata; id } =
  let str = string_of_int id ^ metadata in
  BLAKE2b.hash str
