#!/usr/bin/env bash

BASE_DIR="/opt/backup-manager"
BACKUP_DIR="$BASE_DIR/backups"

while true; do
  clear
  echo "========== Backup Manager =========="
  echo "1) Install prerequisites"
  echo "2) Add new backup"
  echo "3) Edit existing backup"
  echo "4) Enable / Disable backup"
  echo "5) Delete backup"
  echo "6) DELETE EVERYTHING"
  echo "0) Exit"
  echo "===================================="
  read -p "Choose an option: " choice

  case $choice in
    1) bash "$BASE_DIR/install/prerequisites.sh" ;;
    2) bash "$BASE_DIR/scripts/add-backup.sh" ;;
    3) bash "$BASE_DIR/scripts/edit-backup.sh" ;;
    4) bash "$BASE_DIR/scripts/toggle-backup.sh" ;;
    5) bash "$BASE_DIR/scripts/delete-backup.sh" ;;
    6) bash "$BASE_DIR/scripts/nuke.sh" ;;
    0) exit 0 ;;
    *) echo "Invalid option"; sleep 1 ;;
  esac
done
