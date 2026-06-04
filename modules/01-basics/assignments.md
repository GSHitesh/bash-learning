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
