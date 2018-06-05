#/bin/bash

echo "***Creating bin***"
SEALER_NODES=$1
PASSWORD=$2

mkdir -p bin
cp startgeth.sh bin/
cd bin
#rm -rf *

i=1
while [ $i -le $SEALER_NODES ] ;
do
  echo "Created sealernode$i"
  mkdir  "sealernode$i"
  ((i=$i+1))
done

echo "***Creating accounts for sealer  node***"
echo "password">password.txt

i=1
while [ $i -le $SEALER_NODES ] ;
do
   geth --datadir sealernode$i/.ethereum account new --password password.txt >> accounts.txt
   ((i=$i+1))
done
echo "Creating Genesis File"

sed -i -e 's/Address: {//g' accounts.txt
sed -i -e 's/}//g' accounts.txt

echo "Accounts are created into accounts.txt and accounts2.txt in bin"
