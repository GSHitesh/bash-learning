# Module 11 Assignments — Advanced Bash

These exercises reinforce advanced bash patterns from `Lesson11.sh`.
Each task includes the goal, sample I/O, a hint, and a collapsible solution.

---

## 1) Build a short-flag CLI with `getopts`

### Problem

Write `cli-demo.sh` that supports:

- `-h` → print help
- `-v` → enable verbose mode
- `-f FILE` → read a filename

If `-f` is missing, print an error and exit non-zero.

### Sample I/O

```text
$ ./cli-demo.sh -h
Usage: ./cli-demo.sh [-h] [-v] -f FILE

$ ./cli-demo.sh -v -f notes.txt
Verbose mode is ON
Processing file: notes.txt

$ ./cli-demo.sh -v
Error: -f FILE is required
```

### Hint

Use `while getopts ":hv:f:" opt; do ...` and remember that `f:` means the option needs a value.

### Solution
<details>
<summary>Show solution</summary>

```bash
#!/bin/bash
verbose=false
file=""

usage() {
    echo "Usage: ./cli-demo.sh [-h] [-v] -f FILE"
}

while getopts ":hv:f:" opt; do
    case "$opt" in
        h)
            usage
            exit 0
            ;;
        v)
            verbose=true
            ;;
        f)
            file="$OPTARG"
            ;;
        :)
            echo "Error: -$OPTARG requires a value" >&2
            usage >&2
            exit 1
            ;;
        \?)
            echo "Error: unknown option -$OPTARG" >&2
            usage >&2
            exit 1
            ;;
    esac
done

if [[ -z "$file" ]]; then
    echo "Error: -f FILE is required" >&2
    exit 1
fi

[[ "$verbose" == true ]] && echo "Verbose mode is ON"
echo "Processing file: $file"
```

</details>

---

## 2) Template renderer using here-docs

### Problem

Create a script that generates `app.conf` with variable interpolation enabled. Then create `template.txt` where variables are left literal.

### Sample I/O

```text
$ APP_NAME=demo PORT=9000 ./render.sh
Created app.conf
Created template.txt

$ cat app.conf
name=demo
port=9000

$ cat template.txt
name=$APP_NAME
port=$PORT
```

### Hint

Use `<<EOF` for interpolation and `<<'EOF'` to disable it.

### Solution
<details>
<summary>Show solution</summary>

```bash
#!/bin/bash
APP_NAME=${APP_NAME:-demo}
PORT=${PORT:-8080}

cat > app.conf <<EOF
name=$APP_NAME
port=$PORT
EOF

cat > template.txt <<'EOF'
name=$APP_NAME
port=$PORT
EOF

echo "Created app.conf"
echo "Created template.txt"
```

</details>

---

## 3) Integer calculator using `(( ))`

### Problem

Write `calc.sh` that accepts two integers and prints sum, difference, product, and integer division.

### Sample I/O

```text
$ ./calc.sh 9 4
sum=13
diff=5
prod=36
div=2
```

### Hint

Use arithmetic expansion for printing values and `(( ))` when you want arithmetic statements.

### Solution
<details>
<summary>Show solution</summary>

```bash
#!/bin/bash
if [[ $# -ne 2 ]]; then
    echo "Usage: ./calc.sh A B" >&2
    exit 1
fi

a=$1
b=$2

(( sum = a + b ))
(( diff = a - b ))
(( prod = a * b ))
(( div = a / b ))

echo "sum=$sum"
echo "diff=$diff"
echo "prod=$prod"
echo "div=$div"
```

</details>

---

## 4) Make a script both sourceable and runnable

### Problem

Create `mathlib.sh` with a function `double()` and a `main()` function. When sourced, only the function should load. When executed directly, it should run `main`.

### Sample I/O

```text
$ source ./mathlib.sh
$ double 7
14

$ ./mathlib.sh 7
14
```

### Hint

Use the guard `[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"`.

### Solution
<details>
<summary>Show solution</summary>

```bash
#!/bin/bash
double() {
    echo $(( $1 * 2 ))
}

main() {
    double "${1:-0}"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
```

</details>

---

## 5) `mkfifo` producer/consumer demo

### Problem

Use a named pipe called `jobs.pipe`. A producer should send three items into the pipe, and a consumer should print them.

### Sample I/O

```text
$ ./fifo-demo.sh
received: task-1
received: task-2
received: task-3
```

### Hint

Create the FIFO with `mkfifo`, write to it in the background, and read it in a `while read` loop.

### Solution
<details>
<summary>Show solution</summary>

```bash
#!/bin/bash
pipe="jobs.pipe"
rm -f "$pipe"
mkfifo "$pipe"
trap 'rm -f "$pipe"' EXIT

{
    printf '%s\n' task-1 task-2 task-3 > "$pipe"
} &

while IFS= read -r item; do
    echo "received: $item"
done < "$pipe"
```

</details>

---

## 6) One-liner challenges

### Problem

Solve these with compact commands:

1. Print the value of an associative-array key named `theme`.
2. Remove duplicate lines from `names.txt` in place.
3. Replace `localhost` with `127.0.0.1` across all `.conf` files.
4. Print `.port` from `settings.json` using `jq`.

### Sample I/O

```text
$ declare -A cfg=([theme]=dark)
$ printf '%s\n' "${cfg[theme]}"
dark
```

### Hint

Think about `${map[key]}`, `awk '!seen[$0]++'`, `grep -rl`, `sed -i`, and `jq`.

### Solution
<details>
<summary>Show solution</summary>

```bash
# 1
printf '%s\n' "${cfg[theme]}"

# 2
awk '!seen[$0]++' names.txt > names.txt.tmp && mv names.txt.tmp names.txt

# 3
grep -rl --include='*.conf' 'localhost' . | xargs sed -i 's/localhost/127.0.0.1/g'

# 4
jq -r '.port' settings.json
```

</details>
