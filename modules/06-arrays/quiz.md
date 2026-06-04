# Module 06 Quiz: Bash Arrays

## Multiple Choice (10)
Choose the best answer.

1. Which syntax creates an indexed array with three elements?
   - A. `declare -A arr=(a b c)`
   - B. `arr=(a b c)`
   - C. `arr={a,b,c}`
   - D. `arr=[a b c]`

2. What does `${#arr[@]}` return?
   - A. The length of the first string element
   - B. The highest numeric index in the array
   - C. The number of assigned elements in the array
   - D. The number of characters in the array name

3. With `arr=("a b" "c")`, what does `"${arr[@]}"` preserve?
   - A. It joins everything into one string
   - B. It preserves each element as a separate word
   - C. It removes spaces inside elements
   - D. It sorts the array before expansion

4. With `arr=("a b" "c")`, what does `"${arr[*]}"` produce?
   - A. Two separate words
   - B. Three separate words
   - C. One single word containing all elements joined by the first character of `IFS`
   - D. An error

5. What happens after `unset 'arr[1]'` on an indexed array?
   - A. All later elements shift left automatically
   - B. The array becomes empty
   - C. A gap remains; the array can become sparse
   - D. The array turns into an associative array

6. Which syntax lists the assigned indices of an indexed array?
   - A. `${arr[#]}`
   - B. `${!arr[@]}`
   - C. `${arr[@]!}`
   - D. `${#arr[*]}`

7. Which declaration is required for associative arrays?
   - A. `declare -i map`
   - B. `declare -r map`
   - C. `declare -x map`
   - D. `declare -A map`

8. Which loop is safest for iterating through array elements that may contain spaces?
   - A. `for x in ${arr[*]}; do ...; done`
   - B. `for x in ${arr[@]}; do ...; done`
   - C. `for x in "${arr[@]}"; do ...; done`
   - D. `for x in $arr; do ...; done`

9. What does `declare -n ref=$1` do inside a function?
   - A. Creates a numeric variable
   - B. Creates a nameref pointing to another variable by name
   - C. Exports a variable to child processes
   - D. Makes a copy of an array

10. Which command splits a string into an array using shell word splitting rules?
    - A. `read -ra arr <<< "$line"`
    - B. `printf -ra arr "$line"`
    - C. `echo -ra arr "$line"`
    - D. `set -A arr "$line"`

## Fill in the blanks (3)
11. The expansion used to get all keys from an associative array named `map` is `__________`.

12. To append two elements `e` and `f` to an indexed array named `arr`, write `__________`.

13. To get a slice starting at index 2 with count 3 from `arr`, write `__________`.

## Predict the output (2)
14. Predict the output:
```bash
arr=("a b" "c")
printf '<%s>\n' "${arr[@]}"
```

15. Predict the output:
```bash
arr=(zero one two)
unset 'arr[1]'
echo "indices=${!arr[@]} values=${arr[*]} length=${#arr[@]}"
```

---

# Answer Key

## Multiple Choice
1. **B**
2. **C**
3. **B**
4. **C**
5. **C**
6. **B**
7. **D**
8. **C**
9. **B**
10. **A**

## Fill in the blanks
11. **`${!map[@]}`**
12. **`arr+=(e f)`**
13. **`${arr[@]:2:3}`**

## Predict the output
14.
```bash
<a b>
<c>
```

15.
```bash
indices=0 2 values=zero two length=2
```

**Why:** `unset 'arr[1]'` removes only index 1. The array becomes sparse, so indices `0` and `2` remain assigned.
