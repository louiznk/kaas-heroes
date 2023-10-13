#!/bin/bash
DIR=$(dirname "$0")
pushd $DIR

clustername=$1
while read -r line
do 
  if ! [[ "$line" =~ ^#.* ]]
  then
    short="${line##*/}.tar"
    echo "Load $line docker image in kind cluster"
    #kind load image-archive "images/$short" --name $clustername
    kind load docker-image "$line" --name $clustername
  fi
done < images.txt

popd
