# How many new outputs were created by block 123,456?
block_hash=$(bitcoin-cli getblockhash 123456)
block_data=$(bitcoin-cli getblock $block_hash)
tx_hashes=$(echo $block_data | jq -r '.tx[]')
for tx_hash in $tx_hashes; do 
    tx_data=$(bitcoin-cli getrawtransaction $tx_hash true) 
    outputs_count=$(echo $tx_data | jq '.vout | length') 
    total_outputs=$((total_outputs + outputs_count)) 
done
echo "$total_outputs"
