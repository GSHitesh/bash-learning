# Module 08 Notes — Processes, Signals, and Traps

## 1. Process model

- Every running command is a process.
- A shell script runs inside a shell process.
- Foreground processes keep the shell busy until they finish.
- Background processes are started with `&` so the shell can continue immediately.
- `jobs` lists jobs started from the current shell session.
- `wait` pauses until one or more background jobs finish.
- `wait -n` pauses until the next background job finishes.
- `fg` and `bg` are mainly interactive-shell tools for resuming jobs in the foreground or background.

## 2. PID variables

- `$$` — PID of the current shell.
- `$!` — PID of the most recently started background job.
- `$PPID` — PID of the parent process.

Example:

```bash
echo "shell pid: $$"
sleep 5 &
echo "last bg pid: $!"
echo "parent pid: $PPID"
```

## 3. Signals table

| Number | Name | Default action | Can trap? | Typical meaning |
| --- | --- | --- | --- | --- |
| 1 | `SIGHUP` | Terminate | Yes | Terminal closed; often reused as reload |
| 2 | `SIGINT` | Terminate | Yes | Keyboard interrupt (`Ctrl-C`) |
| 9 | `SIGKILL` | Terminate immediately | No | Force-kill; cannot be caught or ignored |
| 10 | `SIGUSR1` | Terminate | Yes | User-defined application signal |
| 12 | `SIGUSR2` | Terminate | Yes | User-defined application signal |
| 15 | `SIGTERM` | Terminate | Yes | Polite request to stop cleanly |

Notes:
- Prefer `SIGTERM` before `SIGKILL`.
- `SIGKILL` is a last resort because the process gets no chance to clean up.
- Signal numbers can vary across some Unix systems, but the names are stable and easier to remember.

## 4. `trap` recipes

### Cleanup on exit

```bash
cleanup() {
  rm -rf "$temp_dir"
}

trap 'cleanup' EXIT INT TERM
```

Use this when you create temp files, lock files, sockets, or directories that must be removed.

### Retry wrapper

```bash
retry() {
  local attempt
  for attempt in 1 2 3; do
    "$@" && return 0
    sleep "$attempt"
  done
  return 1
}
```

Use retry when a command may fail temporarily, such as a network call or a transient lock.

### Ignore a signal

```bash
trap '' INT
```

This tells the shell to ignore `SIGINT`. Use sparingly because ignoring `Ctrl-C` can be frustrating for users.

## 5. Parallel jobs pattern

A simple pattern for launching independent work in parallel:

```bash
work() {
  local item="$1"
  echo "starting $item"
  sleep 1
  echo "done $item"
}

for i in 1 2 3; do
  work "$i" &
done

wait
```

Key idea:
- `&` starts each job in the background.
- `wait` with no PID waits for all of them.

When you need per-job status, store the PIDs:

```bash
pids=()
for i in 1 2 3; do
  work "$i" &
  pids+=("$!")
done

for pid in "${pids[@]}"; do
  wait "$pid"
done
```

## 6. Common pitfalls

- Forgetting that `( ... )` uses a subshell, so variable changes do not come back out.
- Forgetting the spaces or trailing semicolon in `{ ...; }`.
- Using `SIGKILL` first instead of trying `SIGTERM`.
- Setting a trap before the variable it uses is defined.
- Creating temp files but forgetting cleanup.
- Assuming `jobs`, `fg`, and `bg` behave the same way in non-interactive scripts as they do in an interactive terminal.
- Launching background jobs and forgetting `wait`, which can make a script exit early.
- Not checking `timeout` exit codes; `124` usually means the command exceeded the limit.
