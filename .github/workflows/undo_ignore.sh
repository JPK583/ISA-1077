#!/bin/bash

BROWN='\033[0;33m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

FOLDER_ARRAY=("pipeline" "dataset" "dataflow")

echo -en "Checking following folders: "

for LOCATION in "${FOLDER_ARRAY[@]}"; do
    echo -en "${BROWN}$LOCATION${NC} "
done

echo

for FOLDER in "${FOLDER_ARRAY[@]}"; do
    cd $FOLDER
    echo -e "Checking: ${PURPLE}$FOLDER${NC}."
    for OBJECT in *.ignore; do
        NO_IGNORE=$(basename "$OBJECT" .ignore)
        #echo $NO_IGNORE
        mv "$OBJECT" "$NO_IGNORE"
    done
    cd ..
done