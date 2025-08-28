#!/bin/bash

ENVIORNMENT=$1
DIRECTORY=$2
FEATURE=$3
FEAT_ARRAY=()
#FEAT_ARRAY+=("New_Path")

echo $DIRECTORY; echo $FEATURE

cd "$DIRECTORY/$FEATURE"; for OBJECT in *.json; do
    ANNO_PRESENT="$(jq '.properties | has("annotations")' "$OBJECT")"; if [ $ANNO_PRESENT == "true" ]; then
        echo "Has annotations file"; ENV_PRESENT="$(jq '.properties.annotations | contains(["$ENVIORNMENT"])' "$OBJECT")"; if [ $ENV_PRESENT == "true" ]; then
            echo "Annotation Present"; FEAT_ARRAY+=(pwd); break
        fi
    fi
done

echo "TEMP FEAT_ARRAY:"

for ITEM in "${FEAT_ARRAY[@]}"; do
    echo $ITEM;
done