#!/usr/bin/env bash
# dlc.sh - send one or more filenames/patterns to the dls FIFO

set -euo pipefail

FIFO="${HOME}/dls.fifo"

if [[ ! -p "$FIFO" ]]; then
  echo "Error: FIFO $FIFO does not exist. Is dls.sh running?" >&2
  exit 1
fi

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <filename|pattern> [filename|pattern ...]" >&2
  exit 1
fi

# Write each argument on its own line so spaces and special characters are preserved
for arg in "$@"; do
  printf '%s\n' "$arg"
done > "$FIFO"
