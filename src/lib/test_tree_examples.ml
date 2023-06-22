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
          hash = bfb566be3d85a72bc343229675f2aaaa9a780082c5ac22cb447ab5d6f973ea07};
        hash = 0eb9992b0977f33390770c0fbae6d19d4f99ae9129c703c7ecb4305fa60e49dd;
        right =
        Incremental_patricia.Make.Leaf {
          value = { Nft_entry.metadata = "b"; id = 1 };
          hash = 61f7482ee57411bd6840a2ccc8b95b9a98c7d6a1403ce50cb07708f027ebbfc9}};
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
                                                                    bfb566be3d85a72bc343229675f2aaaa9a780082c5ac22cb447ab5d6f973ea07};
                                                                  hash =
                                                                  0eb9992b0977f33390770c0fbae6d19d4f99ae9129c703c7ecb4305fa60e49dd;
                                                                  right =
                                                                  Incremental_patricia.Make.Leaf {
                                                                    value =
                                                                    { Nft_entry.metadata =
                                                                      "b";
                                                                      id = 1 };
                                                                    hash =
                                                                    61f7482ee57411bd6840a2ccc8b95b9a98c7d6a1403ce50cb07708f027ebbfc9}};
                                                                hash =
                                                                515516f0493235c0d96ae9a081b2ee97bd1198d7d652faedc0e4395bf0e17741;
                                                                right =
                                                                Incremental_patricia.Make.Node {
                                                                  left =
                                                                  Incremental_patricia.Make.Leaf {
                                                                    value =
                                                                    { Nft_entry.metadata =
                                                                      "c";
                                                                      id = 2 };
                                                                    hash =
                                                                    23649bfa37dd2c92460e38a1aaa977122e089f2cc260309ed5354f97385b560e};
                                                                  hash =
                                                                  b8bb0233aa4476456b25d0af8faf939c191dde5fe71e7d482b56f4072bb45c90;
                                                                  right =
                                                                  Incremental_patricia.Make.Empty}};
                                                              top_bit = 2;
                                                              last_key = 2 }
    ---------------- |}]

type proof = (BLAKE2b.t * BLAKE2b.t) list [@@deriving show]

let%expect_test "proofs" =
  let tree = tree_of_list [ "a"; "b"; "c" ] in
  let proof, _ = Nft_tree.find 2 tree |> Option.get in
  Format.printf "%a\n" pp_proof proof;
  [%expect
    {|
     [(0eb9992b0977f33390770c0fbae6d19d4f99ae9129c703c7ecb4305fa60e49dd,
       b8bb0233aa4476456b25d0af8faf939c191dde5fe71e7d482b56f4072bb45c90);
       (23649bfa37dd2c92460e38a1aaa977122e089f2cc260309ed5354f97385b560e,
        0e5751c026e543b2e8ab2eb06099daa1d1e5df47778f7787faab45cdf12fe3a8)
       ] |}]
