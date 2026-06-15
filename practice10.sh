#!/bin/bash

# Error Handling and Debugging

set -uo pipefail
value=$(grep -i "content" out.txt | cut -d 'e' -f1 ) || die "$0 SOURCE"

echo $value
# x=2

# echo $xy

sleep 1

function die ()
{
    echo "Unrecoverable error" > /dev/stderr
    echo "$@"
    echo "$*"
    # exit 1;
}

die


release=3.0.32

if [[ $release =~ ^3\.[(0-9)+]\.([0-9]+)$ ]]; then
    echo "release is a match"
    echo "${BASH_REMATCH[0]}"
else
    echo "release is not a match"
fi


## Module 11 Advanced Patterns


source practice.sh

echo "BASH SOURCE: ${BASH_SOURCE[1]}"
