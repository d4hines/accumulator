#include "../src/consensus.mligo"
#include "./test_utils.mligo"

let () =
    let () = Test.log "root hash:" in
    let () = Test.log root in 
    let () = Test.log "handle hash:" in
    let () = Test.log handle_hash  in
    let () = Test.log "proof:" in
    let () = Test.log proof in
    let () = vault_check_handle_proof proof root handle in
    Test.log "successssss"
 
let reset_state () =
    let _ = Test.reset_state  5n ([4000000tz; 100tz; 100tz; 100tez; 100tez;] : tez list) in
    let faucet = Test.nth_bootstrap_account 0 in
    let _ = Test.set_baker faucet in
    let initial_storage : storage = Big_map.empty in
    let () = Test.set_source faucet in 
    let taddr, _, _ = Test.originate_uncurried main initial_storage 0tz in 
    (faucet, taddr) 

let test_contract () = 
    let (_faucet, taddr) = reset_state () in
    let contract = Test.to_contract taddr in 
    let gas_consumed = Test.transfer_to_contract_exn contract params 0tz in
    let ()  = Test.log "Gas consumed:"  in
    let ()  = Test.log gas_consumed  in
    () 

let () = test_contract () 
