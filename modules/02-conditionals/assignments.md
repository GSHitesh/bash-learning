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
