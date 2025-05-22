# زمان کرون به شکل "0 2 * * *" (مثلاً هر روز ساعت ۲ صبح)
echo "Enter cron schedule (e.g. 0 2 * * *):"
read CRON_SCHEDULE

CRON_COMMAND="bash $(pwd)/scripts/backup_runner.sh"

(crontab -l 2>/dev/null; echo "$CRON_SCHEDULE $CRON_COMMAND") | crontab -
echo "Cron job added."
