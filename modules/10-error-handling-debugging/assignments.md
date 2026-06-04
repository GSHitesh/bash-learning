# Module 10 Assignments — Error Handling & Debugging

These exercises reinforce strict mode, defensive scripting, traps, retries, and `shellcheck`.

---

## 1) Refactor a script to use `set -euo pipefail` safely

### Problem
You inherit this script:

```bash
#!/bin/bash
name=$1
cat "$2" | grep "$name"
echo Found it
```

Refactor it so it safely uses:

```bash
set -euo pipefail
```

Requirements:
- fail with a helpful usage message if fewer than 2 args are passed
- avoid the useless `cat | grep` pipeline
- print a friendly “not found” message instead of crashing when `grep` does not match
- keep the script readable

### Sample I/O

```text
$ ./find-name.sh alice names.txt
Found: alice

$ ./find-name.sh zoe names.txt
Name 'zoe' was not found.

$ ./find-name.sh alice
ERROR: usage: ./find-name.sh NAME FILE
```

### Hint
`set -e` is great, but `grep` returning 1 for “no match” is often normal business logic. Handle that case explicitly with `if grep ...; then` or `if ! grep ...; then`.

### Solution
<details>
<summary>Show solution</summary>

```bash
#!/bin/bash
set -euo pipefail

# Validate arguments before doing any real work.
die() { echo "ERROR: $*" >&2; exit 1; }
usage() { die "usage: $0 NAME FILE"; }

[[ $# -eq 2 ]] || usage

name=$1
file=$2
[[ -f "$file" ]] || die "file not found: $file"

if grep -Fxq "$name" "$file"; then
    echo "Found: $name"
else
    echo "Name '$name' was not found."
fi
```

</details>

---

## 2) Write `die()` and `usage()` helpers

### Problem
Create `copy-safe.sh` that expects exactly 2 arguments: source and destination.

Requirements:
- `die()` prints `ERROR: ...` to stderr and exits 1
- `usage()` prints `usage: ./copy-safe.sh SOURCE DEST`
- reject missing args immediately
- reject a missing source file before calling `cp`

### Sample I/O

```text
$ ./copy-safe.sh
ERROR: usage: ./copy-safe.sh SOURCE DEST

$ ./copy-safe.sh missing.txt backup.txt
ERROR: source file not found: missing.txt
```

### Hint
Keep helpers tiny. `usage()` can simply call `die`.

### Solution
<details>
<summary>Show solution</summary>

```bash
#!/bin/bash
set -euo pipefail

die() { echo "ERROR: $*" >&2; exit 1; }
usage() { die "usage: ./copy-safe.sh SOURCE DEST"; }

[[ $# -eq 2 ]] || usage

src=$1
dst=$2
[[ -f "$src" ]] || die "source file not found: $src"

cp -- "$src" "$dst"
echo "Copied '$src' -> '$dst'"
```

</details>

---

## 3) Check required commands and dependencies before running

### Problem
Write a script named `backup-db.sh` that depends on `tar`, `gzip`, and `date`.

Requirements:
- define `require_cmd()` using `command -v`
- fail early if any dependency is missing
- create an archive name like `backup-2025-01-15.tar.gz`
- print a clear success message

### Sample I/O

```text
$ ./backup-db.sh
All dependencies are available.
Creating backup-2025-01-15.tar.gz
Backup created successfully.
```

### Hint
A reusable helper such as `require_cmd tar` is cleaner than repeating the same `if` block three times.

### Solution
<details>
<summary>Show solution</summary>

```bash
#!/bin/bash
set -euo pipefail

die() { echo "ERROR: $*" >&2; exit 1; }
require_cmd() {
    command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"
}

require_cmd tar
require_cmd gzip
require_cmd date

echo "All dependencies are available."
archive="backup-$(date +%F).tar.gz"
echo "Creating $archive"

tar -czf "$archive" ./data
echo "Backup created successfully."
```

</details>

---

## 4) Add an `ERR` trap that logs line number and command

### Problem
Write a script that:
- enables `set -Eeuo pipefail`
- installs an `ERR` trap
- logs the failing line number and command
- intentionally triggers a failure to prove the trap works

### Sample I/O

```text
$ ./err-demo.sh
Starting demo...
ERROR at line 14 while running: cp missing.txt backup.txt
```

### Hint
Use `BASH_COMMAND` for the command text and `LINENO` for the line number. Put the reporting logic in a function to keep the trap readable.

### Solution
<details>
<summary>Show solution</summary>

```bash
#!/bin/bash
set -Eeuo pipefail

report_err() {
    local exit_code=$?
    echo "ERROR at line $1 while running: $2 (status=$exit_code)" >&2
}

trap 'report_err "$LINENO" "$BASH_COMMAND"' ERR

echo "Starting demo..."
cp missing.txt backup.txt
```

</details>

---

## 5) Wrap a flaky command in retry logic with exponential backoff

### Problem
Suppose a network command fails intermittently. Write `retry.sh` with a function:

```bash
retry MAX_ATTEMPTS command args...
```

Requirements:
- retry a command up to `MAX_ATTEMPTS`
- wait `1`, then `2`, then `4`, then `8` seconds...
- stop immediately once the command succeeds
- print attempt numbers and delays
- fail with a final error after the last attempt

### Sample I/O

```text
$ ./retry.sh
Attempt 1 failed. Sleeping 1s...
Attempt 2 failed. Sleeping 2s...
Attempt 3 succeeded.
```

### Hint
Use a `delay` variable that starts at `1` and doubles with `delay=$((delay * 2))` after each failed attempt.

### Solution
<details>
<summary>Show solution</summary>

```bash
#!/bin/bash
set -euo pipefail

die() { echo "ERROR: $*" >&2; exit 1; }

retry() {
    local max_attempts=$1
    shift

    local attempt=1
    local delay=1

    while (( attempt <= max_attempts )); do
        if "$@"; then
            echo "Attempt $attempt succeeded."
            return 0
        fi

        if (( attempt == max_attempts )); then
            die "command failed after $attempt attempts: $*"
        fi

        echo "Attempt $attempt failed. Sleeping ${delay}s..."
        sleep "$delay"
        attempt=$((attempt + 1))
        delay=$((delay * 2))
    done
}

# Demo command: fails twice, then succeeds.
count=0
flaky() {
    count=$((count + 1))
    (( count >= 3 ))
}

retry 5 flaky
```

</details>

---

## 6) Run `shellcheck` on a broken script and fix everything

### Problem
Start with this intentionally broken script and fix all reported issues:

```bash
#!/bin/bash
file=$1
if [ -f $file ]; then
  cat $file | grep TODO
  echo Done
fi
for x in $(cat $file); do
  echo $x
done
```

Requirements:
- run `shellcheck broken.sh`
- fix quoting issues
- remove useless `cat`
- avoid unsafe `for x in $(cat file)` word splitting
- make the script handle missing args safely

### Sample I/O

```text
$ shellcheck broken.sh
# ... warnings shown ...

$ ./broken.sh tasks.txt
TODO: buy milk
TODO: call plumber
Done
word-safe iteration complete
```

### Hint
Expect warnings related to quoting, command substitution, and robustness. Use `while IFS= read -r line; do ... done < "$file"` for safe line-by-line processing.

### Solution
<details>
<summary>Show solution</summary>

```bash
#!/bin/bash
set -euo pipefail

die() { echo "ERROR: $*" >&2; exit 1; }
[[ $# -eq 1 ]] || die "usage: $0 FILE"

file=$1
[[ -f "$file" ]] || die "file not found: $file"

if grep -F "TODO" "$file"; then
    echo "Done"
fi

while IFS= read -r line; do
    echo "$line"
done < "$file"

echo "word-safe iteration complete"
```

</details>
