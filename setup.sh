#!/bin/bash

echo "Kill all pids of geth and bootnodes in an instance"
#killall geth
#killall bootnode
#rm -rf cashenet

SEALER_NODES=$1
PORT=3050
RPCPORT=8545
BOOTPORT=30310
WSPORT=8546
NETWORKID=2015
PASSWORD="password"

if [ -z "$1" ]
  then
    SEALER_NODES=1
fi

#fuser -k $BOOTPORT/tcp

./createaccounts.sh $SEALER_NODES $PASSWORD
#cp startminer.sh bin/
#cp getbootnodeurl.sh bin/
cd bin
#echo "---------------------------------------"
cat accounts.txt
#echo "---------------------------------------"
#cat accounts2.txt
#echo "---------------------------------------"

echo "Generating genesis.json-->Puppeth from bin Ctrl+D to exit"
puppeth

#i=1
#while read p; do
#   geth --datadir "sealernode$i"/ init genesis.json
#  ((i=$i+1))
#done<accounts.txt

#rm -rf bootnode.log
#touch bootnode.log
#rm -rf boot.key

#bootnode -genkey boot.key

#nohup bootnode -nodekey boot.key -verbosity 9 -addr :$BOOTPORT > bootnode.log &

#echo "bootnode is running"

#i=1
#while read p; do
#   echo "Run sealer $i with Account $p on port $PORT rpcport $RPCPORT"
#   fuser -k $PORT/tcp
#   fuser -k $RPCPORT/tcp
#   sleep 10
#   ./startminer.sh $i $p $PORT $RPCPORT $WSPORT $NETWORKID $SEALER_NODES
#   ((i=$i+1))
#   ((PORT=$PORT+2))
#   ((WSPORT=$WSPORT+2))
#   ((RPCPORT=$RPCPORT+4))
#done<accounts.txt

#sleep 10
#ps aux | grep node
#cat sealernode1/sealernode1.log
#echo "Setup Done. Test whether peers are attached geth attach http://localhost:8545 > admin.peers"
