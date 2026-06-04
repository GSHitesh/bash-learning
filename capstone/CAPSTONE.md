# log-analyzer

Build a command-line Bash tool named `log-analyzer.sh` that summarizes application logs.
This capstone is designed to combine argument parsing, validation, strict mode, traps,
functions, arrays, parameter expansion, text processing, and stdin/file input handling.

---

## Project Goal

Create `log-analyzer.sh` that reads log data from a file or from standard input and prints:

1. Total line count
2. Count by log level
3. Top-N IP addresses
4. Top-N error messages
5. Hourly histogram

---

## Required CLI Behavior

Support these flags with `getopts`:

- `-f LOGFILE` → input log file (optional if stdin is provided)
- `-t TOP` → limit top lists, default `10`
- `-v` → verbose mode
- `-h` → help
- `-e ERROR_PATTERN` → default `ERROR|FATAL`

### Rules

- `-f` is required **unless** input is being piped on stdin.
- Exit `0` on success.
- Exit non-zero on invalid usage or runtime error.
- Print clear error messages to stderr.

---

## Required Implementation Details

Your script must:

- use `set -euo pipefail`
- install a trap-based `ERR` reporter
- validate required commands **before** doing work
- check for `awk`, `grep`, and `sort`
- use functions to organize the program
- use arrays somewhere meaningful
- use parameter expansion
- use traps for cleanup of temporary files
- support both file input and stdin input

---

## Input Assumptions

Assume logs resemble this shape:

```text
2025-01-01 10:15:01 INFO User logged in ip=192.168.1.10 user=alice
2025-01-01 10:15:45 ERROR Database timeout ip=192.168.1.11 code=DB100
2025-01-01 10:16:12 WARN Slow response ip=192.168.1.10 ms=812
```

- The first two fields are date and time.
- Log level is the third field.
- IPs appear as `ip=x.x.x.x`.
- Error lines match `ERROR_PATTERN`.

---

## Sample Input Snippet

Use this snippet while testing:

```bash
cat <<'LOG' > sample.log
2025-01-01 10:15:01 INFO User logged in ip=192.168.1.10 user=alice
2025-01-01 10:15:45 ERROR Database timeout ip=192.168.1.11 code=DB100
2025-01-01 10:16:12 WARN Slow response ip=192.168.1.10 ms=812
2025-01-01 10:17:50 ERROR Database timeout ip=192.168.1.11 code=DB100
2025-01-01 11:02:11 INFO User logged out ip=192.168.1.10 user=alice
2025-01-01 11:10:05 FATAL Disk offline ip=192.168.1.12 code=FS500
LOG
```

---

## Expected Output Sample

A valid output format can look like this:

```text
Log Analyzer Summary
====================
Source: sample.log
Total lines: 6

Count by level:
  ERROR 2
  FATAL 1
  INFO  2
  WARN  1

Top 10 IP addresses:
  2 192.168.1.11
  2 192.168.1.10
  1 192.168.1.12

Top 10 error messages:
  2 Database timeout
  1 Disk offline

Hourly histogram:
  2025-01-01 10 4
  2025-01-01 11 2
```

Exact spacing may differ, but the content should match.

---

## Acceptance Criteria

Check your finished script against all of these:

- [ ] `-h` prints usage and exits `0`
- [ ] `-v` enables extra diagnostic output
- [ ] `-t` changes the number of “top” rows shown
- [ ] `-e` changes which lines count as errors
- [ ] `-f` reads from a file when provided
- [ ] stdin works when `-f` is omitted
- [ ] required commands are validated before processing starts
- [ ] `set -euo pipefail` is enabled
- [ ] temporary files are cleaned up via traps
- [ ] runtime failures produce a clear non-zero exit

---

## Hints by Subsystem

### 1) CLI parsing

Use:

```bash
while getopts ":hf:t:ve:" opt; do
    case "$opt" in
        ...
    esac
done
```

Remember to validate `TOP` as a positive integer.

### 2) Command validation

Write a helper such as:

```bash
require_commands() {
    local cmd
    for cmd in awk grep sort; do
        command -v "$cmd" >/dev/null 2>&1 || {
            echo "Missing required command: $cmd" >&2
            exit 1
        }
    done
}
```

### 3) Strict mode and traps

Use `set -euo pipefail` near the top of the script.
Install one trap for cleanup and another for the `ERR` signal.

### 4) Input handling

If `-f` is given, read that file.
Otherwise, if stdin is not a terminal, capture stdin into a temporary file first.

### 5) Summary sections

- Total lines: `awk 'END { print NR }'`
- Level counts: inspect field 3
- IP extraction: `grep -Eo 'ip=([0-9]{1,3}\.){3}[0-9]{1,3}'`
- Error messages: remove the timestamp, level, and trailing metadata
- Hour buckets: date + hour from the first two fields

### 6) Cleanup strategy

Use an array to store temporary file paths, then remove them in `cleanup()`.

---

## Reference Solution

<details>
<summary>Show reference solution</summary>

```bash
#!/bin/bash
set -euo pipefail

TOP=10
VERBOSE=false
LOGFILE=""
ERROR_PATTERN='ERROR|FATAL'
TEMP_FILES=()
SCRIPT_NAME=$(basename "$0")

usage() {
    cat <<EOF
Usage: $SCRIPT_NAME [-h] [-v] [-f LOGFILE] [-t TOP] [-e ERROR_PATTERN]

Options:
  -h                Show help and exit
  -v                Enable verbose output
  -f LOGFILE        Read from LOGFILE
  -t TOP            Number of top rows to show (default: 10)
  -e ERROR_PATTERN  Regex for error lines (default: ERROR|FATAL)

Examples:
  ./$SCRIPT_NAME -f sample.log
  cat sample.log | ./$SCRIPT_NAME -t 5 -e 'ERROR|FATAL|PANIC'
EOF
}

cleanup() {
    local file
    for file in "${TEMP_FILES[@]}"; do
        [[ -e "$file" ]] && rm -f -- "$file"
    done
}

on_error() {
    local exit_code=$?
    echo "[$SCRIPT_NAME] error near line ${BASH_LINENO[0]} (exit=$exit_code)" >&2
    exit "$exit_code"
}

trap cleanup EXIT
trap on_error ERR

register_temp() {
    TEMP_FILES+=("$1")
}

require_commands() {
    local required=(awk grep sort)
    local cmd
    for cmd in "${required[@]}"; do
        command -v "$cmd" >/dev/null 2>&1 || {
            echo "Missing required command: $cmd" >&2
            exit 1
        }
    done
}

is_positive_integer() {
    [[ "$1" =~ ^[1-9][0-9]*$ ]]
}

parse_args() {
    while getopts ":hf:t:ve:" opt; do
        case "$opt" in
            h)
                usage
                exit 0
                ;;
            f)
                LOGFILE="$OPTARG"
                ;;
            t)
                TOP="$OPTARG"
                ;;
            v)
                VERBOSE=true
                ;;
            e)
                ERROR_PATTERN="$OPTARG"
                ;;
            :)
                echo "Option -$OPTARG requires an argument" >&2
                usage >&2
                exit 1
                ;;
            \?)
                echo "Unknown option: -$OPTARG" >&2
                usage >&2
                exit 1
                ;;
        esac
    done

    shift $((OPTIND - 1))

    if (($# > 0)); then
        echo "Unexpected positional arguments: $*" >&2
        exit 1
    fi

    if ! is_positive_integer "$TOP"; then
        echo "TOP must be a positive integer" >&2
        exit 1
    fi
}

prepare_input() {
    local stdin_file

    if [[ -n "$LOGFILE" ]]; then
        [[ -r "$LOGFILE" ]] || {
            echo "Cannot read log file: $LOGFILE" >&2
            exit 1
        }
        echo "$LOGFILE"
        return 0
    fi

    if [[ ! -t 0 ]]; then
        stdin_file="./.log-analyzer.stdin.$$"
        cat > "$stdin_file"
        register_temp "$stdin_file"
        echo "$stdin_file"
        return 0
    fi

    echo "Provide -f LOGFILE or pipe data on stdin" >&2
    exit 1
}

print_header() {
    local source_label=$1
    echo "Log Analyzer Summary"
    echo "===================="
    echo "Source: $source_label"
}

print_total_lines() {
    local input=$1
    echo "Total lines: $(awk 'END { print NR + 0 }' "$input")"
}

print_level_counts() {
    local input=$1
    echo
    echo "Count by level:"
    awk '{ counts[$3]++ } END { for (level in counts) printf "  %-5s %d\n", level, counts[level] }' "$input" | sort
}

print_top_ips() {
    local input=$1
    echo
    echo "Top $TOP IP addresses:"
    grep -Eo 'ip=([0-9]{1,3}\.){3}[0-9]{1,3}' "$input" \
        | cut -d= -f2 \
        | sort \
        | uniq -c \
        | sort -rn \
        | head -n "$TOP" \
        | awk '{ printf "  %d %s\n", $1, $2 }'
}

print_top_errors() {
    local input=$1
    echo
    echo "Top $TOP error messages:"
    awk -v pattern="$ERROR_PATTERN" '
        $0 ~ pattern {
            message = $0
            sub(/^[0-9-]+ [0-9:]+ [A-Z]+ /, "", message)
            sub(/ ip=[^ ]+.*/, "", message)
            counts[message]++
        }
        END {
            for (msg in counts) {
                printf "%d\t%s\n", counts[msg], msg
            }
        }
    ' "$input" | sort -rn | head -n "$TOP" | awk -F '\t' '{ printf "  %d %s\n", $1, $2 }'
}

print_hourly_histogram() {
    local input=$1
    echo
    echo "Hourly histogram:"
    awk '
        {
            split($2, t, ":")
            bucket = $1 " " t[1]
            counts[bucket]++
        }
        END {
            for (bucket in counts) {
                printf "%s\t%d\n", bucket, counts[bucket]
            }
        }
    ' "$input" | sort | awk -F '\t' '{ printf "  %s %d\n", $1, $2 }'
}

main() {
    local input_file

    parse_args "$@"
    require_commands
    input_file=$(prepare_input)

    [[ "$VERBOSE" == true ]] && echo "[debug] using input: $input_file" >&2
    [[ "$VERBOSE" == true ]] && echo "[debug] error pattern: $ERROR_PATTERN" >&2

    print_header "${LOGFILE:-stdin}"
    print_total_lines "$input_file"
    print_level_counts "$input_file"
    print_top_ips "$input_file"
    print_top_errors "$input_file"
    print_hourly_histogram "$input_file"
}

main "$@"
```

</details>
