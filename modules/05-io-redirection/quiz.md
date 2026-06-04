# Module 05 Quiz: I/O and Redirection

## Multiple Choice (10)

1. Which file descriptor number is **stdin**?
   - A. 0
   - B. 1
   - C. 2
   - D. 3

2. Which operator appends stdout to a file instead of overwriting it?
   - A. `>`
   - B. `>>`
   - C. `2>`
   - D. `|`

3. What does `2> errors.log` do?
   - A. Redirect stdout to `errors.log`
   - B. Redirect stdin from `errors.log`
   - C. Redirect stderr to `errors.log`
   - D. Merge stdout and stderr

4. Which command sends both stdout and stderr to the same file **in the correct order**?
   - A. `cmd 2>&1 > out.log`
   - B. `cmd > out.log 2>&1`
   - C. `cmd < out.log 2>&1`
   - D. `cmd | out.log 2>&1`

5. What is a here-string?
   - A. Multi-line inline input using `<<EOF`
   - B. A single string passed to stdin using `<<<`
   - C. A way to append to a file with `>>`
   - D. A way to duplicate output with `tee`

6. What does `< <(cmd)` mean?
   - A. Append command output to a file
   - B. Read stdin from the output of `cmd` using process substitution
   - C. Run `cmd` in the background
   - D. Merge stderr into stdout

7. What is the main purpose of `tee`?
   - A. Convert stderr into stdout
   - B. Read a file into stdin
   - C. Write output to both stdout and a file
   - D. Sort command output before diffing

8. In bash, `diff <(sort a.txt) <(sort b.txt)` is useful because it:
   - A. Deletes both files after sorting
   - B. Compares sorted command outputs without creating sorted temp files manually
   - C. Redirects stderr to `diff`
   - D. Forces both files to have the same content

9. In a pipeline like `printf 'a\nb\n' | while read -r line; do count=$((count+1)); done`, why is `count` often unchanged afterward?
   - A. `read` cannot handle piped input
   - B. `printf` resets shell variables
   - C. The loop may run in a subshell created by the pipe
   - D. `count` is a reserved variable name

10. Which redirection discards both stdout and stderr?
    - A. `2> /dev/null`
    - B. `> /dev/null`
    - C. `>/dev/null 2>&1`
    - D. `<< /dev/null`

## Fill in the Blank (3)

11. The standard error file descriptor number is `___`.

12. A multi-line block of inline input introduced with `<<EOF` is called a `__________`.

13. To append stdout to `log.txt`, use `___ log.txt`.

## Predict the Output (2)

14. Predict the terminal output:

```bash
{
  echo "OUT"
  echo "ERR" >&2
} > result.log 2>&1
cat result.log
```

15. Predict the terminal output:

```bash
count=0
printf 'x\ny\n' | while read -r line; do
  count=$((count+1))
  echo "inside:$count"
done
echo "outside:$count"
```

---

# Answer Key

## Multiple Choice
1. A
2. B
3. C
4. B
5. B
6. B
7. C
8. B
9. C
10. C

## Fill in the Blank
11. `2`
12. `here-document`
13. `>>`

## Predict the Output
14.
```text
OUT
ERR
```
Explanation: both streams went into `result.log`, and then `cat result.log` printed the file contents.

15.
```text
inside:1
inside:2
outside:0
```
Explanation: the `while` loop runs in a subshell in many bash pipeline cases, so the outer `count` variable does not keep the updated value.

## Order Matters Note
- `cmd >file 2>&1` sends both stdout and stderr to `file`.
- `cmd 2>&1 >file` usually leaves stderr pointing at the old stdout destination (often the terminal), while stdout goes to `file`.
