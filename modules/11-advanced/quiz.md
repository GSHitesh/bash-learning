# Module 11 Quiz — Advanced Bash

## Multiple Choice (10)

### 1) What does the option string `":hv:f:"` mean in `getopts`?
- A. `h`, `v`, and `f` all require values
- B. `h` and `v` are flags; `f` requires a value
- C. only `v` requires a value
- D. bash should ignore errors

**Answer:** B

### 2) Which variable holds the current option argument in `getopts`?
- A. `$1`
- B. `$OPT`
- C. `$OPTARG`
- D. `$ARGV`

**Answer:** C

### 3) Which pattern is commonly used for long options in bash?
- A. `select ... in`
- B. `while [[ $# -gt 0 ]]; do case "$1" in ... esac; done`
- C. `for opt in "$@"`
- D. `read --long`

**Answer:** B

### 4) What is the main difference between `(( x = 5 + 2 ))` and `x=$(( 5 + 2 ))`?
- A. The first is invalid bash
- B. The second supports floating point and the first does not
- C. `(( ))` is an arithmetic command; `$(( ))` expands to a value
- D. They are always identical in every context

**Answer:** C

### 5) What happens with a quoted here-doc delimiter like `<<'EOF'`?
- A. Variables are expanded twice
- B. Variable interpolation is disabled
- C. Only command substitution is disabled
- D. The file becomes executable

**Answer:** B

### 6) Why does `let "x = 5 / 2"` assign `2` to `x`?
- A. `let` rounds to nearest integer
- B. `let` uses integer arithmetic in bash
- C. `/` means modulo in `let`
- D. because quotes force string math

**Answer:** B

### 7) What does `source file.sh` do?
- A. Runs the script in a new shell process
- B. Loads and executes the file in the current shell
- C. Compiles the script
- D. Makes the file executable

**Answer:** B

### 8) In `[[ "${BASH_SOURCE[0]}" == "${0}" ]]`, what is this check usually for?
- A. Detecting whether a file was executed directly or sourced
- B. Checking whether bash exists
- C. Verifying the user is root
- D. Comparing two filenames alphabetically

**Answer:** A

### 9) Which command creates a named pipe?
- A. `mkpipe`
- B. `pipe`
- C. `mkfifo`
- D. `coproc`

**Answer:** C

### 10) Which tool is commonly used for floating-point math in shell scripts?
- A. `bc` or `awk`
- B. `sort`
- C. `chmod`
- D. `mkfifo`

**Answer:** A

---

## Fill in the Blank (3)

### 11) The shorthand POSIX-style command that behaves like `source file.sh` is `________ file.sh`.

**Answer:** `.`

### 12) In bash, `(( ))` and `$(( ))` both perform __________ arithmetic.

**Answer:** `integer`

### 13) The `getopts` variable that tracks the next argument index is `________`.

**Answer:** `OPTIND`

---

## Predict the Output / Behavior (2)

### 14) Predict the output:

```bash
x=3
echo $(( x * 4 ))
```

**Answer:** `12`

### 15) Predict the output:

```bash
name="Bash"
cat <<'EOF'
Hello $name
EOF
```

**Answer:** `Hello $name`
