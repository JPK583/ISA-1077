#!/bin/bash

ENVIRONMENT=$1
DIRECTORY=$2
#FEATURE=$3
FEAT_ARRAY=()
#FEAT_ARRAY+=("New_Path")

echo $DIRECTORY; echo $FEATURE

cd "$DIRECTORY"
for FOLDER in *; do
    cd $FOLDER
    FEAT=("$(pwd)")
    for OBJECT in *.json; do
        ANNO_PRESENT="$(jq '.properties | has("annotations")' "$OBJECT")"
        if [ "$ANNO_PRESENT" == "true" ]; then
            ENV_PRESENT="$(jq --arg env "$ENVIRONMENT" '.properties.annotations | contains([$env])' "$OBJECT")"
            if [ "$ENV_PRESENT" == "true" ]; then
                FEAT_ARRAY+=$FEAT
                break
            fi
        fi
    done
    cd ..
done

echo "TEMP FEAT_ARRAY:"

for ITEM in "${FEAT_ARRAY[@]}"; do
    echo $ITEM;
done