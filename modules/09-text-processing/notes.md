# Module 09 Notes: Text Processing

Printable quick-reference notes for `grep`, `sed`, `awk`, and related tools.

---

## grep cheatsheet

### Basic form
```bash
grep 'pattern' file
```

### Common flags
```bash
grep -i 'error' file      # case-insensitive
grep -v 'INFO' file       # invert match
grep -n 'TODO' file       # show line numbers
grep -r 'main' src/       # recursive search
grep -E 'cat|dog' file    # extended regex
grep -F 'a+b' file        # fixed string, no regex parsing
grep -c 'ERROR' file      # count matching lines
grep -l 'TODO' *.md       # print filenames with matches
grep -oE '[0-9]+' file    # print only the matched text
```

### Common regex examples
```bash
grep -E '^[A-Z]' file              # line starts with uppercase
grep -E '[0-9]{4}' file            # 4-digit number
grep -oE '[^ ]+@[^ ]+' file        # rough email extraction
```

---

## sed cheatsheet

### Basic substitution
```bash
sed 's/old/new/' file      # first match per line
sed 's/old/new/g' file     # all matches per line
sed 's/foo/bar/2' file     # second match per line
sed -n 's/foo/bar/p' file  # print only lines where substitution happened
```

### Addressing and deletion
```bash
sed '1,5s/apple/orange/g' file   # apply only to lines 1 through 5
sed '/DEBUG/d' file              # delete matching lines
sed '/start/,/end/d' file        # delete a range of lines
```

### In-place editing
```bash
sed -i 's/TODO/DONE/g' notes.md
```

### Portability note
- GNU sed (Linux): `sed -i 's/a/b/' file`
- BSD sed (macOS): `sed -i '' 's/a/b/' file`

### Multiple commands
```bash
sed -e 's/error/ERROR/g' -e '/DEBUG/d' app.log
```

---

## awk one-liners cheatsheet

### Basic fields
```bash
awk '{print $0}' file      # whole line
awk '{print $1}' file      # first field
awk '{print $NF}' file     # last field
awk '{print NR, $0}' file  # line number + line
```

### Custom field separator
```bash
awk -F ',' '{print $1, $3}' users.csv
```

### BEGIN / END
```bash
awk 'BEGIN {print "Start"} {print $1} END {print "Done"}' file
```

### Filtering
```bash
awk '$3 > 100' file
awk -F ':' '$3 >= 1000 {print $1}' /etc/passwd
```

### Sum a column
```bash
awk '{sum += $2} END {print sum}' numbers.txt
awk -F ',' 'NR > 1 {sum += $3} END {print sum}' report.csv
```

### printf formatting
```bash
awk '{printf "%-10s %5d\n", $1, $2}' file
```

### FS vs OFS
- `FS`: input field separator
- `OFS`: output field separator

Example:
```bash
awk 'BEGIN {FS=","; OFS=" | "} {print $1, $2}' file.csv
```

---

## sort / uniq / cut / tr quick ref

### cut
```bash
cut -d ',' -f1,3 users.csv
cut -c1-5 file
```

### sort
```bash
sort file              # alphabetical
sort -n numbers.txt    # numeric
sort -r file           # reverse
sort -u file           # unique lines after sorting
sort -nu numbers.txt    # numeric sort + unique
sort -t ',' -k3,3nr report.csv
```

### uniq
```bash
sort words.txt | uniq
sort words.txt | uniq -c
sort words.txt | uniq -d
```

### tr
```bash
tr '[:upper:]' '[:lower:]' < file
tr -d ',' < file
tr -s ' ' < file
```

### wc
```bash
wc file
wc -l file
wc -w file
wc -c file
```

### head / tail
```bash
head -5 file
tail -10 file
tail -f app.log
```

---

## Pipeline patterns

### Top 5 most frequent words
```bash
tr '[:upper:]' '[:lower:]' < paragraph.txt \
  | tr -cs '[:alpha:]' '\n' \
  | sort \
  | uniq -c \
  | sort -rn \
  | head -5
```

### Find errors in logs
```bash
grep -i 'error' app.log | tail -20
```

### Extract a CSV column and sort it
```bash
cut -d ',' -f2 users.csv | sort | uniq
```

### Count users with UID >= 1000
```bash
awk -F ':' '$3 >= 1000 {count++} END {print count}' /etc/passwd
```

### Safe filename handling
```bash
find . -type f -print0 | xargs -0 ls -la
```

---

## Common pitfalls

### 1. `sed -i` portability
- Linux usually uses GNU sed.
- macOS usually uses BSD sed.
- `sed -i` syntax is different between them.

### 2. GNU vs BSD differences
- Some flags and regex behaviors differ.
- If a command works on Linux but not macOS, check the system's man page.

### 3. `uniq` only removes adjacent duplicates
```bash
uniq words.txt
```
This only works as expected if identical lines are already next to each other, so often you want:
```bash
sort words.txt | uniq
```

### 4. `cat file | grep ...` is usually unnecessary
Prefer:
```bash
grep 'word' file
```
instead of:
```bash
cat file | grep 'word'
```
This is often called a UUOC: useless use of `cat`.

### 5. `xargs` without `-0` can break on spaces
Prefer:
```bash
find . -type f -print0 | xargs -0 ls -la
```
when filenames may contain spaces or unusual characters.
