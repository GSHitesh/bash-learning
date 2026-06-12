#!/bin/bash

arr=(a b c)
for a in ${arr[@]}
do
    echo -e "$a \n"
done
echo $arr
arr[3]=d
echo $arr
arr+=(e f)
echo ${arr[@]:1:2}


declare -A marks
marks[english]=86
marks[hindi]=90

echo ${marks[hindi]}

echo ${marks[@]}

echo ${!marks[@]}

echo ${!marks[*]}


echo ${#marks[@]}



#==========================================================

#Regex

name="Sai hitesh"
echo ${name^}

echo ${name^^}

echo ${name: -4:3}

trap 'echo "Exit abrupt"' INT TERM

function work()
{
    sleep 2
}

pid=()
for id in 1 2 3; 
do
    work $id &
    pid+=("$!")
done


for p in $"${pid[@]}";
do
    echo $p
    wait $p
done