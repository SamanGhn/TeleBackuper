import os
import time

def clean_old_backups(directory: str, max_age_days: int):
    now = time.time()
    for filename in os.listdir(directory):
        if filename.endswith(".tar.gz"):
            file_path = os.path.join(directory, filename)
            if os.path.isfile(file_path):
                file_age_days = (now - os.path.getmtime(file_path)) / (60 * 60 * 24)
                if file_age_days > max_age_days:
                    os.remove(file_path)
