#!/usr/bin/env bash
# archive-backup.sh – daily copy-only backup of the archive

set -euo pipefail

SOURCE="/media/hbgong/SGT-P1/archive"
DESTINATIONS=(
  "/media/hbgong/WD-BLK-1T/archive"
  "/media/hbgong/WD1T-SLV/archive"
)

LOG="$HOME/logs/archive-backup.log"
## Copy-only mode
#RSYNC_OPTS=(-av --human-readable --stats)
## Mirror mode
RSYNC_OPTS=(-av --human-readable --stats --delete-after)

# Ensure log directory exists
mkdir -p "$(dirname "$LOG")"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S')  $*" | tee -a "$LOG"
}

log "========== Backup started =========="

if [[ ! -d "$SOURCE" ]]; then
  log "ERROR: Source $SOURCE is not available. Aborting."
  exit 1
fi

for DEST in "${DESTINATIONS[@]}"; do
  if [[ ! -d "$DEST" ]]; then
    log "SKIP: Destination $DEST is not available (disk offline?)"
    continue
  fi

  log "Backing up to $DEST ..."
  if rsync "${RSYNC_OPTS[@]}" "$SOURCE/" "$DEST/" >> "$LOG" 2>&1; then
    log "SUCCESS: $DEST"
  else
    log "ERROR: rsync to $DEST failed (exit code $?)"
  fi
done

log "========== Backup finished =========="
echo >> "$LOG"
