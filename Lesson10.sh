#!/bin/bash
# ============================================================
# Lesson 10: Error Handling & Debugging
# Topics covered:
#   1. Exit status ($?) and the 0-255 range
#   2. set -e, set -u, set -o pipefail, set -x
#   3. Explicit error checking patterns
#   4. trap ERR for centralized error reporting
#   5. Writing a die() helper
#   6. Defensive scripting practices
#   7. Debugging techniques in bash
#   8. shellcheck as the linter for shell scripts
# ============================================================


# ------------------------------------------------------------
# HELPER FUNCTIONS USED BY MULTIPLE SECTIONS
# ------------------------------------------------------------
# We keep a few small helpers near the top so later examples stay
# readable. Notice that we are NOT enabling "set -euo pipefail"
# globally for this lesson because we want to demonstrate failures
# in a controlled way without aborting the whole script.

script_path="${BASH_SOURCE[0]}"
script_dir="$(cd "$(dirname "$script_path")" && pwd)"

handle_error() {
    # Simple reusable handler for demo purposes.
    echo "Handled error: $*"
}

# A classic helper for scripts that want to stop immediately with a
# clear message. The user specifically requested this exact pattern.
die() { echo "ERROR: $*" >&2; exit 1; }

report_err() {
    # In an ERR trap, $? is the exit code from the command that failed.
    # We pass line number, source file, and command text into this
    # function so the error message is centralized and consistent.
    local exit_code=$?
    local line_no=$1
    local source_file=$2
    local failed_command=$3

    echo "ERR trap report:"
    echo "  file: $source_file"
    echo "  line: $line_no"
    echo "  command: $failed_command"
    echo "  exit status: $exit_code"
}

require_two_args() {
    # A tiny validation helper used in section 6.
    [[ $# -ge 2 ]] || die "usage: demo_copy SOURCE DEST"
}


echo "============================================================"
echo "Lesson 10: Error Handling & Debugging"
echo "Script path: $script_path"
echo "Script dir : $script_dir"
echo "============================================================"
echo ""


# ------------------------------------------------------------
# 1. EXIT STATUS ($?)
# ------------------------------------------------------------
# Every command exits with a numeric status code.
#   0       -> success
#   non-zero -> some kind of failure
# In bash, exit statuses are stored in the range 0-255.
# The special variable $? contains the status of the MOST RECENT
# command only, so read it immediately before another command runs.

echo "Section 1: Exit status examples"

true
echo "After running 'true', \$? = $? (0 means success)"

false
echo "After running 'false', \$? = $? (non-zero means failure)"

# Exit codes are limited to one byte. Larger values wrap around.
bash -c 'exit 300'
echo "After 'exit 300', bash reports \$? = $? (300 wraps into the 0-255 range)"

# For a pipeline, $? normally reflects the LAST command only.
false | true
echo "After 'false | true' without pipefail, \$? = $? (status of the last command)"

echo ""


# ------------------------------------------------------------
# 2. STRICT MODE OPTIONS: -e, -u, -o pipefail, -x
# ------------------------------------------------------------
# These options are common in production scripts:
#   set -e          -> exit when a simple command fails
#   set -u          -> treat unset variables as errors
#   set -o pipefail -> make a pipeline fail if ANY command fails
#   set -x          -> print commands as bash executes them
#
# You will often see this compact idiom at the top of scripts:
#   set -euo pipefail
#
# It is useful, but it is NOT magic. One important limitation is that
# commands used for control flow do not always trigger -e the way new
# users expect. In particular, failing commands in an if condition or
# on the left side of || and && are special cases.
#
# We use subshells below so the lesson can show failures safely and
# still continue running to the end.

echo "Section 2: Demonstrating strict-mode options safely"

echo "-e demo: a failing command stops the subshell early"
(
    set -e
    echo "  Inside subshell with set -e"
    false
    echo "  You will NOT see this line because set -e stops here"
)
errexit_status=$?
if [ "$errexit_status" -ne 0 ]; then
    echo "  Parent script continues because only the subshell exited"
fi

echo ""
echo "-u demo: using an unset variable becomes an error"
(
    set -u
    echo "  About to read an unset variable..."
    echo "  Value: $unset_demo_variable"
) 2>/dev/null || echo "  nounset stopped the subshell when an unset variable was expanded"

echo ""
echo "pipefail demo: pipeline status changes when an earlier command fails"
(
    false | true
    echo "  Without pipefail, pipeline status = $?"
)
(
    set -eo pipefail
    false | true
    echo "  You will NOT see this line because the pipeline returned non-zero"
)
pipefail_status=$?
if [ "$pipefail_status" -ne 0 ]; then
    echo "  With pipefail, the failing 'false' makes the whole pipeline fail"
fi

echo ""
echo "Limitation demo: set -e does NOT catch every failure you might expect"
(
    set -e

    if grep -q "zebra" <<< "cat dog"; then
        echo "  Found zebra"
    else
        echo "  grep failed inside an if condition, but set -e did not abort"
    fi

    false || echo "  Left side of || failed, but set -e did not abort"
    false && echo "  This right side never runs"
    echo "  Script is still running after control-flow examples"
)

echo ""

echo "xtrace demo: set -x prints commands as they execute"
(
    PS4='+ ${BASH_SOURCE##*/}:${LINENO}:${FUNCNAME[0]:-main}: '
    set -x
    debug_value=$((10 / 2))
    echo "debug_value = $debug_value"
    set +x
)

echo ""


# ------------------------------------------------------------
# 3. EXPLICIT ERROR CHECKING
# ------------------------------------------------------------
# Strict mode is helpful, but explicit checks are often clearer.
# Two common patterns are:
#   if ! cmd; then
#       ... handle it ...
#   fi
#
#   cmd || handle_error
#
# These patterns make the failure path visible right where it happens.

echo "Section 3: Explicit error checking"

if ! grep -q "zebra" <<< "cat dog"; then
    echo "  Pattern not found, so the if ! cmd; then ... branch ran"
fi

grep -q "zebra" <<< "cat dog" || handle_error "grep did not find the expected text"

echo ""


# ------------------------------------------------------------
# 4. trap ERR FOR CENTRALIZED ERROR REPORTING
# ------------------------------------------------------------
# An ERR trap can give one consistent place to log failures.
# Here we report:
#   - source file      -> from BASH_SOURCE
#   - line number      -> from LINENO
#   - failed command   -> from BASH_COMMAND
#
# Note: ERR has its own caveats and does not fire in every context.
# It is best used as extra visibility, not as a replacement for clear
# control flow.

echo "Section 4: trap ERR demo"

(
    set -Ee
    trap 'report_err "${LINENO}" "${BASH_SOURCE[0]}" "${BASH_COMMAND}"' ERR

    echo "  Triggering a failure inside a subshell with an ERR trap..."
    ls /definitely/missing/path >/dev/null
    echo "  You will NOT see this line"
)
err_trap_status=$?
if [ "$err_trap_status" -ne 0 ]; then
    echo "  ERR trap fired, and the parent script kept going"
fi

echo ""


# ------------------------------------------------------------
# 5. WRITING A die() FUNCTION
# ------------------------------------------------------------
# A die() helper is a simple way to stop immediately with a readable
# error message sent to standard error.
#
# Example definition:
#   die() { echo "ERROR: $*" >&2; exit 1; }
#
# We demonstrate it inside a subshell so the full lesson keeps running.

echo "Section 5: die() helper"

if ! (
    die "This is a demo failure from die()"
); then
    echo "  die() exited with status 1, but only inside the subshell"
fi

echo ""


# ------------------------------------------------------------
# 6. DEFENSIVE SCRIPTING
# ------------------------------------------------------------
# Defensive scripts validate assumptions early.
# Common checks near the top of a real script include:
#
#   [[ $# -ge 2 ]] || die "usage: script SOURCE DEST"
#   command -v curl >/dev/null 2>&1 || die "curl is required"
#
# This section demonstrates both argument validation and dependency
# checks without making this lesson depend on external inputs.

echo "Section 6: Defensive scripting patterns"

echo "  Example top-of-script guard: [[ \$# -ge 2 ]] || die \"usage: script SOURCE DEST\""

if ! (
    require_two_args "only-one-arg"
); then
    echo "  Argument validation failed as expected"
fi

if command -v bash >/dev/null 2>&1; then
    echo "  command -v bash: bash is available"
else
    die "bash is required for this lesson"
fi

if command -v shellcheck >/dev/null 2>&1; then
    echo "  command -v shellcheck: shellcheck is installed"
else
    echo "  command -v shellcheck: not currently installed in PATH"
fi

echo ""


# ------------------------------------------------------------
# 7. DEBUGGING RECIPES
# ------------------------------------------------------------
# Useful debugging tools include:
#   bash -x script.sh         -> trace the whole script from the outside
#   set -x / set +x           -> trace only a suspicious region
#   PS4='...'                 -> customize xtrace prefixes
#   trap 'echo line $LINENO' DEBUG
#
# The DEBUG trap runs BEFORE each simple command, so it can be noisy.
# Use it for short, focused investigations.

echo "Section 7: Debugging techniques"
echo "  Tip: run this script as 'bash -x Lesson10.sh' to trace everything"

echo "  Demo: DEBUG trap for a few commands"
debug_events=0
trap 'if (( debug_events < 2 )); then echo "  DEBUG trap: about to run line $LINENO -> $BASH_COMMAND"; debug_events=$((debug_events + 1)); fi' DEBUG
echo "  First command observed by DEBUG trap"
echo "  Second command observed by DEBUG trap"
trap - DEBUG

echo "  DEBUG trap removed so normal output stays clean"

echo ""


# ------------------------------------------------------------
# 8. SHELLCHECK
# ------------------------------------------------------------
# shellcheck is the most widely recommended linter for shell scripts.
# Install it and run it on EVERY script you write.
#
# Typical usage:
#   shellcheck Lesson10.sh
#   shellcheck *.sh
#
# It catches common mistakes such as:
#   - missing quotes around variables
#   - unused variables
#   - fragile word splitting
#   - unreachable code and suspicious conditions
#
# If shellcheck is available, we show the version. Otherwise we still
# print the command learners should use after installing it.

echo "Section 8: shellcheck"

if command -v shellcheck >/dev/null 2>&1; then
    echo "  Installed version: $(shellcheck --version | head -n 1)"
else
    echo "  Install shellcheck, then run: shellcheck Lesson10.sh"
fi

echo ""
echo "Lesson 10 complete: error-handling and debugging examples finished running."
