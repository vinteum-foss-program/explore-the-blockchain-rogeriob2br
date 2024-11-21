# Only one single output remains unspent from block 123,321. What address was it sent to?
block_hash=$(bitcoin-cli getblockhash 123321)

txs=$(bitcoin-cli getblock $block_hash | jq -r '.tx[]')

declare -a unspent_outputs

for txid in $txs; do
    raw_tx=$(bitcoin-cli getrawtransaction $txid)
    decoded_tx=$(bitcoin-cli decoderawtransaction $raw_tx)
    for vout in $(echo $decoded_tx | jq -r '.vout | keys[]'); do
        is_unspent=$(bitcoin-cli gettxout $txid $vout)
        if [ ! -z "$is_unspent" ]; then
            address=$(echo $decoded_tx | jq -r ".vout[$vout].scriptPubKey.address")
            unspent_outputs+=("$address")
        fi
    done
done
for address in "${unspent_outputs[@]}"; do
    echo "$address"
done

