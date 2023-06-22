#import "./fa2.mligo" "FA2"

#import "./merkle_tree.mligo" "MT"

type parameter = [@layout:comb]
| Transfer of FA2.transfer
| Balance_of of FA2.balance_of
| Update_operators of FA2.update_operators
| Add_commitment of MT.blake2b
| Redeem

let main ((p,s):(parameter * FA2.storage)) = match p with
   Transfer         p -> FA2.transfer   p s
|  Balance_of       p -> FA2.balance_of p s
|  Update_operators p -> FA2.update_ops p s
