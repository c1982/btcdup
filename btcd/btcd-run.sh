#!/bin/bash

set -e

WALLETHOST="wallet.local"

sleep 7

if [ ! -f "/root/.btcd/btcd.conf" ]; then
    cp /root/.btcd/rpc.cert /root/.btcwallet/rpc.cert
    touch /root/.btcwallet/btcwallet.conf
    touch /root/.btcd/btcd.conf

    echo "[Application Options]
rpclisten=0.0.0.0
rpckey=/root/.btcd/rpc.key
rpccert=/root/.btcd/rpc.cert
norpc=0
listen=0.0.0.0
nolisten=0
txindex=1
addrindex=1
simnet=1" > /root/.btcd/btcd.conf

    echo "created btcd.conf"
fi

echo "WALLET: ${WALLETHOST}"
echo "RPC USER: ${RPCUSER}"
echo "RPC PASS: ${RCPPASS}"
echo "ACCOUNT: ${WALLETACCOUNT}"

btcctl -s ${WALLETHOST} --skipverify -c /root/.btcd/rpc.cert -u ${RPCUSER} -P ${RCPPASS} --simnet --wallet walletpassphrase password 9999999
echo "wallet unlocked"

ACCEXISTS=$(btcctl -s ${WALLETHOST} --skipverify -c /root/.btcd/rpc.cert -u ${RPCUSER} -P ${RCPPASS} --simnet --wallet listaccounts)
echo "listaccounts result:"
echo  ${ACCEXISTS}

if [[ ! $ACCEXISTS = *"${WALLETACCOUNT}"* ]]; then
   btcctl -s ${WALLETHOST} --skipverify -c /root/.btcd/rpc.cert -u ${RPCUSER} -P ${RCPPASS} --simnet --wallet createnewaccount ${WALLETACCOUNT}
   echo "createnewaccount done"
fi

MADDR=$(btcctl -s ${WALLETHOST} --skipverify -c /root/.btcd/rpc.cert -u ${RPCUSER} -P ${RCPPASS} --simnet --wallet getnewaddress ${WALLETACCOUNT})
echo "mining address for btcd: ${MADDR}"

sleep 2

btcd -u ${RPCUSER} -P ${RCPPASS} -d trace --simnet --miningaddr="${MADDR}"