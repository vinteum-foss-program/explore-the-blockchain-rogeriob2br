# Create a 1-of-4 P2SH multisig address from the public keys in the four inputs of this tx:
#   `37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517`
txid="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"
raw_tx=$(bitcoin-cli getrawtransaction $txid)
decoded_tx=$(bitcoin-cli decoderawtransaction $raw_tx)
pubkeys=($(echo $decoded_tx | jq -r '.vin[].txinwitness[1]'))
multisig_script=$(bitcoin-cli createmultisig 1 "[\"${pubkeys[0]}\",\"${pubkeys[1]}\",\"${pubkeys[2]}\",\"${pubkeys[3]}\"]")
p2sh_address=$(echo $multisig_script | jq -r '.address')
echo "$p2sh_address"
