# Module 04: Functions — Notes

## Defining functions
Functions let you group commands under a reusable name.

```bash
say_hello() {
    echo "Hello"
}

function say_hi {
    echo "Hi"
}
```

- Prefer `name() { ... }` for everyday bash scripts.
- `function name { ... }` works in bash, but it is less portable to plain `sh`.
- Call a function by writing its name: `say_hello`

## Arguments
Functions receive positional parameters just like scripts do.

```bash
show_args() {
    echo "first: $1"
    echo "all: $@"
    echo "count: $#"
    echo "script name is still: $0"
}

show_args apple banana
```

Inside the function:
- `$1`, `$2`, ... = function arguments
- `$@` = all function arguments
- `$#` = number of function arguments
- `$0` = script name, not the function name

## Return vs Output
In bash, `return` sets an **exit status**, not a general data value.

```bash
is_ok() {
    return 0
}
```

- `0` usually means success
- non-zero usually means failure or a special condition
- valid range is `0-255`

If you want the function to give back actual data, print it:

```bash
make_name() {
    echo "$1 $2"
}

full_name="$(make_name Ada Lovelace)"
echo "$full_name"
```

## Local scope
Variables are global by default in bash.

```bash
name="outside"

change_it() {
    name="changed"
}
```

That can cause bugs because the function modifies the caller's variable.
Use `local` when the variable only belongs inside the function.

```bash
safe_change() {
    local name="inside"
    echo "$name"
}
```

Why it matters:
- avoids accidental overwrites
- makes functions easier to reason about
- reduces surprising side effects

## Recursion
A recursive function calls itself.

```bash
factorial() {
    local n="$1"
    if (( n <= 1 )); then
        echo 1
        return 0
    fi

    local smaller
    smaller="$(factorial $((n - 1)))"
    echo $((n * smaller))
}
```

Use recursion carefully in shell scripts. It is great for learning, but simple loops are often easier to read and debug.

## Common pitfalls

### 1) Forgetting `local`
```bash
count=10
bump() {
    count=99
}
```
After calling `bump`, the outer `count` becomes `99`.

### 2) Trying to `return` big numbers
```bash
myfunc() {
    return 300
}
```
Exit statuses are limited to `0-255`, so large values do not behave like normal return values.

### 3) Expecting `return` to act like other languages
```bash
add() {
    return $(( $1 + $2 ))
}
```
This sets an exit status, not a printable sum. For data, use `echo`:

```bash
add() {
    echo $(( $1 + $2 ))
}
```

### 4) Modifying caller variables by mistake
```bash
message="hello"
show() {
    message="bye"
}
```
Use `local message="bye"` if the change should stay inside the function.

## Quick pattern to remember
```bash
myfunc() {
    local arg1="$1"
    local arg2="${2:-default}"

    if [ -z "$arg1" ]; then
        return 1
    fi

    echo "$arg2 $arg1"
}

result="$(myfunc world Hello)"
```

- Use parameters for input
- Use `local` for temporary variables
- Use `return` for status
- Use `echo`/`printf` for output
