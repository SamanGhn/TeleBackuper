#!/usr/bin/env bash

NAME="$1"
BASE_DIR="/opt/backup-manager"
CFG="$BASE_DIR/backups/$NAME/config.env"

source "$CFG"

case "$INTERVAL" in
  1h) CRON="0 * * * *" ;;
  2h) CRON="0 */2 * * *" ;;
  6h) CRON="0 */6 * * *" ;;
  12h) CRON="0 */12 * * *" ;;
  *) echo "Invalid interval"; exit 1 ;;
esac

( crontab -l 2>/dev/null | grep -v "$NAME" ; \
  echo "$CRON $BASE_DIR/scripts/run-backup.sh $NAME" ) | crontab -
