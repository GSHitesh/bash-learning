# Module 05 Notes: I/O and Redirection

## File Descriptor Table

| FD | Name   | Meaning |
|----|--------|---------|
| 0  | stdin  | Standard input: where a command reads from |
| 1  | stdout | Standard output: normal command output |
| 2  | stderr | Standard error: error messages |

## Redirection Operators Table

| Operator | Meaning | Example |
|----------|---------|---------|
| `>` | Redirect stdout and overwrite target file | `echo "hi" > out.txt` |
| `>>` | Redirect stdout and append to target file | `echo "hi" >> out.txt` |
| `2>` | Redirect stderr only | `ls missing 2> errors.log` |
| `2>>` | Append stderr only | `cmd 2>> errors.log` |
| `2>&1` | Point stderr to wherever stdout currently goes | `cmd > all.log 2>&1` |
| `&>` | Redirect stdout and stderr together (bash shortcut) | `cmd &> all.log` |
| `<` | Read stdin from a file | `wc -l < names.txt` |
| `<<<` | Feed a single string to stdin (here-string) | `read -r name <<< "Hitesh"` |
| `<<EOF` | Feed a multi-line block to stdin (here-document) | `cat <<EOF` |
| `<<-EOF` | Here-document that strips leading **tabs** | `cat <<-EOF` |
| `|` | Pipe stdout of one command into stdin of another | `ls | wc -l` |
| `tee` | Copy stdin to stdout and a file | `make | tee build.log` |
| `<(cmd)` | Expose command output as a readable pseudo-file | `diff <(sort a) <(sort b)` |
| `>(cmd)` | Expose a writable pseudo-file that sends data into a command | `echo hi > >(tr a-z A-Z)` |
| `exec > file 2>&1` | Redirect the shell/script itself from that point onward | `exec > out.log 2>&1` |

## Here-Docs and Here-Strings

### Here-string
Use `<<<` when you have one short string and want to feed it into stdin.

```bash
read -r word <<< "hello"
```

### Here-document
Use a here-document when you need multiple lines.

```bash
cat <<'EOF'
name=app
port=8080
EOF
```

### Indented here-document
Use `<<-EOF` if you want to indent the body with **tabs** for readability.
Spaces are not stripped.

```bash
cat <<-'EOF'
	line one
	line two
EOF
```

## Process Substitution

Process substitution lets command output behave like a file path.

```bash
diff <(sort a.txt) <(sort b.txt)
```

That is often cleaner than creating temporary sorted files first.

You can also send output into a command with `>(cmd)`:

```bash
printf 'hello\n' > >(tr '[:lower:]' '[:upper:]')
```

## Pipes and the Subshell Gotcha

Pipes connect stdout from the left command to stdin of the right command.

```bash
printf 'a\nb\n' | wc -l
```

A common bash gotcha:

```bash
count=0
printf 'a\nb\n' | while read -r line; do
  count=$((count+1))
done
echo "$count"
```

In many cases the `while` loop runs in a **subshell**, so `count` outside the loop stays unchanged.

Safer pattern when you need the variable afterward:

```bash
count=0
while read -r line; do
  count=$((count+1))
done < <(printf 'a\nb\n')
echo "$count"
```

## Common Pitfalls

1. **Order matters**
   - `cmd >file 2>&1` redirects both stdout and stderr to `file`.
   - `cmd 2>&1 >file` usually leaves stderr going to the terminal.

2. **`>` overwrites**
   - Use `>>` if you want to keep existing content.

3. **`<<-EOF` strips tabs, not spaces**
   - If indentation is done with spaces, they stay in the output.

4. **Pipes may create subshells**
   - Variables changed inside a piped loop may not survive outside.

5. **`2>/dev/null` hides errors**
   - Helpful for noisy commands, but dangerous if it hides something important.

6. **Quote filenames in redirections and commands**
   - Example: `> "$log_file"` is safer than `> $log_file`.
