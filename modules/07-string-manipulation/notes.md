# Module 07 Notes: String Manipulation and Regex

## Parameter Expansion Cheatsheet

| Expression | Behavior | Example |
| --- | --- | --- |
| `${#str}` | Length of string | `name="bash"` -> `4` |
| `${str:offset:length}` | Slice substring | `word="scripting"` + `${word:0:6}` -> `script` |
| `${str: -3}` | Last 3 characters (negative offset needs a space) | `word="bash"` -> `ash` |
| `${str^^}` | Uppercase all letters | `bash` -> `BASH` |
| `${str,,}` | Lowercase all letters | `BaSh` -> `bash` |
| `${str^}` | Uppercase first character | `bash` -> `Bash` |
| `${str,}` | Lowercase first character | `Bash` -> `bash` |
| `${var#pattern}` | Remove shortest matching prefix | `path="/a/b/c"` -> `${path#*/}` = `a/b/c` |
| `${var##pattern}` | Remove longest matching prefix | `path="/a/b/c"` -> `${path##*/}` = `c` |
| `${var%pattern}` | Remove shortest matching suffix | `file="a.tar.gz"` -> `${file%.*}` = `a.tar` |
| `${var%%pattern}` | Remove longest matching suffix | `file="a.tar.gz"` -> `${file%%.*}` = `a` |
| `${var/old/new}` | Replace first match | `foo foo` -> `bar foo` |
| `${var//old/new}` | Replace all matches | `foo foo` -> `bar bar` |
| `${var/#old/new}` | Replace only at the start | `hello world` -> `hi world` |
| `${var/%old/new}` | Replace only at the end | `report.txt` -> `report.md` |
| `${var:-default}` | Use default if unset or empty | `unset x` -> `${x:-guest}` = `guest` |
| `${var:=default}` | Use and assign default if unset or empty | `unset x` -> `${x:=guest}` sets `x=guest` |
| `${var:?message}` | Error if unset or empty | `: "${x:?x required}"` |
| `${var:+alt}` | Use alternate text if set and non-empty | `x=1` -> `${x:+yes}` = `yes` |

## Case Conversion

- Requires **bash 4+**.
- `${text^^}` uppercases all matching letters.
- `${text,,}` lowercases all matching letters.
- `${text^}` changes only the first character to uppercase.
- `${text,}` changes only the first character to lowercase.
- Useful for normalization, headings, tags, and simple title-style output.

## Pattern Matching vs Regex

| Topic | Pattern Matching | Regex |
| --- | --- | --- |
| Used by | Parameter expansion, `case`, `[[ $x == pattern ]]` | `[[ $x =~ regex ]]` |
| Syntax style | Globs like `*`, `?`, `[abc]` | Regex tokens like `^`, `$`, `+`, `()`, `{2,}` |
| Quoting rule | Usually quote variables, not patterns you want expanded as patterns | Do **not** quote the right side if you want real regex matching |
| Example | `${file##*/}` removes up to the last slash | `[[ $email =~ ^.+@.+\..+$ ]]` |

## `printf` Formats

| Format | Meaning | Example Result |
| --- | --- | --- |
| `%s` | String | `bash` |
| `%d` | Integer | `42` |
| `%05d` | Integer, width 5, zero-padded | `00042` |
| `%.2f` | Floating-point with 2 decimals | `3.14` |
| `%q` | Shell-escaped string | `two\ words` |

## Common Pitfalls

1. **Negative substring offsets need a space**: write `${var: -3}`, not `${var:-3}`.
2. **`#`/`##`/`%`/`%%` use glob patterns, not regex**.
3. **`/` replaces once, `//` replaces everywhere**.
4. **`:-` does not assign; `:=` does assign**.
5. **`${var:?msg}` can exit the current shell/script** if the variable is missing.
6. **For regex, do not quote the right side of `=~`** if you want bash to interpret regex syntax.
7. **Use `read -r`** unless you specifically want backslashes treated as escapes.
8. **Use `printf` instead of `echo`** when you need reliable formatting.
