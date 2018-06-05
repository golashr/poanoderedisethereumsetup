#!/bin/sh
#docker stop $(docker ps -q -f name=ethereum)
#docker rm $(docker ps -aq -f name=ethereum)

docker stop $(docker ps -q -f name=CASHe)
docker rm $(docker ps -aq -f name=CASHe)

rm -rf ./bin/.bootnode
rm -rf ./bin/sealernode1
rm -rf ./bin/sealernode2
rm -rf ./bin/sealernode3
rm -rf ./bin/password.txt
rm -rf ./bin/accounts.txt
rm -rf ./bin/accounts.txt-e
rm -rf ./bin/genesis.json
