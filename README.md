# bash-learning

A 2-day, hands-on curriculum to take you from zero to **industry-proficient** in
shell / bash scripting. Every module ships with a runnable lesson script, an
assignment set (with collapsible solutions), a quiz with answer key, and a
printable notes sheet.

> **Start here:** [`reference/STUDY_PLAN-2day.md`](reference/STUDY_PLAN-2day.md)

---

## Curriculum

### Day 1 — Fundamentals

| # | Module | Lesson script | Assignments | Quiz | Notes |
|---|--------|---------------|-------------|------|-------|
| 1 | Bash Basics — shebang, variables, args, `read` | [`Lesson1.sh`](Lesson1.sh) | [a](modules/01-basics/assignments.md) | [q](modules/01-basics/quiz.md) | [n](modules/01-basics/notes.md) |
| 2 | Conditionals — `if`/`[[ ]]`/`case` | [`Lesson2.sh`](Lesson2.sh) | [a](modules/02-conditionals/assignments.md) | [q](modules/02-conditionals/quiz.md) | [n](modules/02-conditionals/notes.md) |
| 3 | Loops — `for`/`while`/`until` | [`Lesson3.sh`](Lesson3.sh) | [a](modules/03-loops/assignments.md) | [q](modules/03-loops/quiz.md) | [n](modules/03-loops/notes.md) |
| 4 | Functions, scope, return vs echo | [`Lesson4.sh`](Lesson4.sh) | [a](modules/04-functions/assignments.md) | [q](modules/04-functions/quiz.md) | [n](modules/04-functions/notes.md) |
| 5 | I/O & Redirection (pipes, FDs, here-docs, process subst.) | [`Lesson5.sh`](Lesson5.sh) | [a](modules/05-io-redirection/assignments.md) | [q](modules/05-io-redirection/quiz.md) | [n](modules/05-io-redirection/notes.md) |
| 6 | Arrays — indexed & associative | [`Lesson6.sh`](Lesson6.sh) | [a](modules/06-arrays/assignments.md) | [q](modules/06-arrays/quiz.md) | [n](modules/06-arrays/notes.md) |

### Day 2 — Intermediate → Advanced

| # | Module | Lesson script | Assignments | Quiz | Notes |
|---|--------|---------------|-------------|------|-------|
| 7 | String manipulation & regex (parameter expansion, `=~`) | [`Lesson7.sh`](Lesson7.sh) | [a](modules/07-string-manipulation/assignments.md) | [q](modules/07-string-manipulation/quiz.md) | [n](modules/07-string-manipulation/notes.md) |
| 8 | Processes, signals, traps | [`Lesson8.sh`](Lesson8.sh) | [a](modules/08-processes-signals/assignments.md) | [q](modules/08-processes-signals/quiz.md) | [n](modules/08-processes-signals/notes.md) |
| 9 | Text processing — `grep` / `sed` / `awk` / `sort` / `xargs` | [`Lesson9.sh`](Lesson9.sh) | [a](modules/09-text-processing/assignments.md) | [q](modules/09-text-processing/quiz.md) | [n](modules/09-text-processing/notes.md) |
| 10 | Error handling & debugging (`set -euo pipefail`, `trap ERR`, `shellcheck`) | [`Lesson10.sh`](Lesson10.sh) | [a](modules/10-error-handling-debugging/assignments.md) | [q](modules/10-error-handling-debugging/quiz.md) | [n](modules/10-error-handling-debugging/notes.md) |
| 11 | Advanced — `getopts`, here-docs, sourcing, modular scripts | [`Lesson11.sh`](Lesson11.sh) | [a](modules/11-advanced/assignments.md) | [q](modules/11-advanced/quiz.md) | [n](modules/11-advanced/notes.md) |

### Capstone

[`capstone/CAPSTONE.md`](capstone/CAPSTONE.md) — build **`log-analyzer.sh`**, a
production-grade CLI tool that exercises everything in the curriculum
(`getopts`, arrays, `awk` pipelines, `trap`-based cleanup, `set -euo pipefail`,
input validation).

---

## Printable reference

- 📋 [`reference/CHEATSHEET.md`](reference/CHEATSHEET.md) — single-sheet bash
  cheatsheet (4–6 pages) covering everything in the curriculum.
- ✅ [`reference/BEST_PRACTICES.md`](reference/BEST_PRACTICES.md) — production
  best practices (quoting, `mktemp`, `shellcheck`, when *not* to use bash, etc.).
- 🗓 [`reference/STUDY_PLAN-2day.md`](reference/STUDY_PLAN-2day.md) — hour-by-hour
  schedule with self-assessment checklist.

> All Markdown files are written to render cleanly in plain Markdown → PDF
> tools (e.g. `pandoc`, VS Code "Markdown PDF" extension, GitHub print).
> Example: `pandoc reference/CHEATSHEET.md -o cheatsheet.pdf`

---

## How to run a lesson

```bash
chmod +x Lesson1.sh       # one-time
./Lesson1.sh              # run it
bash -x Lesson1.sh        # trace every command (debugging)
shellcheck Lesson1.sh     # lint (recommended: install shellcheck)
```

Each lesson is self-contained — no external dependencies beyond a standard
Linux/macOS install of bash 4+ and core utilities (`grep`, `sed`, `awk`,
`sort`, `uniq`, `cut`, `tr`, `xargs`, `find`).

---

## Recommended path

1. Read [`reference/STUDY_PLAN-2day.md`](reference/STUDY_PLAN-2day.md).
2. For each module, in order:
   - **Run** the `LessonN.sh` script, then **read** it line by line.
   - **Read** the `notes.md` for that module.
   - **Do** the assignments without peeking; check with the collapsible solution.
   - **Take** the quiz; verify against the answer key.
3. Keep [`reference/CHEATSHEET.md`](reference/CHEATSHEET.md) open in a second
   window for quick lookups.
4. Internalise [`reference/BEST_PRACTICES.md`](reference/BEST_PRACTICES.md).
5. Build the [capstone](capstone/CAPSTONE.md) without looking at the reference
   solution — that is your "industry proficient" certification.

---

## Top 10 best practices (TL;DR)

1. Start every script with `#!/usr/bin/env bash` + `set -euo pipefail` + `IFS=$'\n\t'`.
2. **Always quote** variables: `"$var"`, `"${arr[@]}"`. Unquoted = bugs.
3. Use `[[ ]]` not `[ ]` in bash. Use `$(...)` not backticks.
4. `local` every variable inside a function.
5. Create temp files with `mktemp` and clean them up with `trap '...' EXIT`.
6. Validate inputs and required commands (`command -v jq >/dev/null || die ...`) at the top.
7. Write errors to stderr (`>&2`) and exit with a non-zero status.
8. Never parse `ls`. Use globs, `find -print0 | xargs -0`, or `while read -r`.
9. Lint with `shellcheck` in CI; pin a bash version assumption in the header.
10. If your script crosses ~200 lines or needs real data structures / unit
    tests → reach for Python or Go instead.

Full list with rationales: [`reference/BEST_PRACTICES.md`](reference/BEST_PRACTICES.md).
