#!/bin/bash

MY_IP=$(ifconfig eth0 | awk '/inet/{print substr($2,1)}')
echo "This is current docker IP  $MY_IP"

echo "Your container args are: $@"

DATA_DIR="/root/.ethereum"
GEN_ARGS=

if [ "$1" == "bash" ]; then
    echo "Running bash console..."
    exec /bin/bash
fi

echo "RUN_BOOTNODE - $RUN_BOOTNODE"

if [ "$RUN_BOOTNODE" == "true" ]; then
    echo "Running bootnode..."
    KEY_FILE="/opt/bootnode/boot.key"
    mkdir -p /opt/bootnode
    if [ ! -f "$KEY_FILE" ]; then
       echo "(creating $KEY_FILE)"
       bootnode --genkey="$KEY_FILE"
    fi
    [[ -z $BOOTNODE_SERVICE ]] && BOOTNODE_SERVICE=$MY_IP
    echo "Running bootnode with arguments '--nodekey=$KEY_FILE --addr $BOOTNODE_SERVICE:30301 $@'"
    exec /usr/bin/bootnode --nodekey="$KEY_FILE" --addr "$BOOTNODE_SERVICE:30301" "$@"
else
  echo "run the redis server with 'redis-server /etc/redis/redis.conf'"
  redis-server /etc/redis/redis.conf --daemonize yes

  echo "DATA_DIR=$DATA_DIR"
  echo "DATA_DIR '$DATA_DIR' non existant or empty. Initializing DATA_DIR..."
  geth --datadir "$DATA_DIR" init /opt/genesis.json
  #$DATA_ROOT/bin/sealernode$NODECOUNT

  GEN_ARGS="--datadir $DATA_DIR"
  GEN_ARGS="$GEN_ARGS --nat=any"
  [[ ! -z $BOOTNODE_URL ]] && GEN_ARGS="--bootnodes=$BOOTNODE_URL $GEN_ARGS"

  echo "Running geth with arguments $GEN_ARGS $@"
  exec /usr/bin/geth $GEN_ARGS "$@"
fi
