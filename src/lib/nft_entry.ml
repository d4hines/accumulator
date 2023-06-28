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

let hash { data; author; recipient; signature } =
  let open Encoding.Pack in
  let author = string author in
  let recipient = string recipient in
  let signature = string signature in
  let token_id = nat (Z.of_int data.token_id) in
  let token_info_elts =
    List.map (fun (k, v) -> elt (string k) (bytes v)) data.token_info
  in
  let token_info = list token_info_elts in
  let value = triple (triple author token_id token_info) recipient signature in
  value |> to_bytes |> Bytes.to_string |> BLAKE2b.hash
