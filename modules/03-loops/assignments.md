# Module 03 — Loop Assignments

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
