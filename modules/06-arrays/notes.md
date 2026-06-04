# Module 06 Notes: Bash Arrays

## Indexed arrays cheatsheet

### Creation
```bash
arr=(a b c)
arr[3]=d
arr+=(e f)
```

### Access
```bash
${arr[0]}      # first element
${arr[@]}      # all elements
${arr[*]}      # all elements
${!arr[@]}     # assigned indices
${#arr[@]}     # number of assigned elements
```

### Iteration
```bash
for x in "${arr[@]}"; do
    echo "$x"
done
```

### Slicing
```bash
${arr[@]:start:count}
${arr[@]:1:2}
${arr[@]:2:3}
```

## Associative arrays

```bash
declare -A map
map[name]="bash"
map[level]="intermediate"

${map[name]}     # access one value
${!map[@]}       # all keys
${#map[@]}       # number of keys

for key in "${!map[@]}"; do
    echo "$key => ${map[$key]}"
done
```

## Quoting matrix
Assume:
```bash
arr=("a b" "c")
```

| Expression | Result |
|---|---|
| `"${arr[@]}"` | Expands to **two words**: `a b` and `c` |
| `"${arr[*]}"` | Expands to **one word**: `a b c` |
| `${arr[@]}` | Unquoted; subject to word splitting and globbing |
| `${arr[*]}` | Unquoted; subject to word splitting and globbing |
| `printf '%s\n' "${arr[@]}"` | Safely prints each element on its own line |

## Common pitfalls

- Forgetting quotes around `"${arr[@]}"` when elements may contain spaces.
- Expecting `unset 'arr[1]'` to shift later elements left automatically.
- Confusing `${#arr[@]}` (element count) with string-length expansions.
- Using associative arrays without `declare -A`.
- Assuming associative arrays preserve insertion order; do not rely on key order.
- Passing arrays to functions by value instead of by name when you want generic helpers.
