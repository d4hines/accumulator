module Size_256 = struct
  let digest_size = 256 / 8; 
end

include Digestif.Make_BLAKE2B(Size_256)

let pp = pp

let show = to_hex

let compare a b = unsafe_compare a b
let of_raw string = of_raw_string_opt string
  let to_raw hash = to_raw_string hash

  let of_hex string =
    let size = digest_size * 2 in
    match String.length string = size with
    | true -> of_hex_opt string
    | false -> None

  let to_hex hash = to_hex hash
  let hash data = digest_string data
  let both a b = hash (to_raw_string a ^ to_raw_string b)
 
let%expect_test "hashing functions" =  
  let message = "asdf" in
  let hash = hash message in 
  let hash_hex = to_hex hash in 
  let () = Format.printf "Blake2b hash of '%s' = %s" message hash_hex in
  assert ("b91349ff7c99c3ae3379dd49c2f3208e202c95c0aac5f97bb24ded899e9a2e83" = hash_hex);
  [%expect {|Blake2b hash of 'asdf' = b91349ff7c99c3ae3379dd49c2f3208e202c95c0aac5f97bb24ded899e9a2e83 |}]
