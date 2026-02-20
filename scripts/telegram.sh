#!/usr/bin/env bash
set -euo pipefail

FILE="${1:-}"
TOKEN="${2:-}"
CHAT_ID="${3:-}"

[[ -f "$FILE" ]] || { echo "❌ File not found: $FILE"; exit 1; }
[[ -n "$TOKEN" ]] || { echo "❌ Telegram token missing"; exit 1; }
[[ -n "$CHAT_ID" ]] || { echo "❌ Telegram chat_id missing"; exit 1; }

curl --fail --silent --show-error \
     --max-time 60 \
     -X POST "https://api.telegram.org/bot$TOKEN/sendDocument" \
     -F chat_id="$CHAT_ID" \
     -F document=@"$FILE"
