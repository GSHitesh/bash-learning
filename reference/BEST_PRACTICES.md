# Bash Best Practices for Production

1. **Start every serious script with a standard header.**
   - Rationale: makes interpreter choice and failure behavior explicit.
   ```bash
   #!/usr/bin/env bash
   set -euo pipefail
   IFS=$'\n\t'
   # LC_ALL=C   # enable for bytewise sorting/parsing when needed
   ```

2. **Quote variables by default: `"$var"`.**
   - Rationale: prevents accidental word splitting and glob expansion.
   ```bash
   printf '%s\n' "$file_path"
   cp -- "$src" "$dst"
   ```
   - Main exceptions:
     - Right side of `[[ string =~ regex ]]` should usually stay **unquoted**.
     - Intentional word splitting into an array or argument list.
     ```bash
     [[ $line =~ ^[0-9]+$ ]]
     read -r -a words <<< "$input"
     ```

3. **Prefer `[[ ]]` over `[ ]` in Bash scripts.**
   - Rationale: safer string handling, built-in regex/pattern support, fewer quoting hazards.
   ```bash
   if [[ $file == *.log && -s $file ]]; then
     printf 'non-empty log\n'
   fi
   ```

4. **Prefer `$(...)` over backticks.**
   - Rationale: easier nesting and clearer readability.
   ```bash
   today=$(date +%F)
   script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
   ```

5. **Prefer `printf` over `echo -e`.**
   - Rationale: predictable escaping and portability.
   ```bash
   printf 'User: %s\n' "$user"
   printf 'line1\nline2\n'
   ```

6. **Use `local` inside functions.**
   - Rationale: avoids leaking temporary state into the global namespace.
   ```bash
   parse_user() {
     local line=$1
     local user=${line%%:*}
     printf '%s\n' "$user"
   }
   ```

7. **Namespace globals with prefixes.**
   - Rationale: reduces collisions in larger scripts and sourced libraries.
   ```bash
   app_config_file=${APP_CONFIG_FILE:-/etc/myapp.conf}
   readonly APP_DEFAULT_PORT=8080
   ```

8. **Use `mktemp` for temp files/directories, and always clean them up.**
   - Rationale: avoids race conditions and name collisions.
   ```bash
   tmp_dir=$(mktemp -d)
   trap 'rm -rf "$tmp_dir"' EXIT
   ```

9. **Use `trap EXIT` for cleanup and `trap ERR`/signals for diagnostics.**
   - Rationale: ensures cleanup on success, failure, or interruption.
   ```bash
   cleanup() { rm -f -- "$lock_file"; }
   on_err() { printf 'failed at line %s\n' "$1" >&2; }
   trap cleanup EXIT
   trap 'on_err "$LINENO"' ERR
   ```

10. **Validate inputs early.**
    - Rationale: fail fast with a clear message.
    ```bash
    : "${API_TOKEN:?API_TOKEN is required}"
    [[ $# -ge 1 ]] || { printf 'missing input\n' >&2; exit 2; }
    ```

11. **Check required commands at the top.**
    - Rationale: users should discover missing dependencies immediately.
    ```bash
    require_cmd() { command -v "$1" >/dev/null 2>&1 || { printf 'missing: %s\n' "$1" >&2; exit 127; }; }
    require_cmd curl
    require_cmd jq
    ```

12. **Provide a `usage()` function.**
    - Rationale: a script without usage text is hard to operate and automate.
    ```bash
    usage() {
      printf 'Usage: %s [-v] -o FILE INPUT\n' "$0" >&2
    }
    ```

13. **Parse flags with `getopts`.**
    - Rationale: standard, built-in, and much less error-prone than manual shifting.
    ```bash
    while getopts ':vo:' opt; do
      case "$opt" in
        v) verbose=true ;;
        o) output=$OPTARG ;;
        :) printf 'Option -%s needs an argument\n' "$OPTARG" >&2; exit 2 ;;
        \?) usage; exit 2 ;;
      esac
    done
    shift "$((OPTIND - 1))"
    ```

14. **Be idempotent whenever possible.**
    - Rationale: rerunning automation should be safe.
    ```bash
    mkdir -p -- "$target_dir"
    ln -sfn -- "$new_release" current
    grep -qxF "$line" "$file" || printf '%s\n' "$line" >> "$file"
    ```

15. **Return meaningful exit codes.**
    - Rationale: callers and CI rely on them.
    - `0` success
    - `1` general failure
    - `2` bad usage / invalid arguments
    - `127` missing command
    ```bash
    exit 2
    ```

16. **Write errors to stderr.**
    - Rationale: keeps machine-readable stdout clean.
    ```bash
    printf 'error: invalid config\n' >&2
    ```

17. **Avoid parsing `ls`.**
    - Rationale: whitespace, newlines, and locale make it unsafe.
    ```bash
    shopt -s nullglob
    for file in *.log; do
      printf '%s\n' "$file"
    done

    find . -type f -name '*.log' -print0 |
      while IFS= read -r -d '' file; do
        printf '%s\n' "$file"
      done
    ```

18. **Prefer `read` loops for line-oriented input.**
    - Rationale: preserves whitespace and avoids splitting surprises.
    ```bash
    while IFS= read -r line; do
      printf '%s\n' "$line"
    done < input.txt
    ```

19. **Use arrays for lists of arguments.**
    - Rationale: arrays preserve boundaries safely.
    ```bash
    cmd=(grep -Rni -- "$pattern" "$root")
    "${cmd[@]}"
    ```

20. **Always use `--` before user-controlled path arguments when supported.**
    - Rationale: prevents filenames beginning with `-` from becoming options.
    ```bash
    rm -- "$file"
    grep -- "$pattern" -- "$file"
    ```

21. **Never `eval` untrusted input.**
    - Rationale: `eval` turns data into code and is a major injection risk.
    ```bash
    # bad
    eval "$user_supplied"
    # good
    bash_script=(/usr/bin/env bash "$script" "${args[@]}")
    "${bash_script[@]}"
    ```

22. **Quote everything passed to the shell, especially filenames.**
    - Rationale: filenames can contain spaces, globs, or shell metacharacters.
    ```bash
    mv -- "$old_name" "$new_name"
    ```

23. **Beware command injection through filenames and input text.**
    - Rationale: hostile names like `$(rm -rf /)` are just strings until you mishandle them.
    - Safe pattern: keep data as data, quote it, and avoid reinterpreting it.

24. **Run ShellCheck in CI.**
    - Rationale: it catches many Bash footguns cheaply.
    ```bash
    shellcheck *.sh
    ```

25. **Pin your Bash assumption explicitly.**
    - Rationale: `#!/usr/bin/env bash` signals that the script requires Bash, not POSIX `sh`.
    - If you need Bash 4+ features such as associative arrays, say so in docs/comments.

26. **Know when Bash is the wrong tool.**
    - Reach for Python or Go when:
      - script size pushes past roughly **200 LOC**,
      - you need nested/complex data structures,
      - performance is critical,
      - unit testing is central,
      - parsing JSON/XML/CSV becomes substantial.
    - Rationale: Bash is great glue; it is not great application architecture.

27. **Be explicit about portability.**
    - Rationale: Bash is not POSIX `sh`, and macOS often ships older Bash plus BSD userland.
    - Common gotchas:
      - `sed -i` differs (`sed -i ''` on BSD/macOS, `sed -i` on GNU).
      - `date` formatting flags differ.
      - `readlink -f` may not exist on macOS.
    ```bash
    # GNU-specific assumption; document it if used
    sed -i 's/old/new/' file
    ```

28. **Set locale intentionally when text tools must behave bytewise.**
    - Rationale: sort order and character classes can change with locale.
    ```bash
    LC_ALL=C sort data.txt
    ```

29. **Use a consistent style.**
    - 2-space indentation
    - `snake_case` for variables
    - `UPPER_CASE` for environment/config constants
    - function names `lowercase_with_underscores`
    - comments above non-obvious blocks, not at line ends
    ```bash
    backup_file() {
      local src=$1
      local dst=$2
      cp -- "$src" "$dst"
    }
    ```

30. **Keep logs actionable.**
    - Rationale: operators need context, not noise.
    ```bash
    log() { printf '[%s] %s\n' "$(date +%T)" "$*"; }
    die() { printf 'error: %s\n' "$*" >&2; exit 1; }
    ```
