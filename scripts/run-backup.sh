#!/usr/bin/env bash
set -euo pipefail

# ---------- Args ----------
NAME="${1:-}"

if [[ -z "$NAME" ]]; then
  echo "❌ Backup name not provided"
  exit 1
fi

# ---------- Paths ----------
BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BKP_DIR="$BASE_DIR/backups/$NAME"
CFG="$BKP_DIR/config.env"
PATHS_FILE="$BKP_DIR/paths.list"

RUNTIME_DIR="$BASE_DIR/runtime"
TEMP_DIR="$RUNTIME_DIR/temp"
LOG_DIR="$RUNTIME_DIR/logs"

RUN_LOG="$LOG_DIR/$NAME.log"

# ---------- Sanity checks ----------
[[ -d "$BKP_DIR" ]] || { echo "❌ Backup '$NAME' not found"; exit 1; }
[[ -f "$CFG" ]] || { echo "❌ config.env missing for '$NAME'"; exit 1; }
[[ -s "$PATHS_FILE" ]] || { echo "❌ No paths defined for '$NAME'"; exit 1; }

mkdir -p "$TEMP_DIR" "$LOG_DIR"

# ---------- Load config ----------
# shellcheck disable=SC1090
source "$CFG"

if [[ "${ENABLED:-false}" != "true" ]]; then
  echo "ℹ Backup '$NAME' is disabled"
  exit 0
fi

# ---------- Archive ----------
DATE="$(date '+%Y-%m-%d_%H-%M-%S')"
ARCHIVE="$TEMP_DIR/${NAME}_${DATE}.tar.gz"

echo "[$(date)] Starting backup '$NAME'" >> "$RUN_LOG"

tar -czf "$ARCHIVE" -T "$PATHS_FILE"

if [[ ! -f "$ARCHIVE" ]]; then
  echo "❌ Archive creation failed" >> "$RUN_LOG"
  exit 1
fi

# ---------- Telegram ----------
TG_SCRIPT="$BASE_DIR/scripts/telegram.sh"

if [[ ! -x "$TG_SCRIPT" ]]; then
  echo "❌ telegram.sh not executable" >> "$RUN_LOG"
  exit 1
fi

bash "$TG_SCRIPT" \
  "$ARCHIVE" \
  "$TELEGRAM_BOT_TOKEN" \
  "$TELEGRAM_ADMIN_ID"

# ---------- Retention ----------
KEEP_DAYS="${KEEP_DAYS:-7}"

find "$TEMP_DIR" \
  -name "${NAME}_*.tar.gz" \
  -type f \
  -mtime +"$KEEP_DAYS" \
  -exec rm -f {} \;

# ---------- Log ----------
echo "[$(date)] Backup completed successfully: $ARCHIVE" >> "$RUN_LOG"

exit 0
