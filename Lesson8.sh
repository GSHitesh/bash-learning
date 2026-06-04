#!/bin/bash
# ============================================================
# Lesson 8: Processes, Signals, and Traps
# Topics covered:
#   1. Foreground vs background jobs (&), $!, wait, wait -n, jobs,
#      and the interactive fg/bg commands
#   2. Subshells ( ... ) vs grouping { ...; } and variable scope
#   3. PID variables: $$, $!, and $PPID
#   4. Common signals and what they mean
#   5. trap basics for cleanup on EXIT, INT, and TERM
#   6. Safe mktemp pattern with automatic cleanup
#   7. Running work in parallel and waiting for all jobs
#   8. timeout for limiting how long a command can run
# ============================================================


# ------------------------------------------------------------
# Helper setup used later in the lesson
# ------------------------------------------------------------
# We keep temporary demo files inside the lesson directory instead of
# using the system temp directory. That keeps the lesson self-contained
# and easy to inspect.

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cleanup_paths=()

cleanup() {
    # This function is safe to call multiple times.
    # It removes any temp file or temp directory we registered.
    local path

    for path in "${cleanup_paths[@]}"; do
        if [ -e "$path" ]; then
            rm -rf "$path"
            echo "cleanup: removed $path"
        fi
    done
}


# ------------------------------------------------------------
# 1. FOREGROUND VS BACKGROUND JOBS
# ------------------------------------------------------------
# By default, a command runs in the foreground.
# That means the shell waits until the command finishes.
# Example:
#   sleep 1
# The next command will not run until that sleep ends.
#
# Add "&" to run a command in the background:
#   sleep 1 &
# Then the shell prompt returns immediately.
#
# Useful tools:
#   $!     -> PID of the most recent background process
#   wait   -> wait for a specific PID, or for all background jobs
#   wait -n -> wait for the next background job to finish
#   jobs   -> list jobs started from the current shell
#   fg/bg  -> move jobs to foreground/background in an INTERACTIVE shell


echo "Section 1: Foreground vs background jobs"

sleep 0.1 &
first_bg_pid=$!
echo "Started background job 1 with PID: $first_bg_pid"

sleep 0.2 &
second_bg_pid=$!
echo "Started background job 2 with PID: $second_bg_pid"
echo "The value of \$! always tracks the most recent background PID."

echo "Current jobs from this shell:"
jobs -l

echo "Waiting specifically for PID $first_bg_pid with wait ..."
wait "$first_bg_pid"
echo "PID $first_bg_pid has finished."

echo "Now waiting for the next remaining job with wait -n ..."
wait -n
echo "wait -n returned after one background job completed."

echo "Interactive-only helpers:"
echo "  fg %1   -> bring job 1 to the foreground"
echo "  bg %1   -> resume job 1 in the background"


echo ""


# ------------------------------------------------------------
# 2. SUBSHELLS ( ... ) VS GROUPING { ...; }
# ------------------------------------------------------------
# Parentheses create a SUBSHELL.
# Changes made inside a subshell do not affect the parent shell.
#
# Braces group commands in the CURRENT shell.
# Changes made inside a brace group remain visible afterwards.
#
# Syntax details:
#   ( command1; command2 )
#   { command1; command2; }
# Notice the spaces around { and }, and the semicolon before }.


echo "Section 2: Subshells vs grouping"

scope_demo="outside"
echo "Before subshell: scope_demo=$scope_demo"

(
    scope_demo="inside subshell"
    echo "Inside subshell: scope_demo=$scope_demo"
)

echo "After subshell: scope_demo=$scope_demo"

{
    scope_demo="inside brace group"
    echo "Inside brace group: scope_demo=$scope_demo"
}

echo "After brace group: scope_demo=$scope_demo"

echo ""


# ------------------------------------------------------------
# 3. PID VARIABLES: $$, $!, AND $PPID
# ------------------------------------------------------------
# $$     -> PID of the current shell process
# $!     -> PID of the most recently started background process
# $PPID  -> PID of this shell's parent process
#
# These are very useful when logging, debugging, and coordinating jobs.


echo "Section 3: PID variables"
echo "Current shell PID (\$\$): $$"
echo "Parent shell PID (\$PPID): $PPID"

sleep 0.1 &
last_bg_pid=$!
echo "Most recent background PID (\$!): $last_bg_pid"
wait "$last_bg_pid"

echo ""


# ------------------------------------------------------------
# 4. COMMON SIGNALS
# ------------------------------------------------------------
# A signal is a lightweight notification sent to a process.
# Signals are often used to ask a process to stop, reload, or do
# some custom action.
#
# Common examples:
#   SIGTERM (15) -> polite request to terminate
#   SIGINT  (2)  -> interrupt from keyboard, usually Ctrl-C
#   SIGHUP  (1)  -> terminal hangup; often used as reload/restart hint
#   SIGKILL (9)  -> force-kill immediately; cannot be trapped or ignored
#   SIGUSR1/SIGUSR2 -> user-defined signals for custom behavior


echo "Section 4: Common signals"
cat <<'EOF'
SIGTERM (15): Ask a process to terminate cleanly.
SIGINT  (2) : Interrupt from the keyboard, commonly Ctrl-C.
SIGHUP  (1) : Originally meant terminal hangup; often reused for reload.
SIGKILL (9) : Immediate kill. The process cannot catch or ignore it.
SIGUSR1/2   : User-defined signals for app-specific actions.
EOF

echo ""


# ------------------------------------------------------------
# 5. TRAP BASICS
# ------------------------------------------------------------
# trap lets you run code when the shell receives a signal or exits.
# A classic pattern is:
#   trap 'cleanup' EXIT INT TERM
#
# That means:
#   - run cleanup when the script exits normally (EXIT)
#   - run cleanup if the user presses Ctrl-C (INT)
#   - run cleanup if the script receives SIGTERM (TERM)
#
# This is how you guarantee cleanup code runs even when the script is
# interrupted.


echo "Section 5: trap basics"
trap 'cleanup' EXIT INT TERM
echo "Installed trap: trap 'cleanup' EXIT INT TERM"

echo ""


# ------------------------------------------------------------
# 6. TRAP + MKTEMP PATTERN
# ------------------------------------------------------------
# A very common real-world pattern is:
#   1. create a temporary file or directory
#   2. store its path in a variable
#   3. register a trap so it is always removed on exit
#
# We create demo temp resources INSIDE this project directory so the
# lesson stays self-contained.


echo "Section 6: trap with mktemp pattern"

temp_dir="$(mktemp -d "$script_dir/lesson8-tempdir.XXXXXX")"
temp_file="$(mktemp "$script_dir/lesson8-tempfile.XXXXXX")"
cleanup_paths+=("$temp_dir" "$temp_file")

echo "Temporary directory created: $temp_dir"
echo "Temporary file created: $temp_file"

echo "demo data" > "$temp_file"
echo "inside temp dir" > "$temp_dir/example.txt"
echo "These paths will be removed automatically by the EXIT trap."

echo ""


# ------------------------------------------------------------
# 7. RUNNING THINGS IN PARALLEL AND WAITING FOR ALL
# ------------------------------------------------------------
# Background jobs are a simple way to do independent work in parallel.
# A common pattern is:
#   for i in 1 2 3; do work "$i" & done
#   wait
#
# The final "wait" with no PID waits for all current background jobs.

work() {
    local job_id="$1"
    echo "worker $job_id: starting"
    sleep 0.1
    echo "worker $job_id: finished"
}


echo "Section 7: Parallel jobs + wait"

for i in 1 2 3; do
    work "$i" &
done

wait
echo "All parallel workers finished."

echo ""


# ------------------------------------------------------------
# 8. TIMEOUT FOR BOUNDING RUNTIME
# ------------------------------------------------------------
# Sometimes you do not want a command to run forever.
# The GNU "timeout" command stops a command if it exceeds a limit.
# Example:
#   timeout 5 some_command
#
# If timeout stops the command, it usually returns exit status 124.


echo "Section 8: timeout command"

if command -v timeout >/dev/null 2>&1; then
    if timeout 0.2 bash -c 'echo "bounded command started"; sleep 0.5; echo "this line will not print"'; then
        echo "The command finished before the timeout."
    else
        timeout_status=$?
        echo "timeout stopped the command. Exit status: $timeout_status"
    fi
else
    echo "The timeout command is not available on this system."
fi


echo ""
echo "Lesson 8 complete: process, signal, and trap examples finished running."
