#!/bin/bash
# ============================================================
# Lesson 5: I/O and Redirection
# Topics covered:
#   1. stdin (0), stdout (1), stderr (2)
#   2. > overwrite vs >> append
#   3. stderr redirection and merging streams
#   4. <, <<<, <<EOF, and <<-EOF
#   5. Pipes with |
#   6. tee for writing to file and screen
#   7. Process substitution: <(cmd) and >(cmd)
#   8. exec for redirecting a whole script
# ============================================================


# ------------------------------------------------------------
# SETUP: Create demo files inside the project directory
# ------------------------------------------------------------
# The user asked for cleanup, so we create uniquely named demo files
# near this script and remove them automatically on exit.
#
# IMPORTANT: We avoid system temp directories here and keep everything
# inside the project folder.

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
demo_dir="$script_dir/.lesson5-demo-$$"

cleanup() {
    rm -rf "$demo_dir"
}
trap cleanup EXIT

mkdir -p "$demo_dir"

echo "Lesson 5 demo workspace: $demo_dir"
echo ""


# ------------------------------------------------------------
# 1. stdin (0), stdout (1), stderr (2)
# ------------------------------------------------------------
# Every shell process starts with three standard file descriptors:
#   0 -> stdin  (standard input)
#   1 -> stdout (standard output)
#   2 -> stderr (standard error)
#
# stdin is where a command reads input from.
# stdout is the normal output stream.
# stderr is the error stream.
#
# Keeping stdout and stderr separate is useful because you can save
# normal output to one place and errors to another.

echo "Section 1: Standard file descriptors"
echo "stdout example: this is normal output on file descriptor 1"
ls "$demo_dir/does-not-exist" 2>/dev/null
printf '%s\n' "stderr example: sending this message directly to file descriptor 2" >&2
printf '%s\n' "apple" > "$demo_dir/stdin-source.txt"
read -r first_word < "$demo_dir/stdin-source.txt"
echo "stdin example: read '$first_word' from a file using input redirection"
echo ""


# ------------------------------------------------------------
# 2. > overwrite vs >> append (stdout)
# ------------------------------------------------------------
# >  writes stdout to a file and OVERWRITES the file.
# >> writes stdout to a file and APPENDS to the end.

stdout_file="$demo_dir/stdout-demo.txt"

echo "Section 2: > vs >>"
echo "first line" > "$stdout_file"
echo "second line replaces the old content" > "$stdout_file"
echo "third line gets appended" >> "$stdout_file"
echo "fourth line also gets appended" >> "$stdout_file"
echo "Contents of $stdout_file:"
cat "$stdout_file"
echo ""


# ------------------------------------------------------------
# 3. Redirect stderr and merge streams
# ------------------------------------------------------------
# 2> file       -> redirect ONLY stderr into file
# 2>&1          -> point stderr at the SAME place stdout currently goes
# &> file       -> bash shortcut for redirecting both stdout and stderr
# >/dev/null 2>&1 -> discard both stdout and stderr
#
# ORDER MATTERS.
#   command >file 2>&1   means:
#       1) send stdout to file
#       2) send stderr to wherever stdout NOW goes (the file)
#   command 2>&1 >file   means:
#       1) send stderr to wherever stdout goes NOW (usually terminal)
#       2) send stdout to file
#   Result: stderr may still go to terminal in the second form.

stderr_only_file="$demo_dir/stderr-only.log"
merged_file="$demo_dir/merged.log"
shortcut_file="$demo_dir/shortcut.log"

emit_both_streams() {
    echo "stdout: demo output"
    echo "stderr: demo error" >&2
}

echo "Section 3: stderr redirection and merging streams"
ls "$demo_dir/missing-file" 2> "$stderr_only_file"
echo "Saved stderr-only output to $stderr_only_file"
cat "$stderr_only_file"

echo ""
emit_both_streams > "$merged_file" 2>&1
echo "Merged stdout + stderr with > file 2>&1:"
cat "$merged_file"

echo ""
emit_both_streams &> "$shortcut_file"
echo "Merged stdout + stderr with &>:"
cat "$shortcut_file"

echo ""
echo "Suppressing both stdout and stderr with >/dev/null 2>&1"
emit_both_streams >/dev/null 2>&1
echo "Nothing from emit_both_streams was shown because both streams were discarded."
echo ""


# ------------------------------------------------------------
# 4. <, <<<, <<EOF, and <<-EOF
# ------------------------------------------------------------
# < file        -> feed file contents into stdin
# <<< "text"     -> here-string (a single string becomes stdin)
# <<EOF         -> here-document (multiple lines become stdin)
# <<-EOF        -> here-document that allows TAB indentation before content
#
# NOTE: <<-EOF strips leading TAB characters, not spaces.

input_file="$demo_dir/input-lines.txt"
cat > "$input_file" <<'EOF'
alpha
beta
gamma
EOF

echo "Section 4: Input redirection forms"
line_total=$(wc -l < "$input_file")
echo "Using < with wc -l < file gives line count: $line_total"

read -r here_string_value <<< "value from a here-string"
echo "Using <<< read this text: $here_string_value"

echo "Here-document sent into cat:"
cat <<'EOF'
line 1 from here-document
line 2 from here-document
EOF

echo "Indented here-document using <<-EOF (tabs are stripped):"
cat <<-'EOF'
	this line starts with a tab in the script
	this one does too
EOF

echo ""


# ------------------------------------------------------------
# 5. Pipes with |
# ------------------------------------------------------------
# A pipe sends stdout from the command on the left into stdin of the
# command on the right.
#
# Example: ls | wc -l
#   ls produces a list
#   wc -l counts how many lines it receives

echo "Section 5: Pipes"
printf '%s\n' one two three four | wc -l | {
    read -r piped_count
    echo "Count from pipeline: $piped_count"
}

echo "Shell scripts in this directory (ls | grep | wc -l):"
ls "$script_dir" | grep '^Lesson.*\.sh$' | wc -l

echo ""


# ------------------------------------------------------------
# 6. tee writes to a file AND stdout
# ------------------------------------------------------------
# tee is useful when you want to see output on the terminal but also
# save the same output to a file.
#
#   command | tee file
#   command | tee -a file   # append instead of overwrite

tee_file="$demo_dir/tee.log"

echo "Section 6: tee"
printf '%s\n' "first tee line" "second tee line" | tee "$tee_file"
echo "Saved copy in $tee_file"
echo ""


# ------------------------------------------------------------
# 7. Process substitution: <(cmd) and >(cmd)
# ------------------------------------------------------------
# <(cmd) runs a command and exposes its output as if it were a file.
# >(cmd) gives you a writable path that sends data INTO a command.
#
# Common example:
#   diff <(sort a.txt) <(sort b.txt)
# This compares sorted output without creating separate sorted files.

file_a="$demo_dir/a.txt"
file_b="$demo_dir/b.txt"
uppercase_file="$demo_dir/upper.txt"

cat > "$file_a" <<'EOF'
pear
apple
banana
EOF

cat > "$file_b" <<'EOF'
banana
pear
apple
EOF

echo "Section 7: Process substitution"
if diff <(sort "$file_a") <(sort "$file_b") >/dev/null; then
    echo "diff <(sort a.txt) <(sort b.txt): files match after sorting"
else
    echo "diff <(sort a.txt) <(sort b.txt): files differ"
fi

printf '%s\n' "alpha" "beta" > >(tr '[:lower:]' '[:upper:]' > "$uppercase_file")
echo "Using >(cmd) sent text through tr and saved:"
cat "$uppercase_file"
echo ""


# ------------------------------------------------------------
# 8. exec for redirecting a whole script
# ------------------------------------------------------------
# exec can replace the shell's own file descriptor setup.
#
# Example pattern:
#   exec > out.log 2>&1
# After that point, the rest of the script sends stdout and stderr
# into out.log.
#
# To keep THIS lesson working normally, we demonstrate exec inside a
# subshell. That way, only the subshell is redirected.

exec_demo_file="$demo_dir/exec-demo.log"

echo "Section 8: exec redirection (safe demo)"
(
    exec > "$exec_demo_file" 2>&1
    echo "Inside subshell: stdout goes to the log file"
    echo "Inside subshell: stderr also goes to the same log file" >&2
    echo "Inside subshell: this mimics exec > out.log 2>&1 for a whole script"
)

echo "Back in the parent shell, normal terminal output still works."
echo "Contents of $exec_demo_file:"
cat "$exec_demo_file"
echo ""

echo "Lesson 5 complete: I/O and redirection examples finished running without errors."
