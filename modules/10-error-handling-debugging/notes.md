# Module 10 Notes — Error Handling & Debugging

Printable reference for writing safer bash scripts.

---

## 1) `set` options quick table

| Option | Long form | Meaning | Why it helps | Common caveat |
|---|---|---|---|---|
| `-e` | `errexit` | Exit when a simple command fails | Stops many scripts from continuing after an unexpected failure | Tricky in `if`, `&&`, `||`, subshells, command substitutions, and other control-flow contexts |
| `-u` | `nounset` | Treat unset variables as errors | Catches typos like `$usre_name` early | Can break scripts that assume missing variables expand to empty strings |
| `-o pipefail` | `pipefail` | Pipeline fails if any command fails | Prevents hidden failures on the left side of a pipeline | Some commands in pipelines use non-zero status for normal control flow |
| `-x` | `xtrace` | Print commands before executing them | Great for debugging and teaching | Very noisy; can leak secrets if enabled around sensitive values |
| `-E` | `errtrace` | Inherit `ERR` trap into functions/subshells more consistently | Makes central error reporting more useful | Still not a full replacement for explicit error handling |

---

## 2) Standard script header

A common “safe by default” bash header:

```bash
#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
```

### Why this header is popular
- `#!/bin/bash` ensures the script runs with bash.
- `set -euo pipefail` enables a practical strict mode.
- `IFS=$'\n\t'` removes space from the default word-splitting characters, which reduces accidental splitting of filenames like `My File.txt`.

### Important note about `IFS`
`IFS` controls how unquoted expansions split into words. Changing it does **not** eliminate the need to quote variables. The safest habit is still:

```bash
echo "$file"
cp -- "$src" "$dst"
```

---

## 3) Error-handling patterns

### Pattern A: fail fast with `die()`

```bash
die() { echo "ERROR: $*" >&2; exit 1; }
```

Use it for unrecoverable errors such as bad arguments, missing files, or missing dependencies.

### Pattern B: validate arguments at the top

```bash
[[ $# -ge 2 ]] || die "usage: $0 SOURCE DEST"
```

Validate early so the rest of the script can assume required inputs exist.

### Pattern C: check required commands once

```bash
require_cmd() {
    command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"
}

require_cmd curl
require_cmd jq
```

### Pattern D: explicit handling for expected failures

```bash
if ! grep -q "$needle" "$file"; then
    echo "Pattern not found"
fi
```

Use explicit handling when a non-zero status is part of normal logic.

### Pattern E: one-line fallback

```bash
mkdir -p "$dir" || die "could not create directory: $dir"
```

### Pattern F: centralized logging with `ERR`

```bash
report_err() {
    local exit_code=$?
    echo "ERROR line $1: $2 (status=$exit_code)" >&2
}

trap 'report_err "$LINENO" "$BASH_COMMAND"' ERR
```

Use `ERR` traps to improve visibility, not to avoid writing clear logic.

---

## 4) Debugging recipes

### Trace the whole script

```bash
bash -x script.sh
```

Useful when you do not want to edit the file just to turn tracing on.

### Trace only one region

```bash
set -x
# suspicious code here
set +x
```

This keeps the rest of the script readable.

### Customize trace lines with `PS4`

```bash
PS4='+ ${BASH_SOURCE##*/}:${LINENO}:${FUNCNAME[0]:-main}: '
set -x
```

Helpful fields to include:
- source file
- line number
- current function name

### Use a DEBUG trap for short investigations

```bash
trap 'echo "line $LINENO -> $BASH_COMMAND"' DEBUG
```

The `DEBUG` trap runs **before** each simple command. It is powerful, but noisy.

### Print variable state safely

```bash
printf 'user=%q\n' "$user"
printf 'args=%q\n' "$@"
```

`printf %q` shows values in a shell-escaped form that makes spaces and special characters visible.

---

## 5) shellcheck cheatsheet

Run it on every script:

```bash
shellcheck script.sh
```

### Common severity labels
- `error` — likely broken or dangerous
- `warning` — risky or confusing
- `info` — useful suggestion
- `style` — readability or convention improvement

### Top 10 common warnings and what they usually mean

1. **Unquoted variable expansion**  
   Example: `rm $file`  
   Fix: `rm -- "$file"`

2. **Useless use of `cat`**  
   Example: `cat file | grep text`  
   Fix: `grep text file`

3. **Unsafe iteration with `for x in $(cat file)`**  
   Fix with: `while IFS= read -r line; do ...; done < file`

4. **Using `[` when `[[` is safer for bash string tests**  
   Especially relevant for pattern matching and `<` / `>` string comparisons.

5. **Variables assigned but never used**  
   Remove dead code or use the value intentionally.

6. **Arrays expanded without quotes**  
   Use `"${arr[@]}"`, not `${arr[@]}` when passing elements as separate arguments.

7. **Masking failures in pipelines**  
   Add `set -o pipefail` if a left-side failure should matter.

8. **Read without `-r`**  
   Use `read -r` to avoid backslash interpretation.

9. **Globs or tests that may break on spaces**  
   Quote variables and prefer arrays.

10. **Command substitutions used where direct commands are clearer**  
    Example: `for f in $(ls)` is fragile; prefer globs or `find ... -print0` plus a safe read loop.

---

## 6) Common pitfalls

### Pitfall: assuming `set -e` catches everything
It does not. Special cases include:
- commands used as `if` tests
- some commands in `&&` and `||` lists
- some command substitutions and subshell contexts

If a failure is expected or meaningful, handle it explicitly.

### Pitfall: reading `$?` too late
This is wrong:

```bash
some_command
echo "done"
echo "$?"
```

The final `$?` now belongs to `echo`, not `some_command`.

### Pitfall: trusting pipelines without `pipefail`

```bash
false | true
```

Without `pipefail`, that pipeline looks successful because the last command succeeded.

### Pitfall: relying on unset variables becoming empty strings
With `set -u`, this becomes an error:

```bash
echo "$missing_var"
```

Use defaults when appropriate:

```bash
echo "${missing_var:-default}"
```

### Pitfall: xtrace leaking secrets
Avoid tracing around commands that expose tokens, passwords, or private data.

### Pitfall: changing `IFS` and then forgetting to quote
Changing `IFS` can reduce accidental splitting, but quoting is still the primary defense.

---

## 7) Suggested checklist before shipping a script

- Add a bash shebang
- Decide whether `set -euo pipefail` is appropriate
- Validate required arguments early
- Check external dependencies with `command -v`
- Quote variable expansions
- Use arrays or `while IFS= read -r` for safe iteration
- Add clear error messages with `die()`
- Use `shellcheck`
- Test with good input and bad input
- Run with `bash -n` and, when needed, `bash -x`
