## Quiz: Bash Conditionals

### Multiple-choice
1. What is the main difference between `[ ... ]` and `[[ ... ]]` in Bash?
   - A. `[ ... ]` can use regex, but `[[ ... ]]` cannot.
   - B. `[[ ... ]]` is Bash-specific and supports safer pattern/logic features.
   - C. `[ ... ]` only works for numbers.
   - D. `[[ ... ]]` only works inside loops.

2. Why should variables usually be quoted inside `[ ... ]`?
   - A. To make them uppercase automatically.
   - B. To avoid word splitting and pathname expansion problems.
   - C. To force numeric comparison.
   - D. To convert empty strings to zero.

3. Which test checks whether `a` and `b` are numerically equal?
   - A. `[ "$a" = "$b" ]`
   - B. `[ "$a" == "$b" ]`
   - C. `[ "$a" -eq "$b" ]`
   - D. `[[ "$a" =~ "$b" ]]`

4. Which expression does a lexicographic (alphabetical) comparison correctly?
   - A. `[ "$x" -lt "$y" ]`
   - B. `[[ "$x" < "$y" ]]`
   - C. `[ "$x" =< "$y" ]`
   - D. `[[ "$x" -eq "$y" ]]`

5. What does `-z` check?
   - A. The file size is zero.
   - B. The variable contains only digits.
   - C. The string is empty.
   - D. The string is quoted.

6. What does `-n` check?
   - A. The string is not empty.
   - B. The value is negative.
   - C. The variable is numeric.
   - D. The file is new.

7. Which option correctly matches the file test flags?
   - A. `-f` directory, `-d` regular file, `-e` executable
   - B. `-f` regular file, `-d` directory, `-e` path exists
   - C. `-f` full path, `-d` device, `-e` empty file
   - D. `-f` found, `-d` deleted, `-e` enabled

8. Which mapping is correct?
   - A. `-r` readable, `-w` writable, `-x` executable, `-s` non-empty file, `-L` symbolic link
   - B. `-r` renamed, `-w` whole file, `-x` extra file, `-s` safe file, `-L` large file
   - C. `-r` regular file, `-w` working directory, `-x` hidden file, `-s` symlink, `-L` locked file
   - D. `-r` root-only, `-w` wildcard, `-x` empty, `-s` source file, `-L` local file

9. In a `case` statement, what is the difference between `;;`, `;&`, and `;;&`?
   - A. They are three ways to end the script.
   - B. `;;` stops, `;&` runs the next branch body, `;;&` re-tests the next pattern list.
   - C. `;&` means default case, `;;&` means exit, `;;` means continue loop.
   - D. There is no difference.

10. How do you define the default branch in a `case` statement?
   - A. `default)`
   - B. `else)`
   - C. `*)`
   - D. `?)`

### Fill in the blank
11. The file test flag for “path exists” is `_____`.

12. The file test flag for “symbolic link” is `_____`.

13. Complete the pattern used for the default `case` branch: `_____ )`.

### Predict the output
14. ```bash
#!/bin/bash
name=""
if [ -z "$name" ]; then
  echo "empty"
else
  echo "filled"
fi
```
What is printed?

15. ```bash
#!/bin/bash
value="report.txt"
if [[ $value == *.txt ]]; then
  echo "text file"
else
  echo "other"
fi
```
What is printed?

## Answer Key
1. B
2. B
3. C
4. B
5. C
6. A
7. B
8. A
9. B
10. C
11. `-e`
12. `-L`
13. `*`
14. `empty`
15. `text file`
