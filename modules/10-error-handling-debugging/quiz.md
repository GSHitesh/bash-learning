# Module 10 Quiz — Error Handling & Debugging

## Multiple Choice (10)

### 1) What does an exit status of `0` mean in bash?
- A. The command printed no output
- B. The command succeeded
- C. The command ran in the background
- D. The command returned false text

**Answer:** B

### 2) Which variable stores the exit status of the most recently executed command?
- A. `$#`
- B. `$!`
- C. `$?`
- D. `$$`

**Answer:** C

### 3) Without `set -o pipefail`, what does `$?` reflect after `false | true`?
- A. The status of the first command in the pipeline
- B. The status of the last command in the pipeline
- C. The sum of both exit codes
- D. A random non-zero code

**Answer:** B

### 4) What does `set -u` do?
- A. Treats unset variables as errors
- B. Disables globbing
- C. Prints executed commands
- D. Forces every command to return 0

**Answer:** A

### 5) Why is `set -e` considered tricky inside `if` conditions?
- A. It is ignored inside scripts
- B. Failing commands used as `if` tests are special cases and may not abort the script
- C. It only works with `[[ ]]`
- D. It converts stderr into stdout

**Answer:** B

### 6) What is the purpose of `PS4` when debugging with `set -x`?
- A. It changes the shell prompt for interactive sessions only
- B. It stores the last exit code
- C. It customizes the prefix shown for xtrace output
- D. It disables tracing after four commands

**Answer:** C

### 7) Which pattern is best when a command failure is expected and should be handled clearly?
- A. `set -e` and hope for the best
- B. `if ! cmd; then ... fi`
- C. `cmd &`
- D. `cmd >> /dev/null`

**Answer:** B

### 8) Which statement about `ERR` traps is most accurate?
- A. They fire for every successful command
- B. They can centralize failure logging, but they do not fire in every context
- C. They replace the need for explicit error handling entirely
- D. They only work in POSIX `sh`, not bash

**Answer:** B

### 9) In a “strict mode” header, why do many scripts also set `IFS=$'\n\t'`?
- A. To split words only on newlines and tabs instead of spaces too
- B. To make `set -u` ignore unset variables
- C. To enable arrays automatically
- D. To disable redirection

**Answer:** A

### 10) Which severity labels does `shellcheck` commonly use when reporting findings?
- A. low / medium / high only
- B. style / info / warning / error
- C. bronze / silver / gold
- D. note / severe / fatal

**Answer:** B

---

## Fill in the Blank (3)

### 11) Complete the common strict-mode header:

```bash
set -euo ________
```

**Answer:** `pipefail`

### 12) Complete the helper:

```bash
die() { echo "ERROR: $*" >&2; exit ___; }
```

**Answer:** `1`

### 13) The command used to check whether `curl` exists in `PATH` is:

```bash
________ -v curl >/dev/null 2>&1
```

**Answer:** `command`

---

## Predict the Output / Behavior (2)

### 14) Predict the value of `$?`

```bash
false | true
echo "$?"
```

What prints if `pipefail` is **not** enabled?

**Answer:** `0`

**Why:** Without `pipefail`, the pipeline status comes from the last command only, and `true` returns `0`.

### 15) Predict the behavior

```bash
set -e
if grep -q zebra <<< "cat dog"; then
    echo "found"
fi
echo "after if"
```

What happens?

- A. The script exits before printing anything
- B. It prints `found` only
- C. It prints `after if`
- D. It prints a bash syntax error

**Answer:** C

**Why:** `grep` is being used as the `if` test. That is a special case where `set -e` does not automatically abort the script.

---

## Answer Key

1. B  
2. C  
3. B  
4. A  
5. B  
6. C  
7. B  
8. B  
9. A  
10. B  
11. `pipefail`  
12. `1`  
13. `command`  
14. `0`  
15. C
