#!/bin/bash

ENVIRONMENT=$1
DIRECTORY=$2
FEAT_ARRAY=()

#TEMP directory is "pipeline"

#echo $ENVIRONMENT; echo $DIRECTORY

cd "$DIRECTORY"

for OBJECT in *.json; do
    ANNO_PRESENT="$(jq '.properties | has("annotations")' "$OBJECT")"
    if [ "$ANNO_PRESENT" == "true" ]; then
        ENV_PRESENT="$(jq --arg env "$ENVIRONMENT" '.properties.annotations | contains([$env])' "$OBJECT")"
        if [ "$ENV_PRESENT" == "false" ]; then
            FEAT_ARRAY+=("$(jq '.properties.folder.name' "$OBJECT" | cut -d '/' -f 1)\"")
            echo "TEMP IGNORE $OBJECT" #mv "$OBJECT" "$OBJECT.ignore"
        fi
    fi
done
cd ..

echo "TEMP FEAT_ARRAY:"

for ITEM in "${FEAT_ARRAY[@]}"; do
    echo $ITEM
done 