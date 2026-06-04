#!/bin/bash
# Build 3 combined PDFs: assignments, notes, quizzes.
# Each PDF concatenates the corresponding file from every module 01..11,
# with a banner heading per module so the PDF has clean section breaks.

set -euo pipefail

ROOT="/root/projects/bash-learning"
OUT="$ROOT/pdfs"
mkdir -p "$OUT"

# Friendly module titles for the section banners
declare -A TITLES=(
  [01-basics]="Module 1 — Bash Basics"
  [02-conditionals]="Module 2 — Conditionals"
  [03-loops]="Module 3 — Loops"
  [04-functions]="Module 4 — Functions"
  [05-io-redirection]="Module 5 — I/O & Redirection"
  [06-arrays]="Module 6 — Arrays"
  [07-string-manipulation]="Module 7 — String Manipulation & Regex"
  [08-processes-signals]="Module 8 — Processes, Signals, Traps"
  [09-text-processing]="Module 9 — Text Processing (grep / sed / awk)"
  [10-error-handling-debugging]="Module 10 — Error Handling & Debugging"
  [11-advanced]="Module 11 — Advanced Patterns"
)

MODULES=(01-basics 02-conditionals 03-loops 04-functions 05-io-redirection \
         06-arrays 07-string-manipulation 08-processes-signals \
         09-text-processing 10-error-handling-debugging 11-advanced)

build_combined() {
    local kind="$1"          # assignments | notes | quiz
    local title="$2"         # cover title
    local outfile="$OUT/${kind}.md"

    {
        echo "% ${title}"
        echo "% bash-learning curriculum"
        echo "% $(date +%Y-%m-%d)"
        echo
        echo "\\newpage"
        echo
        echo "# Table of Contents"
        echo
        local i=1
        for m in "${MODULES[@]}"; do
            printf "%d. %s\n\n" "$i" "${TITLES[$m]}"
            i=$((i+1))
        done
        echo "\\newpage"
        echo
        for m in "${MODULES[@]}"; do
            local src="$ROOT/modules/$m/${kind}.md"
            [[ -f "$src" ]] || { echo "WARN: missing $src" >&2; continue; }
            echo
            echo "# ${TITLES[$m]}"
            echo
            # Demote any H1s inside the source to H2 so the module title stays the top of its section
            sed -E 's/^# /## /' "$src"
            echo
            echo "\\newpage"
            echo
        done
    } > "$outfile"
    echo "wrote $outfile ($(wc -l < "$outfile") lines)"
}

build_combined assignments "Bash Mastery — Assignments"
build_combined notes       "Bash Mastery — Printable Notes"
build_combined quiz        "Bash Mastery — Quizzes"

# Render to PDF via pandoc -> wkhtmltopdf (no LaTeX required)
render_pdf() {
    local md="$1"
    local pdf="${md%.md}.pdf"
    pandoc "$md" \
        -o "$pdf" \
        --pdf-engine=wkhtmltopdf \
        --pdf-engine-opt=--enable-local-file-access \
        --pdf-engine-opt=--encoding --pdf-engine-opt=utf-8 \
        --pdf-engine-opt=--margin-top    --pdf-engine-opt=15mm \
        --pdf-engine-opt=--margin-bottom --pdf-engine-opt=15mm \
        --pdf-engine-opt=--margin-left   --pdf-engine-opt=15mm \
        --pdf-engine-opt=--margin-right  --pdf-engine-opt=15mm \
        --metadata title="$(head -1 "$md" | sed 's/^% //')" \
        2>&1 | tail -3
    echo "rendered $pdf ($(du -h "$pdf" | cut -f1))"
}

render_pdf "$OUT/assignments.md"
render_pdf "$OUT/notes.md"
render_pdf "$OUT/quiz.md"

echo
echo "=== PDFs ready ==="
ls -lh "$OUT"/*.pdf
