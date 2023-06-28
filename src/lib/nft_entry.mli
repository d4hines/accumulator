type data = { token_id : int; token_info : (string * bytes) list }
[@@deriving show]

type t = {
  data : data;
  (* FIXME: How does this get indexed and displayed in wallets? *)
  author : string;
  recipient : string;
  signature : string;
}
[@@deriving show]

val hash : t -> BLAKE2b.t
