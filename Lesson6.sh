#!/bin/bash
# ============================================================
# Lesson 6: Bash Arrays
# Topics covered:
#   1. Indexed array creation
#   2. Accessing elements and quoting rules
#   3. Iteration with for loops
#   4. Slicing arrays
#   5. Removing elements and compacting sparse arrays
#   6. Associative arrays
#   7. Passing arrays to functions with namerefs
#   8. Converting strings to arrays with read -ra
# ============================================================
# This lesson is intentionally verbose and heavily commented so it can
# be read like a guided tutorial. Run it with:
#   chmod +x Lesson6.sh
#   ./Lesson6.sh
#
# REQUIREMENT NOTE:
# - Associative arrays need bash 4+
# - Namerefs (declare -n) need bash 4.3+
# ============================================================


echo "============================================================"
echo "Lesson 6: Arrays in Bash"
echo "============================================================"


# ------------------------------------------------------------
# 1. INDEXED ARRAY CREATION
# ------------------------------------------------------------
# Indexed arrays store values at numeric positions: 0, 1, 2, ...
# Unlike many languages, bash arrays do not need a fixed size.
# You can create them all at once, assign an element by index,
# and append more values later.

arr=(a b c)

echo ""
echo "Section 1: Indexed array creation"
echo "Initial array: ${arr[*]}"

# Add one element at a specific numeric index.
# Since indices 0, 1, and 2 already exist, index 3 becomes the
# fourth element.
arr[3]=d
echo "After arr[3]=d: ${arr[*]}"

# Append multiple new elements to the end of the array.
arr+=(e f)
echo "After arr+=(e f): ${arr[*]}"


# ------------------------------------------------------------
# 2. ACCESSING ELEMENTS
# ------------------------------------------------------------
# Common expansions:
#   ${arr[0]}     -> first element
#   ${arr[@]}     -> all elements
#   ${arr[*]}     -> all elements
#   ${!arr[@]}    -> all assigned indices
#   ${#arr[@]}    -> number of assigned elements
#
# IMPORTANT:
# ${arr[@]} and ${arr[*]} behave very differently INSIDE double quotes.
# That is one of the most common array bugs in bash scripts.

show_words() {
    echo "Word count received: $#"
    local item
    for item in "$@"; do
        echo "- [$item]"
    done
}

echo ""
echo "Section 2: Accessing elements"
echo 'First element using ${arr[0]}:' "${arr[0]}"
echo 'Indices using ${!arr[@]}:' "${!arr[@]}"
echo 'Length using ${#arr[@]}:' "${#arr[@]}"

# To make the quoting difference obvious, we use an element that has a
# space inside it.
quote_demo=("a b" "c")

echo ""
echo "Quoting demo with quote_demo=(\"a b\" \"c\")"
echo 'Using show_words "${quote_demo[@]}"'
show_words "${quote_demo[@]}"

echo ""
echo 'Using show_words "${quote_demo[*]}"'
show_words "${quote_demo[*]}"

echo ""
echo 'Using show_words ${quote_demo[*]} (unquoted on purpose)'
# shellcheck disable=SC2086
show_words ${quote_demo[*]}

# Summary:
# - "${arr[@]}" preserves each array element as its own word.
# - "${arr[*]}" joins everything into ONE word using the first char of IFS
#   (space by default).
# - Unquoted ${arr[*]} or ${arr[@]} allows word splitting and globbing,
#   which can corrupt elements containing spaces or wildcard characters.


# ------------------------------------------------------------
# 3. ITERATION WITH for
# ------------------------------------------------------------
# The safest, most common array loop is:
#   for x in "${arr[@]}"; do ...; done
# Each element stays intact, even if it contains spaces.

echo ""
echo "Section 3: Iteration"
for x in "${arr[@]}"; do
    echo "Array item: $x"
done


# ------------------------------------------------------------
# 4. SLICING
# ------------------------------------------------------------
# Syntax:
#   ${arr[@]:start:count}
# Example:
#   ${arr[@]:2:3} -> start from index 2 and return 3 elements

echo ""
echo "Section 4: Slicing"
echo "Slice starting at index 2, count 3: ${arr[@]:2:3}"
echo "Slice starting at index 1, count 2: ${arr[@]:1:2}"


# ------------------------------------------------------------
# 5. REMOVING ELEMENTS
# ------------------------------------------------------------
# unset arr[idx] removes ONE element, but it does not shift the rest.
# That means bash arrays can become sparse.
# Sparse arrays have gaps in their numeric indices.

echo ""
echo "Section 5: Removing elements"
sparse=("zero" "one" "two" "three")
echo "Before unset: indices=${!sparse[@]} values=${sparse[*]}"

unset 'sparse[1]'
echo "After unset 'sparse[1]': indices=${!sparse[@]} values=${sparse[*]}"

# To rebuild a compact array with consecutive indices, reassign from the
# element list. Quoted ${array[@]} preserves each remaining element.
compact=("${sparse[@]}")
echo "Compacted copy: indices=${!compact[@]} values=${compact[*]}"


# ------------------------------------------------------------
# 6. ASSOCIATIVE ARRAYS
# ------------------------------------------------------------
# Associative arrays use string keys instead of numeric indices.
# Think of them as key/value maps or dictionaries.
# They must be declared with: declare -A name

declare -A map
map[name]="bash"
map[level]="intermediate"
map[topic]="arrays"

echo ""
echo "Section 6: Associative arrays"
echo "map[name] = ${map[name]}"
echo "map[level] = ${map[level]}"
echo 'Keys using ${!map[@]}:' "${!map[@]}"

echo "Iterating over key/value pairs:"
for key in "${!map[@]}"; do
    echo "$key => ${map[$key]}"
done


# ------------------------------------------------------------
# 7. PASSING ARRAYS TO FUNCTIONS (BY NAME)
# ------------------------------------------------------------
# Bash does not pass arrays to functions the same way many other
# languages do. A clean modern pattern is to pass the ARRAY NAME and
# use a nameref inside the function.
#
# declare -n ref=$1 means:
#   ref becomes a reference to the variable whose name is stored in $1
#
# This requires bash 4.3+

print_array_details() {
    local array_name=$1
    declare -n ref=$array_name

    echo "Array name received: $array_name"
    echo "Array length: ${#ref[@]}"

    local value
    for value in "${ref[@]}"; do
        echo "-> $value"
    done
}

echo ""
echo "Section 7: Passing arrays to functions by name"
print_array_details arr


# ------------------------------------------------------------
# 8. STRING -> ARRAY WITH read -ra, THEN PRINT/JOIN SAFELY
# ------------------------------------------------------------
# read -ra splits a string into array elements using IFS.
# -r : do not treat backslashes specially
# -a : assign words into an array
#
# Here we split on spaces.

line="red green blue yellow"
read -ra colors <<< "$line"

echo ""
echo "Section 8: Converting a string to an array"
echo "Source string: $line"
echo "Array length after read -ra: ${#colors[@]}"

# printf '%s\n' prints each element on its own line.
# This is a very safe way to emit array items without accidental
# word splitting.
echo "Printing elements with printf '%s\\n':"
printf '%s\n' "${colors[@]}"

# If you want a single delimiter-separated display, you can combine the
# array into one string intentionally. We keep this as an extra example.
(
    IFS=:
    echo "Joined with colon for display: ${colors[*]}"
)


echo ""
echo "Lesson 6 complete: array examples finished running."
