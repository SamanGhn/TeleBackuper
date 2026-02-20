#!/usr/bin/env bash
set -e

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BACKUPS_DIR="$BASE_DIR/backups"

clear
echo "➕ Add New Backup"
echo "-------------------------"

# ---------- Backup Name ----------
read -rp "Backup name: " BACKUP_NAME
[[ -z "$BACKUP_NAME" ]] && echo "❌ Backup name is required" && exit 1

BACKUP_PATH="$BACKUPS_DIR/$BACKUP_NAME"

if [[ -d "$BACKUP_PATH" ]]; then
  echo "❌ Backup '$BACKUP_NAME' already exists"
  exit 1
fi

mkdir -p "$BACKUP_PATH"

# ---------- Paths ----------
echo
echo "[+] Enter paths to backup (leave empty to finish)"
> "$BACKUP_PATH/paths.list"

while true; do
  read -rp "Path: " PATH_INPUT
  [[ -z "$PATH_INPUT" ]] && break

  if [[ ! -e "$PATH_INPUT" ]]; then
    echo "⚠ Path does not exist, skipped"
    continue
  fi

  echo "$PATH_INPUT" >> "$BACKUP_PATH/paths.list"
done

if [[ ! -s "$BACKUP_PATH/paths.list" ]]; then
  echo "❌ No valid paths provided"
  rm -rf "$BACKUP_PATH"
  exit 1
fi

# ---------- Interval ----------
echo
read -rp "Interval (1h,2h,6h,12h,24h): " INTERVAL

case "$INTERVAL" in
  1h|2h|6h|12h|24h) ;;
  *)
    echo "❌ Invalid interval format"
    rm -rf "$BACKUP_PATH"
    exit 1
    ;;
esac

# ---------- Keep Days ----------
read -rp "Keep backups for how many days? [7]: " KEEP_DAYS
KEEP_DAYS="${KEEP_DAYS:-7}"

if ! [[ "$KEEP_DAYS" =~ ^[0-9]+$ ]]; then
  echo "❌ KEEP_DAYS must be a number"
  rm -rf "$BACKUP_PATH"
  exit 1
fi

# ---------- Enabled ----------
read -rp "Enable backup now? (y/n) [y]: " ENABLED_INPUT
ENABLED_INPUT="${ENABLED_INPUT:-y}"

case "$ENABLED_INPUT" in
  y|Y) ENABLED=true ;;
  n|N) ENABLED=false ;;
  *)
    echo "❌ Invalid choice"
    rm -rf "$BACKUP_PATH"
    exit 1
    ;;
esac

# ---------- Telegram ----------
echo
read -rp "Telegram Bot Token: " TELEGRAM_BOT_TOKEN
read -rp "Telegram Admin ID: " TELEGRAM_ADMIN_ID

if [[ -z "$TELEGRAM_BOT_TOKEN" || -z "$TELEGRAM_ADMIN_ID" ]]; then
  echo "❌ Telegram config required"
  rm -rf "$BACKUP_PATH"
  exit 1
fi

# ---------- Description ----------
read -rp "Description (optional): " DESCRIPTION

# ---------- Config ----------
cat > "$BACKUP_PATH/config.env" <<EOF
BACKUP_NAME="$BACKUP_NAME"
INTERVAL="$INTERVAL"
KEEP_DAYS="$KEEP_DAYS"
ENABLED="$ENABLED"
TELEGRAM_BOT_TOKEN="$TELEGRAM_BOT_TOKEN"
TELEGRAM_ADMIN_ID="$TELEGRAM_ADMIN_ID"
DESCRIPTION="$DESCRIPTION"
EOF

echo "$ENABLED" > "$BACKUP_PATH/status"

echo
echo "✅ Backup '$BACKUP_NAME' created successfully"

# ---------- Cron ----------
if [[ "$ENABLED" == "true" ]]; then
  bash "$BASE_DIR/scripts/install-cron.sh" "$BACKUP_NAME"
else
  echo "ℹ Backup is disabled; cron not installed"
fi
