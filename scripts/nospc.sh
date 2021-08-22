#!/bin/bash

#Remove space in filenames

while [[ "$1" != "" ]]; do
    echo mv "$1" "$(ls -1 "$1" | sed 's/ /_/g')"
    mv "$1" "$(ls -1 "$1" | sed 's/ /_/g')"
    shift
done
