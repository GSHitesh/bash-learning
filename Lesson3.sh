#!/bin/bash
# ============================================================
# Lesson 3: Loops
# Topics covered:
#   1. for loop (list form)
#   2. for loop (C-style)
#   3. while loop
#   4. until loop
#   5. break and continue
#   6. Looping over command output and arrays
# ============================================================


# ------------------------------------------------------------
# 1. FOR LOOP (List Form)
# ------------------------------------------------------------
# A basic "for" loop walks through a list of values one by one.
# Syntax:
#   for VARIABLE in item1 item2 item3
#   do
#       commands
#   done
#
# Here, the variable "fruit" becomes apple, then banana,
# then cherry.

for fruit in apple banana cherry
 do
    echo "Fruit from list loop: $fruit"
 done


echo ""


# ------------------------------------------------------------
# 2. FOR LOOP (C-style)
# ------------------------------------------------------------
# Bash also supports a C-like loop syntax.
# Syntax:
#   for ((initialization; condition; increment))
#   do
#       commands
#   done
#
# This is useful when you want a numeric counter.

for ((i=0; i<5; i++))
do
    echo "C-style loop counter: $i"
done


echo ""


# ------------------------------------------------------------
# 3. WHILE LOOP
# ------------------------------------------------------------
# A "while" loop keeps running as long as the condition is true.
# It is commonly used with counters, input processing, and files.

# Example A: while loop with a counter
count=1
while [ $count -le 3 ]
do
    echo "While loop counter: $count"
    ((count++))
done
₹₹

echo ""

# Example B: while loop reading lines from a multi-line variable
# "read" pulls one line at a time. The "-r" option prevents
# backslash escaping from being interpreted.
multiline_var=$'red\nblue\ngreen'
while read -r line
do
    echo "Line read by while loop: $line"
done <<< "$multiline_var"


echo ""


# ------------------------------------------------------------
# 4. UNTIL LOOP
# ------------------------------------------------------------
# An "until" loop is the opposite of "while".
# It keeps running UNTIL the condition becomes true.
# In other words, it runs while the condition is false.

number=1
until [ $number -gt 3 ]
do
    echo "Until loop number: $number"
    ((number++))
done


echo ""


# ------------------------------------------------------------
# 5. BREAK AND CONTINUE
# ------------------------------------------------------------
# "continue" skips the rest of the current iteration and moves
# to the next one.
# "break" exits the loop immediately.

for ((j=1; j<=5; j++))
do
    if [ $j -eq 2 ]
    then
        echo "Skipping iteration $j with continue"
        continue
    fi

    if [ $j -eq 4 ]
    then
        echo "Stopping loop early at $j with break"
        break
    fi

    echo "Processing value: $j"
done


echo ""


# ------------------------------------------------------------
# 6. LOOPING OVER COMMAND OUTPUT AND ARRAYS
# ------------------------------------------------------------
# Example A: Looping over command output
# This classic form captures command output and iterates over it:
#   for f in $(ls *.sh 2>/dev/null)
#
# IMPORTANT: This style splits on whitespace, so filenames with
# spaces can break into multiple pieces.
# For filenames, prefer arrays, globbing, or a while read loop.

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
for f in $(cd "$script_dir" && ls *.sh 2>/dev/null)
do
    echo "Script found from command output: $f"
done


echo ""

# Example B: Looping over an array
# Arrays are safer because each element stays intact when quoted
# as "${arr[@]}".
arr=(a b c)
for x in "${arr[@]}"
do
    echo "Array value: $x"
done


echo ""

# Quoting-safety note:
# - Prefer arrays when you already have structured values.
# - Prefer while read -r when processing lines or filenames.
# - Be careful with command substitution in loops when values may
#   contain spaces.

echo "Lesson 3 complete: loop examples finished running."
