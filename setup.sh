#!/bin/bash

CONFIG_FILE="config.py"
CRON_FILE="/etc/cron.d/telebackuper"
SCRIPT_PATH="$(realpath main.py)"
PYTHON_PATH=$(which python3)

GREEN="\033[0;32m"
RED="\033[0;31m"
CYAN="\033[0;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

show_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════╗"
    echo "║      🚀 TeleBackuper Installer       ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${RESET}"
}

install() {
    echo -e "${YELLOW}🔑 Enter your Telegram Bot Token:${RESET}"
    read -r BOT_TOKEN

    echo -e "${YELLOW}🆔 Enter your numeric Chat ID:${RESET}"
    read -r CHAT_ID

    echo -e "${YELLOW}📂 Enter directories to backup (comma-separated):${RESET}"
    read -r DIRS

    echo -e "${YELLOW}⏱️  Enter interval in hours for cron job:${RESET}"
    read -r INTERVAL

    echo -e "${CYAN}🔧 Generating config.py ...${RESET}"
    cat > "$CONFIG_FILE" <<EOF
BOT_TOKEN = "${BOT_TOKEN}"
CHAT_ID = "${CHAT_ID}"
DIRECTORIES = [${DIRS//,/","}]
BACKUP_EXPIRE_DAYS = 3
EOF
    echo -e "${GREEN}✅ config.py updated.${RESET}"

    echo -e "${CYAN}📅 Adding cron job ...${RESET}"
    (crontab -l 2>/dev/null; echo "0 */$INTERVAL * * * $PYTHON_PATH $SCRIPT_PATH > /dev/null 2>&1") | crontab -
    echo -e "${GREEN}✅ Cron job added to run every $INTERVAL hour(s).${RESET}"

    echo -e "${GREEN}✅ Installation complete!${RESET}"
}

change_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}⚠️ config.py not found. Please install first.${RESET}"
        return
    fi

    echo -e "${YELLOW}What do you want to change? (bot/chat/dirs/expire):${RESET}"
    read -r option

    case $option in
        bot)
            echo -e "${YELLOW}Enter new Bot Token:${RESET}"
            read -r new
            sed -i "s/^BOT_TOKEN = .*/BOT_TOKEN = \"${new}\"/" "$CONFIG_FILE"
            ;;
        chat)
            echo -e "${YELLOW}Enter new Chat ID:${RESET}"
            read -r new
            sed -i "s/^CHAT_ID = .*/CHAT_ID = \"${new}\"/" "$CONFIG_FILE"
            ;;
        dirs)
            echo -e "${YELLOW}Enter new directories (comma-separated):${RESET}"
            read -r new
            sed -i "s|^DIRECTORIES = .*|DIRECTORIES = [${new//,/","}]|" "$CONFIG_FILE"
            ;;
        expire)
            echo -e "${YELLOW}Enter new expiration days for backups:${RESET}"
            read -r new
            sed -i "s/^BACKUP_EXPIRE_DAYS = .*/BACKUP_EXPIRE_DAYS = ${new}/" "$CONFIG_FILE"
            ;;
        *)
            echo -e "${RED}❌ Invalid option.${RESET}"
            ;;
    esac

    echo -e "${GREEN}✅ Configuration updated.${RESET}"
}

exit_script() {
    echo -e "${CYAN}👋 Exiting...${RESET}"
    exit 0
}

# Menu
while true; do
    show_banner
    echo -e "${YELLOW}1) 🛠 Install / Reinstall"
    echo -e "2) ⚙️  Change Config"
    echo -e "3) ❌ Exit${RESET}"
    echo
    read -rp "Enter your choice [1-3]: " choice
    echo

    case $choice in
        1) install ;;
        2) change_config ;;
        3) exit_script ;;
        *) echo -e "${RED}❌ Invalid choice. Try again.${RESET}" ;;
    esac

    echo -e "${CYAN}\nPress Enter to return to menu...${RESET}"
    read
done
