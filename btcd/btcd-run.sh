#!/bin/bash

set -e
set -o verbose

sleep 2

/root/btcctl -s dev-btcwallet --skipverify -u ${RPCUSER} -P ${RCPPASS} --simnet --wallet walletpassphrase password 9999999

accountexists=$(/root/btcctl -s dev-btcwallet --skipverify -u ${RPCUSER} -P ${RCPPASS} --simnet --wallet listaccounts)

if [[ ! $accountexists = *"${WALLET_ACCOUNT}"* ]]; then
   /root/btcctl -s dev-btcwallet --skipverify  -u ${RPCUSER} -P ${RCPPASS} --simnet --wallet createnewaccount ${WALLET_ACCOUNT}
fi

miningaddr=$(/root/btcctl -s dev-btcwallet --skipverify -u ${RPCUSER} -P ${RCPPASS}  --simnet --wallet getnewaddress ${WALLET_ACCOUNT})
echo "mining address: ${miningaddr}"

sleep 1

echo "****BTCD START****"
/root/btcd -u ${RPCUSER} -P ${RCPPASS} -d trace --miningaddr="${miningaddr}"