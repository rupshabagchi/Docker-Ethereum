#!/bin/bash

MY_IP=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')
GEN_ARGS=

if [ "$1" == "bash" ]; then
    echo "Running bash console..."
    exec /bin/bash
fi

# replace vars
if [[ ! -z $GEN_NONCE ]]; then
    echo "Generating genesis.nonce from arguments..."
    sed "s/\${GEN_NONCE}/$GEN_NONCE/g" -i /opt/genesis.json
fi
echo "Generating genesis.alloc from arguments..."
sed "s/\${GEN_ALLOC}/$GEN_ALLOC/g" -i /opt/genesis.json

echo "Running ethereum node with CHAIN_TYPE=$CHAIN_TYPE"
if [ "$CHAIN_TYPE" == "private" ]; then
  # empty datadir -> geth init
  DATA_DIR=${DATA_DIR:-"/root/.ethereum"}
  echo "DATA_DIR=$DATA_DIR"
  if [ ! -d "$DATA_DIR" ] || [ -d "ls -A $DATA_DIR" ]; then
      echo "DATA_DIR '$DATA_DIR' non existant or empty. Initializing DATA_DIR..."
      geth --datadir "$DATA_DIR" init /opt/genesis.json
  fi
  GEN_ARGS="--datadir $DATA_DIR"
  [[ ! -z $NET_ID ]] && GEN_ARGS="$GEN_ARGS --networkid=$NET_ID"
#  [[ ! -z $MY_IP ]] && GEN_ARGS="$GEN_ARGS --nat=extip:$MY_IP"
  [[ ! -z $BOOTNODE_URL ]] && GEN_ARGS="--bootnodes=$BOOTNODE_URL $GEN_ARGS"
fi

if [ "$RUN_BOOTNODE" == "true" ]; then
    echo "Running bootnode..."
    KEY_FILE="/opt/bootnode/boot.key"
    mkdir -p /opt/bootnode
    if [ ! -f "$KEY_FILE" ]; then
       echo "(creating $KEY_FILE)"
       bootnode --genkey="$KEY_FILE"
    fi
    echo "Running bootnode with arguments '--nodekey=$KEY_FILE --addr $MY_IP:30301 $@'"
    exec /usr/bin/bootnode --nodekey="$KEY_FILE" --addr "$MY_IP:30301" "$@"
fi

echo "Running geth with arguments $GEN_ARGS $@"
exec /usr/bin/geth $GEN_ARGS "$@"

