#!/usr/bin/env bash
set -e

BASE_DIR="/opt/backup-manager"
NAME="$1"

if [[ -z "$NAME" ]]; then
  echo "Backup name not provided"
  exit 1
fi

BKP_DIR="$BASE_DIR/backups/$NAME"

if [[ ! -d "$BKP_DIR" ]]; then
  echo "Backup '$NAME' not found"
  exit 1
fi

# Load config
source "$BKP_DIR/config.env"

if [[ "$ENABLED" != "true" ]]; then
  echo "Backup '$NAME' is disabled"
  exit 0
fi

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVE="$BASE_DIR/runtime/temp/${NAME}_${DATE}.tar.gz"

# Validate paths file
if [[ ! -s "$BKP_DIR/paths.list" ]]; then
  echo "No paths defined for backup '$NAME'"
  exit 1
fi

# Create archive
tar -czf "$ARCHIVE" -T "$BKP_DIR/paths.list"

# Send to Telegram
bash "$BASE_DIR/scripts/telegram.sh" \
  "$ARCHIVE" \
  "$TELEGRAM_BOT_TOKEN" \
  "$TELEGRAM_ADMIN_ID"

# Log
echo "[$(date)] Backup sent: $ARCHIVE" >> \
  "$BASE_DIR/runtime/logs/$NAME.log"

echo "Backup '$NAME' completed successfully"
