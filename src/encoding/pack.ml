open Tezos_micheline
open Micheline
open Michelson_v1_primitives

type t = (canonical_location, prim) node

let int n = Int (-1, n)
let nat n = Int (-1, n)
let bytes b = Bytes (-1, b)
let string s = String (-1, s)
let pair l r = Prim (-1, D_Pair, [ l; r ], [])
let list l = Seq (-1, l)
let elt k v = Prim (-1, D_Elt, [ k; v ], [])
let triple a b c = Prim (-1, D_Pair, [ a; b; c ], [])

let to_bytes data =
  Data_encoding.Binary.to_bytes_exn Michelson.expr_encoding
    (strip_locations data)
  |> Bytes.cat (Bytes.of_string "\005")
