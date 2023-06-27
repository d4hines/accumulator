#import "./token_interface.mligo" "Token_interface"
#import "./errors.mligo" "Errors"

type blake2b = bytes

type leaf = {
  data : Token_interface.data;
  (* FIXME: How does this get indexed and displayed in wallets? *)
  author : key;
  recipient : address;
  signature : signature;
} 

type merkle_proof = (blake2b * blake2b) list

let assert_valid_leaf ({data; author; recipient; signature} : leaf) =
  let bytes = Bytes.pack (data, recipient) in
  assert_with_error (Crypto.check author signature bytes) Errors.invalid_signature

let assert_valid_witness
  (proof: merkle_proof)
  (root: blake2b)
  (leaf: leaf) =
    let bit_is_set (bit: int) =
      Bitwise.and (Bitwise.shift_left 1n (abs bit)) leaf.data.token_id <> 0n in
    let rec verify
      (bit, proof, parent: int * merkle_proof * blake2b): unit =
        match proof with
        | [] ->
          let calculated_hash = Crypto.blake2b (Bytes.pack leaf) in
          assert_with_error  (parent = calculated_hash) "invalid handle data"
        | (left, right) :: tl ->
          let () =
            let calculated_hash = Crypto.blake2b (Bytes.concat left right) in
            assert_with_error (parent = calculated_hash) "invalid proof hash"
          in
          verify (bit - 1, tl, (if bit_is_set bit then right else left)) in
    (* each bit in the handle_id indicates if we should go left or right in
       the proof, but the first bit to check is the MSB, so we use the length
       of the proof to know what is the MSB *)
    let most_significant_bit = int (List.length proof) - 1 in
    verify (most_significant_bit, proof, root)

type 'a lazy_set = ('a, unit) big_map

type hash_set = blake2b lazy_set
