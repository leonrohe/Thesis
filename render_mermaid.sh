#!/usr/bin/env bash

set -euo pipefail

# --- Usage --------------------------------------------------------------
# ./render_mermaid.sh input.mmd output.svg
# Creates a temporary PDF and converts it to SVG using pdf2svg.
# ------------------------------------------------------------------------

if [ $# -ne 2 ]; then
    echo "Usage: $0 input.mmd output.svg"
    exit 1
fi

INPUT="$1"
OUTPUT="$2"

if [ ! -f "$INPUT" ]; then
    echo "Error: File '$INPUT' does not exist."
    exit 1
fi

TMPPDF="$(mktemp --suffix=.pdf)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

echo "→ Rendering Mermaid to PDF..."
mmdc -i "$INPUT" -o "$TMPPDF" --pdfFit --scale 2 || {
    echo "Failed to render Mermaid with mmdc."
    exit 1
}

echo "→ Converting PDF to SVG..."
pdf2svg "$TMPPDF" "$OUTPUT" || {
    echo "Failed to convert PDF to SVG."
    exit 1
}

echo "→ Output written to $OUTPUT"

rm "$TMPPDF"
