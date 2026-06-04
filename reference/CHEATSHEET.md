# Bash Cheatsheet

## Script header
```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

main() {
  printf 'hello %s\n' "${1:-world}"
}

main "$@"
```

| Item | Purpose | Notes |
|---|---|---|
| `#!/usr/bin/env bash` | Find bash in `PATH` | Good when bash is not always `/bin/bash` |
| `set -e` | Exit on unhandled command failure | Watch for expected non-zero statuses |
| `set -u` | Error on unset variables | Use `${var:-}` for optional vars |
| `set -o pipefail` | Pipeline fails if any stage fails | Crucial with `cmd1 | cmd2` |
| `IFS=$'\n\t'` | Split on newline/tab only | Helps avoid accidental splitting on spaces |

## Variables and quoting
```bash
name='Ada Lovelace'
printf '%s\n' "$name"        # exact value
printf '%s\n' "${name}_dev"  # braces remove ambiguity
printf '%s\n' "$HOME/bin"
```

| Form | Use | Why |
|---|---|---|
| `$var` | Simple expansion | Fine when boundary is obvious |
| `${var}` | Preferred in mixed text | `"${var}_suffix"` |
| `"$var"` | Default safe form | Prevents word splitting + globbing |
| `'literal'` | No expansion | Best for fixed text |
| `"double quotes"` | Expand vars/command substitution | Usually what you want |
| `$(cmd)` | Command substitution | Prefer over backticks |
| `` `cmd` `` | Old command substitution | Harder to nest/read |

### `"$@"` vs `"$*"`

| Form | Meaning |
|---|---|
| `"$@"` | Expands to separate quoted args: `"$1" "$2" ...` |
| `"$*"` | Expands to one string joined by first char of `IFS` |
| `$@` / `$*` unquoted | Word-split and glob-expanded; usually wrong |

## Positional parameters

| Param | Meaning |
|---|---|
| `$0` | Script name/path used to invoke script |
| `$1`..`${10}` | Individual arguments |
| `"$@"` | All args, preserved as separate words |
| `"$*"` | All args as one string |
| `$#` | Number of args |
| `$?` | Exit status of previous command |
| `$$` | Current shell PID |
| `$!` | PID of last background job |
| `$PPID` | Parent PID |

## Test operators

### Numeric tests
| Operator | True when |
|---|---|
| `-eq` | equal |
| `-ne` | not equal |
| `-lt` | less than |
| `-le` | less than or equal |
| `-gt` | greater than |
| `-ge` | greater than or equal |

### String tests
| Operator | True when |
|---|---|
| `=` / `==` | strings equal |
| `!=` | strings differ |
| `<` | left sorts before right (`[[ ]]`) |
| `>` | left sorts after right (`[[ ]]`) |
| `-z str` | string is empty |
| `-n str` | string is non-empty |

### File tests
| Operator | True when |
|---|---|
| `-f` | regular file exists |
| `-d` | directory exists |
| `-e` | path exists |
| `-r` | readable |
| `-w` | writable |
| `-x` | executable/searchable |
| `-s` | exists and size > 0 |
| `-L` | symlink |

## Conditionals
```bash
if [[ $# -lt 1 ]]; then
  printf 'usage: %s NAME\n' "$0" >&2
  exit 2
elif [[ $1 == admin ]]; then
  printf 'welcome\n'
else
  printf 'hello %s\n' "$1"
fi
```

### `[[ ]]` features
| Feature | Example |
|---|---|
| Safer string tests | `[[ $name == 'Ada Lovelace' ]]` |
| Pattern matching | `[[ $file == *.txt ]]` |
| Regex match | `[[ $email =~ ^[^@]+@[^@]+$ ]]` |
| No pathname expansion | `[[ $x == * ]]` behaves predictably |
| `&&` / `||` inside test | `[[ -n ${x:-} && $x != root ]]` |

```bash
case "$1" in
  start|up)   printf 'start\n' ;;
  stop|down)  printf 'stop\n' ;;
  restart)    printf 'restart\n' ;;
  *)          printf 'unknown: %s\n' "$1" >&2; exit 2 ;;
esac
```

## Loops
```bash
for name in alice bob carol; do
  printf '%s\n' "$name"
done

for ((i=0; i<3; i++)); do
  printf 'i=%d\n' "$i"
done

while IFS= read -r line; do
  printf '%s\n' "$line"
done < input.txt

until curl -fsS https://example.com/health >/dev/null; do
  sleep 1
done
```

| Control | Use |
|---|---|
| `break` | exit loop now |
| `continue` | skip to next iteration |
| `select` | quick menu loop in bash |

## Functions
```bash
greet() {
  local name=${1:-world}
  printf 'hello %s\n' "$name"
}

sum() {
  local a=$1 b=$2
  printf '%d\n' "$((a + b))"
}

die() {
  printf 'error: %s\n' "$*" >&2
  return 1
}
```

| Topic | Rule |
|---|---|
| Definition | `fname() { ...; }` |
| Args | Access as `$1`, `$2`, `"$@"` inside function |
| Return | `return` sets exit status `0-255` only |
| Data output | Use `printf`/`echo`; capture with `$(func ...)` |
| Scope | `local var=value` inside functions |

## Arrays
```bash
arr=(one 'two words' three)
printf '%s\n' "${arr[0]}"
printf '%s\n' "${arr[@]}"

letters=(a b c d e)
printf '%s\n' "${letters[@]:1:3}"   # b c d

declare -A ages=([alice]=30 [bob]=28)
printf '%s\n' "${ages[alice]}"
```

| Form | Meaning |
|---|---|
| `arr=(a b c)` | indexed array |
| `declare -A map=([k]=v)` | associative array |
| `${arr[@]}` | elements, separate words when quoted |
| `${arr[*]}` | all elements as one word when quoted |
| `${#arr[@]}` | element count |
| `${#arr[0]}` | length of first element |
| `${arr[@]:start:len}` | slice |
| `${!arr[@]}` | indexes / keys |

## Parameter expansion

| Expansion | Meaning |
|---|---|
| `${var:-default}` | use default if unset or empty |
| `${var:=default}` | assign default if unset or empty |
| `${var:?message}` | error if unset or empty |
| `${var:+alt}` | use alt if set and non-empty |
| `${#var}` | string length |
| `${var:offset:len}` | substring |
| `${var#prefix}` | remove shortest matching prefix |
| `${var##prefix}` | remove longest matching prefix |
| `${var%suffix}` | remove shortest matching suffix |
| `${var%%suffix}` | remove longest matching suffix |
| `${var/old/new}` | replace first match |
| `${var//old/new}` | replace all matches |
| `${var^^}` | uppercase |
| `${var,,}` | lowercase |

```bash
path=/srv/app/archive.tar.gz
printf '%s\n' "${path##*/}"     # archive.tar.gz
printf '%s\n' "${path%.gz}"     # /srv/app/archive.tar
printf '%s\n' "${path//a/A}"
```

## Arithmetic
```bash
((count++))
((sum = a + b))
printf '%d\n' "$((10 * 3 + 2))"
if (( uid == 0 )); then printf 'root\n'; fi
```

| Form | Use |
|---|---|
| `(( expr ))` | arithmetic evaluation / test |
| `$(( expr ))` | arithmetic expansion to string |
| `let "x += 1"` | older style; `(( ))` preferred |

## Redirection and file descriptors

### Common redirections
| Syntax | Meaning |
|---|---|
| `>` | stdout to file (truncate) |
| `>>` | stdout append |
| `2>` | stderr to file |
| `2>&1` | stderr to same destination as stdout |
| `&>` | stdout + stderr to one file (bash) |
| `<` | stdin from file |
| `<<EOF` | here-doc |
| `<<< "$x"` | here-string |
| `|` | pipe stdout to next command |
| `tee file` | copy stdout to screen and file |

### FD table
| FD | Stream | Default |
|---|---|---|
| `0` | stdin | keyboard / pipe input |
| `1` | stdout | terminal |
| `2` | stderr | terminal |

```bash
cmd >out.log 2>err.log
cmd >all.log 2>&1
sort < input.txt > output.txt
cat <<'EOF2' > config.ini
name=value
EOF2
printf '%s\n' "$json" | tee payload.log | jq .
```

## Process substitution
```bash
diff <(sort old.txt) <(sort new.txt)
mapfile -t users < <(cut -d: -f1 /etc/passwd)
printf '%s\n' "${users[@]}" > >(sed 's/^/[user] /')
```

| Form | Meaning |
|---|---|
| `<(cmd)` | expose command output as pseudo-file |
| `>(cmd)` | send output to command as pseudo-file |

## Processes and signals
```bash
sleep 60 &
pid=$!
trap 'rm -f "$tmp_file"' EXIT
trap 'printf "interrupted\n" >&2; exit 130' INT
wait "$pid"
```

| Item | Meaning |
|---|---|
| `$$` | current script PID |
| `$!` | last background PID |
| `$PPID` | parent PID |
| `wait` | wait for background job/PID |
| `trap 'handler' SIGINT` | run handler on signal |
| `kill -TERM "$pid"` | ask process to terminate |

### Common signals
| Signal | Typical meaning |
|---|---|
| `EXIT` | shell is exiting |
| `ERR` | command failed under `set -e` context |
| `INT` | Ctrl-C / SIGINT |
| `TERM` | polite termination request |
| `HUP` | terminal/session closed |

## Text-processing one-liners
```bash
grep -Rni 'TODO' .
sed -n '1,20p' file.txt
awk -F, '{sum += $3} END {print sum}' data.csv
sort file.txt | uniq -c | sort -rn | head
cut -d: -f1 /etc/passwd
tr '[:lower:]' '[:upper:]' < input.txt
find . -type f -name '*.log' -print0 | xargs -0 rm -f
```

| Tool | Quick pattern |
|---|---|
| `grep` | search lines: `grep -Rni pattern dir` |
| `sed` | print/substitute: `sed 's/old/new/g' file` |
| `awk` | field-based reports: `awk -F, '{print $2}' file` |
| `sort` | sort lines: `sort -u file` |
| `uniq` | collapse adjacent duplicates: `sort file | uniq -c` |
| `cut` | extract columns: `cut -d, -f1,3 file` |
| `tr` | translate/delete chars: `tr -d '\r'` |
| `xargs` | build command args: `find ... -print0 | xargs -0 ...` |
| `find` | recursive file selection |

## `getopts` template
```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

usage() {
  printf 'Usage: %s [-v] [-o FILE] NAME\n' "$0" >&2
}

verbose=false
output=''

while getopts ':vo:h' opt; do
  case "$opt" in
    v) verbose=true ;;
    o) output=$OPTARG ;;
    h) usage; exit 0 ;;
    :) printf 'Option -%s requires an argument\n' "$OPTARG" >&2; usage; exit 2 ;;
    \?) printf 'Unknown option: -%s\n' "$OPTARG" >&2; usage; exit 2 ;;
  esac
done
shift "$((OPTIND - 1))"
name=${1:?missing NAME}
```

## Debugging

| Tool | Use |
|---|---|
| `bash -x script.sh` | trace execution |
| `set -x` / `set +x` | enable/disable tracing inside script |
| `bash -n script.sh` | syntax check only |
| `shellcheck script.sh` | static analysis / lint |
| `printf '%q\n' "$var"` | inspect shell-escaped value |

```bash
PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '
set -x
```
