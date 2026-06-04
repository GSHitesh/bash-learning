# Module 04: Functions — Quiz

## Questions

1. **MCQ:** Which syntax is the most common portable way to define a bash function?
   - A. `def name():`
   - B. `name() { ... }`
   - C. `func name => { ... }`
   - D. `function: name`

2. **Fill in the blank:** Inside a function, `______` refers to the first argument passed to that function.

3. **MCQ:** Inside a function, what does `$0` refer to?
   - A. The function name
   - B. The first function argument
   - C. The script name
   - D. The last command status

4. **Predict output:**
   ```bash
   show() {
       echo "$#:$1:$2"
   }
   show cat dog
   ```

5. **MCQ:** What does `return 7` do inside a bash function?
   - A. Prints `7`
   - B. Sets the function exit status to `7`
   - C. Stores `7` in `$1`
   - D. Sends `7` to stdout and stderr

6. **Fill in the blank:** To capture text printed by a function, use `result=$(__________)`.

7. **MCQ:** Which statement about `return` in bash is correct?
   - A. It can return any size integer safely
   - B. It is mainly for exit status values
   - C. It returns strings directly
   - D. It is the same as `echo`

8. **Predict output:**
   ```bash
   greet() {
       local name="${1:-friend}"
       echo "Hi, $name"
   }
   greet
   ```

9. **MCQ:** Why is `local` useful inside a function?
   - A. It makes the variable available to all scripts
   - B. It prevents the function from changing outer variables accidentally
   - C. It automatically exports the variable
   - D. It converts the variable into an array

10. **Fill in the blank:** The usual exit-status range for `return` is `___` to `___`.

11. **MCQ:** Why is the `function` keyword considered less portable than `name() { ... }`?
   - A. It only works in Python
   - B. It is bash/ksh-style and not required by POSIX `sh`
   - C. It requires root privileges
   - D. It only works for recursive functions

12. **Predict output:**
   ```bash
   value="outside"
   demo() {
       local value="inside"
       echo "$value"
   }
   demo
   echo "$value"
   ```

13. **MCQ:** Which is the best way for a function to provide a computed string like `full_name`?
   - A. `return "full_name"`
   - B. `echo "full_name"` and capture it with `$(...)`
   - C. `exit "full_name"`
   - D. Put it in `$0`

14. **Fill in the blank:** `"$@"` expands to ____________________.

15. **Predict output:**
   ```bash
   add() {
       echo $(( $1 + $2 ))
   }
   total="$(add 4 9)"
   echo "$total"
   ```

## Answer Key

1. **B** — `name() { ... }`
2. **`$1`**
3. **C** — the script name
4. **`2:cat:dog`**
5. **B** — sets the function exit status to `7`
6. **the function call**, for example `myfunc arg1 arg2`
7. **B** — it is mainly for exit status values
8. **`Hi, friend`**
9. **B** — it prevents accidental changes to outer variables
10. **0** to **255**
11. **B** — it is bash/ksh-style and not required by POSIX `sh`
12. Output is:
    ```text
    inside
    outside
    ```
13. **B** — `echo` plus command substitution
14. **all positional arguments as separate words when quoted**
15. **`13`**
