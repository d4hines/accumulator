module Nft_tree = Incremental_patricia.Make (Nft_entry)

let tree_of_list =
  List.fold_left
    (fun tree nft ->
      let tree, _value = Nft_tree.add (fun id -> { metadata = nft; id }) tree in
      tree)
    Nft_tree.empty

let%expect_test "example trees" =
  Format.printf "empty:\n%a\n" Nft_tree.pp Nft_tree.empty;
  Format.printf "empty hash: %a\n----------------\n" BLAKE2b.pp
    (BLAKE2b.hash "");
  Format.printf "'a;b':\n%a\n----------------\n" Nft_tree.pp
    (tree_of_list [ "a"; "b" ]);
  Format.printf "'a;b;c':\n%a\n----------------\n" Nft_tree.pp
    (tree_of_list [ "a"; "b"; "c" ]);
  [%expect
    {|
    empty:
    { Incremental_patricia.Make.tree = Incremental_patricia.Make.Empty;
             top_bit = 0; last_key = -1 }
    empty hash: 0e5751c026e543b2e8ab2eb06099daa1d1e5df47778f7787faab45cdf12fe3a8
    ----------------
    'a;b':

    { Incremental_patricia.Make.tree =
      Incremental_patricia.Make.Node {
        left =
        Incremental_patricia.Make.Leaf {
          value = { Nft_entry.metadata = "a"; id = 0 };
          hash = b68cf90741aad1a3a985b7c0b9f5c01183030ad0e63132f5edaa5f3e6b6e4e25};
        hash = 71e055d664229ce45278c8e5d631a17e4c6d2557ec0bdc350649511842083842;
        right =
        Incremental_patricia.Make.Leaf {
          value = { Nft_entry.metadata = "b"; id = 1 };
          hash = e15928114adba31d0483d88d83d42303f5d02e7637c892a5714fdbddbc234a1c}};
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
                                                                    { Nft_entry.metadata =
                                                                      "a";
                                                                      id = 0 };
                                                                    hash =
                                                                    b68cf90741aad1a3a985b7c0b9f5c01183030ad0e63132f5edaa5f3e6b6e4e25};
                                                                  hash =
                                                                  71e055d664229ce45278c8e5d631a17e4c6d2557ec0bdc350649511842083842;
                                                                  right =
                                                                  Incremental_patricia.Make.Leaf {
                                                                    value =
                                                                    { Nft_entry.metadata =
                                                                      "b";
                                                                      id = 1 };
                                                                    hash =
                                                                    e15928114adba31d0483d88d83d42303f5d02e7637c892a5714fdbddbc234a1c}};
                                                                hash =
                                                                10115bc5aa9c245b60d3258dc316684f214162a92a5e977153f6188da832c237;
                                                                right =
                                                                Incremental_patricia.Make.Node {
                                                                  left =
                                                                  Incremental_patricia.Make.Leaf {
                                                                    value =
                                                                    { Nft_entry.metadata =
                                                                      "c";
                                                                      id = 2 };
                                                                    hash =
                                                                    5b0aa9b8fc01df22d700a9fea0f9c9a9400e8f9ecc43f16df536d645ab447ca3};
                                                                  hash =
                                                                  1b531989a7183cda947794f91843fcaf2c1e237eb43ca9a31de9438b726239e1;
                                                                  right =
                                                                  Incremental_patricia.Make.Empty}};
                                                              top_bit = 2;
                                                              last_key = 2 }
    ---------------- |}]

type proof = (BLAKE2b.t * BLAKE2b.t) list [@@deriving show]

let%expect_test "proofs" =
  let tree = tree_of_list [ "a"; "b"; "c" ] in
  let proof, _ = Nft_tree.find 1 tree |> Option.get in
  Format.printf "%a\n" pp_proof proof;
  [%expect
    {|
     [(71e055d664229ce45278c8e5d631a17e4c6d2557ec0bdc350649511842083842,
       1b531989a7183cda947794f91843fcaf2c1e237eb43ca9a31de9438b726239e1);
       (b68cf90741aad1a3a985b7c0b9f5c01183030ad0e63132f5edaa5f3e6b6e4e25,
        e15928114adba31d0483d88d83d42303f5d02e7637c892a5714fdbddbc234a1c)
       ] |}]
