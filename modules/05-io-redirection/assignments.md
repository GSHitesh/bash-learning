# Module 05 Assignments: I/O and Redirection

## 1) Redirect stderr only to a file
**Problem:**
Write a command that runs `ls missing-file real-file`, keeps normal output on the terminal, and saves only the error message into `errors.log`.

**Sample I/O:**
- Terminal shows the listing for `real-file`
- `errors.log` contains the `ls: cannot access 'missing-file'...` message

**Hint:**
Remember that stderr is file descriptor `2`.

<details>
<summary>Solution</summary>

```bash
ls missing-file real-file 2> errors.log
```

</details>

---

## 2) Merge stdout and stderr into one log
**Problem:**
Run a command that prints one normal line and one error line, then store both in `combined.log`.

**Sample I/O:**
- `combined.log` ends up with:
  ```text
  hello
  oops
  ```

**Hint:**
Send stdout to the file first, then point stderr to stdout's new location.

<details>
<summary>Solution</summary>

```bash
{
  echo "hello"
  echo "oops" >&2
} > combined.log 2>&1
```

</details>

---

## 3) Count lines from stdin via a pipe
**Problem:**
Take a list of values from stdin and count how many lines came in.

**Sample I/O:**
```bash
printf 'red\nblue\ngreen\n' | wc -l
# output: 3
```

**Hint:**
`wc -l` counts newline-terminated lines from stdin.

<details>
<summary>Solution</summary>

```bash
printf 'red\nblue\ngreen\n' | wc -l
```

</details>

---

## 4) Build a config file with a here-document
**Problem:**
Create a file named `app.conf` containing:

```ini
host=localhost
port=8080
debug=true
```

Use a here-document instead of multiple `echo` commands.

**Sample I/O:**
After running your command, `cat app.conf` should show the three lines above.

**Hint:**
Use `cat > app.conf <<EOF` and close it with the same marker.

<details>
<summary>Solution</summary>

```bash
cat > app.conf <<'EOF'
host=localhost
port=8080
debug=true
EOF
```

</details>

---

## 5) Compare two `find` outputs with process substitution
**Problem:**
Compare the file lists of `dir_a` and `dir_b` without creating intermediate files. Ignore ordering differences.

**Sample I/O:**
```bash
diff <(find dir_a -type f | sort) <(find dir_b -type f | sort)
```
If the directories contain the same file paths, `diff` prints nothing.

**Hint:**
`<(...)` makes command output look like a temporary file path.

<details>
<summary>Solution</summary>

```bash
diff <(find dir_a -type f | sort) <(find dir_b -type f | sort)
```

</details>

---

## 6) Use tee to log while still showing output
**Problem:**
Run a command that prints three status lines, displays them on the terminal, and also stores them in `run.log`.

**Sample I/O:**
- Terminal shows:
  ```text
  step 1
  step 2
  done
  ```
- `run.log` contains the same three lines

**Hint:**
Put `tee` at the end of a pipeline.

<details>
<summary>Solution</summary>

```bash
printf 'step 1\nstep 2\ndone\n' | tee run.log
```

</details>
