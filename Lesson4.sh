#!/bin/bash
# ============================================================
# Lesson 4: Bash Functions
# Topics covered:
#   1. Function definition styles
#   2. Calling functions and function arguments
#   3. Return values vs output
#   4. Local vs global variables
#   5. Recursion
#   6. Returning multiple values
#   7. Default parameter values
#   8. Small library pattern
# ============================================================


# ------------------------------------------------------------
# 1. FUNCTION DEFINITION STYLES
# ------------------------------------------------------------
# A function is a named block of code that you can call multiple times.
# Functions help you avoid repetition and make scripts easier to read.
#
# Bash supports these common definition styles:
#   name() {
#       commands
#   }
#
#   function name {
#       commands
#   }
#
# Both work in bash. The first style is more common and more portable.
# The second style uses the bash/ksh "function" keyword.

say_hello() {
    echo "Hello from say_hello()"
}

function say_hi {
    echo "Hello from function say_hi"
}

echo "Section 1: Function definition styles"
say_hello
say_hi


echo ""


# ------------------------------------------------------------
# 2. CALLING FUNCTIONS AND FUNCTION ARGUMENTS
# ------------------------------------------------------------
# Call a function by writing its name, followed by any arguments.
# Inside a function:
#   $1  -> first argument passed to the FUNCTION
#   $2  -> second argument passed to the FUNCTION
#   $@  -> all function arguments
#   $#  -> number of function arguments
#
# IMPORTANT:
#   $0 is STILL the script name, not the function name.
# That means functions get their own $1, $2, $@, and $# values,
# but $0 remains tied to the script itself.

show_function_args() {
    echo "Inside show_function_args"
    echo "  Script name from \$0: $0"
    echo "  First function arg (\$1): $1"
    echo "  Second function arg (\$2): $2"
    echo "  All function args (\$@): $@"
    echo "  Total function args (\$#): $#"
}

echo "Section 2: Calling functions and reading their arguments"
show_function_args apple banana cherry


echo ""


# ------------------------------------------------------------
# 3. RETURN VALUES VS OUTPUT
# ------------------------------------------------------------
# In bash, "return N" does NOT return a general-purpose number like in
# many programming languages. It sets the function's EXIT STATUS.
# Exit status rules:
#   0     usually means success
#   non-0 usually means failure or a special condition
#   valid range is 0 to 255
#
# So use "return" for status, and use echo/printf when you want actual
# data back from a function.

is_positive() {
    if [ "$1" -gt 0 ]; then
        return 0
    else
        return 1
    fi
}

join_with_dash() {
    # This function returns DATA by printing to stdout.
    # The caller can capture it using command substitution.
    echo "$1-$2-$3"
}

echo "Section 3: Return values vs output"

if is_positive 7; then
    echo "is_positive 7 -> exit status 0 (success)"
else
    echo "is_positive 7 -> exit status 1 (not positive)"
fi

echo "Calling is_positive -2 and checking \$? immediately after"
is_positive -2
echo "Exit status from is_positive -2: $?"

# Command substitution captures whatever the function prints.
result="$(join_with_dash red green blue)"
echo "Captured output using result=\$(join_with_dash ...): $result"

# Avoid trying to return large computed values with "return".
# For example, "return 300" does not preserve 300 as-is because exit
# statuses are limited to 0-255.


echo ""


# ------------------------------------------------------------
# 4. LOCAL VS GLOBAL VARIABLES
# ------------------------------------------------------------
# By default, variables in bash are global to the current shell.
# That means a function can accidentally overwrite a variable that the
# rest of the script is using.
#
# Use "local" inside functions when a variable is only needed there.
# This keeps the function self-contained and prevents side effects.

message="global message"

change_global_message() {
    message="changed by change_global_message"
}

safe_local_example() {
    local message="local message inside safe_local_example"
    echo "  Inside safe_local_example: $message"
}

echo "Section 4: Local vs global variables"
echo "Before change_global_message: $message"
change_global_message
echo "After change_global_message:  $message"

safe_local_example
echo "After safe_local_example:    $message"


echo ""


# ------------------------------------------------------------
# 5. RECURSION EXAMPLE (FACTORIAL)
# ------------------------------------------------------------
# Recursion means a function calls itself.
# The factorial of n is:
#   n! = n * (n-1) * (n-2) * ... * 1
# Base case:
#   0! = 1
#
# Because factorial values grow quickly, we print the result and capture
# it rather than trying to use "return".

factorial() {
    local n="$1"

    if [ "$n" -le 1 ]; then
        echo 1
        return 0
    fi

    local smaller
    smaller="$(factorial $((n - 1)))"
    echo $((n * smaller))
}

echo "Section 5: Recursion with factorial"
factorial_of_5="$(factorial 5)"
echo "factorial 5 = $factorial_of_5"


echo ""


# ------------------------------------------------------------
# 6. RETURNING MULTIPLE VALUES
# ------------------------------------------------------------
# A function can only set ONE exit status with "return", but it can
# print multiple pieces of data to stdout.
#
# Common patterns:
#   A) Print multiple values and capture them with read
#   B) Fill a global array that the caller reads later

split_name() {
    local full_name="$1"
    local first_name last_name

    first_name="${full_name%% *}"
    last_name="${full_name#* }"

    echo "$first_name $last_name"
}

set_rgb_values() {
    # This writes to a global array on purpose.
    RGB_VALUES=(255 128 64)
}

echo "Section 6: Returning multiple values"
read -r first_name last_name <<< "$(split_name 'Ada Lovelace')"
echo "From stdout + read -> first_name=$first_name, last_name=$last_name"

set_rgb_values
echo "From global array -> R=${RGB_VALUES[0]}, G=${RGB_VALUES[1]}, B=${RGB_VALUES[2]}"


echo ""


# ------------------------------------------------------------
# 7. DEFAULT PARAMETER VALUES
# ------------------------------------------------------------
# "${1:-default}" means:
#   use $1 if it is set and not empty
#   otherwise use "default"
#
# This is very useful when a function argument is optional.

greet_user() {
    local name="${1:-friend}"
    local greeting="${2:-Hello}"
    echo "$greeting, $name!"
}

echo "Section 7: Default parameter values"
greet_user
greet_user "Hitesh"
greet_user "Sai" "Welcome"


echo ""


# ------------------------------------------------------------
# 8. SMALL LIBRARY PATTERN
# ------------------------------------------------------------
# A common pattern is to place utility functions near the top of the
# script and then call them later from the "main" part of the script.
# This feels like a small function library inside one file.
#
# Here we define a few helpers and then use them together.

print_banner() {
    local title="$1"
    echo "========== $title =========="
}

repeat_char() {
    local char="${1:--}"
    local count="${2:-10}"
    local output=""
    local i

    for ((i = 0; i < count; i++)); do
        output+="$char"
    done

    echo "$output"
}

print_key_value() {
    local key="$1"
    local value="$2"
    echo "$key: $value"
}

echo "Section 8: Small library pattern"
print_banner "Utility function demo"
print_key_value "Script" "$0"
print_key_value "Divider" "$(repeat_char '=' 12)"
print_key_value "Greeting" "$(greet_user 'Learner' 'Hi')"

echo ""
echo "Lesson 4 complete: function examples finished running."
