#!/bin/bash

set -a
source ../config/config.env
set +a

echo "Welcome to TeleBackuper"
echo "Enter directory or file to backup:"
read SOURCE_PATH

echo "Enter the name for backup archive (without extension):"
read BACKUP_NAME

BACKUP_FILE="$BACKUP_PATH/${BACKUP_NAME}.tar.gz"

echo "Creating backup..."
tar -czf "$BACKUP_FILE" "$SOURCE_PATH"

echo "Backup created at $BACKUP_FILE"

echo "Sending backup to Telegram..."
python3 ../core/telegram_sender.py "$BACKUP_FILE"
