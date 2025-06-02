# telegram/sender.py

import requests
from config import BOT_TOKEN, CHAT_ID

def send_file_to_telegram(file_path):
    url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendDocument"
    with open(file_path, 'rb') as file:
        response = requests.post(url, data={"chat_id": CHAT_ID}, files={"document": file})
    
    if response.status_code != 200:
        raise Exception(f"Failed to send file: {response.text}")
