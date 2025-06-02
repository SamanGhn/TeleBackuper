from backup.collector import create_backup_from_dirs
from backup.cleaner import clean_old_backups
from telegram.sender import send_file_to_telegram
from utils.logger import setup_logger
from config import BACKUP_EXPIRE_DAYS, BACKUP_DIRECTORIES
import tempfile
from rich.console import Console
from rich.prompt import Prompt
from rich.panel import Panel
from rich.traceback import install
from rich import box
import datetime

install()
console = Console()
logger = setup_logger()

def get_dirs_from_user():
    console.print(Panel.fit("📂 [bold cyan]Enter directories to backup[/bold cyan]\n[dim]Separate with commas like:[/dim] [yellow]/root/mamad, /root/ali[/yellow]", title="Directory Input", box=box.ROUNDED))
    input_dirs = Prompt.ask("➡️  [green]Directories[/green]")
    dirs = [d.strip() for d in input_dirs.split(",") if d.strip()]
    return dirs

def run_backup():
    try:
        dirs = BACKUP_DIRECTORIES if BACKUP_DIRECTORIES else get_dirs_from_user()

        backup_file = create_backup_from_dirs(dirs)
        logger.info(f"✅ Backup created at {backup_file}")

        send_file_to_telegram(backup_file)
        logger.info("📤 File sent to Telegram successfully.")

        clean_old_backups(tempfile.gettempdir(), BACKUP_EXPIRE_DAYS)
        logger.info("🧹 Old backups cleaned up.")

    except Exception as e:
        logger.error(f"❌ Error during backup: {e}")

if __name__ == "__main__":
    now_str = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    console.rule(f"[bold green]🚀 Backup to Telegram - {now_str}[/bold green]", style="green")

    run_backup()

    console.rule("[bold green]✅ Process finished[/bold green]", style="green")
