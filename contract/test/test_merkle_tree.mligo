#import "../src/merkle_tree.mligo" "MT"

let () = 
    (* See src/lib/test_tree_examples.ml *)
    (* example 1 *)
    let root = 0x10115bc5aa9c245b60d3258dc316684f214162a92a5e977153f6188da832c237 in 
    let proof =  [
      (0x71e055d664229ce45278c8e5d631a17e4c6d2557ec0bdc350649511842083842,
       0x1b531989a7183cda947794f91843fcaf2c1e237eb43ca9a31de9438b726239e1);
      (0xb68cf90741aad1a3a985b7c0b9f5c01183030ad0e63132f5edaa5f3e6b6e4e25,
       0xe15928114adba31d0483d88d83d42303f5d02e7637c892a5714fdbddbc234a1c)
       ] in
    let leaf = { metadata = "b"; id = 1n} in
    let () = MT.assert_valid_witness proof root leaf in
    (* example 2 *)
    let root = 0x15ec4e09903d84ccb95473bc05f6c7f9434a307729828a62d478d1a6e2c031ed in 
    let proof =  [(0x3b5f99ddd4c3a480e725124ed04b2a54b1786bae96a6d2ac2b917c1005bd64bc,
       0x76beaf7dc7668360acc4fa6d9e47c3b3b7eea1f3156204de0406c432e2f58ee5);
       (0xf8e99d14fd83d18d881028196a28fbe8b742e20c11d9c5ce73bb53cd46080cd8,
        0x8438b0d941bcc7a33e296f07393103e83e31c603897de881e869a3e60c516412);
       (0x3c97552cc1c4c2845429858290a5b6e22577e8f07d5e6a5543ab09a67023f719,
        0x461cc538a6ae23529cb18843518a7171ff6cb5ea1bb7a074d3c4c0b5a9cfbf51)
       ] in
    let leaf = { metadata = "g"; id = 5n} in
     MT.assert_valid_witness proof root leaf