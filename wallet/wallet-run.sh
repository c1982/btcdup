#!/bin/bash

set -e

echo "RPC USER: ${RPCUSER}"
echo "RPC PASS: ${RCPPASS}"

if [ ! -f "/root/.btcwallet/btcwallet.conf" ]; then
    touch /root/.btcwallet/btcwallet.conf

    echo "[Application Options]
btcdusername=${RPCUSER}
btcdpassword=${RCPPASS}
rpccert=/root/.btcwallet/rpc.cert
rpckey=/root/.btcwallet/rpc.key
rpclisten=0.0.0.0:18554
rpcconnect=btcd.local:18556" > /root/.btcwallet/btcwallet.conf

    echo "created btcwallet.conf"
fi

if [ ! -f "/root/.btcwallet/rpc.cert" ]; then
    gencerts --host="*" --org="dev" --directory="/root/.btcwallet" -y 10 -f
    echo "created certificate"
fi

btcwallet --simnet -u ${RPCUSER} -P ${RCPPASS} -d trace --createtemp --appdata=/root/.btcwallet -C /root/.btcwallet/btcwallet.conf