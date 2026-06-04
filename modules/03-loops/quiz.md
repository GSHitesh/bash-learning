# Module 03 — Loops Quiz

## Multiple Choice (10)

1. Which loop is best when you want to run with a numeric counter from `1` to `10`?
   - A. `for item in list`
   - B. `for ((i=1; i<=10; i++))`
   - C. `until read x`
   - D. `case ... esac`

2. What is the main difference between `while` and `until`?
   - A. `while` runs while the condition is true; `until` runs while the condition is false
   - B. `while` is only for files; `until` is only for numbers
   - C. `until` is faster than `while`
   - D. There is no difference

3. What does `continue` do inside a loop?
   - A. Ends the script
   - B. Exits the loop completely
   - C. Skips the rest of the current iteration
   - D. Repeats the previous iteration

4. What does `break` do inside a loop?
   - A. Skips one command
   - B. Exits the current loop immediately
   - C. Restarts the loop
   - D. Closes the terminal

5. Which is the safest canonical pattern for reading a file line by line?
   - A. `for line in $(cat file)`
   - B. `cat file | while read line; do ...; done`
   - C. `while IFS= read -r line; do ...; done < file`
   - D. `read file line`

6. Why is `for f in $(ls)` a bad idea?
   - A. `ls` cannot list files
   - B. It can split filenames on spaces and other whitespace
   - C. It only works for hidden files
   - D. It is slower than `echo`

7. What does `read -r line` protect against?
   - A. Arithmetic expansion
   - B. Command substitution
   - C. Backslash interpretation by `read`
   - D. Filename globbing

8. Which statement about `IFS` is true?
   - A. It controls how Bash splits input into fields
   - B. It is only used by `echo`
   - C. It permanently disables whitespace
   - D. It creates arrays automatically

9. Which loop can easily become infinite if the condition never changes?
   - A. `while`
   - B. `until`
   - C. Both `while` and `until`
   - D. Neither

10. Which is the best way to loop over array elements that may contain spaces?
    - A. `for x in ${arr[@]}`
    - B. `for x in $(printf '%s\n' "${arr[@]}")`
    - C. `for x in "${arr[@]}"`
    - D. `for x in $arr`

## Fill in the Blank (3)

11. The loop that runs until a condition becomes true is called an `__________` loop.

12. To read raw lines safely from a file, the usual pattern starts with `while IFS= read -r ________`.

13. To stop a loop as soon as a match is found, use the `__________` command.

## Predict the Output (2)

14. What is the output?

```bash
for ((i=1; i<=4; i++))
do
    if [ "$i" -eq 3 ]
    then
        continue
    fi
    echo "$i"
done
```

15. What is the output?

```bash
count=1
until [ "$count" -gt 3 ]
do
    echo "$count"
    ((count++))
done
```

## Answer Key

1. **B**
2. **A**
3. **C**
4. **B**
5. **C**
6. **B**
7. **C**
8. **A**
9. **C**
10. **C**
11. **until**
12. **line**
13. **break**
14. 
```bash
1
2
4
```
15. 
```bash
1
2
3
```
