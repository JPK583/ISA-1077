#!/bin/bash

ENVIORNMENT=$1
DIRECTORY=$2

#TEMP DEBUG
echo pwd; echo $ENVIORNMENT; echo $DIRECTORY;

cd "$DIRECTORY/"; for OBJECT in *.json; do
    ANNO_PRESENT="$(jq '.properties | has("annotations")' "$OBJECT")"; if [ $ANNO_PRESENT == "true" ]; then
        ENV_PRESENT="$(jq '.properties.annotations | contains(["$ENVIORNMENT"])' "$OBJECT")"; if [ $ENV_PRESENT == "true" ]; then
            echo "$OBJECT is approved for $ENVIORNMENT"
        else
            echo "$OBJECT is NOT approved for $ENVIORNMENT. It will be ignored."; pwd
        fi
    else
        echo "$OBJECT is NOT approved for $ENVIORNMENT, and has no annotations. It will be ignored."; pwd
    fi
done