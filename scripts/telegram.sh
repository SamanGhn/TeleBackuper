#!/usr/bin/env bash

FILE="$1"
TOKEN="$2"
CHAT_ID="$3"

curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendDocument" \
  -F chat_id="$CHAT_ID" \
  -F document=@"$FILE"
