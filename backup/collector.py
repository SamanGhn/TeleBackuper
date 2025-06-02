import tarfile
import os
from datetime import datetime
import tempfile

def create_backup_from_dirs(dirs: list) -> str:
    for path in dirs:
        if not os.path.exists(path):
            raise FileNotFoundError(f"Directory not found: {path}")
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_filename = f"backup_{timestamp}.tar.gz"
    backup_path = os.path.join(tempfile.gettempdir(), backup_filename)

    with tarfile.open(backup_path, "w:gz") as tar:
        for path in dirs:
            arcname = os.path.basename(path.rstrip("/"))
            tar.add(path, arcname=arcname)

    return backup_path

