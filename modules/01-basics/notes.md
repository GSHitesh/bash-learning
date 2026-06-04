## Bash Basics Study Notes

### Shebang
- Put the shebang on the first line of the script.
- `#!/bin/bash` tells the system to run the file with Bash.
- Common workflow:

```bash
chmod +x script.sh
./script.sh
```

### Variables & quoting basics
- Create variables with `name="Sai"`.
- Do not put spaces around `=`.
- Read a value with `$name` or `${name}`.
- Use `${name}` when text touches the variable name.
- Quote variable expansions to keep spaces safe.

```bash
name="Hitesh"
echo "$name"
echo "Sai${name}"
```

### Positional parameters reference table

| Syntax | Meaning | Example |
| --- | --- | --- |
| `$0` | Script name/path used to start the script | `./Lesson1.sh` |
| `$1` | First argument | `John` |
| `$2` | Second argument | `Michael` |
| `$#` | Number of arguments | `2` |
| `$@` | All arguments, preserved as separate items when quoted | `John Michael` |
| `$*` | All arguments, often joined into one string when quoted | `John Michael` |

```bash
#!/bin/bash
echo "Script: $0"
echo "First: $1"
echo "Second: $2"
echo "Count: $#"
echo "All: $@"
```

### `read` cheatsheet
- Basic form: `read name`
- Prompt + read in one line: `read -p "Enter your name: " name`
- Do not write `read $name`.
- `read $name` expands first and can target the wrong variable.

```bash
echo "Enter your city:"
read city
echo "City: $city"

read -p "Enter your age: " age
echo "Age: $age"
```

### Common pitfalls
- **Wrong:** `name = "Sai"`
- **Right:** `name="Sai"`
- **Wrong:** `read $name`
- **Right:** `read name`
- **Wrong target:** `echo "$name_file"`
- **Clearer:** `echo "${name}_file"`
- Unquoted variables can break when values contain spaces.

```bash
file_name="my notes.txt"
echo "$file_name"
```

### Key takeaways
- Use `#!/bin/bash` on line 1.
- Variable assignment has no spaces around `=`.
- Use `$1`, `$2`, `$@`, and `$#` for CLI input.
- Use `read name` or `read -p "Prompt" name` for user input.
- Prefer `${name}` when joining variables with other text.
- Quote variables unless you specifically need word splitting.
