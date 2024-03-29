#!/bin/bash
DIR=$(dirname "$0")
pushd $DIR

clustername=$1
while read -r line
do 
  if ! [[ "$line" =~ ^#.* ]]
  then
    short="${line##*/}.tar"
    echo "Load $line docker image in k3d $clustername cluster"
    echo "k3d image import -c $clustername 'images/$short'"
    k3d image import -c $clustername "images/$short"
  fi
done < images.txt

popd
