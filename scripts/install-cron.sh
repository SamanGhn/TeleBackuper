#!/usr/bin/env bash
set -euo pipefail

# ---------- Args ----------
NAME="${1:-}"

if [[ -z "$NAME" ]]; then
  echo "❌ Backup name is required"
  exit 1
fi

# ---------- Paths ----------
BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CFG="$BASE_DIR/backups/$NAME/config.env"
RUNNER="$BASE_DIR/scripts/run-backup.sh"

if [[ ! -f "$CFG" ]]; then
  echo "❌ Config not found for backup '$NAME'"
  exit 1
fi

# ---------- Load config ----------
# shellcheck disable=SC1090
source "$CFG"

# ---------- Enabled check ----------
if [[ "${ENABLED:-false}" != "true" ]]; then
  echo "ℹ Backup '$NAME' is disabled; cron not installed"
  exit 0
fi

# ---------- Interval ----------
case "$INTERVAL" in
  1h)  CRON="0 * * * *" ;;
  2h)  CRON="0 */2 * * *" ;;
  6h)  CRON="0 */6 * * *" ;;
  12h) CRON="0 */12 * * *" ;;
  24h) CRON="0 0 * * *" ;;
  *)
    echo "❌ Invalid interval: '$INTERVAL'"
    exit 1
    ;;
esac

# ---------- Marker ----------
CRON_MARKER="# TeleBackuper:$NAME"

# ---------- Install ----------
(
  crontab -l 2>/dev/null | grep -v "$CRON_MARKER"
  echo "$CRON $RUNNER $NAME $CRON_MARKER"
) | crontab -

echo "✅ Cron installed for backup '$NAME' ($INTERVAL)"
