# Module 09 Quiz: Text Processing

## Multiple Choice (10)
Choose the best answer.

1. Which `grep` flag makes matching case-insensitive?  
   A. `-v`  
   B. `-i`  
   C. `-n`  
   D. `-c`

2. Which `grep` flag prints line numbers?  
   A. `-l`  
   B. `-o`  
   C. `-n`  
   D. `-r`

3. What does `grep -v pattern file` do?  
   A. Shows only matching lines  
   B. Deletes matching lines from the file  
   C. Shows non-matching lines  
   D. Counts matching lines

4. In `sed 's/cat/dog/g' file`, what does `g` mean?  
   A. Global: replace all matches on each line  
   B. Greedy matching  
   C. Group the pattern  
   D. Go to next line

5. In `sed -n 's/error/ERROR/p' file`, why is `p` used?  
   A. To print only lines where the substitution succeeded  
   B. To pause processing  
   C. To print line numbers  
   D. To preserve the file

6. What does `$0` mean in `awk`?  
   A. The first field  
   B. The entire current line  
   C. The line number  
   D. The last field

7. What does `$NF` mean in `awk`?  
   A. Number of files  
   B. Next field  
   C. Last field in the current record  
   D. New file

8. What is `FS` in `awk`?  
   A. File size  
   B. Field separator used for input  
   C. Output format string  
   D. File system

9. Why is `cat file | grep word` often called a UUOC?  
   A. Because `grep` cannot read from standard input  
   B. Because `cat` changes the data  
   C. Because `grep word file` is simpler and avoids an unnecessary `cat`  
   D. Because pipes are slower than files in every case

10. Why is `xargs -0` safer with filenames from `find -print0`?  
    A. It encrypts the filenames  
    B. It handles spaces and special characters safely using NUL separators  
    C. It sorts the filenames first  
    D. It ignores hidden files

## Fill in the blanks (3)

11. In `awk`, `_____` stores the current record number.  
12. In `awk`, `OFS` stands for output __________.  
13. In `sed 's/foo/bar/2'`, the `2` means replace the __________ match on each line.

## Predict the output (2)

14. What is the output of:
```bash
printf 'One\nTWO\nthree\n' | grep -i 'two'
```

15. What is the output of:
```bash
awk -F ',' 'NR > 1 {sum += $2} END {print sum}' <<'EOF'
item,qty
pen,2
book,3
bag,5
EOF
```

---

# Answer Key

## Multiple Choice
1. **B**  
2. **C**  
3. **C**  
4. **A**  
5. **A**  
6. **B**  
7. **C**  
8. **B**  
9. **C**  
10. **B**

## Fill in the blanks
11. **NR**  
12. **field separator**  
13. **second**

## Predict the output
14.
```txt
TWO
```

15.
```txt
10
```

## Notes
- `BEGIN` runs before input is read.
- `END` runs after all input has been processed.
- `sed -n ... p` is a common way to print only selected transformed lines.
