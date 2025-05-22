import os
import sys
import requests
from dotenv import load_dotenv

load_dotenv(dotenv_path='config/config.env')

BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN")
CHAT_ID = os.getenv("TELEGRAM_CHAT_ID")

def send_backup(file_path):
    url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendDocument"
    with open(file_path, 'rb') as f:
        files = {'document': f}
        data = {'chat_id': CHAT_ID}
        response = requests.post(url, files=files, data=data)
    if response.status_code == 200:
        print("Backup sent successfully!")
    else:
        print(f"Failed to send backup. Status code: {response.status_code}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Please provide the path to backup file")
        sys.exit(1)
    send_backup(sys.argv[1])
