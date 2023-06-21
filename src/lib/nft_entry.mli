type t = {
  metadata: string;
  id: int;
}[@@deriving show]

val hash : t -> BLAKE2b.t

val make : string -> t
