module Nft_tree = Incremental_patricia.Make (Nft_entry)

let leaf_of_id id =
  let open Nft_entry in
  let data =
    { token_id = id; token_info = [ ("hello", Bytes.of_string "world") ] }
  in
  {
    data;
    (* FIXME: How does this get indexed and displayed in wallets? *)
    author = "edpkvYuMUqDdSJjfc5ukdrD42kUiJ4UJsb296TaT5iFzANhdFCdQaF";
    recipient =
      "tz1anBZ6qANs3bCn5By42NH475kPD7GhJBKQ" (* just a random address *);
    signature =
      "edsigtib3NBVvPPcmTiBWxr9q7xx7wYczbHDni7M6nYKs9VUq5zntmN4ebGVLCfGgida1f8nKL1rngU5CZG64fSSyEFL4m2LAs3"
      (* this signature won't be valid but it's fine for testing *);
  }

let tree_of_size n =
  List.fold_left
    (fun tree _ ->
      let tree, _value = Nft_tree.add (fun id -> leaf_of_id id) tree in
      tree)
    Nft_tree.empty
    (List.init n (fun _ -> ()))

let%expect_test "example trees" =
  Format.printf "empty:\n%a\n" Nft_tree.pp Nft_tree.empty;
  Format.printf "empty hash: %a\n----------------\n" BLAKE2b.pp
    (BLAKE2b.hash "");
  Format.printf "'a;b':\n%a\n----------------\n" Nft_tree.pp (tree_of_size 2);
  Format.printf "'a;b;c':\n%a\n----------------\n" Nft_tree.pp (tree_of_size 3);
  [%expect
    {|
    empty:
    { Incremental_patricia.Make.tree = Incremental_patricia.Make.Empty;
             top_bit = 0; last_key = -1 }
    empty hash: 0x0e5751c026e543b2e8ab2eb06099daa1d1e5df47778f7787faab45cdf12fe3a8
    ----------------
    'a;b':

    { Incremental_patricia.Make.tree =
      Incremental_patricia.Make.Node {
        left =
        Incremental_patricia.Make.Leaf {
          value =
          { Nft_entry.data =
            { Nft_entry.token_id = 0; token_info = [("hello", "world")] };
            author = "edpkvYuMUqDdSJjfc5ukdrD42kUiJ4UJsb296TaT5iFzANhdFCdQaF";
            recipient = "tz1anBZ6qANs3bCn5By42NH475kPD7GhJBKQ";
            signature =
            "edsigtib3NBVvPPcmTiBWxr9q7xx7wYczbHDni7M6nYKs9VUq5zntmN4ebGVLCfGgida1f8nKL1rngU5CZG64fSSyEFL4m2LAs3"
            };
          hash =
          0xeb91288e0dbeb6b131ef287beab86a364f180356090dfdc3379b9352c0501513};
        hash = 0x9bca18b7190c6f911a237979192307295cea2732bba7484181e5ab2ba3e1feac;
        right =
        Incremental_patricia.Make.Leaf {
          value =
          { Nft_entry.data =
            { Nft_entry.token_id = 1; token_info = [("hello", "world")] };
            author = "edpkvYuMUqDdSJjfc5ukdrD42kUiJ4UJsb296TaT5iFzANhdFCdQaF";
            recipient = "tz1anBZ6qANs3bCn5By42NH475kPD7GhJBKQ";
            signature =
            "edsigtib3NBVvPPcmTiBWxr9q7xx7wYczbHDni7M6nYKs9VUq5zntmN4ebGVLCfGgida1f8nKL1rngU5CZG64fSSyEFL4m2LAs3"
            };
          hash =
          0x33259f5230a3f895b10c8d391e8ba4d30b2b175383ad64b3f695ecc69685bca6}};
      top_bit = 1; last_key = 1 }
    ----------------
    'a;b;c':
    { Incremental_patricia.Make.tree =
                                                              Incremental_patricia.Make.Node {
                                                                left =
                                                                Incremental_patricia.Make.Node {
                                                                  left =
                                                                  Incremental_patricia.Make.Leaf {
                                                                    value =
                                                                    { Nft_entry.data =
                                                                      { Nft_entry.token_id =
                                                                        0;
                                                                        token_info =
                                                                        [("hello",
                                                                        "world")]
                                                                        };
                                                                      author =
                                                                      "edpkvYuMUqDdSJjfc5ukdrD42kUiJ4UJsb296TaT5iFzANhdFCdQaF";
                                                                      recipient =
                                                                      "tz1anBZ6qANs3bCn5By42NH475kPD7GhJBKQ";
                                                                      signature =
                                                                      "edsigtib3NBVvPPcmTiBWxr9q7xx7wYczbHDni7M6nYKs9VUq5zntmN4ebGVLCfGgida1f8nKL1rngU5CZG64fSSyEFL4m2LAs3"
                                                                      };
                                                                    hash =
                                                                    0xeb91288e0dbeb6b131ef287beab86a364f180356090dfdc3379b9352c0501513};
                                                                  hash =
                                                                  0x9bca18b7190c6f911a237979192307295cea2732bba7484181e5ab2ba3e1feac;
                                                                  right =
                                                                  Incremental_patricia.Make.Leaf {
                                                                    value =
                                                                    { Nft_entry.data =
                                                                      { Nft_entry.token_id =
                                                                        1;
                                                                        token_info =
                                                                        [("hello",
                                                                        "world")]
                                                                        };
                                                                      author =
                                                                      "edpkvYuMUqDdSJjfc5ukdrD42kUiJ4UJsb296TaT5iFzANhdFCdQaF";
                                                                      recipient =
                                                                      "tz1anBZ6qANs3bCn5By42NH475kPD7GhJBKQ";
                                                                      signature =
                                                                      "edsigtib3NBVvPPcmTiBWxr9q7xx7wYczbHDni7M6nYKs9VUq5zntmN4ebGVLCfGgida1f8nKL1rngU5CZG64fSSyEFL4m2LAs3"
                                                                      };
                                                                    hash =
                                                                    0x33259f5230a3f895b10c8d391e8ba4d30b2b175383ad64b3f695ecc69685bca6}};
                                                                hash =
                                                                0x0232c5455175cc58a166c713e2192152b7b6b024c50cf1c433eb1a51cb7daa53;
                                                                right =
                                                                Incremental_patricia.Make.Node {
                                                                  left =
                                                                  Incremental_patricia.Make.Leaf {
                                                                    value =
                                                                    { Nft_entry.data =
                                                                      { Nft_entry.token_id =
                                                                        2;
                                                                        token_info =
                                                                        [("hello",
                                                                        "world")]
                                                                        };
                                                                      author =
                                                                      "edpkvYuMUqDdSJjfc5ukdrD42kUiJ4UJsb296TaT5iFzANhdFCdQaF";
                                                                      recipient =
                                                                      "tz1anBZ6qANs3bCn5By42NH475kPD7GhJBKQ";
                                                                      signature =
                                                                      "edsigtib3NBVvPPcmTiBWxr9q7xx7wYczbHDni7M6nYKs9VUq5zntmN4ebGVLCfGgida1f8nKL1rngU5CZG64fSSyEFL4m2LAs3"
                                                                      };
                                                                    hash =
                                                                    0x305e3adb1e237df53ff29e9a4f91d6451e8d69750d166c4baf796db0990ba91c};
                                                                  hash =
                                                                  0x0dea7909619090ae016cc190479668afdb466f50937dee8e637c6e1566127a40;
                                                                  right =
                                                                  Incremental_patricia.Make.Empty}};
                                                              top_bit = 2;
                                                              last_key = 2 }
    ---------------- |}]

type proof = (BLAKE2b.t * BLAKE2b.t) list [@@deriving show]

let%expect_test "proofs" =
  let tree = tree_of_size 3 in
  let proof, _ = Nft_tree.find 1 tree |> Option.get in
  Format.printf "root: %a; proof: %a\n-----------\n" BLAKE2b.pp
    (Nft_tree.hash tree) pp_proof proof;
  let tree = tree_of_size 6 in
  let proof, _ = Nft_tree.find 5 tree |> Option.get in
  Format.printf "root: %a; proof: %a\n-----------\n" BLAKE2b.pp
    (Nft_tree.hash tree) pp_proof proof;
  [%expect
    {|
     root: 0x0232c5455175cc58a166c713e2192152b7b6b024c50cf1c433eb1a51cb7daa53; proof:
     [(0x9bca18b7190c6f911a237979192307295cea2732bba7484181e5ab2ba3e1feac,
       0x0dea7909619090ae016cc190479668afdb466f50937dee8e637c6e1566127a40);
       (0xeb91288e0dbeb6b131ef287beab86a364f180356090dfdc3379b9352c0501513,
        0x33259f5230a3f895b10c8d391e8ba4d30b2b175383ad64b3f695ecc69685bca6)
       ]
     -----------
     root: 0x95b83aff9a4ccd866cc1a1d16153757e2f2d7e36fbb5cf6bbf8c78f2da2788ce; proof:
     [(0xb1ca5db917f20a2a85b7a8c52a9035611b0becfd0d104ea12d6ef2d81eb23d75,
       0x1bb087798f39d75e367be184e293cfe0a1e7db36d8a66a22a5b03272057da5e5);
       (0x6007dd1f6ad831203dcc21c7d48721b2706ebc3f7986747d825f7306dad90a3e,
        0x8438b0d941bcc7a33e296f07393103e83e31c603897de881e869a3e60c516412);
       (0x616323927acb8c1a375834a2fa4ddfeb761d0337251044ba8651c6819bd2b8bb,
        0x3555f70f10e1858b1ed7e131d8de0b6bcb3b8998cfc4ec56eb32f565390ec3f8)
       ]
     ----------- |}]
