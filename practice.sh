#!/bin/bash

function name {
    echo "Function called: $0"
    echo "My name is ${2:-Hitesh}"
}


# read -p "Enter your name: " nameI
# name $name

function factorial(){
    local num=$1
    if ((num <= 1));then
        echo 1
        return 0
    fi 

local smaller
smaller="$(factorial $(($num-1)))"
echo $((num*smaller))
}

factorial 5

# echo $fac

function name() {
    echo "Hitesh"
}

printf "My name is: %s\n" "$(name)"