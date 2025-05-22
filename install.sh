#!/bin/bash

set -e

echo "Installing required packages..."
apt update
apt install -y python3 python3-pip cron

echo "Installing Python dependencies..."
pip3 install requests python-dotenv

echo "Loading configuration..."
set -a
source config/config.env
set +a

echo "Creating backup and log directories..."
mkdir -p "$BACKUP_PATH"
mkdir -p "$LOG_PATH"

echo "Installation and setup done."
