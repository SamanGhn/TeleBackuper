# backup/collector.py

import tarfile
import os

def create_backup_from_dirs(dirs: list, dest_path: str):
    for path in dirs:
        if not os.path.exists(path):
            raise FileNotFoundError(f"Directory not found: {path}")
    
    with tarfile.open(dest_path, "w:gz") as tar:
        for path in dirs:
            arcname = os.path.basename(path.rstrip("/"))
            tar.add(path, arcname=arcname)
    
    return dest_path
