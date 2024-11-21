# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
#!/bin/bash

txid="e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163"

raw_tx=$(bitcoin-cli getrawtransaction $txid)

decoded_tx=$(bitcoin-cli decoderawtransaction $raw_tx)

txinwitness=$(echo $decoded_tx | jq -r '.vin[0].txinwitness')


num_elements=$(echo $txinwitness | jq '. | length')
if [ $num_elements -gt 2 ]; then

    witness_script=$(echo $txinwitness | jq -r '.[-1]')

    public_key=$(echo $witness_script | awk '{print substr($0, 5, 66)}')
else
    public_key=$(echo $txinwitness | jq -r '.[1]')
fi
echo "$public_key"
