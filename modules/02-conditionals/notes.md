## Bash Conditionals Notes

### `if / elif / else` syntax
Use `if` when your script must choose between conditions.

```bash
if [ "$marks" -ge 90 ]; then
  echo "Grade: A"
elif [ "$marks" -ge 60 ]; then
  echo "Grade: B"
else
  echo "Grade: C"
fi
```

Quick rules:
- `then` starts the command block.
- `elif` adds another condition.
- `else` is the fallback.
- `fi` closes the statement.

### Test operators table

#### Numeric tests
| Operator | Meaning |
| --- | --- |
| `-eq` | equal to |
| `-ne` | not equal to |
| `-lt` | less than |
| `-le` | less than or equal to |
| `-gt` | greater than |
| `-ge` | greater than or equal to |

#### String tests
| Operator | Meaning |
| --- | --- |
| `=` or `==` | strings are equal |
| `!=` | strings are not equal |
| `<` | left string comes before right string alphabetically |
| `>` | left string comes after right string alphabetically |
| `-z` | string is empty |
| `-n` | string is not empty |

#### File tests
| Operator | Meaning |
| --- | --- |
| `-f` | path exists and is a regular file |
| `-d` | path exists and is a directory |
| `-e` | path exists |
| `-r` | path is readable |
| `-w` | path is writable |
| `-x` | path is executable |
| `-s` | file exists and is not empty |
| `-L` | path is a symbolic link |

### `[ ]` vs `[[ ]]`
`[ ... ]` is the traditional POSIX test form. `[[ ... ]]` is Bash-specific and more powerful.

```bash
file_name="notes.txt"

if [ "$file_name" = "notes.txt" ]; then
  echo "Exact match"
fi

if [[ $file_name == *.txt ]]; then
  echo "Pattern match"
fi
```

### `[[ ]]` superpowers
Use `[[ ... ]]` when you want extra Bash features.

- Supports pattern matching with `==`.
- Supports regex matching with `=~`.
- Lets you combine checks with `&&` and `||`.
- Avoids word splitting and pathname expansion in a safer way.

```bash
text="hello world"
file_name="report.txt"

if [[ $file_name == *.txt && -n $text ]]; then
  echo "Text file with non-empty text"
fi

email="student42@example.com"
if [[ $email =~ ^[a-z0-9]+@example\.com$ ]]; then
  echo "Valid example.com email"
fi
```

### `case` statement
Use `case` when one value can match several patterns.

```bash
action="reload"

case "$action" in
  start|run|up)
    echo "Start service"
    ;;
  stop|down)
    echo "Stop service"
    ;;
  restart|reload)
    echo "Reload service"
    ;;
  *)
    echo "Unknown action"
    ;;
esac
```

Useful reminders:
- Separate alternate patterns with `|`.
- End each branch with `;;` in normal usage.
- `*)` is the default branch.
- Close the block with `esac`.

### Interactive menu pattern
A common beginner pattern is `read` + `case`.

```bash
echo "1) Show date"
echo "2) Show current directory"
echo "3) Exit"
read -r -p "Choose an option: " choice

case "$choice" in
  1) echo "Date: $(date)" ;;
  2) echo "Directory: $(pwd)" ;;
  3) echo "Goodbye" ;;
  *) echo "Invalid choice" ;;
esac
```

### Common pitfalls
- **Unquoted variables in `[ ]`:** `[ $name = hello ]` can break if `$name` is empty or contains spaces.
- **Using `=` or `==` for numbers:** `[ "$a" = "$b" ]` and `[ "$a" == "$b" ]` compare text, not numeric value; use `-eq`.
- **Mixing `=` and `==`:** `=` is the portable string operator for `[ ... ]`; `==` is commonly used inside `[[ ... ]]`.
- **Using `<` or `>` inside `[ ]`:** they may be treated as redirection; prefer `[[ ... ]]`.
- **Missing `fi`:** every `if` block must end with `fi`.
- **Missing `esac`:** every `case` block must end with `esac`.

```bash
name="hello world"
a=10
b=2

# Safe string test
if [ "$name" = "hello world" ]; then
  echo "match"
fi

# Safe numeric test
if [ "$a" -gt "$b" ]; then
  echo "a is greater"
fi
```

### Quick checklist
- Quote variables in `[ ... ]`.
- Use `-eq`, `-lt`, `-gt` for numbers.
- Use `[[ ... ]]` for patterns, regex, and combined logic.
- Use file flags like `-f`, `-d`, and `-e` for path checks.
- Use `case` for many fixed choices.
