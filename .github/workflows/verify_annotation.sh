#!/bin/bash

ENVIORNMENT=$1
DIRECTORY=$2
DIR_ARRAY=()
#DIR_ARRAY+=("New_Path")

cd "$DIRECTORY"; for OBJECT in *.json; do
    ANNO_PRESENT="$(jq '.properties | has("annotations")' "$OBJECT")"; if [ $ANNO_PRESENT == "true" ]; then
        ENV_PRESENT="$(jq '.properties.annotations | contains(["$ENVIORNMENT"])' "$OBJECT")"; if [ $ENV_PRESENT == "true" ]; then
            DIR_ARRAY+=(pwd); break
done

for PATH in DIR_ARRAY; do
    echo PATH;
done