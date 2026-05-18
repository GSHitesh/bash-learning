#!/bin/bash
# ============================================================
# Lesson 1: Bash Basics
# Topics covered:
#   1. Shebang
#   2. Variable declaration
#   3. CLI input (positional parameters)
#   4. User input (read)
# ============================================================


# ------------------------------------------------------------
# 1. SHEBANG
# ------------------------------------------------------------
# The first line "#!/bin/bash" is called a "shebang".
# It tells the OS which interpreter to use to run this script.
# Without it, the script may be executed by the default shell,
# which might not support all bash features.
# Make the script executable with: chmod +x Lesson1.sh
# Run it with: ./Lesson1.sh

echo "Hello World"


# ------------------------------------------------------------
# 2. VARIABLE DECLARATION
# ------------------------------------------------------------
# Variables are declared as NAME=value
# IMPORTANT: No spaces around the "=" sign.
# Access a variable's value using $NAME or ${NAME}.
# Use ${NAME} (curly braces) when concatenating with other text
# to avoid ambiguity.

name="Hitesh"

echo "My name is $name"

# Curly braces are required here so bash knows where the
# variable name ends.
echo "My name is Sai${name}"


# ------------------------------------------------------------
# 3. CLI INPUT (Positional Parameters)
# ------------------------------------------------------------
# Arguments passed on the command line are accessed as:
#   $0  -> script name
#   $1  -> first argument
#   $2  -> second argument
#   $@  -> all arguments as a list
#   $#  -> number of arguments
#
# Example: ./Lesson1.sh John Michael
#   $1 = John, $2 = Michael

echo "Name using the CLI is $1"
echo "Mid Name using the CLI is $2"

# Read all CLI inputs at once
echo "All cli inputs are ${@}"
echo "Total number of cli inputs: $#"


# ------------------------------------------------------------
# 4. USER INPUT (read)
# ------------------------------------------------------------
# The "read" command captures input from the user at runtime.
# Syntax: read VARIABLE_NAME    (no $ when assigning to it)
#
# NOTE: A common mistake is "read $name" — that expands $name
# FIRST and then tries to read into whatever its value is.
# Correct usage is: read name

echo "Enter your name: "
read name
echo "My name is $name"

# Shorter form: prompt + read on a single line using -p
read -p "Enter your name again: " name
echo "My name is $name"

