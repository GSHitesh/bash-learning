## Quiz: Bash Basics

### Multiple-choice
1. What is the main purpose of the shebang line `#!/bin/bash`?
   - A. It adds comments to the file.
   - B. It tells the system which interpreter should run the script.
   - C. It makes every variable global.
   - D. It prints Bash version information.

2. Which variable assignment is correct in Bash?
   - A. `name = "Sai"`
   - B. `$name="Sai"`
   - C. `name="Sai"`
   - D. `name := "Sai"`

3. Why does Bash require no spaces around `=` in variable assignment?
   - A. Because spaces turn the line into command + arguments instead of assignment.
   - B. Because spaces are only allowed inside loops.
   - C. Because quotes stop working otherwise.
   - D. Because `=` only works in comments.

4. When is `${name}` better than `$name`?
   - A. Only inside comments.
   - B. When the variable is next to other text and Bash must know where the name ends.
   - C. Only for numbers.
   - D. Only after `read`.

5. In a script, what does `$0` mean?
   - A. The first user argument.
   - B. The number of arguments.
   - C. The script name or path used to run the script.
   - D. All arguments as one list.

6. In a script, what does `$#` mean?
   - A. The count of command-line arguments.
   - B. The value of the last argument.
   - C. The current line number.
   - D. The shebang path.

7. What does `"$*"` usually represent?
   - A. Only the script name.
   - B. All command-line arguments combined into one string.
   - C. The first and second arguments only.
   - D. The number of arguments.

8. Which line correctly reads user input into a variable called `name`?
   - A. `read $name`
   - B. `read name`
   - C. `read =name`
   - D. `read "$name"`

9. What is the problem with `read $name`?
   - A. It always reads two words.
   - B. It expands `$name` first instead of using `name` as the target variable.
   - C. It only works in loops.
   - D. It clears every other variable.

10. Which command shows a prompt and stores input in `city` on one line?
   - A. `read city -p "Enter city: "`
   - B. `read -prompt "Enter city: " city`
   - C. `read -p "Enter city: " city`
   - D. `read "Enter city: " city`

### Fill in the blank
11. The shortcut that stores the first command-line argument is `_____`.

12. The shortcut that stores all command-line arguments is `_____`.

13. Complete the safer expansion form: `Hello, _____!`

### Short answer: What does this script print?
14. ```bash
#!/bin/bash
name="Hitesh"
echo "Hello $name"
```

15. ```bash
#!/bin/bash
echo "Count: $#"
```
If the script is run as `./count.sh red blue green`, what is printed?

## Answer Key
1. B
2. C
3. A
4. B
5. C
6. A
7. B
8. B
9. B
10. C
11. `$1`
12. `$@`
13. `${name}`
14. `Hello Hitesh`
15. `Count: 3`
