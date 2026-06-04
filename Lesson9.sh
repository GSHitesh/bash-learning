#!/bin/bash
# ============================================================
# Lesson 9: Text Processing Tools
# Topics covered:
#   1. grep and useful flags
#   2. sed for substitutions and editing streams
#   3. awk for field processing and calculations
#   4. cut, sort, uniq, tr, wc, head, tail
#   5. Pipeline example for word frequency
#   6. xargs basics
# ============================================================

# This lesson is intentionally self-contained.
# Instead of depending on files that already exist on your system,
# the script creates sample files with here-docs inside a throwaway
# demo directory, uses them for examples, and removes them on exit.
# That way you can run the script anywhere and still get the same
# outputs and learning experience.

# ------------------------------------------------------------
# LESSON BANNER
# ------------------------------------------------------------
echo "============================================================"
echo "Lesson 9: Text Processing Tools"
echo "============================================================"

# ------------------------------------------------------------
# DEMO DATA SETUP (self-contained sample files)
# ------------------------------------------------------------
# We place demo files beside this script so we do not depend on /tmp
# or any outside directory. A trap removes the directory when the
# script exits normally or after an interruption.

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
demo_dir="$script_dir/.lesson9_demo"

rm -rf "$demo_dir"
mkdir -p "$demo_dir/search-tree/docs" "$demo_dir/search-tree/logs" "$demo_dir/xargs-demo"

cleanup() {
    rm -rf "$demo_dir"
}
trap cleanup EXIT

# File used for grep and sed examples.
cat <<'EOF' > "$demo_dir/notes.txt"
Bash makes automation easier.
bash scripts can combine small tools.
TODO: write more grep examples.
TODO: explain sed clearly.
Literal text: a+b should stay a+b.
Contact support@example.com for help.
EOF

# File used for grep, sed, head, and tail examples.
cat <<'EOF' > "$demo_dir/app.log"
INFO Application started
WARN Cache miss for user profile
ERROR Database connection failed
DEBUG Retrying request
INFO Application recovered
ERROR Timeout while calling payment API
EOF

# Directory tree used for recursive grep examples.
cat <<'EOF' > "$demo_dir/search-tree/docs/guide.md"
# Guide
TODO: document deployment steps.
The word bash appears here.
EOF

cat <<'EOF' > "$demo_dir/search-tree/logs/system.log"
INFO boot complete
ERROR disk temporarily unavailable
EOF

# File used for grep -o email extraction.
cat <<'EOF' > "$demo_dir/contacts.txt"
Reach us at admin@example.com or sales@example.org.
Backup contact: support-team@demo.net
EOF

# CSV file used for awk, cut, and sort examples.
cat <<'EOF' > "$demo_dir/users.csv"
name,team,score
Alice,Engineering,120
Bob,Sales,95
Carol,Engineering,140
Dave,Support,80
EOF

# Space-separated file used for awk default field splitting.
cat <<'EOF' > "$demo_dir/sales.txt"
Alice Engineering 1200
Bob Sales 950
Carol Engineering 1400
Dave Support 800
EOF

# Small number file for sort examples.
cat <<'EOF' > "$demo_dir/numbers.txt"
10
2
30
2
15
EOF

# Word list for uniq and tr examples.
cat <<'EOF' > "$demo_dir/words.txt"
Apple
apple
banana
banana
BANANA
EOF

# Paragraph used for the word-frequency pipeline.
cat <<'EOF' > "$demo_dir/paragraph.txt"
Bash is powerful, and bash is practical. Text tools let bash process
logs, text, CSV data, and plain text quickly. Good pipelines turn text
into insight, and good practice makes bash feel natural.
EOF

# Filenames for xargs demonstrations, including spaces.
cat <<'EOF' > "$demo_dir/xargs-demo/file one.txt"
first file
EOF

cat <<'EOF' > "$demo_dir/xargs-demo/file two.txt"
second file
EOF

cat <<'EOF' > "$demo_dir/xargs-demo/file-three.txt"
third file
EOF


echo "Demo data created in: $demo_dir"
echo ""

# ------------------------------------------------------------
# 1. GREP
# ------------------------------------------------------------
# grep searches text for patterns.
# It is one of the fastest and most common text-search tools.
#
# Useful flags covered here:
#   -i  case-insensitive search
#   -v  invert the match (show non-matching lines)
#   -n  show line numbers
#   -r  search recursively in directories
#   -E  use extended regular expressions
#   -F  treat the pattern as a fixed string, not regex
#   -c  count matching lines
#   -l  print only filenames with matches
#   -o  print only the matching part of a line

echo "------------------------------------------------------------"
echo "1. GREP"
echo "------------------------------------------------------------"

echo '$ grep "ERROR" app.log'
grep "ERROR" "$demo_dir/app.log"
echo ""

echo '$ grep -i "bash" notes.txt'
grep -i "bash" "$demo_dir/notes.txt"
echo ""

echo '$ grep -v "INFO" app.log'
grep -v "INFO" "$demo_dir/app.log"
echo ""

echo '$ grep -n "TODO" notes.txt'
grep -n "TODO" "$demo_dir/notes.txt"
echo ""

echo '$ grep -r "TODO" search-tree'
grep -r "TODO" "$demo_dir/search-tree"
echo ""

echo '$ grep -E "ERROR|WARN" app.log'
grep -E "ERROR|WARN" "$demo_dir/app.log"
echo ""

echo '$ grep -F "a+b" notes.txt'
grep -F "a+b" "$demo_dir/notes.txt"
echo ""

echo '$ grep -c "ERROR" app.log'
grep -c "ERROR" "$demo_dir/app.log"
echo ""

echo '$ grep -lr "TODO" search-tree'
grep -lr "TODO" "$demo_dir/search-tree"
echo ""

echo '$ grep -oE "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}" contacts.txt'
grep -oE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' "$demo_dir/contacts.txt"
echo ""

# ------------------------------------------------------------
# 2. SED
# ------------------------------------------------------------
# sed is a stream editor.
# It reads input line by line and can transform, delete, or print lines.
#
# Common patterns shown below:
#   s/old/new/g   substitute all matches on each line
#   1,5s/.../.../   apply a substitution only to a line range
#   /pattern/d    delete lines matching a pattern
#   -i            edit a file in place
#   -e            provide multiple sed commands
#
# macOS / BSD sed note:
#   GNU sed (common on Linux): sed -i 's/old/new/' file
#   BSD sed (common on macOS): sed -i '' 's/old/new/' file
# The empty string after -i on macOS means “edit in place with no backup”.

echo "------------------------------------------------------------"
echo "2. SED"
echo "------------------------------------------------------------"

echo '$ sed "s/TODO/DONE/g" notes.txt'
sed 's/TODO/DONE/g' "$demo_dir/notes.txt"
echo ""

echo '$ sed "1,5s/Application/Service/g" app.log'
sed '1,5s/Application/Service/g' "$demo_dir/app.log"
echo ""

echo '$ sed "/DEBUG/d" app.log'
sed '/DEBUG/d' "$demo_dir/app.log"
echo ""

# We copy the file first so the in-place example does not permanently
# change the original demo input used by earlier examples.
cp "$demo_dir/notes.txt" "$demo_dir/notes-inplace.txt"

echo '$ sed -i "s/TODO/DONE/g" notes-inplace.txt'
sed -i 's/TODO/DONE/g' "$demo_dir/notes-inplace.txt"
cat "$demo_dir/notes-inplace.txt"
echo ""

echo '$ sed -e "s/ERROR/ERR/g" -e "/DEBUG/d" app.log'
sed -e 's/ERROR/ERR/g' -e '/DEBUG/d' "$demo_dir/app.log"
echo ""

# ------------------------------------------------------------
# 3. AWK
# ------------------------------------------------------------
# awk is a small programming language designed for text processing.
# It shines when data is arranged in columns.
#
# Important ideas:
#   $0   whole line
#   $1   first field
#   $NF  last field (NF = number of fields)
#   -F   choose a field separator, such as a comma for CSV
#   BEGIN / END blocks run before and after reading data
#   You can filter rows and do arithmetic while scanning input

echo "------------------------------------------------------------"
echo "3. AWK"
echo "------------------------------------------------------------"

echo '$ awk "{print $0}" sales.txt'
awk '{print $0}' "$demo_dir/sales.txt"
echo ""

echo '$ awk "{print $1, $NF}" sales.txt'
awk '{print $1, $NF}' "$demo_dir/sales.txt"
echo ""

echo '$ awk -F"," "NR>1 {print $1, $3}" users.csv'
awk -F',' 'NR>1 {print $1, $3}' "$demo_dir/users.csv"
echo ""

echo '$ awk -F"," "BEGIN {print \"Name Score\"} NR>1 {print $1, $3} END {print \"-- done --\"}" users.csv'
awk -F',' 'BEGIN {print "Name Score"} NR>1 {print $1, $3} END {print "-- done --"}' "$demo_dir/users.csv"
echo ""

echo '$ awk -F"," "NR>1 {sum += $3} END {print sum}" users.csv'
awk -F',' 'NR>1 {sum += $3} END {print sum}' "$demo_dir/users.csv"
echo ""

echo '$ awk -F"," "NR>1 && $3 > 100 {print $1, $3}" users.csv'
awk -F',' 'NR>1 && $3 > 100 {print $1, $3}' "$demo_dir/users.csv"
echo ""

echo '$ awk -F"," "NR>1 {printf \"%-10s %5d\\n\", $1, $3}" users.csv'
awk -F',' 'NR>1 {printf "%-10s %5d\n", $1, $3}' "$demo_dir/users.csv"
echo ""

# ------------------------------------------------------------
# 4. CUT, SORT, UNIQ, TR, WC, HEAD, TAIL
# ------------------------------------------------------------
# These are classic Unix text utilities.
# They are small, focused, and extremely useful in pipelines.
#
# cut   -> extract selected columns or character ranges
# sort  -> order lines alphabetically or numerically
# uniq  -> remove adjacent duplicates (often after sort)
# tr    -> translate or delete characters
# wc    -> count lines, words, and bytes
# head  -> show the beginning of input
# tail  -> show the end of input

echo "------------------------------------------------------------"
echo "4. CUT, SORT, UNIQ, TR, WC, HEAD, TAIL"
echo "------------------------------------------------------------"

echo '$ cut -d"," -f1,3 users.csv'
cut -d',' -f1,3 "$demo_dir/users.csv"
echo ""

echo '$ sort -n numbers.txt'
sort -n "$demo_dir/numbers.txt"
echo ""

echo '$ sort -nr numbers.txt'
sort -nr "$demo_dir/numbers.txt"
echo ""

echo '$ sort -t"," -k3,3nr users.csv'
sort -t',' -k3,3nr "$demo_dir/users.csv"
echo ""

echo '$ sort -nu numbers.txt'
sort -nu "$demo_dir/numbers.txt"
echo ""

echo '$ tr "[:upper:]" "[:lower:]" < words.txt | sort | uniq -c'
tr '[:upper:]' '[:lower:]' < "$demo_dir/words.txt" | sort | uniq -c
echo ""

echo '$ wc notes.txt'
wc "$demo_dir/notes.txt"
echo ""

echo '$ head -3 app.log'
head -3 "$demo_dir/app.log"
echo ""

echo '$ tail -2 app.log'
tail -2 "$demo_dir/app.log"
echo ""

# ------------------------------------------------------------
# 5. PIPELINE EXAMPLE: TOP 5 MOST-FREQUENT WORDS
# ------------------------------------------------------------
# Pipelines let one command feed the next.
# This example:
#   1. lowercases text
#   2. turns non-letters into newlines
#   3. sorts words
#   4. counts duplicates with uniq -c
#   5. sorts counts numerically, highest first
#   6. shows the top 5

echo "------------------------------------------------------------"
echo "5. PIPELINE EXAMPLE"
echo "------------------------------------------------------------"

echo '$ tr "[:upper:]" "[:lower:]" < paragraph.txt | tr -cs "[:alpha:]" "\\n" | sort | uniq -c | sort -rn | head -5'
tr '[:upper:]' '[:lower:]' < "$demo_dir/paragraph.txt" | tr -cs '[:alpha:]' '\n' | sort | uniq -c | sort -rn | head -5
echo ""

# ------------------------------------------------------------
# 6. XARGS BASICS
# ------------------------------------------------------------
# xargs builds command lines from standard input.
# It is useful when one command produces a list of items and another
# command should run using those items as arguments.
#
# Covered here:
#   -I {}  placeholder for each input item
#   -n     use only N input items per command invocation
#   -0     read NUL-separated input safely
#
# Why -0 matters:
# Filenames can contain spaces, tabs, or even newlines.
# The combination find -print0 | xargs -0 handles such names safely.

echo "------------------------------------------------------------"
echo "6. XARGS BASICS"
echo "------------------------------------------------------------"

echo '$ printf "apple\\nbanana\\n" | xargs -I {} printf "Fruit: %s\\n" "{}"'
printf 'apple\nbanana\n' | xargs -I {} printf 'Fruit: %s\n' '{}'
echo ""

echo '$ printf "one two three four" | xargs -n 2 echo'
printf 'one two three four' | xargs -n 2 echo
echo ""

echo '$ find xargs-demo -type f -print0 | xargs -0 -n 1 ls -ld'
find "$demo_dir/xargs-demo" -type f -print0 | xargs -0 -n 1 ls -ld
echo ""

echo "Lesson 9 complete: text-processing examples finished running."
