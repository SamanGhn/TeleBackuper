from backup.collector import create_backup_from_dirs
from backup.cleaner import clean_old_backups
from telegram.sender import send_file_to_telegram
from utils.logger import setup_logger
from config import BACKUP_EXPIRE_DAYS
import tempfile

logger = setup_logger()

def get_dirs_from_user():
    input_dirs = input("📂 Enter directories to backup (comma-separated):\n> ")
    return [d.strip() for d in input_dirs.split(",") if d.strip()]

def run_backup():
    try:
        dirs = get_dirs_from_user()
        backup_file = create_backup_from_dirs(dirs)
        logger.info(f"Backup created at {backup_file}")
        
        send_file_to_telegram(backup_file)
        logger.info("File sent to Telegram successfully.")
        
        clean_old_backups(tempfile.gettempdir(), BACKUP_EXPIRE_DAYS)
        logger.info("Old backups cleaned up.")
        
    except Exception as e:
        logger.error(f"Error during backup: {e}")

if __name__ == "__main__":
    run_backup()

