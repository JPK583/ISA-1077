#!/bin/bash

ENVIRONMENT=$1

#List of names for features which contain proper annotation.
FEAT_ARRAY=()

#Colors
BROWN='\033[0;33m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

cd "pipeline"

echo -e "Checking ${PURPLE}pipeline${NC} file for ${PURPLE}$ENVIRONMENT${NC} annotation."

#Goes through each .json file in the pipline directory. 
#NOTE: Files in pipeline directory aren't actually stored in files and instead have a .json annotation denoting which folder they are in.
#If the pipeline file does not have the proper annotation it will not be included in feat_array and .ignore'd.

for OBJECT in *.json; do
    ANNO_PRESENT="$(jq '.properties | has("annotations")' "$OBJECT")"
    if [ "$ANNO_PRESENT" == "true" ]; then
        ENV_PRESENT="$(jq --arg env "$ENVIRONMENT" '.properties.annotations | contains([$env])' "$OBJECT")"
        if [ "$ENV_PRESENT" == "false" ]; then
            echo -e "${BROWN}$OBJECT${NC} ${RED}NOT annotated as ready for${NC} ${PURPLE}$ENVIRONMENT${NC}${RED}.${NC}"
            echo -e "${RED}This pipeline and any other item which shares it's name or is included in a folder which does will be ignored.${NC}"
            FEAT_ARRAY+=("$(jq '.properties.folder.name' "$OBJECT" | cut -d '/' -f 1)\"")
            mv "$OBJECT" "$OBJECT.ignore"
        fi
    else
        FEAT_ARRAY+=("$(jq '.properties.folder.name' "$OBJECT" | cut -d '/' -f 1)\"")
        echo -e "${RED}Annotations field not present for${NC} ${BROWN}$OBJECT${NC}${RED}.${NC}"
        echo -e "${BROWN}$OBJECT${NC} ${YELLOW}will be infered as not in${NC} ${PURPLE}$ENVIRONMENT${NC}${YELLOW} and ignored.${NC}"
        mv "$OBJECT" "$OBJECT.ignore"
    fi
done
cd ..

#UNIQUE ELEMENTS
FEAT_ARRAY=($(printf "%s\n" "${FEAT_ARRAY[@]}" | sort -u))

#DIRECTORIES TO BE SEARCHED
FOLDER_ARRAY=("dataset" "dataflow")

echo -en "Checking following folders: "
for LOCATION in "${FOLDER_ARRAY[@]}"; do
    echo -en "${BROWN}$LOCATION${NC} "
done
echo

#This goes through any other files in other directories listed in folder_array.
#If the name of the folder in which an item is stored is not included in feat_array it will be .ignored.
#If the file is not stored in a folder, the name of the file itself will be compared.
for FOLDER in "${FOLDER_ARRAY[@]}"; do
    cd $FOLDER
    echo -e "Checking: ${PURPLE}$FOLDER${NC}."
    for OBJECT in *.json; do
        FOLDER_PRESENT="$(jq '.properties | has("folder")' "$OBJECT")"
        if [ "$FOLDER_PRESENT" == "true" ]; then
            FEAT_NAME="$(jq '.properties.folder.name' "$OBJECT" | cut -d '/' -f 1)\""
            echo -e "${PURPLE}$FOLDER${NC}: ${BROWN}$OBJECT${NC} located within ${BROWN}$FEAT_NAME${NC}."
        else
            FEAT_NAME=$(basename "$OBJECT" .json)
            echo -e "${PURPLE}$FOLDER${NC}: ${BROWN}$OBJECT${NC} ${RED}NOT${NC} ${YELLOW}present in a folder${NC}. ${BROWN}$FEAT_NAME${NC} ${YELLOW}will be used instead.${NC}"
        fi
        if [[ ${FEAT_ARRAY[@]} =~ $FEAT_NAME ]]; then
            echo -e "${BROWN}$FEAT_NAME${NC} ${RED}NOT marked ready for${NC} ${PURPLE}$ENVIRONMENT${NC} ${BROWN}$OBJECT${NC} ${RED}will be ignored.${NC}"
            mv "$OBJECT" "$OBJECT.ignore"
        fi
    done
    cd ..
done