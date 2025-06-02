import schedule
import time
from main import run_backup

def start_scheduler():
    schedule.every().day.at("02:00").do(run_backup)  # ساعت ۲ نصف شب
    
    while True:
        schedule.run_pending()
        time.sleep(1)
