# Module 03 — Printable Notes

## `for` (list form)
Use this form when you already have a list of values.

```bash
for fruit in apple banana cherry
do
    echo "$fruit"
done
```

- Good for simple fixed lists
- Also useful with globs such as `*.sh`
- Quote variables when printing: `"$fruit"`

## `for` (C-style)
Use this when you need a numeric counter.

```bash
for ((i=1; i<=5; i++))
do
    echo "$i"
done
```

Structure:

```bash
for ((initialization; condition; increment))
do
    commands
done
```

## `while`
A `while` loop runs as long as its condition is true.

```bash
count=1
while [ "$count" -le 3 ]
do
    echo "$count"
    ((count++))
done
```

Common uses:
- Counters
- Repeating work until a condition changes
- Reading input or files line by line

## `until`
An `until` loop runs until its condition becomes true.

```bash
count=1
until [ "$count" -gt 3 ]
do
    echo "$count"
    ((count++))
done
```

Think of it as the opposite of `while`.

## `break` and `continue`
- `break` exits the loop immediately
- `continue` skips the rest of the current iteration

```bash
for n in 1 2 3 4 5
do
    [ "$n" -eq 2 ] && continue
    [ "$n" -eq 4 ] && break
    echo "$n"
done
```

Output:

```bash
1
3
```

## Reading a file line by line
Canonical safe pattern:

```bash
while IFS= read -r line
do
    echo "$line"
done < file.txt
```

Why this pattern?
- `IFS=` preserves leading/trailing whitespace
- `read -r` prevents backslash escaping
- `< file.txt` avoids unnecessary command substitution

Reading colon-separated files such as `/etc/passwd`:

```bash
while IFS=: read -r user _ _ _ _ _ shell
do
    echo "$user -> $shell"
done < /etc/passwd
```

## Looping over arrays vs command substitution
Prefer arrays when values may contain spaces.

### Safe array loop
```bash
files=("one file.txt" "two file.txt" "notes.md")
for f in "${files[@]}"
do
    echo "$f"
done
```

### Risky command substitution
```bash
for f in $(ls)
do
    echo "$f"
done
```

Why risky?
- Word splitting breaks filenames with spaces
- Output from `ls` is for display, not robust parsing

Better options:

```bash
for f in *
do
    [ -e "$f" ] || continue
    echo "$f"
done
```

or

```bash
while IFS= read -r file
do
    echo "$file"
done < file-list.txt
```

## Common pitfalls

### 1. Unquoted variables
```bash
echo $file   # risky
echo "$file" # safe
```

### 2. Using `for f in $(ls)`
Bad for filenames with spaces, tabs, or newlines.

### 3. Forgetting to update the loop condition
This can cause an infinite loop.

```bash
count=1
while [ "$count" -le 3 ]
do
    echo "$count"
    # missing ((count++))
done
```

### 4. Misusing `IFS`
Changing `IFS` globally can affect later splitting behavior.
Prefer setting it for a single command:

```bash
while IFS= read -r line
do
    echo "$line"
done < file.txt
```

### 5. Reading files with `for line in $(cat file)`
This splits on whitespace, not lines.
Use `while IFS= read -r line` instead.

## Quick comparison

| Loop type | Best use |
| --- | --- |
| `for item in list` | Fixed lists, globs, array values |
| `for ((...))` | Numeric counters |
| `while` | Repeat while condition is true |
| `until` | Repeat while condition is false |

## Memory tips
- Use `for ((...))` for numbers
- Use `while` for counters and files
- Use `until` when you want “keep going until this becomes true”
- Use `break` to stop early
- Use `continue` to skip one iteration
- Use `while IFS= read -r line; do ...; done < file` for safe line-by-line reading
