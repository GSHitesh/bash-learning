# Module 08 Assignments — Processes, Signals, and Traps

These exercises focus on process control, signals, cleanup, and bounded execution.

---

## Exercise 1: Create a temp directory and clean it with `trap`

### Problem
Write a script that:
1. creates a temporary directory inside the current working directory using `mktemp -d ./scratch.XXXXXX`
2. stores the path in a variable
3. installs `trap 'rm -rf "$temp_dir"' EXIT`
4. creates two files inside that directory
5. prints the directory path while the script is running

### Sample I/O
```bash
$ bash exercise1.sh
Created temp dir: ./scratch.a1B2c3
Wrote files: notes.txt, data.log
Script finished. Cleanup will now run.
```

### Hint
Use `temp_dir="$(mktemp -d ./scratch.XXXXXX)"` and define the trap after the variable is assigned.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

temp_dir="$(mktemp -d ./scratch.XXXXXX)"
trap 'rm -rf "$temp_dir"' EXIT

echo "Created temp dir: $temp_dir"
echo "hello" > "$temp_dir/notes.txt"
echo "42" > "$temp_dir/data.log"
echo "Wrote files: notes.txt, data.log"
echo "Script finished. Cleanup will now run."
```

</details>

---

## Exercise 2: Run 5 sleeps in parallel and measure total time

### Problem
Write a script that launches five `sleep 1` commands in the background, waits for all of them, and prints how many seconds the whole batch took.

### Sample I/O
```bash
$ bash exercise2.sh
Launching 5 jobs in parallel...
All jobs finished.
Total seconds: 1
```

### Hint
Capture `start=$(date +%s)` before the loop, then `wait`, then `end=$(date +%s)`.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

start=$(date +%s)
echo "Launching 5 jobs in parallel..."

for i in 1 2 3 4 5; do
    sleep 1 &
done

wait
end=$(date +%s)

echo "All jobs finished."
echo "Total seconds: $((end - start))"
```

</details>

---

## Exercise 3: Catch Ctrl-C and exit gracefully

### Problem
Write a script that loops forever, prints `Working...`, and sleeps for 1 second each iteration. If the user presses Ctrl-C, the script should print a friendly message and exit with a non-zero status.

### Sample I/O
```bash
$ bash exercise3.sh
Working...
Working...
^CInterrupted by user. Cleaning up and exiting.
```

### Hint
Use `trap 'echo "Interrupted by user. Cleaning up and exiting."; exit 130' INT`.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

trap 'echo "Interrupted by user. Cleaning up and exiting."; exit 130' INT

while true; do
    echo "Working..."
    sleep 1
done
```

</details>

---

## Exercise 4: Spawn a background job and report when it finishes

### Problem
Write a script that starts a background command, saves its PID, waits for it, and then prints a message saying the job completed.

### Sample I/O
```bash
$ bash exercise4.sh
Started job with PID 12345
Job 12345 finished successfully.
```

### Hint
Start with `sleep 2 &`, save `pid=$!`, then `wait "$pid"`.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

sleep 2 &
pid=$!

echo "Started job with PID $pid"

if wait "$pid"; then
    echo "Job $pid finished successfully."
else
    echo "Job $pid failed."
fi
```

</details>

---

## Exercise 5: Use `timeout` to stop a long command

### Problem
Write a script that runs a command that would normally take 10 seconds, but use `timeout` so it is stopped after 2 seconds. Detect the timeout exit code and print a helpful message.

### Sample I/O
```bash
$ bash exercise5.sh
Starting bounded command...
The command timed out after 2 seconds.
```

### Hint
`timeout` usually returns exit code `124` when it kills the command.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

echo "Starting bounded command..."

if timeout 2 sleep 10; then
    echo "The command finished normally."
else
    status=$?
    if [ "$status" -eq 124 ]; then
        echo "The command timed out after 2 seconds."
    else
        echo "The command failed with status $status."
    fi
fi
```

</details>

---

## Exercise 6: Write a retry-with-backoff wrapper

### Problem
Write a shell function named `retry_with_backoff` that:
1. accepts a command to run
2. retries up to 3 times
3. waits 1 second before retry 2, then 2 seconds before retry 3
4. stops early if the command succeeds

Test it with a command that fails the first two times and succeeds the third time.

### Sample I/O
```bash
$ bash exercise6.sh
Attempt 1 failed.
Sleeping 1 second before retry...
Attempt 2 failed.
Sleeping 2 seconds before retry...
Attempt 3 succeeded.
```

### Hint
Use a loop like `for attempt in 1 2 3; do ... done` and compute sleep time with `sleep "$((attempt))"` for the failed attempts.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

counter=0
flaky_command() {
    counter=$((counter + 1))
    [ "$counter" -ge 3 ]
}

retry_with_backoff() {
    local attempt

    for attempt in 1 2 3; do
        if "$@"; then
            echo "Attempt $attempt succeeded."
            return 0
        fi

        echo "Attempt $attempt failed."

        if [ "$attempt" -lt 3 ]; then
            echo "Sleeping $attempt second(s) before retry..."
            sleep "$attempt"
        fi
    done

    return 1
}

retry_with_backoff flaky_command
```

</details>
