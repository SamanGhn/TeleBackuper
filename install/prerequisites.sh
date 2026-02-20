#!/usr/bin/env bash

echo "[+] Installing prerequisites..."

apt update -y
apt install -y tar curl cron jq

systemctl enable cron
systemctl start cron

echo "[✓] Done."
read -p "Press Enter to continue..."
