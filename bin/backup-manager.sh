#!/usr/bin/env bash
set -euo pipefail

# -------------------------
# Paths
# -------------------------
BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPTS="$BASE_DIR/scripts"
BACKUPS="$BASE_DIR/backups"

# -------------------------
# Colors
# -------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

pause() {
  echo
  read -rp "Press Enter to continue..."
}

error() {
  echo -e "${RED}❌ $1${NC}"
}

info() {
  echo -e "${CYAN}ℹ️  $1${NC}"
}

success() {
  echo -e "${GREEN}✅ $1${NC}"
}

# -------------------------
# Helpers
# -------------------------
list_backups() {
  [[ -d "$BACKUPS" ]] || {
    error "No backups directory found"
    return
  }

  local found=false
  for d in "$BACKUPS"/*; do
    [[ -d "$d" && -f "$d/config.env" ]] || continue
    echo " - $(basename "$d")"
    found=true
  done

  $found || info "No backups configured"
}

select_backup() {
  read -rp "Backup name: " NAME
  [[ -d "$BACKUPS/$NAME" && -f "$BACKUPS/$NAME/config.env" ]] || {
    error "Backup '$NAME' not found"
    return 1
  }
  echo "$NAME"
}

# -------------------------
# Menu loop
# -------------------------
while true; do
  clear
  echo -e "${BOLD}TeleBackuper CLI${NC}"
  echo "----------------------------"
  echo "1) List backups"
  echo "2) Add backup"
  echo "3) Edit backup"
  echo "4) Toggle backup (enable/disable)"
  echo "5) Run backup now (manual)"
  echo "6) Delete backup"
  echo "0) Exit"
  echo

  read -rp "Select option: " OPT

  case "$OPT" in
    1)
      list_backups
      pause
      ;;
    2)
      bash "$SCRIPTS/add-backup.sh"
      pause
      ;;
    3)
      bash "$SCRIPTS/edit-backup.sh"
      pause
      ;;
    4)
      bash "$SCRIPTS/toggle-backup.sh"
      pause
      ;;
    5)
      if NAME="$(select_backup)"; then
        info "Running backup '$NAME' manually"
        bash "$SCRIPTS/run-backup.sh" "$NAME"
        success "Backup finished"
      fi
      pause
      ;;
    6)
      bash "$SCRIPTS/delete-backup.sh"
      pause
      ;;
    0)
      echo "Bye 👋"
      exit 0
      ;;
    *)
      error "Invalid option"
      pause
      ;;
  esac
done
