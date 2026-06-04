# Module 09 Assignments: Text Processing

## 1) Extract email addresses with `grep -oE`
**Problem**  
Given a file `contacts.txt`, print only the email addresses.

**Sample input**
```txt
Name: Asha, Email: asha@example.com
Name: Ravi, Email: ravi.kumar@demo.org
Support: helpdesk@company.net
```

**Expected output**
```txt
asha@example.com
ravi.kumar@demo.org
helpdesk@company.net
```

**Hint**  
Use `grep -oE` with a regular expression that matches `name@domain.tld`.

<details>
<summary>Solution</summary>

```bash
grep -oE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' contacts.txt
```

</details>

---

## 2) Replace `TODO` with `DONE` in all `.md` files using `sed`
**Problem**  
Inside the current directory tree, replace every `TODO` with `DONE` in Markdown files only.

**Sample input**
```txt
notes.md: TODO: add examples
readme.md: TODO: review wording
script.sh: TODO should stay unchanged
```

**Expected result**  
All `.md` files are updated in place so `TODO` becomes `DONE`.

**Hint**  
Use `find` to locate `*.md` files, then run `sed -i` on them. Remember the macOS `sed -i ''` quirk.

<details>
<summary>Solution</summary>

```bash
find . -type f -name '*.md' -exec sed -i 's/TODO/DONE/g' {} +
```

macOS / BSD sed version:
```bash
find . -type f -name '*.md' -exec sed -i '' 's/TODO/DONE/g' {} +
```

</details>

---

## 3) Print users from `/etc/passwd` whose UID is at least 1000
**Problem**  
Use `awk` on `/etc/passwd` and print usernames whose UID is greater than or equal to `1000`.

**Sample input**
```txt
root:x:0:0:root:/root:/bin/bash
alice:x:1000:1000:Alice:/home/alice:/bin/bash
bob:x:1001:1001:Bob:/home/bob:/bin/zsh
```

**Expected output**
```txt
alice
bob
```

**Hint**  
`/etc/passwd` is colon-separated, so use `-F ':'`. The UID is field 3 and the username is field 1.

<details>
<summary>Solution</summary>

```bash
awk -F ':' '$3 >= 1000 {print $1}' /etc/passwd
```

</details>

---

## 4) Build a word-frequency pipeline
**Problem**  
From a paragraph in `paragraph.txt`, print the most frequent words in descending count order.

**Sample input**
```txt
Bash is simple. Bash is fast. Text tools make bash powerful.
```

**Sample output**
```txt
      3 bash
      1 tools
      1 text
      1 simple
      1 powerful
```

**Hint**  
Lowercase the text first, split words onto separate lines, then use `sort | uniq -c | sort -rn`.

<details>
<summary>Solution</summary>

```bash
tr '[:upper:]' '[:lower:]' < paragraph.txt \
  | tr -cs '[:alpha:]' '\n' \
  | sort \
  | uniq -c \
  | sort -rn
```

</details>

---

## 5) Sum a CSV column with `awk -F','`
**Problem**  
Given this file:

**Sample input**
```csv
item,amount
Keyboard,1200
Mouse,450
Monitor,8900
```

Print the sum of the `amount` column.

**Expected output**
```txt
10550
```

**Hint**  
Skip the header row with `NR > 1`.

<details>
<summary>Solution</summary>

```bash
awk -F ',' 'NR > 1 {sum += $2} END {print sum}' expenses.csv
```

</details>

---

## 6) Find files larger than 1 MB with `find` + `xargs ls -la`
**Problem**  
List detailed information for files bigger than 1 MB in the current directory tree.

**Sample command goal**
```txt
-rw-r--r-- 1 user user 2456789 Jan 10 12:30 ./logs/big.log
-rw-r--r-- 1 user user 1450011 Jan 10 12:30 ./data/archive.bin
```

**Hint**  
Use `find ... -size +1M -print0` and pair it with `xargs -0` so filenames with spaces are handled safely.

<details>
<summary>Solution</summary>

```bash
find . -type f -size +1M -print0 | xargs -0 ls -la
```

</details>
