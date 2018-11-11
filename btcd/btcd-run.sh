#!/bin/bash

set -e
set -o verbose

WALLETHOST="wallet.local"

sleep 7

if [ ! -d "/root/.btcwallet" ]; then
    mkdir /root/.btcwallet
fi

if [ ! -f "/root/.btcwallet/btcwallet.conf" ]; then
    touch /root/.btcwallet/btcwallet.conf
fi

if [ ! -f "/root/.btcwallet/rpc.cert" ]; then
    cp /root/.btcd/rpc.cert /root/.btcwallet/rpc.cert
fi

if [ ! -f "/root/.btcd/btcd.conf" ]; then
    touch /root/.btcd/btcd.conf

    echo "[Application Options]
rpcuser=${RPCUSER}
rpcpass=${RCPPASS}
rpclimituser=l${RPCUSER}
rpclimitpass=l${RCPPASS}
rpclisten=0.0.0.0
rpckey=/root/.btcd/rpc.key
rpccert=/root/.btcd/rpc.cert
listen=0.0.0.0
nolisten=0
txindex=1
addrindex=1
simnet=1
norpc=0" > /root/.btcd/btcd.conf

    echo "created btcd.conf"
fi

echo "WALLET: ${WALLETHOST}"
echo "RPC USER: ${RPCUSER}"
echo "RPC PASS: ${RCPPASS}"
echo "ACCOUNT: ${WALLETACCOUNT}"

/root/btcctl -s ${WALLETHOST} --skipverify -c /root/.btcd/rpc.cert -u ${RPCUSER} -P ${RCPPASS} --simnet --wallet walletpassphrase password 9999999
echo "wallet unlocked"

ACCEXISTS=$(/root/btcctl -s ${WALLETHOST} --skipverify -c /root/.btcd/rpc.cert -u ${RPCUSER} -P ${RCPPASS} --simnet --wallet listaccounts)
echo "listaccounts result:"
echo  ${ACCEXISTS}

if [[ ! $ACCEXISTS = *"${WALLETACCOUNT}"* ]]; then
   /root/btcctl -s ${WALLETHOST} --skipverify -c /root/.btcd/rpc.cert -u ${RPCUSER} -P ${RCPPASS} --simnet --wallet createnewaccount ${WALLETACCOUNT}
   echo "createnewaccount done"
fi

sleep 2

MADDR=$(/root/btcctl -s ${WALLETHOST} --skipverify -c /root/.btcd/rpc.cert -u ${RPCUSER} -P ${RCPPASS} --simnet --wallet getnewaddress ${WALLETACCOUNT})
echo "mining address for btcd: ${MADDR}"

/root/btcd -d trace --simnet --miningaddr="${MADDR}"