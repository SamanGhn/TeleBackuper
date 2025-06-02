# main.py

from backup.collector import create_backup_from_dirs
from telegram.sender import send_file_to_telegram
import tempfile
import datetime

def get_dirs_from_user():
    input_dirs = input("📂 Enter directories to backup (comma-separated):\n> ")
    dirs = [d.strip() for d in input_dirs.split(",") if d.strip()]
    return dirs

def main():
    try:
        dirs = get_dirs_from_user()
        
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        temp_path = tempfile.gettempdir() + f"/backup_{timestamp}.tar.gz"
        
        backup_file = create_backup_from_dirs(dirs, temp_path)
        print(f"✅ Backup created: {backup_file}")
        
        send_file_to_telegram(backup_file)
        print("📤 File sent to Telegram successfully.")

    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    main()
