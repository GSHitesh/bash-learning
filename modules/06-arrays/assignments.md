# Module 06 Assignments: Bash Arrays

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
