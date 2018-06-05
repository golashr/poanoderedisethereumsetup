#!/bin/bash

IMGVERSION=$(head -n 1 IMGVERSION)
IMGVERSION=${IMGVERSION:-"latest"}
IMGNAME=$(head -n 1 IMGNAME)
NODE_NAME=$1
RPC_PORT=$2
PORT=$3
WSPORT=$4
ACCOUNT=$5
NODECOUNT=$6
#SEALER_NODES=$7
NETWORKID=$7
NETWORK_NAME=$8
RPC_ARG=

NODE_NAME=${NODE_NAME:-"CASHe-node1"}
CONTAINER_NAME="$NODE_NAME"
DATA_ROOT=${DATA_ROOT:-$(pwd)}
echo "Destroying old container $CONTAINER_NAME..."
sudo docker stop $CONTAINER_NAME
sudo docker rm $CONTAINER_NAME

if [ ! -z $RPC_PORT ];then
RPC_ARG="--syncmode full --networkid $NETWORKID --gasprice "1" --unlock $ACCOUNT --password "/opt/password.txt" --mine --targetgaslimit 90000000000 --port $PORT --rpc --rpcaddr=0.0.0.0 --rpccorsdomain '"http://localhost:8000"' --rpcport $RPC_PORT --rpcapi=admin,personal,db,eth,net,web3,txpool,miner,clique --ws --wsorigins '"*"' --wsport $WSPORT --cache=1024 --verbosity=4 --maxpeers=10"
RPC_PORTMAP="-p $RPC_PORT:$RPC_PORT -p $PORT:$PORT -p $WSPORT:$WSPORT -p 8000:8000"
fi

if [ ! -z $UDP_PORT ];then
UDP_PORTMAP="-p $UDP_PORT:30303 -p $UDP_PORT:30303/udp"
fi

echo "RPC_PORT - $RPC_PORT"
echo "UDP_PORT - $UDP_PORT"
echo "RPC_ARG - $RPC_ARG"
echo "RPC_PORTMAP - $RPC_PORTMAP"
echo "UDP_PORTMAP - $UDP_PORTMAP"

BOOTNODE_URL=${BOOTNODE_URL:-$(./getbootnodeurl.sh)}
echo "Running new container $CONTAINER_NAME..."
sudo docker run -d --name $CONTAINER_NAME \
    -v $DATA_ROOT/bin/sealernode$NODECOUNT:/root \
    -v $DATA_ROOT/bin/:/opt \
    --network $NETWORK_NAME \
    -e "BOOTNODE_URL=$BOOTNODE_URL" \
    $RPC_PORTMAP $UDP_PORTMAP \
    $IMGNAME:$IMGVERSION --identity $NODE_NAME $RPC_ARG
  #  $IMGNAME:$IMGVERSION $RPC_ARG --identity $NODE_NAME --cache=1024 --verbosity=4 --maxpeers=10 ${@:2}
