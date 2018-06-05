#!/bin/sh
#
# Runs a bootnode
#
# If there is a NET_ID variable it is passed on to the container.
#
sudo docker stop ethereum-bootnode
sudo docker rm ethereum-bootnode
IMGVERSION=$(head -n 1 IMGVERSION)
IMGVERSION=${IMGVERSION:-"latest"}
IMGNAME=$(head -n 1 IMGNAME)
NETWORK_NAME=$1

DATA_ROOT=${DATA_ROOT:-$(pwd)}
sudo docker run -d --name CASHe-bootnode \
    -v $DATA_ROOT/bin/.bootnode:/opt/bootnode \
    --network $NETWORK_NAME \
    -e "RUN_BOOTNODE=true" \
    $IMGNAME:$IMGVERSION
# --verbosity=5
