#!/usr/bin/env bash
# dls.sh - FIFO server that downloads files via rsync

set -euo pipefail

FIFO="${HOME}/dls.fifo"
REMOTE="hbgong@oleander.rgong.click:/home/hbgong/Downloads"
RSYNC_OPTS=(-av --progress --protect-args)

# Create the named pipe if it does not exist
if [[ ! -p "$FIFO" ]]; then
  mkfifo "$FIFO"
  echo "Created FIFO: $FIFO"
fi

echo "Listening on $FIFO (Ctrl-C to stop)"
echo "Downloads will be saved to: $(pwd)"
echo

# Outer loop keeps the reader alive after writers disconnect
while true; do
  # Blocks until a client writes and then closes the pipe
  while IFS= read -r file; do
    # Skip empty lines
    [[ -z "$file" ]] && continue

    echo ">>> Requested: $file"
    rsync "${RSYNC_OPTS[@]}" "${REMOTE}/${file}" .
    echo
  done < "$FIFO"
done
