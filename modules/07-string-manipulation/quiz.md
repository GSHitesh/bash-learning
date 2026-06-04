# Module 07 Quiz: String Manipulation and Regex

## Multiple Choice (1-10)

**1.** What does `${path##*/}` usually return?
- A. Everything before the first slash
- B. Everything after the last slash
- C. Everything after the first slash
- D. Everything before the last slash

**2.** Which expression removes the shortest matching suffix?
- A. `${file%%.*}`
- B. `${file##*.}`
- C. `${file%.*}`
- D. `${file#*.}`

**3.** What is the difference between `${text/foo/bar}` and `${text//foo/bar}`?
- A. No difference
- B. The first removes text, the second replaces text
- C. The first replaces the first match, the second replaces all matches
- D. The first uses regex, the second uses glob

**4.** Which operator both supplies a fallback and assigns it back to the variable?
- A. `${var:-fallback}`
- B. `${var:=fallback}`
- C. `${var:?fallback}`
- D. `${var:+fallback}`

**5.** What does `${var:+yes}` expand to when `var` is set to `hello`?
- A. `hello`
- B. `yes`
- C. an empty string
- D. an error

**6.** In `[[ $value =~ $regex ]]`, where do captured groups go after a successful match?
- A. `$MATCHES`
- B. `${REGEX_GROUPS[@]}`
- C. `${BASH_REMATCH[@]}`
- D. `$?`

**7.** Which statement about `[[ $text =~ regex ]]` is correct?
- A. The right side should always be quoted
- B. The right side should not be quoted if you want regex matching
- C. The left side must be unquoted and unbraced
- D. `=~` works only in `/bin/sh`

**8.** Which `printf` format prints an integer padded with leading zeroes to width 5?
- A. `%5s`
- B. `%05d`
- C. `%.5d`
- D. `%q`

**9.** Which expansion uppercases all letters in a variable on bash 4+?
- A. `${name^}`
- B. `${name,}`
- C. `${name^^}`
- D. `${name~~}`

**10.** Which statement is true about `#` vs `##` and `%` vs `%%`?
- A. `#` and `%` are greedy; `##` and `%%` are non-greedy
- B. `#` and `%` work only with regex
- C. `#`/`%` remove the shortest match; `##`/`%%` remove the longest match
- D. They are only for arrays

## Fill in the Blanks (11-13)

**11.** Complete the expression that prints the last 3 characters of `word`: `${word: ____ }`

**12.** Complete the operator that uses `guest` when `name` is unset or empty, but does **not** assign it: `${name____guest}`

**13.** Complete the `printf` format for shell-escaped output: `printf 'quoted: ____\n' "$value"`

## Predict the Output (14-15)

**14.** Predict the output:
```bash
file="archive.tar.gz"
echo "${file%.*}"
echo "${file%%.*}"
```

**15.** Predict the output:
```bash
text="one two two"
echo "${text/two/2}"
echo "${text//two/2}"
```

---

# Answer Key

1. **B**
2. **C**
3. **C**
4. **B**
5. **B**
6. **C**
7. **B**
8. **B**
9. **C**
10. **C**
11. **-3**
12. **:-**
13. **%q**
14. 
```text
archive.tar
archive
```
15.
```text
one 2 two
one 2 2
```
