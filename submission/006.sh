# Which tx in block 257,343 spends the coinbase output of block 256,128?
hash_256128=$(bitcoin-cli getblockhash 256128)
hash_257343=$(bitcoin-cli getblockhash 257343)
coinbase_txid=$(bitcoin-cli getblock $hash_256128 | jq -r '.tx[0]')
txs_257343=$(bitcoin-cli getblock $hash_257343 | jq -r '.tx[]')
for tx in $txs_257343; do
    raw_tx=$(bitcoin-cli getrawtransaction $tx)
    decoded_tx=$(bitcoin-cli decoderawtransaction $raw_tx)
    for vin in $(echo $decoded_tx | jq -r '.vin[].txid'); do
        if [ "$vin" == "$coinbase_txid" ]; then
            echo "$tx"
            exit 0
        fi
    done
done
