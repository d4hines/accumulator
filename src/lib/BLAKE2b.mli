type t [@@deriving show, eq, ord]

val hash : string -> t

val both : t -> t -> t
(** hashes the concetenation of the raw bytes of the two hashes *)

val of_hex : string -> t option
(** Deserializes a hex-encoded string as a  *)

val of_raw : string -> t option
(** Deserializes a string of raw bytes as a hash *)

val to_raw : t -> string
(** Serializes a hash as its raw byte string *)

val to_hex : t -> string
(** Serializes a hash as a hex-encoded string *)
