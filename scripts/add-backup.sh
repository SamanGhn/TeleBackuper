#!/usr/bin/env bash

BASE_DIR="/opt/backup-manager"
BACKUPS_DIR="$BASE_DIR/backups"

read -p "Enter backup name: " BACKUP_NAME

[[ -z "$BACKUP_NAME" ]] && echo "Name required" && exit 1

BACKUP_PATH="$BACKUPS_DIR/$BACKUP_NAME"

if [[ -d "$BACKUP_PATH" ]]; then
  echo "Backup already exists!"
  exit 1
fi

mkdir -p "$BACKUP_PATH"

# -------- Paths --------
echo "[+] Enter paths to backup"
> "$BACKUP_PATH/paths.list"

while true; do
  read -p "Path: " PATH_INPUT
  [[ -z "$PATH_INPUT" ]] && break
  echo "$PATH_INPUT" >> "$BACKUP_PATH/paths.list"
done

# -------- Interval --------
read -p "Interval (1h,2h,6h,12h): " INTERVAL

# -------- Telegram --------
read -p "Telegram Bot Token: " BOT_TOKEN
read -p "Telegram Admin ID: " ADMIN_ID

# -------- Description --------
read -p "Description (optional): " DESCRIPTION

# -------- Config --------
cat > "$BACKUP_PATH/config.env" <<EOF
BACKUP_NAME="$BACKUP_NAME"
INTERVAL="$INTERVAL"
TELEGRAM_BOT_TOKEN="$BOT_TOKEN"
TELEGRAM_ADMIN_ID="$ADMIN_ID"
DESCRIPTION="$DESCRIPTION"
ENABLED=true
EOF

echo "active" > "$BACKUP_PATH/status"

echo "[✓] Backup $BACKUP_NAME created."

bash "$BASE_DIR/scripts/install-cron.sh" "$BACKUP_NAME"

read -p "Press Enter to continue..."
