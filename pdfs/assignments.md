% Bash Mastery — Assignments
% bash-learning curriculum
% 2026-06-04

\newpage

# Table of Contents

1. Module 1 — Bash Basics

2. Module 2 — Conditionals

3. Module 3 — Loops

4. Module 4 — Functions

5. Module 5 — I/O & Redirection

6. Module 6 — Arrays

7. Module 7 — String Manipulation & Regex

8. Module 8 — Processes, Signals, Traps

9. Module 9 — Text Processing (grep / sed / awk)

10. Module 10 — Error Handling & Debugging

11. Module 11 — Advanced Patterns

\newpage


# Module 1 — Bash Basics

## Assignments: Bash Basics

### Exercise 1 (Easy): Hello with name from CLI
**Problem statement**
Write a script that accepts one name as the first command-line argument and prints:
`Hello, NAME!`

**Expected input/output example**
```bash
./hello_name.sh Hitesh
Hello, Hitesh!
```

**Hint**
Use `$1` for the first argument.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

name="$1"
echo "Hello, $name!"
```

</details>

### Exercise 2 (Easy): Greet using `read`
**Problem statement**
Write a script that asks the user for their name, stores it in a variable,
and then prints `Welcome, NAME!`.

**Expected input/output example**
```bash
./greet_read.sh
Enter your name: Sai
Welcome, Sai!
```

**Hint**
Use `read -p` to show the prompt and capture input in one line.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

read -p "Enter your name: " name
echo "Welcome, $name!"
```

</details>

### Exercise 3 (Medium): Sum of two CLI arguments
**Problem statement**
Write a script that takes two numbers from the command line and prints
their sum.

**Expected input/output example**
```bash
./sum_two.sh 7 5
Sum: 12
```

**Hint**
Use `$1` and `$2`, then arithmetic expansion with `$(( ... ))`.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

num1="$1"
num2="$2"
sum=$((num1 + num2))

echo "Sum: $sum"
```

</details>

### Exercise 4 (Medium): Print argument count and each argument
**Problem statement**
Write a script that prints:
- the script name
- the total number of arguments
- each argument on its own line

Number the arguments as `Arg 1`, `Arg 2`, and so on.

**Expected input/output example**
```bash
./show_args.sh apple mango grape
Script: ./show_args.sh
Count: 3
Arg 1: apple
Arg 2: mango
Arg 3: grape
```

**Hint**
Use `$0` for the script name, `$#` for the count, and loop through `"$@"`.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

echo "Script: $0"
echo "Count: $#"

index=1
for arg in "$@"
do
  echo "Arg $index: $arg"
  index=$((index + 1))
done
```

</details>

### Exercise 5 (Medium): Curly braces in variable expansion
**Problem statement**
Create a script with two variables:
- `prefix="Sai"`
- `name="Hitesh"`

Print two lines:
- `Without braces: ...`
- `With braces: ...`

The first line should show what happens when Bash sees `$prefixname`.
The second line must correctly print `SaiHitesh`.

**Expected input/output example**
```bash
./curly_demo.sh
Without braces:
With braces: SaiHitesh
```

**Hint**
When two variable names touch, Bash can read them as one bigger variable name.
Use `${prefix}` and `${name}` to mark the boundaries clearly.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

prefix="Sai"
name="Hitesh"

echo "Without braces: $prefixname"
echo "With braces: ${prefix}${name}"
```

```
Why the first line is blank:
- Bash searches for a variable named `prefixname`.
- `${prefix}${name}` makes the two variable names explicit.
```

</details>

### Exercise 6 (Hard): Base name and extension from a filename
**Problem statement**
Write a script that accepts a filename as the first command-line argument and prints:
- the original value
- the base name without the extension
- the extension only

Use Bash parameter expansion only. Do not use external commands such as
`basename`, `cut`, or `awk`.

**Expected input/output example**
```bash
./file_parts.sh report.txt
File: report.txt
Base name: report
Extension: txt
```

Another example:
```bash
./file_parts.sh archive.tar.gz
File: archive.tar.gz
Base name: archive.tar
Extension: gz
```

**Hint**
First remove everything before the last `/`, then split the remaining text
around the last `.`.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

filepath="$1"
filename="${filepath##*/}"
base_name="${filename%.*}"
extension="${filename##*.}"

echo "File: $filename"
echo "Base name: $base_name"
echo "Extension: $extension"
```

</details>

\newpage


# Module 2 — Conditionals

## Assignments: Bash Conditionals

### Exercise 1 (Easy · 10 marks): Grade calculator with `if / elif / else`
**Problem statement**  
Write a script that stores a numeric score in `marks` and prints:
- `Grade: A` for 90 or above
- `Grade: B` for 60 to 89
- `Grade: C` for anything below 60

**Sample I/O**
```bash
./grade.sh
Grade: B
```

**Hint**  
Use one `if`, one `elif`, and one `else`. Compare numbers with `-ge`.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

marks=75

if [ "$marks" -ge 90 ]; then
  echo "Grade: A"
elif [ "$marks" -ge 60 ]; then
  echo "Grade: B"
else
  echo "Grade: C"
fi
```

</details>

### Exercise 2 (Easy · 10 marks): Show `[ ]` vs `[[ ]]`
**Problem statement**  
Create a script with `file_name="report.txt"` and print:
- `Pattern matched` if the filename ends in `.txt`
- `Literal match only` when using `[ ]` with a quoted `"*.txt"`

The goal is to show that `[[ $file_name == *.txt ]]` supports pattern matching, while `[ "$file_name" = "*.txt" ]` treats the right side as a normal string.

**Sample I/O**
```bash
./pattern_demo.sh
Pattern matched
Literal match only
```

**Hint**  
Use `[[ ... ]]` for glob-style matching and `[ ... ]` for a literal string check.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

file_name="report.txt"

if [[ $file_name == *.txt ]]; then
  echo "Pattern matched"
fi

if [ "$file_name" != "*.txt" ]; then
  echo "Literal match only"
fi
```

</details>

### Exercise 3 (Medium · 15 marks): Fix numeric vs string comparison
**Problem statement**  
Write a script with:
- `a=10`
- `b=2`

Print two lines:
- `Numeric: a is greater`
- `String: b comes later alphabetically`

Use `-gt` for the numeric check and `>` inside `[[ ]]` for the string check. This exercise is about understanding `-eq`, `-gt`, and `=`/`>`.

**Sample I/O**
```bash
./compare_values.sh
Numeric: a is greater
String: b comes later alphabetically
```

**Hint**  
`10` and `2` behave differently in numeric and string comparisons.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

a=10
b=2

if [ "$a" -gt "$b" ]; then
  echo "Numeric: a is greater"
fi

if [[ "$b" > "$a" ]]; then
  echo "String: b comes later alphabetically"
fi
```

</details>

### Exercise 4 (Medium · 15 marks): File existence checker
**Problem statement**  
Ask the user for a path. Then print:
- `Regular file exists` if it is a file
- `Directory exists` if it is a directory
- `Path does not exist` otherwise

Use file test operators only.

**Sample I/O**
```bash
./path_check.sh
Enter a path: Lesson2.sh
Regular file exists
```

Another example:
```bash
./path_check.sh
Enter a path: modules
Directory exists
```

**Hint**  
Use `-f`, `-d`, and `-e` in the correct order.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

read -r -p "Enter a path: " path

if [ -f "$path" ]; then
  echo "Regular file exists"
elif [ -d "$path" ]; then
  echo "Directory exists"
elif [ ! -e "$path" ]; then
  echo "Path does not exist"
fi
```

</details>

### Exercise 5 (Medium · 20 marks): `case` with multiple patterns
**Problem statement**  
Write a script that stores a command in `action` and prints:
- `Starting service` for `start`, `run`, or `up`
- `Stopping service` for `stop` or `down`
- `Unknown action` for anything else

Use one `case` block and combine patterns with `|`.

**Sample I/O**
```bash
./service_case.sh
Starting service
```

**Hint**  
A single branch can match multiple words like `start|run|up)`.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

action="run"

case "$action" in
  start|run|up)
    echo "Starting service"
    ;;
  stop|down)
    echo "Stopping service"
    ;;
  *)
    echo "Unknown action"
    ;;
esac
```

</details>

### Exercise 6 (Hard · 30 marks): Interactive menu with `read` + `case`
**Problem statement**  
Build a simple menu-driven script that displays:
1. Show date
2. Show current directory
3. Exit

Read the user's choice and use `case` to print the correct result. If the input is not 1, 2, or 3, print `Invalid choice`.

**Sample I/O**
```bash
./menu.sh
1) Show date
2) Show current directory
3) Exit
Choose an option: 2
Current directory: /root/projects/bash-learning
```

**Hint**  
Print the menu with `echo`, capture input with `read -r -p`, then branch with `case`.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

echo "1) Show date"
echo "2) Show current directory"
echo "3) Exit"
read -r -p "Choose an option: " choice

case "$choice" in
  1)
    echo "Date: $(date)"
    ;;
  2)
    echo "Current directory: $(pwd)"
    ;;
  3)
    echo "Goodbye"
    ;;
  *)
    echo "Invalid choice"
    ;;
esac
```

</details>

\newpage


# Module 3 — Loops

## Module 03 — Loop Assignments

## Exercise 1: Print `1..N` with a C-style `for`
**Problem**
Write a Bash script that asks the user for `N` and prints the numbers from `1` to `N` using a C-style `for` loop.

**Expected output**
```bash
Enter N: 5
1
2
3
4
5
```

**Hint**
Use `for ((i=1; i<=N; i++))`.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
read -p "Enter N: " N

for ((i=1; i<=N; i++))
do
    echo "$i"
done
```

</details>

---

## Exercise 2: Sum `1..N` with `while`
**Problem**
Read a number `N` and calculate the sum of all integers from `1` to `N` using a `while` loop.

**Expected output**
```bash
Enter N: 5
Sum = 15
```

**Hint**
Keep a counter and a `sum` variable. Increment the counter each iteration.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
read -p "Enter N: " N

count=1
sum=0
while [ "$count" -le "$N" ]
do
    ((sum += count))
    ((count++))
done

echo "Sum = $sum"
```

</details>

---

## Exercise 3: Iterate over files and skip hidden ones
**Problem**
Loop over entries in the current directory and print only non-hidden filenames. If a name starts with `.`, skip it with `continue`.

**Expected output**
```bash
Visible: Lesson1.sh
Visible: Lesson2.sh
Visible: README.md
```

**Hint**
Use globbing such as `for f in * .*` carefully, or loop over `*` if you only want visible names. To practice `continue`, explicitly test for hidden names.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
for f in .* *
do
    [ "$f" = "." ] && continue
    [ "$f" = ".." ] && continue

    if [[ "$f" == .* ]]
    then
        continue
    fi

    [ -e "$f" ] || continue
    echo "Visible: $f"
done
```

</details>

---

## Exercise 4: Break on the first match
**Problem**
Search the current directory for the first file whose name ends with `.sh`. Print the match, then stop the loop immediately.

**Expected output**
```bash
First shell script found: Lesson1.sh
```

**Hint**
Use `break` as soon as the condition is true.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
for f in *
do
    [ -e "$f" ] || continue

    if [[ "$f" == *.sh ]]
    then
        echo "First shell script found: $f"
        break
    fi
done
```

</details>

---

## Exercise 5: Read `/etc/passwd` line by line
**Problem**
Read `/etc/passwd` one line at a time and print usernames whose login shell is **not** `nologin`.

**Expected output**
```bash
root
sync
hitesh
```

**Hint**
Use `IFS=:` with `read -r` so each colon-separated field is read safely.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
while IFS=: read -r username _ _ _ _ _ shell
do
    [[ "$shell" == */nologin ]] && continue
    echo "$username"
done < /etc/passwd
```

</details>

---

## Exercise 6: Iterate over an array with proper quoting
**Problem**
Create an array containing values such as `"red apple"`, `"green grape"`, and `"banana"`. Print each element on its own line without breaking words that contain spaces.

**Expected output**
```bash
Item: red apple
Item: green grape
Item: banana
```

**Hint**
Use `"${arr[@]}"`, not `${arr[@]}` and not `$(...)`.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
arr=("red apple" "green grape" "banana")

for item in "${arr[@]}"
do
    echo "Item: $item"
done
```

</details>

\newpage


# Module 4 — Functions

## Module 04: Functions — Assignments

## 1) Write `is_even()`
**Problem:** Create a function `is_even()` that accepts one number. It should return success (`0`) when the number is even and failure (`1`) when it is odd.

**Sample I/O:**
```bash
is_even 8
 echo $?   # 0

is_even 5
 echo $?   # 1
```

**Hint:** Use arithmetic expansion with `% 2`, and remember that `return` is for exit status.

<details>
<summary>Solution</summary>

```bash
is_even() {
    if (( $1 % 2 == 0 )); then
        return 0
    else
        return 1
    fi
}
```
</details>

---

## 2) Write `greet(name, greeting='Hello')`
**Problem:** Write a function `greet()` that prints a greeting. The first parameter is the name, and the second parameter is optional. If the second parameter is missing, use `Hello`.

**Sample I/O:**
```bash
greet "Asha"
## Hello, Asha!

greet "Asha" "Welcome"
## Welcome, Asha!
```

**Hint:** Use default values like `${2:-Hello}`.

<details>
<summary>Solution</summary>

```bash
greet() {
    local name="$1"
    local greeting="${2:-Hello}"
    echo "$greeting, $name!"
}
```
</details>

---

## 3) Recursive Fibonacci
**Problem:** Write a recursive function `fib()` that prints the nth Fibonacci number. Use `fib 0 -> 0`, `fib 1 -> 1`, `fib 6 -> 8`.

**Sample I/O:**
```bash
fib 0   # 0
fib 1   # 1
fib 6   # 8
```

**Hint:** You cannot store the result in `return` for big values. Print the number with `echo` and capture recursive calls with `$(...)`.

<details>
<summary>Solution</summary>

```bash
fib() {
    local n="$1"

    if (( n == 0 )); then
        echo 0
        return 0
    fi

    if (( n == 1 )); then
        echo 1
        return 0
    fi

    local a b
    a="$(fib $((n - 1)))"
    b="$(fib $((n - 2)))"
    echo $((a + b))
}
```
</details>

---

## 4) Timestamped `log()`
**Problem:** Write a function `log()` that prints a message prefixed with a timestamp like `[2025-01-31 09:15:00] Starting app`.

**Sample I/O:**
```bash
log "Starting app"
## [2025-01-31 09:15:00] Starting app
```

**Hint:** Use `date '+%Y-%m-%d %H:%M:%S'` and `"$*"` to print the whole message.

<details>
<summary>Solution</summary>

```bash
log() {
    local now
    now="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$now] $*"
}
```
</details>

---

## 5) Validate an IP-looking string
**Problem:** Write a function `looks_like_ip()` that returns success only if the input looks like `number.number.number.number`. For this exercise, you only need to check the structure, not whether each number is `0-255`.

**Sample I/O:**
```bash
looks_like_ip "192.168.1.10"
 echo $?   # 0

looks_like_ip "hello.world"
 echo $?   # 1
```

**Hint:** `[[ ... =~ ... ]]` is useful for pattern matching with regular expressions in bash.

<details>
<summary>Solution</summary>

```bash
looks_like_ip() {
    [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]
}
```
</details>

---

## 6) Refactor duplicated code into a function
**Problem:** Suppose a script repeats this block several times:

```bash
echo "----------------"
echo "Deploying web"
echo "----------------"
```

Refactor it into a reusable function `print_section()` that accepts the section name.

**Sample I/O:**
```bash
print_section "Deploying web"
## ----------------
## Deploying web
## ----------------
```

**Hint:** If you see repeated code with only one value changing, that changing value should usually become a parameter.

<details>
<summary>Solution</summary>

```bash
print_section() {
    local title="$1"
    echo "----------------"
    echo "$title"
    echo "----------------"
}
```
</details>

\newpage


# Module 5 — I/O & Redirection

## Module 05 Assignments: I/O and Redirection

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
## output: 3
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

\newpage


# Module 6 — Arrays

## Module 06 Assignments: Bash Arrays

## 1) Reverse an indexed array
**Problem**  
Given an array like `nums=(10 20 30 40 50)`, print the elements in reverse order.

**Sample I/O**
```bash
Input array : 10 20 30 40 50
Output      : 50 40 30 20 10
```

**Hint**  
Use indices from `${#nums[@]}` and loop backward with `for ((i=...; i>=0; i--))`.

<details>
<summary>Solution</summary>

```bash
nums=(10 20 30 40 50)

for ((i=${#nums[@]}-1; i>=0; i--)); do
    printf '%s ' "${nums[i]}"
done
printf '\n'
```
</details>

---

## 2) Remove duplicates with an associative array
**Problem**  
Given `items=(apple banana apple mango banana kiwi)`, print only the first occurrence of each value.

**Sample I/O**
```bash
Input  : apple banana apple mango banana kiwi
Output : apple banana mango kiwi
```

**Hint**  
Track seen values with `declare -A seen`. Only print when a value has not been seen yet.

<details>
<summary>Solution</summary>

```bash
items=(apple banana apple mango banana kiwi)
declare -A seen
unique=()

for item in "${items[@]}"; do
    if [[ -z ${seen[$item]} ]]; then
        seen[$item]=1
        unique+=("$item")
    fi
done

printf '%s\n' "${unique[@]}"
```
</details>

---

## 3) Count word frequency from a paragraph
**Problem**  
Take a paragraph, split it into words, and count how many times each word appears.

**Sample I/O**
```bash
Paragraph : bash is fun and bash is fast
Output:
bash => 2
is => 2
fun => 1
and => 1
fast => 1
```

**Hint**  
Use `read -ra words <<< "$text"` and an associative array like `count[word]=$((count[word]+1))`.

<details>
<summary>Solution</summary>

```bash
text="bash is fun and bash is fast"
read -ra words <<< "$text"
declare -A count

for word in "${words[@]}"; do
    ((count[$word]++))
done

for word in "${!count[@]}"; do
    echo "$word => ${count[$word]}"
done
```
</details>

---

## 4) Build a path-like array and join with ':'
**Problem**  
Create an array of directories and print them as a PATH-style string separated by colons.

**Sample I/O**
```bash
Input array : /usr/local/bin /usr/bin /bin
Output      : /usr/local/bin:/usr/bin:/bin
```

**Hint**  
Set `IFS=:` temporarily, then use `${paths[*]}` inside double quotes.

<details>
<summary>Solution</summary>

```bash
paths=(/usr/local/bin /usr/bin /bin)
(
    IFS=:
    echo "${paths[*]}"
)
```
</details>

---

## 5) Find the maximum number in an array
**Problem**  
Given `scores=(42 17 88 63 88 29)`, print the maximum numeric value.

**Sample I/O**
```bash
Input  : 42 17 88 63 88 29
Output : 88
```

**Hint**  
Start with `max=${scores[0]}` and compare each value using arithmetic comparison.

<details>
<summary>Solution</summary>

```bash
scores=(42 17 88 63 88 29)
max=${scores[0]}

for score in "${scores[@]}"; do
    if (( score > max )); then
        max=$score
    fi
done

echo "$max"
```
</details>

---

## 6) Store env-like key=value pairs in an associative array
**Problem**  
Given lines like `HOST=localhost`, `PORT=8080`, and `MODE=dev`, store them in an associative array and print each key/value pair.

**Sample I/O**
```bash
Input:
HOST=localhost
PORT=8080
MODE=dev

Possible output:
HOST => localhost
PORT => 8080
MODE => dev
```

**Hint**  
Split each line using parameter expansion: `${line%%=*}` for the key and `${line#*=}` for the value.

<details>
<summary>Solution</summary>

```bash
declare -A env_map
lines=("HOST=localhost" "PORT=8080" "MODE=dev")

for line in "${lines[@]}"; do
    key=${line%%=*}
    value=${line#*=}
    env_map[$key]=$value
done

for key in "${!env_map[@]}"; do
    echo "$key => ${env_map[$key]}"
done
```
</details>

\newpage


# Module 7 — String Manipulation & Regex

## Module 07 Assignments: String Manipulation

## 1) Extract the extension from a filename
**Problem:** Given a filename like `photo.jpeg` or `archive.tar.gz`, print only the final extension.

**Sample I/O:**
```text
Input: archive.tar.gz
Output: gz
```

**Hint:** Use the longest prefix-removal form from the left.

<details>
<summary>Solution</summary>

```bash
filename="archive.tar.gz"
extension="${filename##*.}"
echo "$extension"
```

If you want `tar.gz` instead of only `gz`, use a different rule.
</details>

---

## 2) Slugify a string
**Problem:** Convert a title into a simple slug: lowercase it, replace spaces with hyphens, and collapse repeated spaces first.

**Sample I/O:**
```text
Input:  Hello Bash Learners 
Output: hello-bash-learners
```

**Hint:** Trim or normalize spaces, then use `${var,,}` and `${var// /-}`.

<details>
<summary>Solution</summary>

```bash
title="Hello Bash Learners"
slug="${title,,}"
while [[ $slug == *"  "* ]]; do
    slug="${slug//  / }"
done
slug="${slug// /-}"
echo "$slug"
```

For a stricter slug, you could also remove punctuation with a regex check or loop.
</details>

---

## 3) Validate an email-ish string with `=~`
**Problem:** Accept strings that look like `name@example.com` and reject obvious non-matches.

**Sample I/O:**
```text
Input: user_42@example.org
Output: valid

Input: not-an-email
Output: invalid
```

**Hint:** Use `[[ $value =~ regex ]]` and do **not** quote the regex on the right side.

<details>
<summary>Solution</summary>

```bash
value="user_42@example.org"
regex='^[[:alnum:]._%+-]+@[[:alnum:].-]+\.[[:alpha:]]{2,}$'

if [[ $value =~ $regex ]]; then
    echo "valid"
else
    echo "invalid"
fi
```

This is only a simple teaching regex, not a full RFC-complete email validator.
</details>

---

## 4) Parse `name=value` lines
**Problem:** Read lines such as `port=8080` and split each line into a key and value.

**Sample I/O:**
```text
Input: port=8080
Output: key=port value=8080
```

**Hint:** Set `IFS='='` for a single `read` command.

<details>
<summary>Solution</summary>

```bash
while IFS= read -r line; do
    IFS='=' read -r key value <<< "$line"
    printf 'key=%s value=%s\n' "$key" "$value"
done <<'EOF'
port=8080
host=localhost
debug=true
EOF
```

If a value itself contains `=`, the last variable receives the remainder.
</details>

---

## 5) Mask the middle of a credit-card-like string
**Problem:** Keep the first 4 and last 4 characters visible, but replace the middle characters with `*`.

**Sample I/O:**
```text
Input: 1234567812345678
Output: 1234********5678
```

**Hint:** Use `${#card}` for length and `${card: -4}` for the tail.

<details>
<summary>Solution</summary>

```bash
card="1234567812345678"
prefix="${card:0:4}"
suffix="${card: -4}"
middle_len=$(( ${#card} - 8 ))
mask=""

for ((i=0; i<middle_len; i++)); do
    mask+="*"
done

echo "${prefix}${mask}${suffix}"
```

You can add a length check first if short inputs should be rejected.
</details>

---

## 6) Replace all tabs with 4 spaces
**Problem:** Convert tab characters in a string into four spaces.

**Sample I/O:**
```text
Input: name<TAB>score<TAB>grade
Output: name    score    grade
```

**Hint:** A tab can be written as `$'\t'` inside bash.

<details>
<summary>Solution</summary>

```bash
line=$'name\tscore\tgrade'
expanded="${line//$'\t'/    }"
echo "$expanded"
```

`//` replaces all matches. A single `/` would replace only the first tab.
</details>

\newpage


# Module 8 — Processes, Signals, Traps

## Module 08 Assignments — Processes, Signals, and Traps

These exercises focus on process control, signals, cleanup, and bounded execution.

---

## Exercise 1: Create a temp directory and clean it with `trap`

### Problem
Write a script that:
1. creates a temporary directory inside the current working directory using `mktemp -d ./scratch.XXXXXX`
2. stores the path in a variable
3. installs `trap 'rm -rf "$temp_dir"' EXIT`
4. creates two files inside that directory
5. prints the directory path while the script is running

### Sample I/O
```bash
$ bash exercise1.sh
Created temp dir: ./scratch.a1B2c3
Wrote files: notes.txt, data.log
Script finished. Cleanup will now run.
```

### Hint
Use `temp_dir="$(mktemp -d ./scratch.XXXXXX)"` and define the trap after the variable is assigned.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

temp_dir="$(mktemp -d ./scratch.XXXXXX)"
trap 'rm -rf "$temp_dir"' EXIT

echo "Created temp dir: $temp_dir"
echo "hello" > "$temp_dir/notes.txt"
echo "42" > "$temp_dir/data.log"
echo "Wrote files: notes.txt, data.log"
echo "Script finished. Cleanup will now run."
```

</details>

---

## Exercise 2: Run 5 sleeps in parallel and measure total time

### Problem
Write a script that launches five `sleep 1` commands in the background, waits for all of them, and prints how many seconds the whole batch took.

### Sample I/O
```bash
$ bash exercise2.sh
Launching 5 jobs in parallel...
All jobs finished.
Total seconds: 1
```

### Hint
Capture `start=$(date +%s)` before the loop, then `wait`, then `end=$(date +%s)`.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

start=$(date +%s)
echo "Launching 5 jobs in parallel..."

for i in 1 2 3 4 5; do
    sleep 1 &
done

wait
end=$(date +%s)

echo "All jobs finished."
echo "Total seconds: $((end - start))"
```

</details>

---

## Exercise 3: Catch Ctrl-C and exit gracefully

### Problem
Write a script that loops forever, prints `Working...`, and sleeps for 1 second each iteration. If the user presses Ctrl-C, the script should print a friendly message and exit with a non-zero status.

### Sample I/O
```bash
$ bash exercise3.sh
Working...
Working...
^CInterrupted by user. Cleaning up and exiting.
```

### Hint
Use `trap 'echo "Interrupted by user. Cleaning up and exiting."; exit 130' INT`.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

trap 'echo "Interrupted by user. Cleaning up and exiting."; exit 130' INT

while true; do
    echo "Working..."
    sleep 1
done
```

</details>

---

## Exercise 4: Spawn a background job and report when it finishes

### Problem
Write a script that starts a background command, saves its PID, waits for it, and then prints a message saying the job completed.

### Sample I/O
```bash
$ bash exercise4.sh
Started job with PID 12345
Job 12345 finished successfully.
```

### Hint
Start with `sleep 2 &`, save `pid=$!`, then `wait "$pid"`.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

sleep 2 &
pid=$!

echo "Started job with PID $pid"

if wait "$pid"; then
    echo "Job $pid finished successfully."
else
    echo "Job $pid failed."
fi
```

</details>

---

## Exercise 5: Use `timeout` to stop a long command

### Problem
Write a script that runs a command that would normally take 10 seconds, but use `timeout` so it is stopped after 2 seconds. Detect the timeout exit code and print a helpful message.

### Sample I/O
```bash
$ bash exercise5.sh
Starting bounded command...
The command timed out after 2 seconds.
```

### Hint
`timeout` usually returns exit code `124` when it kills the command.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

echo "Starting bounded command..."

if timeout 2 sleep 10; then
    echo "The command finished normally."
else
    status=$?
    if [ "$status" -eq 124 ]; then
        echo "The command timed out after 2 seconds."
    else
        echo "The command failed with status $status."
    fi
fi
```

</details>

---

## Exercise 6: Write a retry-with-backoff wrapper

### Problem
Write a shell function named `retry_with_backoff` that:
1. accepts a command to run
2. retries up to 3 times
3. waits 1 second before retry 2, then 2 seconds before retry 3
4. stops early if the command succeeds

Test it with a command that fails the first two times and succeeds the third time.

### Sample I/O
```bash
$ bash exercise6.sh
Attempt 1 failed.
Sleeping 1 second before retry...
Attempt 2 failed.
Sleeping 2 seconds before retry...
Attempt 3 succeeded.
```

### Hint
Use a loop like `for attempt in 1 2 3; do ... done` and compute sleep time with `sleep "$((attempt))"` for the failed attempts.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

counter=0
flaky_command() {
    counter=$((counter + 1))
    [ "$counter" -ge 3 ]
}

retry_with_backoff() {
    local attempt

    for attempt in 1 2 3; do
        if "$@"; then
            echo "Attempt $attempt succeeded."
            return 0
        fi

        echo "Attempt $attempt failed."

        if [ "$attempt" -lt 3 ]; then
            echo "Sleeping $attempt second(s) before retry..."
            sleep "$attempt"
        fi
    done

    return 1
}

retry_with_backoff flaky_command
```

</details>

\newpage


# Module 9 — Text Processing (grep / sed / awk)

## Module 09 Assignments: Text Processing

## 1) Extract email addresses with `grep -oE`
**Problem**  
Given a file `contacts.txt`, print only the email addresses.

**Sample input**
```txt
Name: Asha, Email: asha@example.com
Name: Ravi, Email: ravi.kumar@demo.org
Support: helpdesk@company.net
```

**Expected output**
```txt
asha@example.com
ravi.kumar@demo.org
helpdesk@company.net
```

**Hint**  
Use `grep -oE` with a regular expression that matches `name@domain.tld`.

<details>
<summary>Solution</summary>

```bash
grep -oE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' contacts.txt
```

</details>

---

## 2) Replace `TODO` with `DONE` in all `.md` files using `sed`
**Problem**  
Inside the current directory tree, replace every `TODO` with `DONE` in Markdown files only.

**Sample input**
```txt
notes.md: TODO: add examples
readme.md: TODO: review wording
script.sh: TODO should stay unchanged
```

**Expected result**  
All `.md` files are updated in place so `TODO` becomes `DONE`.

**Hint**  
Use `find` to locate `*.md` files, then run `sed -i` on them. Remember the macOS `sed -i ''` quirk.

<details>
<summary>Solution</summary>

```bash
find . -type f -name '*.md' -exec sed -i 's/TODO/DONE/g' {} +
```

macOS / BSD sed version:
```bash
find . -type f -name '*.md' -exec sed -i '' 's/TODO/DONE/g' {} +
```

</details>

---

## 3) Print users from `/etc/passwd` whose UID is at least 1000
**Problem**  
Use `awk` on `/etc/passwd` and print usernames whose UID is greater than or equal to `1000`.

**Sample input**
```txt
root:x:0:0:root:/root:/bin/bash
alice:x:1000:1000:Alice:/home/alice:/bin/bash
bob:x:1001:1001:Bob:/home/bob:/bin/zsh
```

**Expected output**
```txt
alice
bob
```

**Hint**  
`/etc/passwd` is colon-separated, so use `-F ':'`. The UID is field 3 and the username is field 1.

<details>
<summary>Solution</summary>

```bash
awk -F ':' '$3 >= 1000 {print $1}' /etc/passwd
```

</details>

---

## 4) Build a word-frequency pipeline
**Problem**  
From a paragraph in `paragraph.txt`, print the most frequent words in descending count order.

**Sample input**
```txt
Bash is simple. Bash is fast. Text tools make bash powerful.
```

**Sample output**
```txt
      3 bash
      1 tools
      1 text
      1 simple
      1 powerful
```

**Hint**  
Lowercase the text first, split words onto separate lines, then use `sort | uniq -c | sort -rn`.

<details>
<summary>Solution</summary>

```bash
tr '[:upper:]' '[:lower:]' < paragraph.txt \
  | tr -cs '[:alpha:]' '\n' \
  | sort \
  | uniq -c \
  | sort -rn
```

</details>

---

## 5) Sum a CSV column with `awk -F','`
**Problem**  
Given this file:

**Sample input**
```csv
item,amount
Keyboard,1200
Mouse,450
Monitor,8900
```

Print the sum of the `amount` column.

**Expected output**
```txt
10550
```

**Hint**  
Skip the header row with `NR > 1`.

<details>
<summary>Solution</summary>

```bash
awk -F ',' 'NR > 1 {sum += $2} END {print sum}' expenses.csv
```

</details>

---

## 6) Find files larger than 1 MB with `find` + `xargs ls -la`
**Problem**  
List detailed information for files bigger than 1 MB in the current directory tree.

**Sample command goal**
```txt
-rw-r--r-- 1 user user 2456789 Jan 10 12:30 ./logs/big.log
-rw-r--r-- 1 user user 1450011 Jan 10 12:30 ./data/archive.bin
```

**Hint**  
Use `find ... -size +1M -print0` and pair it with `xargs -0` so filenames with spaces are handled safely.

<details>
<summary>Solution</summary>

```bash
find . -type f -size +1M -print0 | xargs -0 ls -la
```

</details>

\newpage


# Module 10 — Error Handling & Debugging

## Module 10 Assignments — Error Handling & Debugging

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

## Validate arguments before doing any real work.
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

## Demo command: fails twice, then succeeds.
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
## ... warnings shown ...

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

\newpage


# Module 11 — Advanced Patterns

## Module 11 Assignments — Advanced Bash

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
## 1
printf '%s\n' "${cfg[theme]}"

## 2
awk '!seen[$0]++' names.txt > names.txt.tmp && mv names.txt.tmp names.txt

## 3
grep -rl --include='*.conf' 'localhost' . | xargs sed -i 's/localhost/127.0.0.1/g'

## 4
jq -r '.port' settings.json
```

</details>

\newpage

