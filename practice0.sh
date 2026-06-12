#!/bin/bash

#Module 1: Basics of Shell Scripting


# echo "Hello World"

# echo $0

# echo $@

# echo $#

# echo "$*"

# echo "========================="


# read -p "How old are you:" age

# echo "Age: $age"


#================================================

#Module 2: Conditional Statements

# read -p "Enter marks: " marks

# if [ $marks -gt 80 ]; then
#     echo "$marks: A grade"
# elif [ $marks -ge 70 ]; then
#     echo "$marks: B grade"
# else
#     echo "$marks: C grade"
# fi


# file_name="sample.txt"
# path=`pwd`

# if [[ $file_name == *.txt && -s $path/$file_name ]]; then 
#     echo "$file_name is present"
# else
#     echo "No file found"
# fi

# read -p "Enter the file extension: " file_type

# case "$file_type" in
# \.txt|\.tx) echo "txt file";;
# \.log)
#     echo "log file";;
# \.sh)
#     echo "bash file";;
# *) 
#     echo "Unknown file";;
# esac


#=================================================

#Module 3 - Loops

# names=("Hitesh" "Ramesh" "Suresh" "Rakesh" "Lokesh" "Raju")

# for name in ${names[@]}
# do
#     echo -e "Hello $name\n"
# done


# num=2
# while ((  $num <= 10 && $num % 2 == 0 ))
# do    
#     echo "$num"
#     ((num+=2))
# done

# num=3
# while ((  $num <= 10))
# do    
#     echo "$num"
    
#     [[ $num -eq 4 ]] && continue
#     [[ $num -eq 6 ]] && break
#     ((num+=3))
# done


while IFS=: read -r line
do
    echo "$line"
done < sample.txt