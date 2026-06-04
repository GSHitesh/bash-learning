# Module 11 Notes — Advanced Bash

Printable reference for advanced patterns in bash scripts.

---

## 1) `getopts` template

```bash
#!/bin/bash
verbose=false
file=""

usage() {
    echo "Usage: $0 [-h] [-v] [-f FILE]"
}

while getopts ":hv:f:" opt; do
    case "$opt" in
        h) usage; exit 0 ;;
        v) verbose=true ;;
        f) file="$OPTARG" ;;
        :) echo "Error: -$OPTARG needs a value" >&2; exit 1 ;;
        \?) echo "Error: invalid option -$OPTARG" >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))
```

### Key reminders

- `getopts` is for **short options**.
- A trailing `:` means the option requires a value.
- A leading `:` enables custom missing-argument handling.
- Use `shift $((OPTIND - 1))` if you still need positional arguments afterward.

---

## 2) Long-option pattern

```bash
while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)
            usage
            exit 0
            ;;
        --file)
            file="$2"
            shift 2
            ;;
        --verbose)
            verbose=true
            shift
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
done
```

### Notes

- Bash does not provide native long-option parsing through `getopts`.
- Use `shift` for flags and `shift 2` for `--key value` pairs.
- Validate that `$2` exists before reading it for value-taking options.

---

## 3) Here-doc forms

| Form | Interpolation? | Common use |
|---|---|---|
| `<<EOF` | Yes | Generate configs, JSON, scripts |
| `<<'EOF'` | No | Literal templates, examples |
| `<<-EOF` | Yes, strips leading tabs | Nicely indented here-docs |
| `<<-'EOF'` | No, strips leading tabs | Nicely indented literal blocks |

### Examples

```bash
cat <<EOF
user=$USER
home=$HOME
EOF
```

```bash
cat <<'EOF'
user=$USER
home=$HOME
EOF
```

---

## 4) Arithmetic forms

| Form | What it does | Example |
|---|---|---|
| `$(( ))` | Expands to a numeric value | `sum=$((a + b))` |
| `(( ))` | Runs an arithmetic command | `((count++))` |
| `let` | Older arithmetic command form | `let "x = 5 * 2"` |

### Important rules

- Bash arithmetic is **integer only**.
- `5 / 2` becomes `2`.
- Use `awk` or `bc` for floating-point math.

```bash
x=$((5 / 2))
((count += 1))
let "area = width * height"
awk 'BEGIN { print 5 / 2 }'
```

---

## 5) Sourcing and libraries

```bash
# lib.sh
say_hi() {
    echo "hi"
}

main() {
    say_hi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
```

### Notes

- `source lib.sh` runs the file in the **current shell**.
- `./lib.sh` runs it in a **new process**.
- `BASH_SOURCE[0]` refers to the file being read.
- The guard prevents `main` from running when the file is sourced.

---

## 6) Common pitfalls

1. Trying to parse `--long` options directly with `getopts`
2. Forgetting `shift $((OPTIND - 1))`
3. Expecting floating-point math from `(( ))`, `$(( ))`, or `let`
4. Using `<<EOF` when you meant to keep variables literal
5. Sourcing a file that auto-runs `main`
6. Forgetting to quote variable expansions in normal shell code
