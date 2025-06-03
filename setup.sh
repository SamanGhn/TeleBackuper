#!/bin/bash

# 🎨 رنگ‌ها
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
BOLD='\033[1m'
RESET='\033[0m'

CONFIG_FILE="config.py"
SCRIPT_PATH="$(pwd)/main.py"
PYTHON_PATH=$(which python3)

function show_banner() {
    clear
    echo -e "${BOLD}${CYAN}"
    echo "╔═════════════════════════════════════════════════════════════╗"
    echo "║                                                             ║"
    echo "║           🔐  ${BOLD}TeleBackuper - Interactive Setup Menu${RESET}${CYAN}           ║"
    echo "║                                                             ║"
    echo "╚═════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

function install() {
    echo -e "${BOLD}${CYAN}🔑 Enter your Telegram Bot Token:${RESET}"
    read BOT_TOKEN

    echo -e "${BOLD}${CYAN}🆔 Enter your numeric Chat ID:${RESET}"
    read CHAT_ID

    echo -e "${BOLD}${CYAN}📂 Enter directories to backup (comma-separated):${RESET}"
    read DIRS

    echo -e "${BOLD}${CYAN}⏱️  Enter interval in hours for cron job:${RESET}"
    read interval

    echo -e "\n${YELLOW}🔧 Generating config.py ...${RESET}"
    echo "BOT_TOKEN = '$BOT_TOKEN'" > $CONFIG_FILE
    echo "CHAT_ID = '$CHAT_ID'" >> $CONFIG_FILE
    echo "BACKUP_DIRECTORIES = [$(
        IFS=',' read -ra ADDR <<< "$DIRS"
        for i in "${ADDR[@]}"; do
            printf "'%s'," "$(echo $i | xargs)"
        done
    )]" >> $CONFIG_FILE
    echo "BACKUP_EXPIRE_DAYS = 7" >> $CONFIG_FILE
    echo -e "${GREEN}✅ config.py updated.${RESET}"

    echo -e "\n${YELLOW}🔄 Setting up cron job...${RESET}"
    (crontab -l 2>/dev/null; echo "0 */$interval * * * $PYTHON_PATH $SCRIPT_PATH >> /var/log/telebackuper.log 2>&1") | crontab -
    echo -e "${GREEN}✅ Cron job added to run every $interval hour(s).${RESET}"

    echo -e "\n${CYAN}🚀 Sending first backup now...${RESET}"
    $PYTHON_PATH $SCRIPT_PATH

    echo -e "\n${GREEN}🎉 Installation complete!${RESET}"
    echo -e "${CYAN}ℹ️  You can view logs with: ${BOLD}tail -f /var/log/telebackuper.log${RESET}"
    read -p "$(echo -e "${YELLOW}⏎ Press Enter to return to menu...${RESET}")"
}

function change_config() {
    echo -e "\n${YELLOW}🔧 Opening config.py for editing...${RESET}"
    sleep 1
    ${EDITOR:-nano} config.py
}

function exit_script() {
    echo -e "\n${RED}👋 Exiting...${RESET}"
    exit 0
}

while true; do
    show_banner
    echo -e "${BOLD}${YELLOW}Please select an option:${RESET}"
    echo ""
    echo -e "${GREEN}[1]${RESET} 🔧  Install / Reconfigure"
    echo -e "${GREEN}[2]${RESET} ✏️   Edit config.py"
    echo -e "${GREEN}[3]${RESET} ❌  Exit"
    echo ""
    read -p "$(echo -e "${BOLD}➡️  Enter your choice [1-3]: ${RESET}")" choice
    case $choice in
        1) install ;;
        2) change_config ;;
        3) exit_script ;;
        *) echo -e "\n${RED}❌ Invalid option. Please choose 1-3.${RESET}"; sleep 2 ;;
    esac
done
