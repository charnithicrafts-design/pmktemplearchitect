import os
import sys
from ftplib import FTP

def clean_dir(ftp, dir_path):
    print(f"Cleaning directory: {dir_path}")
    try:
        ftp.cwd(dir_path)
    except Exception as e:
        print(f"Could not change directory to {dir_path}: {e}")
        return

    names = []
    try:
        names = ftp.nlst()
    except Exception as e:
        print(f"Could not list directory {dir_path}: {e}")
        return

    for name in names:
        # Avoid infinite loops or traversing up
        if name in ('.', '..'):
            continue

        full_path = f"{dir_path}/{name}"
        
        # Check if it is a directory or file
        is_dir = False
        try:
            ftp.cwd(full_path)
            is_dir = True
            ftp.cwd(dir_path) # go back
        except Exception:
            is_dir = False

        if is_dir:
            clean_dir(ftp, full_path)
            print(f"Removing directory: {full_path}")
            try:
                ftp.rmd(full_path)
            except Exception as e:
                print(f"Failed to remove directory {full_path}: {e}")
        else:
            print(f"Deleting file: {full_path}")
            try:
                ftp.delete(full_path)
            except Exception as e:
                print(f"Failed to delete file {full_path}: {e}")

def main():
    # Load credentials from .deploy.env
    env_path = os.path.join(os.path.dirname(__file__), '..', '.deploy.env')
    if not os.path.exists(env_path):
        print(f"Error: Credentials file not found at {env_path}")
        sys.exit(1)

    credentials = {}
    with open(env_path, 'r') as f:
        for line in f:
            if '=' in line and not line.strip().startswith('#'):
                k, v = line.strip().split('=', 1)
                credentials[k.strip()] = v.strip()

    host = credentials.get('FTP_HOST')
    user = credentials.get('FTP_USER')
    passwd = credentials.get('FTP_PASS')

    if not all([host, user, passwd]):
        print("Error: Missing credentials in .deploy.env")
        sys.exit(1)

    print(f"Connecting to FTP server: {host}")
    try:
        ftp = FTP(host)
        ftp.login(user, passwd)
        print("Logged in successfully.")
        
        # Clean the target directory
        clean_dir(ftp, '/public_html')
        
        ftp.quit()
        print("Cleanup completed successfully.")
    except Exception as e:
        print(f"FTP error occurred during cleanup: {e}")
        sys.exit(1)

if __name__ == '__main__':
    main()
