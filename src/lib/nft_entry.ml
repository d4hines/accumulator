type t = {
  metadata: string;
  id: int;
}[@@deriving show]

let next_id = ref 0

let hash {metadata; id} = 
  let str = (string_of_int id) ^ metadata in
  BLAKE2b.hash str 

let make metadata =
  let id = !next_id in  
  next_id := id + 1;
  {metadata; id}
