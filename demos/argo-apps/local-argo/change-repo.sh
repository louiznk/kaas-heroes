#!/bin/bash
set +x

DIR=$(dirname $0)

REPO="$(echo $1 | sed -e 's/[\/&]/\\&/g')"

for FILE in `grep --include=*.yml --include=*.yaml -rnw "$DIR" -e "repoURL" -l`
do
    echo "🪄 Update $FILE"
    sed -i "s/repoURL:.*/repoURL: '$REPO'/g" "$FILE"
done
