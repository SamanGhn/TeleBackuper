import logging
from rich.logging import RichHandler

def setup_logger():
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s - %(levelname)s - %(message)s",
        handlers=[RichHandler()]
    )
    return logging.getLogger("TeleBackuper")
