#!/bin/bash
# ============================================================
# Lesson 2: Bash Conditionals
# Topics covered:
#   1. if / elif / else basic syntax
#   2. [ ... ] vs [[ ... ]]
#   3. Numeric and string comparisons
#   4. File test operators
#   5. case statement
#   6. Interactive branching with read -p
# ============================================================


# ------------------------------------------------------------
# 1. IF / ELIF / ELSE BASIC SYNTAX
# ------------------------------------------------------------
# The if statement lets bash make decisions.
# Basic structure:
#   if CONDITION
#   then
#       commands
#   elif ANOTHER_CONDITION
#   then
#       commands
#   else
#       commands
#   fi
#
# "fi" closes the if block (it is "if" written backwards).
# Below we assign a variable inside the script so the example is
# completely self-contained and works even when no CLI arguments
# are provided.

marks=75

echo "Section 1: Checking marks = $marks"

if [ "$marks" -ge 90 ]; then
    echo "Grade: A"
elif [ "$marks" -ge 60 ]; then
    echo "Grade: B"
else
    echo "Grade: C"
fi


# ------------------------------------------------------------
# 2. [ ... ] vs [[ ... ]]
# ------------------------------------------------------------
# [ ... ] is the POSIX test syntax. It is portable and widely used.
# [[ ... ]] is bash's extended test syntax. It adds extra features
# such as pattern matching and safer handling in many cases.
#
# IMPORTANT QUOTING RULE:
# With [ ... ], always quote variables unless you intentionally want
# word splitting or pathname expansion.
# Example: [ "$value" = "hello world" ]
#
# [[ ... ]] is usually safer for strings because bash does not perform
# word splitting or pathname expansion there in the same way. Even so,
# quoting variables is still a good habit when you want exact values.

text_with_spaces="hello world"
file_name="notes.txt"

echo ""
echo "Section 2: Comparing text using [ ] and [[ ]]"

if [ "$text_with_spaces" = "hello world" ]; then
    echo "[ ] example: quoted comparison works correctly with spaces"
else
    echo "[ ] example: comparison failed"
fi

# In [[ ... ]], the right-hand side of == can be treated as a pattern.
# Here *.txt matches any string ending in .txt.
if [[ $file_name == *.txt ]]; then
    echo "[[ ]] example: pattern matching works, so $file_name matches *.txt"
else
    echo "[[ ]] example: pattern match failed"
fi

# With [ ... ], using quotes makes the right-hand side literal.
if [ "$file_name" = "*.txt" ]; then
    echo "[ ] example: literal string matched *.txt"
else
    echo "[ ] example: quoted *.txt is treated literally, so it does not match $file_name"
fi


# ------------------------------------------------------------
# 3. NUMERIC COMPARISONS VS STRING COMPARISONS
# ------------------------------------------------------------
# Numeric operators:
#   -eq  equal
#   -ne  not equal
#   -lt  less than
#   -le  less than or equal
#   -gt  greater than
#   -ge  greater than or equal
#
# String operators:
#   =    equal
#   !=   not equal
#   <    comes before alphabetically (best used inside [[ ]])
#   >    comes after alphabetically (best used inside [[ ]])
#   -z   string length is zero (empty string)
#   -n   string length is not zero
#
# Do not mix them up:
#   [ "$a" -lt "$b" ]   -> numeric comparison
#   [[ "$a" < "$b" ]] -> string/alphabetical comparison

count_a=10
count_b=20
word_a="apple"
word_b="banana"
filled_text="bash"
empty_text=""

echo ""
echo "Section 3: Numeric comparisons"

if [ "$count_a" -eq 10 ]; then
    echo "$count_a -eq 10 is true"
fi

if [ "$count_a" -ne "$count_b" ]; then
    echo "$count_a -ne $count_b is true"
fi

if [ "$count_a" -lt "$count_b" ]; then
    echo "$count_a -lt $count_b is true"
fi

if [ "$count_a" -le 10 ]; then
    echo "$count_a -le 10 is true"
fi

if [ "$count_b" -gt "$count_a" ]; then
    echo "$count_b -gt $count_a is true"
fi

if [ "$count_b" -ge 20 ]; then
    echo "$count_b -ge 20 is true"
fi

echo ""
echo "Section 3: String comparisons"

if [ "$word_a" = "apple" ]; then
    echo "$word_a = apple is true"
fi

if [ "$word_a" != "$word_b" ]; then
    echo "$word_a != $word_b is true"
fi

# Use [[ ]] for < and > so bash treats them as string comparisons
# instead of shell redirection operators.
if [[ "$word_a" < "$word_b" ]]; then
    echo "$word_a comes before $word_b alphabetically"
fi

if [[ "$word_b" > "$word_a" ]]; then
    echo "$word_b comes after $word_a alphabetically"
fi

if [ -n "$filled_text" ]; then
    echo "-n check: '$filled_text' is not empty"
fi

if [ -z "$empty_text" ]; then
    echo "-z check: empty_text is empty"
fi


# ------------------------------------------------------------
# 4. FILE TEST OPERATORS
# ------------------------------------------------------------
# Common file test operators:
#   -f  file exists and is a regular file
#   -d  path exists and is a directory
#   -e  path exists (file, directory, symlink, etc.)
#   -r  path is readable
#   -w  path is writable
#   -x  path is executable
#
# We use the current script path and its directory so the checks are
# reliable and do not depend on external arguments.

script_path="${BASH_SOURCE[0]}"
script_dir="$(cd "$(dirname "$script_path")" && pwd)"
missing_path="$script_dir/this-path-does-not-exist"

echo ""
echo "Section 4: File and directory tests"

if [ -f "$script_path" ]; then
    echo "-f check: $script_path exists and is a regular file"
fi

if [ -d "$script_dir" ]; then
    echo "-d check: $script_dir exists and is a directory"
fi

if [ -e "$script_path" ]; then
    echo "-e check: $script_path exists"
fi

if [ -r "$script_path" ]; then
    echo "-r check: $script_path is readable"
fi

if [ -w "$script_path" ]; then
    echo "-w check: $script_path is writable"
fi

if [ -x "$script_path" ]; then
    echo "-x check: $script_path is executable"
else
    echo "-x check: $script_path is not executable yet"
fi

if [ ! -e "$missing_path" ]; then
    echo "Extra example: $missing_path does not exist"
fi


# ------------------------------------------------------------
# 5. CASE STATEMENT
# ------------------------------------------------------------
# The case statement is useful when one value can match one of many
# patterns. It is often cleaner than a long chain of if / elif checks.
#
# Syntax:
#   case "$value" in
#       pattern1)
#           commands
#           ;;
#       pattern2|pattern3)
#           commands
#           ;;
#       *)
#           default commands
#           ;;
#   esac
#
# The *) pattern is the default case.

echo ""
echo "Section 5: case statement examples"

for action in start reload pause; do
    case "$action" in
        start|run|up)
            echo "Action '$action': starting the service"
            ;;
        stop|down)
            echo "Action '$action': stopping the service"
            ;;
        restart|reload)
            echo "Action '$action': reloading the service"
            ;;
        *)
            echo "Action '$action': unknown command (default case)"
            ;;
    esac
done


# ------------------------------------------------------------
# 6. INTERACTIVE EXAMPLE WITH read -p
# ------------------------------------------------------------
# read -p shows a prompt and stores what the user types.
# Since this script may be run with input redirected from /dev/null,
# we check whether read succeeds. If it gets EOF, we print a friendly
# message instead of failing.

echo ""
echo "Section 6: Interactive example"

if read -r -p "Enter yes, no, or maybe: " user_choice; then
    case "${user_choice,,}" in
        yes|y)
            echo "You chose YES"
            ;;
        no|n)
            echo "You chose NO"
            ;;
        maybe|m)
            echo "You chose MAYBE"
            ;;
        *)
            echo "You entered something else: $user_choice"
            ;;
    esac
else
    echo "No input received (EOF). Skipping interactive branch safely."
fi
