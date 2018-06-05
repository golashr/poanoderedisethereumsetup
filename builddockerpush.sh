#!/bin/sh

IMGVERSION=$(head -n 1 IMGVERSION)
IMGVERSION=${IMGVERSION:-"latest"}
IMGNAME=$(head -n 1 IMGNAME)

echo "building $IMGNAME:$IMGVERSION with local Dockerfile"
docker build -t $IMGNAME:$IMGVERSION .

echo "pushing built image golra03/ethereum-poa to remote Docker hub"
docker push $IMGNAME:$IMGVERSION
