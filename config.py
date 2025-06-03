import os

BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN", "")
CHAT_ID = os.getenv("TELEGRAM_CHAT_ID", "")
BACKUP_EXPIRE_DAYS = int(os.getenv("BACKUP_EXPIRE_DAYS", 7))
