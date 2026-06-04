# Module 07 Assignments: String Manipulation

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
