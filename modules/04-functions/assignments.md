# Module 04: Functions — Assignments

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
# Hello, Asha!

greet "Asha" "Welcome"
# Welcome, Asha!
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
# [2025-01-31 09:15:00] Starting app
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
# ----------------
# Deploying web
# ----------------
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
