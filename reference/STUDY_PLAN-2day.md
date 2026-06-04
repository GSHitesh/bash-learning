# 2-Day Bash Study Plan

Print this plan, block the time, and work straight through. Use the lesson scripts for hands-on runs, then lean on `reference/CHEATSHEET.md` and `reference/BEST_PRACTICES.md` as your daily desk references.

## Day 1 — Fundamentals (8 hours, Modules M1-M6)

| Time | Topic | Lesson file to read | Notes / cheatsheet pointers | Assignments to attempt | Quiz to take |
|---|---|---|---|---|---|
| 09:00-09:30 | Setup + M1 script structure | `README.md`, `Lesson1.sh` | Header, shebang, `set -euo pipefail`, IFS, quoting sections in cheatsheet | Make `hello.sh` with safe header and a `main "$@"` entrypoint | 5-question self-quiz: explain shebang, `set -u`, `IFS`, `"$@"`, exit codes |
| 09:30-10:20 | M1 variables + quoting | `Lesson1.sh` | Variables, quoting rules, parameter expansion intro | Write `greet.sh` that prints full name from CLI args and prompts if missing | Recite what breaks if `$name` is left unquoted |
| 10:20-10:30 | **Break** | — | Stretch; skim positional params table | — | — |
| 10:30-11:20 | M2 positional params + input | `Lesson1.sh` | Positional params table, `read -r`, `"$@"` vs `"$*"` | Build `args-report.sh` showing `$0`, `$#`, all args, and previous status via `$?` | 5 quick prompts: identify outputs for `$0`, `$1`, `"$@"`, `"$*"`, `$#` |
| 11:20-12:10 | M3 tests and conditionals | `Lesson2.sh` | Test operators tables; `if/elif/else`; `[[ ]]` features | Write `grade.sh` using numeric checks and `filecheck.sh` using `-f/-d/-e` | Compare `[ ]` vs `[[ ]]` from memory |
| 12:10-13:00 | **Lunch** | — | Review string/file test rows | — | — |
| 13:00-13:50 | M4 case + branching style | `Lesson2.sh`, `modules/04-functions/` | `case` examples; best-practices items 2-5 | Build `service.sh start|stop|restart` with `case` and usage text | 3 scenarios: when is `case` cleaner than `if`? |
| 13:50-14:40 | M5 loops | `Lesson3.sh` | Loop section: `for`, C-style `for`, `while`, `until`, `break`, `continue` | Print 1-20, fizzbuzz 1-30, and retry-until-success loop | Timed quiz: choose correct loop for list, counter, retry |
| 14:40-14:50 | **Break** | — | Re-read safe `while IFS= read -r` pattern | — | — |
| 14:50-15:40 | M6 arrays + safe iteration | `Lesson3.sh`, `modules/06-arrays/` | Arrays section: indexed vs associative, `${arr[@]}` vs `${arr[*]}` | Create an array of filenames with spaces and print them safely | Explain why `for x in $(command)` is fragile |
| 15:40-16:20 | Fundamentals review sprint | `reference/CHEATSHEET.md` | Revisit header, quoting, params, tests, loops, arrays | Rewrite one older script to add safe header, quotes, and `case` | 15-minute mixed quiz covering M1-M6 |
| 16:20-17:00 | Mini-lab | `Lesson1.sh`-`Lesson3.sh` | Keep cheatsheet open; use best-practices items 1-17 | Build `user_report.sh` that parses args, prompts optionally, branches, loops, and summarizes | Grade yourself: did it work with spaces in input? |

## Day 2 — Intermediate to Advanced (8 hours, Modules M7-M11 + capstone)

| Time | Topic | Lesson file to read | Notes / cheatsheet pointers | Assignments to attempt | Quiz to take |
|---|---|---|---|---|---|
| 09:00-09:30 | Warm-up review | `reference/CHEATSHEET.md`, `reference/BEST_PRACTICES.md` | Re-read quoting, arrays, redirection, style | Fix one unsafe quoting bug in yesterday's scripts | 10 flashcards from memory |
| 09:30-10:20 | M7 functions + scope | `modules/04-functions/` | Functions section; best-practices items 6-7 | Refactor `user_report.sh` into `usage`, `die`, `parse_args`, `main` | Explain `return` vs `echo` without notes |
| 10:20-10:30 | **Break** | — | Skim `local`, globals, exit codes | — | — |
| 10:30-11:20 | M8 I/O, redirection, FDs | `modules/05-io-redirection/` | Redirection table, FD table, process substitution | Write logs to separate stdout/stderr files; add `tee` and here-doc config output | Label what `2>&1`, `&>`, `<<<`, `<<EOF` do |
| 11:20-12:10 | M9 string + parameter expansion | `modules/07-string-manipulation/` | Parameter expansion table, arithmetic section | Normalize filenames, strip prefixes/suffixes, uppercase/lowercase values | 8-item drill: pick the right expansion for each task |
| 12:10-13:00 | **Lunch** | — | Review defaults `${var:-}` / `${var:?}` | — | — |
| 13:00-13:50 | M10 processes, traps, debugging | `modules/08-processes-signals/`, `modules/10-error-handling-debugging/` | `trap`, signals, `bash -x`, `shellcheck` | Create a temp workspace script that traps `EXIT` and prints debug traces on demand | State what `$$`, `$!`, `$PPID`, `trap ERR` mean |
| 13:50-14:40 | M11 text processing toolkit | `modules/09-text-processing/`, `modules/11-advanced/` | One-liners section: `grep`, `sed`, `awk`, `sort`, `uniq`, `cut`, `tr`, `xargs`, `find` | Solve 5 CLI drills: top N words, CSV sum, filter logs, rename files preview, count extensions | Timed one-liner quiz: 10 minutes, 5 outputs |
| 14:40-14:50 | **Break** | — | Re-read portability + security practices | — | — |
| 14:50-15:30 | Argument parsing + production habits | `reference/BEST_PRACTICES.md` | `getopts` template, validation, stderr, idempotency, `--` | Add `-v`, `-o`, `-n` flags to one script and validate commands at top | Explain why `eval` is dangerous |
| 15:30-16:15 | Reference docs review | `reference/CHEATSHEET.md`, `reference/BEST_PRACTICES.md` | Focus on sections you still hesitate on | Create a one-page handwritten memory dump of core syntax | 20-question oral/self quiz |
| 16:15-17:00 | Capstone execution | `capstone/` plus all references | Use all sections: header, args, loops, functions, arrays, redirection, traps, one-liners | Build a capstone script such as `log_summary.sh`, `backup_rotator.sh`, or `system_audit.sh` with usage, `getopts`, safe loops, and reports | Final review: demo the script end-to-end on sample inputs |

## How to know you're ready

- [ ] I can start every script with a safe Bash header and explain each line.
- [ ] I can explain when to use `$var`, `${var}`, `"$@"`, and `"$*"`.
- [ ] I can write `if/elif/else`, `[[ ]]`, and `case` without looking them up.
- [ ] I can read a file line-by-line safely with `while IFS= read -r line`.
- [ ] I can write and call functions with `local` variables and clear exit codes.
- [ ] I can use indexed and associative arrays without breaking on spaces.
- [ ] I can parse flags with `getopts` and print a usable `usage()` message.
- [ ] I can redirect stdout/stderr intentionally and explain `2>&1`.
- [ ] I can add `trap EXIT` cleanup and basic debug tracing with `set -x` or `bash -x`.
- [ ] I can one-liner a top-N analysis such as `sort | uniq -c | sort -rn | head` and explain each stage.
