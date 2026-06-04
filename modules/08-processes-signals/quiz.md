# Module 08 Quiz — Processes, Signals, and Traps

## Multiple Choice (1–10)

1. Which variable stores the PID of the current shell?
   - A. `$PPID`
   - B. `$$`
   - C. `$!`
   - D. `$?`

2. Which variable stores the PID of the most recently started background job?
   - A. `$!`
   - B. `$$`
   - C. `$#`
   - D. `$0`

3. What does `$PPID` represent?
   - A. The PID of the current script file
   - B. The PID of the previous command
   - C. The PID of the parent process
   - D. The PID of the process group leader

4. Which signal is normally sent by pressing `Ctrl-C`?
   - A. `SIGTERM`
   - B. `SIGHUP`
   - C. `SIGKILL`
   - D. `SIGINT`

5. Which signal is the usual polite request to terminate a process?
   - A. `SIGKILL`
   - B. `SIGTERM`
   - C. `SIGUSR1`
   - D. `SIGSTOP`

6. Why can `SIGKILL` not be trapped?
   - A. Because only root can send it
   - B. Because bash disables traps for signal 9
   - C. Because the kernel enforces immediate termination
   - D. Because it is only valid for background jobs

7. What is the main difference between `( ... )` and `{ ...; }`?
   - A. Parentheses run faster than braces
   - B. Parentheses create a subshell; braces run in the current shell
   - C. Braces create a subshell; parentheses run in the current shell
   - D. There is no difference

8. What does `trap 'cleanup' EXIT` do?
   - A. Calls `cleanup` only on syntax errors
   - B. Calls `cleanup` when the shell exits
   - C. Calls `cleanup` before every command
   - D. Calls `cleanup` only when a background job finishes

9. What does `wait` with no arguments do?
   - A. Waits for the last foreground command only
   - B. Waits for a keypress
   - C. Waits for all current background jobs in the shell
   - D. Waits only for jobs started with `nohup`

10. What is the purpose of `timeout 5 some_command`?
    - A. Delay starting the command for 5 seconds
    - B. Repeat the command every 5 seconds
    - C. Kill the command immediately
    - D. Stop the command if it runs longer than 5 seconds

## Fill in the Blank (11–13)

11. The variable `______` stores the PID of the most recently started background process.

12. The signal number `15` usually refers to `________`.

13. In bash, `trap 'cleanup' ______` is the common pattern for guaranteed cleanup at script exit.

## Predict the Output / Behavior (14–15)

14. Predict the final value of `name` after this script runs:

```bash
name="outer"
(
  name="inner"
)
echo "$name"
```

15. Predict the final value of `count` after this script runs:

```bash
count=1
{
  count=5
}
echo "$count"
```

---

# Answer Key

1. **B** — `$$`
2. **A** — `$!`
3. **C** — parent process ID
4. **D** — `SIGINT`
5. **B** — `SIGTERM`
6. **C** — the kernel forces immediate termination, so the process cannot catch or ignore it
7. **B** — `( ... )` creates a subshell, `{ ...; }` does not
8. **B** — it runs `cleanup` when the shell exits
9. **C** — it waits for all current background jobs
10. **D** — it bounds runtime and stops the command after 5 seconds
11. **`$!`**
12. **`SIGTERM`**
13. **`EXIT`**
14. Output: **`outer`**
15. Output: **`5`**
