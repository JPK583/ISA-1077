#!/bin/bash

ENVIRONMENT=$1
FEAT_ARRAY=()

#TEMP directory is "pipeline"

#echo $ENVIRONMENT; echo $DIRECTORY

cd "pipeline"

for OBJECT in *.json; do
    ANNO_PRESENT="$(jq '.properties | has("annotations")' "$OBJECT")"
    if [ "$ANNO_PRESENT" == "true" ]; then
        ENV_PRESENT="$(jq --arg env "$ENVIRONMENT" '.properties.annotations | contains([$env])' "$OBJECT")"
        if [ "$ENV_PRESENT" == "false" ]; then
            FEAT_ARRAY+=("$(jq '.properties.folder.name' "$OBJECT" | cut -d '/' -f 1)\"")
            echo "TEMP WRONG ENV IGNORE $OBJECT" #mv "$OBJECT" "$OBJECT.ignore"
        fi
    else
        FEAT_ARRAY+=("$(jq '.properties.folder.name' "$OBJECT" | cut -d '/' -f 1)\"")
        echo "TEMP NO ANNOTATION IGNORE $OBJECT" #mv "$OBJECT" "$OBJECT.ignore"
    fi
done
cd ..

#TODO I don't really like how this is done but if a I put in a check for dupes in the previous for loop it will have n^2 complexity and this is linear.
#Remove duplicates

echo "feat array"

for ITEM in "${FEAT_ARRAY[@]}"; do
    echo $ITEM
done

#UNIQUE ELEMENTS

echo "unique feat array"

FEAT_ARRAY=($(printf "%s\n" "${FEAT_ARRAY[@]}" | sort -u))

for ITEM in "${FEAT_ARRAY[@]}"; do
    echo $ITEM
done

#FOLDER_ARRAY=("dataset" "dataflow")
FOLDER_ARRAY=("dataset")

for FOLDER in "${FOLDER_ARRAY[@]}"; do
    cd $FOLDER
    for OBJECT in *.json; do
        FOLDER_PRESENT="$(jq '.properties | has("folder")' "$OBJECT")"
        if [ "$FOLDER_PRESENT" == "true" ]; then
            FEAT_NAME="$(jq '.properties.folder.name' "$OBJECT" | cut -d '/' -f 1)\""
            if [[ $FEAT_ARRAY[@] =~ $FEAT_NAME ]]; then
                echo "TEMP FOLDER MATCHES! IGNORE $OBJECT, FEAT $FEAT_NAME" #NOTE TO FUTURE SELF NONE OF THE DATASETS HAVE DIR3 THIS WORKS
            fi
        else
            echo "Do something here later"
            #IF FOLDER IS NOT PRESENT CHECK TO SEE IF .json NAME IS INCLUDED IN FEAT_ARRAY HERE AND THEN IGNORE
        fi
    done
    cd ..
done