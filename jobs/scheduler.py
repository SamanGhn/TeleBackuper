import os
import subprocess

def add_cron_job(interval_hours):
    command = f"0 */{interval_hours} * * * /usr/bin/python3 {os.path.abspath('main.py')}"
    existing_crontab = subprocess.getoutput("crontab -l || true")

    if command in existing_crontab:
        return

    new_crontab = existing_crontab + f"\n{command}\n"
    subprocess.run(['crontab'], input=new_crontab.encode(), check=True)
