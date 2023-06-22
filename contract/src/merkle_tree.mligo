type blake2b = bytes

type leaf_structure = {
  metadata: string;
  id: nat;
} 

type merkle_proof = (blake2b * blake2b) list

type materialize_params = {
  root: blake2b;
  leaf: leaf_structure;
  proof: merkle_proof;
}

let assert_msg ((message, condition): (string * bool)) =
  if not condition then
    failwith message

let vault_check_handle_proof
  (proof: merkle_proof)
  (root: blake2b)
  (leaf: leaf_structure) =
    let bit_is_set (bit: int) =
      Bitwise.and (Bitwise.shift_left 1n (abs bit)) leaf.id <> 0n in
    let rec verify
      (bit, proof, parent: int * merkle_proof * blake2b): unit =
        match proof with
        | [] ->
          let calculated_hash = Crypto.blake2b (Bytes.pack leaf) in
          assert_msg ("invalid handle data", parent = calculated_hash)
        | (left, right) :: tl ->
          let () =
            let calculated_hash = Crypto.blake2b (Bytes.concat left right) in
            assert_msg ("invalid proof hash", parent = calculated_hash) in
          verify (bit - 1, tl, (if bit_is_set bit then right else left)) in
    (* each bit in the handle_id indicates if we should go left or right in
       the proof, but the first bit to check is the MSB, so we use the length
       of the proof to know what is the MSB *)
    let most_significant_bit = int (List.length proof) - 1 in
    verify (most_significant_bit, proof, root)
