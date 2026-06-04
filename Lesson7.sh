#!/bin/bash
# ============================================================
# Lesson 7: String Manipulation and Regex
# Topics covered:
#   1. String length with ${#str}
#   2. Substrings with ${str:offset:length}
#   3. Case conversion (${str^^}, ${str,,}, ${str^}, ${str,})
#   4. Substring removal with #, ##, %, %%
#   5. Substring replacement with / and //
#   6. Default-value operators (:-, :=, :?, :+)
#   7. Regex matching with [[ ... =~ ... ]] and BASH_REMATCH
#   8. printf formatting and read with IFS splitting
# ============================================================


echo "============================================================"
echo "Lesson 7: String Manipulation and Regex"
echo "============================================================"


# ------------------------------------------------------------
# 1. STRING LENGTH: ${#str}
# ------------------------------------------------------------
# ${#variable} returns the number of characters in the value.
# It does NOT print the string itself; it prints its length.
# This is useful for validation, slicing, and padding logic.

str="Bash scripting"

echo ""
echo "Section 1: String length"
echo "String: $str"
printf 'Length using ${#str}: %s\n' "${#str}"


# ------------------------------------------------------------
# 2. SUBSTRING: ${str:offset:length}
# ------------------------------------------------------------
# Bash can slice strings without calling external tools.
# Syntax:
#   ${str:offset:length}
#
# offset:
#   where to start (0-based index)
# length:
#   how many characters to take
#
# Negative offsets count backward from the end of the string.
# IMPORTANT: when the offset is negative, add a space after the colon:
#   ${str: -3}
# Otherwise bash may think you are writing the ':-' default-value form.

message="parameter expansion"

echo ""
echo "Section 2: Substrings"
echo "Original: $message"
echo "First 9 chars -> ${message:0:9}"
echo "From index 10, 9 chars -> ${message:10:9}"
echo "Last 3 chars with negative offset -> ${message: -3}"
echo "Middle slice (index 2, length 6) -> ${message:2:6}"


# ------------------------------------------------------------
# 3. CASE CONVERSION (bash 4+)
# ------------------------------------------------------------
# Bash 4+ supports built-in case conversion through parameter expansion.
#   ${str^^}  -> uppercase ALL letters
#   ${str,,}  -> lowercase ALL letters
#   ${str^}   -> uppercase FIRST character
#   ${str,}   -> lowercase FIRST character
#
# These are handy when normalizing user input or building labels.

mixed="bAsH Rocks"
loud="BASH rocks"

echo ""
echo "Section 3: Case conversion"
echo "Original -> $mixed"
echo "Uppercase all -> ${mixed^^}"
echo "Lowercase all -> ${mixed,,}"
echo "Uppercase first char -> ${mixed^}"
echo "Lowercase first char (using '$loud') -> ${loud,}"


# ------------------------------------------------------------
# 4. SUBSTRING REMOVAL WITH GLOB PATTERNS
# ------------------------------------------------------------
# These operators REMOVE text that matches a PATTERN.
# The pattern is a shell glob, not a regex.
#
# Prefix removal (from the LEFT):
#   ${var#pattern}   -> remove the SHORTEST matching prefix
#   ${var##pattern}  -> remove the LONGEST matching prefix
#
# Suffix removal (from the RIGHT):
#   ${var%pattern}   -> remove the SHORTEST matching suffix
#   ${var%%pattern}  -> remove the LONGEST matching suffix
#
# Common glob pieces:
#   *   any string
#   ?   any single character
#   [abc] one character from a set

path="/usr/local/bin/script.sh"
archive="backup.tar.gz"

echo ""
echo "Section 4: Substring removal"
echo "Path: $path"
echo "#  shortest prefix removal  -> ${path#*/}"
echo "## longest prefix removal   -> ${path##*/}"
echo "Archive: $archive"
echo "%  shortest suffix removal  -> ${archive%.*}"
echo "%% longest suffix removal   -> ${archive%%.*}"

# Another quick example with repeated separators so the greedy behavior is easy to see.
label="env-prod-us-east"
echo "Label: $label"
echo "Remove shortest prefix ending in - -> ${label#*-}"
echo "Remove longest prefix ending in -  -> ${label##*-}"


# ------------------------------------------------------------
# 5. SUBSTRING REPLACEMENT
# ------------------------------------------------------------
# Replacement also uses shell patterns, not regex.
#   ${var/old/new}      -> replace FIRST match only
#   ${var//old/new}     -> replace ALL matches
#   ${var/#old/new}     -> replace only if match is at START
#   ${var/%old/new}     -> replace only if match is at END

sentence="one fish two fish red fish blue fish"
greeting="Hello world"
filename="report.txt"

echo ""
echo "Section 5: Substring replacement"
echo "Original sentence -> $sentence"
echo "Replace first fish -> ${sentence/fish/cat}"
echo "Replace all fish   -> ${sentence//fish/cat}"
echo "Replace at start   -> ${greeting/#Hello/Hi}"
echo "Replace at end     -> ${filename/%.txt/.md}"


# ------------------------------------------------------------
# 6. DEFAULT VALUES AND ASSERTIONS
# ------------------------------------------------------------
# These forms are extremely useful when variables may be unset or empty.
#
#   ${var:-default}
#       Use default if var is unset OR empty.
#       var itself is not changed.
#
#   ${var:=default}
#       Use default if var is unset OR empty,
#       and ASSIGN that default back into var.
#
#   ${var:?message}
#       If var is unset OR empty, print message to stderr and exit
#       the current shell/script. We demonstrate it safely in a child bash.
#
#   ${var:+alt}
#       If var is set AND not empty, expand to alt.
#       Otherwise expand to an empty string.

unset nickname
unset theme
status="active"
empty_value=""

echo ""
echo "Section 6: Default-value operators"
echo "nickname with :- default -> ${nickname:-guest}"
echo "nickname is still unset after :-"

echo "theme before := -> '${theme-<unset>}'"
echo "theme using := -> ${theme:=dark}"
echo "theme after :=  -> $theme"

echo "status with :+alt -> ${status:+variable is present}"
echo "empty_value with :+alt -> ${empty_value:+you will not see this}"

if required_output="$(bash -c 'unset required_name; : "${required_name:?required_name must be set}"' 2>&1)"; then
    echo "Unexpected success: $required_output"
else
    echo "Demonstrating :? safely in a child shell -> $required_output"
fi


# ------------------------------------------------------------
# 7. REGEX MATCHING WITH [[ str =~ regex ]]
# ------------------------------------------------------------
# [[ string =~ regex ]] performs regex matching in bash.
#
# IMPORTANT RULE:
# Do NOT quote the regex on the right-hand side if you want it treated
# as a regex. Quoting it makes bash treat it as a plain literal string.
# Good:
#   [[ $text =~ ^[0-9]+$ ]]
# Bad for regex matching:
#   [[ $text =~ "^[0-9]+$" ]]
#
# When a match succeeds, bash fills the BASH_REMATCH array:
#   ${BASH_REMATCH[0]} -> full match
#   ${BASH_REMATCH[1]} -> first capture group
#   ${BASH_REMATCH[2]} -> second capture group
#   ...

version="v2.15"
regex='^v([0-9]+)\.([0-9]+)$'

echo ""
echo "Section 7: Regex matching"
echo "Testing version string -> $version"

if [[ $version =~ $regex ]]; then
    echo "Regex matched."
    echo "Full match          -> ${BASH_REMATCH[0]}"
    echo "Major capture group -> ${BASH_REMATCH[1]}"
    echo "Minor capture group -> ${BASH_REMATCH[2]}"
else
    echo "Regex did not match."
fi

email_like="student99@example.com"
if [[ $email_like =~ ^[[:alnum:]._%+-]+@[[:alnum:].-]+\.[[:alpha:]]{2,}$ ]]; then
    echo "Email-ish validation passed for -> $email_like"
else
    echo "Email-ish validation failed for -> $email_like"
fi


# ------------------------------------------------------------
# 8. printf FORMATTING AND read WITH IFS SPLITTING
# ------------------------------------------------------------
# printf is more predictable than echo for structured output.
# Common specifiers:
#   %s   string
#   %d   integer
#   %05d integer padded to width 5 with leading zeroes
#   %.2f floating-point number with 2 decimals
#   %q   shell-escaped/quoted form
#
# read can split input into variables when combined with IFS.
# IFS means Internal Field Separator.
# Example:
#   IFS=',' read -r a b c <<< "red,green,blue"
#
# Use -r with read so backslashes are not treated specially.

name="Ava"
count=7
price=3.14159
unsafe_text='two words & $HOME'
csv_line="red,green,blue"
kv_line="language=bash scripting"

echo ""
echo "Section 8: printf and IFS splitting"
printf 'String with %%s      -> %s\n' "$name"
printf 'Integer with %%d     -> %d\n' "$count"
printf 'Zero-padded %%05d    -> %05d\n' "$count"
printf 'Float with %%.2f     -> %.2f\n' "$price"
printf 'Shell-escaped with %%q -> %q\n' "$unsafe_text"

IFS=',' read -r color1 color2 color3 <<< "$csv_line"
echo "CSV split -> 1:$color1 2:$color2 3:$color3"

IFS='=' read -r key value <<< "$kv_line"
echo "Key/value split -> key='$key' value='$value'"

echo ""
echo "Lesson 7 complete: string manipulation and regex examples finished running."
