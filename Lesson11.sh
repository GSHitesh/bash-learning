#!/bin/bash
# ============================================================
# Lesson 11: Advanced Bash Patterns
# Topics covered:
#   1. getopts for short-option parsing
#   2. Long-option parsing with case/shift
#   3. Here-docs with and without interpolation
#   4. Coprocesses with coproc
#   5. Named pipes with mkfifo
#   6. Arithmetic in bash
#   7. Modular scripts and sourcing libraries
#   8. Useful advanced one-liners
# ============================================================

# This lesson is intentionally verbose.
# It is designed to be read top-to-bottom like lecture notes,
# but it is also fully runnable as a standalone demo script.

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
TEMP_PATHS=()
verbose=false
config_path="$SCRIPT_DIR/.lesson11.generated.conf"
config_is_temporary=true

cleanup() {
    # Remove any demo files we created while running this lesson.
    local path
    for path in "${TEMP_PATHS[@]}"; do
        if [[ -p "$path" || -e "$path" ]]; then
            rm -f -- "$path"
        fi
    done
}
trap cleanup EXIT

register_temp() {
    TEMP_PATHS+=("$1")
}

print_banner() {
    cat <<'BANNER'
============================================================
 Lesson 11 Demo: Advanced Bash Patterns
============================================================
BANNER
}

print_help() {
    cat <<EOF
Usage: ./Lesson11.sh [-h] [-v] [-f FILE]

Options:
  -h        Show this help message and exit
  -v        Enable extra explanation while the demo runs
  -f FILE   Write the interpolated here-doc config to FILE

Examples:
  ./Lesson11.sh
  ./Lesson11.sh -v
  ./Lesson11.sh -f ./demo.conf
EOF
}

# ------------------------------------------------------------
# 1. SHORT OPTIONS WITH getopts
# ------------------------------------------------------------
# The while/getopts/case pattern is the standard bash way to
# parse SHORT flags like -h, -v, and -f FILE.
#
# Pattern:
#   while getopts ":hv:f:" opt; do
#       case "$opt" in
#           h) ... ;;
#           v) ... ;;
#           f) value="$OPTARG" ;;
#           :) ... missing arg ... ;;
#           \?) ... unknown opt ... ;;
#       esac
#   done
#
# In the option string ":hv:f:":
#   h   -> flag, no value
#   v   -> flag, no value
#   f:  -> requires a value
# The leading ":" enables silent error handling so we can print
# our own friendly messages.
parse_short_options() {
    while getopts ":hv:f:" opt; do
        case "$opt" in
            h)
                print_help
                exit 0
                ;;
            v)
                verbose=true
                ;;
            f)
                config_path="$OPTARG"
                config_is_temporary=false
                ;;
            :)
                echo "Error: option -$OPTARG requires an argument." >&2
                print_help >&2
                exit 1
                ;;
            \?)
                echo "Error: unknown option -$OPTARG" >&2
                print_help >&2
                exit 1
                ;;
        esac
    done

    shift $((OPTIND - 1))

    if (($# > 0)); then
        echo "Note: ignoring positional arguments in this lesson demo: $*"
    fi
}

# ------------------------------------------------------------
# 2. LONG OPTIONS PATTERN
# ------------------------------------------------------------
# Bash has no built-in long-option parser like getopts for flags
# such as --name or --dry-run.
#
# The usual pattern is:
#   while [[ $# -gt 0 ]]; do
#       case "$1" in
#           --flag) ...; shift ;;
#           --key) value="$2"; shift 2 ;;
#           *) ... unknown option ... ;;
#       esac
#   done
# ------------------------------------------------------------
demo_long_options() {
    local -a argv=(--name bash-learning --count 3 --dry-run)
    local name=""
    local count=1
    local dry_run=false

    set -- "${argv[@]}"
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --name)
                name="$2"
                shift 2
                ;;
            --count)
                count="$2"
                shift 2
                ;;
            --dry-run)
                dry_run=true
                shift
                ;;
            --help)
                echo "Long-option demo help: --name VALUE --count N [--dry-run]"
                return 0
                ;;
            *)
                echo "Unknown long option in demo: $1"
                return 1
                ;;
        esac
    done

    echo "Long-option parser captured:"
    echo "  name=$name"
    echo "  count=$count"
    echo "  dry_run=$dry_run"
}

# ------------------------------------------------------------
# 3. HERE-DOCS
# ------------------------------------------------------------
# Here-docs are great for generating config files, templates,
# SQL snippets, JSON, and shell fragments.
#
# Unquoted delimiter: variables ARE expanded.
#   cat <<EOF
#   hello $USER
#   EOF
#
# Quoted delimiter: variables are NOT expanded.
#   cat <<'EOF'
#   hello $USER
#   EOF
# ------------------------------------------------------------
demo_here_docs() {
    local literal_path="$SCRIPT_DIR/.lesson11.literal.template"
    local app_name="advanced-demo"
    local app_port=8080

    if [[ "$config_is_temporary" == true ]]; then
        register_temp "$config_path"
    fi
    register_temp "$literal_path"

    cat > "$config_path" <<EOF
# Generated with variable interpolation enabled
app_name=$app_name
app_port=$app_port
home_dir=$HOME
script_dir=$SCRIPT_DIR
EOF

    cat > "$literal_path" <<'EOF'
# Generated with interpolation DISABLED
app_name=$app_name
app_port=$app_port
home_dir=$HOME
literal_braces=${HOME}
EOF

    echo "Interpolated config written to: $config_path"
    echo "Literal template written to:    $literal_path"
    echo
    echo "Interpolated file preview:"
    sed -n '1,5p' "$config_path"
    echo
    echo "Literal file preview:"
    sed -n '1,5p' "$literal_path"
}

# ------------------------------------------------------------
# 4. COPROCESSES WITH coproc
# ------------------------------------------------------------
# A coprocess gives bash a background command plus file
# descriptors so your script can TALK to that command.
#
# This is useful when you want a long-lived helper process.
# Think of it as a two-way conversation with a background job.
# ------------------------------------------------------------
demo_coproc() {
    local coproc_in
    local coproc_out
    local line

    coproc UPPERCASE { awk '{ print toupper($0); fflush(); }'; }

    coproc_in=${UPPERCASE[1]}
    coproc_out=${UPPERCASE[0]}

    printf '%s\n' "coprocess demo" >&"$coproc_in"
    printf '%s\n' "bash can send lines" >&"$coproc_in"
    exec {coproc_in}>&-

    echo "Coprocess replies:"
    while IFS= read -r line; do
        echo "  $line"
    done <&"$coproc_out"

    exec {coproc_out}<&-

    # By the time the read loop finishes, the coprocess has already seen
    # EOF on its stdin and normally exits on its own, so an explicit wait
    # is optional here.
}

# ------------------------------------------------------------
# 5. NAMED PIPES (mkfifo)
# ------------------------------------------------------------
# A named pipe (FIFO) is a special file for streaming data
# between processes.
#
# One process writes to the FIFO.
# Another process reads from it.
#
# Unlike a regular file, the data is consumed as it is read.
# ------------------------------------------------------------
demo_named_pipe() {
    local fifo_path="$SCRIPT_DIR/.lesson11.demo.pipe"
    local item

    register_temp "$fifo_path"
    mkfifo "$fifo_path"

    {
        printf '%s\n' "job-1" "job-2" "job-3" > "$fifo_path"
    } &

    echo "Reading from FIFO:"
    while IFS= read -r item; do
        echo "  consumer received -> $item"
    done < "$fifo_path"

    wait
}

# ------------------------------------------------------------
# 6. ARITHMETIC
# ------------------------------------------------------------
# Bash arithmetic is INTEGER ONLY.
#
# Common forms:
#   result=$(( 7 + 3 ))   -> expansion, use inside assignments
#   (( counter++ ))       -> arithmetic command, useful in tests
#   let "x = 5 * 2"       -> older style
#
# Integer division truncates:
#   $(( 5 / 2 ))  => 2
#
# For floating point, use an external tool such as awk or bc.
# ------------------------------------------------------------
demo_arithmetic() {
    local a=7
    local b=2
    local sum
    local counter=0
    local product=0
    local float_result

    sum=$((a + b))
    ((counter += 5))
    let "product = a * b"
    float_result=$(awk 'BEGIN { printf "%.2f", 7 / 2 }')

    echo "Arithmetic demos:"
    echo "  \$((a + b))          -> $sum"
    echo "  ((counter += 5))    -> $counter"
    echo "  let \"product=a*b\" -> $product"
    echo "  integer 5/2         -> $((5 / 2))"
    echo "  float via awk       -> $float_result"

    if command -v bc >/dev/null 2>&1; then
        echo "  float via bc        -> $(echo 'scale=2; 5/2' | bc)"
    else
        echo "  float via bc        -> skipped (bc not installed)"
    fi
}

# ------------------------------------------------------------
# 7. MODULAR SCRIPTS AND SOURCING LIBRARIES
# ------------------------------------------------------------
# Large scripts should be split into reusable pieces.
# You can place helpers in a library file and load them with:
#   source ./lib.sh
# or the POSIX shorthand:
#   . ./lib.sh
#
# To make a script usable both as a library and as an executable,
# guard the main call like this:
#   [[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
#
# That means:
#   - if the file was executed directly, run main
#   - if the file was sourced, do NOT auto-run main
# ------------------------------------------------------------
demo_modular_sourcing() {
    local lib_path="$SCRIPT_DIR/.lesson11.mathlib.sh"

    register_temp "$lib_path"

    cat > "$lib_path" <<'LIB'
#!/bin/bash
square() {
    local n=${1:-0}
    echo $((n * n))
}

main() {
    echo "Library executed directly. square(${1:-4}) = $(square "${1:-4}")"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
LIB

    # shellcheck source=/dev/null
    source "$lib_path"

    echo "Sourced helper says: square(9) = $(square 9)"
    echo 'Guard pattern used: [[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"'
}

# ------------------------------------------------------------
# 8. USEFUL ONE-LINERS
# ------------------------------------------------------------
# This section mixes tiny runnable examples with practical commands
# you will use in real projects.
# ------------------------------------------------------------
demo_one_liners() {
    local demo_file="$SCRIPT_DIR/.lesson11.duplicates.txt"
    declare -A capitals

    register_temp "$demo_file"

    capitals[france]="Paris"
    capitals[japan]="Tokyo"

    cat > "$demo_file" <<'EOF'
alpha
beta
alpha
gamma
beta
EOF

    awk '!seen[$0]++' "$demo_file" > "$demo_file.tmp"
    mv "$demo_file.tmp" "$demo_file"

    echo "Associative array set/get: capitals[japan] = ${capitals[japan]}"
    echo "Dedupe in place result:"
    sed -n '1,10p' "$demo_file"
    echo
    echo "Find and replace across a tree:"
    echo "  grep -rl 'old_text' ./src | xargs sed -i 's/old_text/new_text/g'"
    echo "JSON poke with jq (external dependency):"
    echo "  jq '.service.port = 9000' config.json"
}

print_section() {
    echo
    echo "------------------------------------------------------------"
    echo "$1"
    echo "------------------------------------------------------------"
}

main() {
    parse_short_options "$@"

    print_banner

    print_section "1. getopts short-option parsing"
    echo "Parsed options: verbose=$verbose, config_path=$config_path"
    echo "Pattern used: while getopts \":hv:f:\" opt; do ..."

    print_section "2. Long-option parsing pattern"
    demo_long_options

    print_section "3. Here-doc generation"
    demo_here_docs

    print_section "4. Coprocesses with coproc"
    demo_coproc

    print_section "5. Named pipes with mkfifo"
    demo_named_pipe

    print_section "6. Arithmetic forms"
    demo_arithmetic

    print_section "7. Modular scripts and sourcing"
    demo_modular_sourcing

    print_section "8. Useful one-liners"
    demo_one_liners

    if [[ "$verbose" == true ]]; then
        echo
        echo "Verbose note: every demo in this file is intentionally small."
        echo "In production scripts, combine these patterns with quoting,"
        echo "input validation, and clear exit codes."
    fi

    echo
    echo "Lesson 11 demo completed successfully."
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
