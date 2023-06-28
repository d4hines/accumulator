type t

val int : Z.t -> t
val nat : Z.t -> t
val bytes : bytes -> t
val string : string -> t
val pair : t -> t -> t
val list : t list -> t
val elt : t -> t -> t
val triple : t -> t -> t -> t
val to_bytes : t -> bytes
