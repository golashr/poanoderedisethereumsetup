#!/bin/bash
ENODE_LINE=$(sudo docker logs ethereum-bootnode 2>&1 | grep enode: | head -n 1 | sed -e 's/INFO.*self=//g')
echo "enode:${ENODE_LINE#*enode:}"


