import os
import requests
import shutil
from datetime import datetime

# List of files to update
# Uncomment the files you want to update.
# To ensure a file is skipped, add the "<VCMAKE_NO_UPDATE>" directive to the file.
# Updated files will be backed up in the backup folder with a timestamp.

repo_url = "https://raw.githubusercontent.com/tomasmark79/MarkWareVCMake/refs/heads/main/"

files_to_update = [
    # "cmake/Modules/FindX11.cmake",
    # "cmake/CPM.cmake",
    # "cmake/tools.cmake",
    # ".github/workflows/install.yml",
    # ".github/workflows/macos.yml",
    # ".github/workflows/ubuntu.yml",
    # ".github/workflows/windows.yml",
    # "include/VCMLib/VCMLib.hpp",
    # "Source/VCMLib.cpp",
    # "Standalone/Source/Main.cpp",
    # "Standalone/CMakeLists.txt",
    # "Standalone/LICENSE",
    # "Utilities/CMakeToolChains/aarch64-linux-gnu.cmake",
    # "Utilities/CMakeToolChains/x86_64-unknown-linux-gnu.cmake",
    # "Utilities/CMakeToolChains/x86_64-w64-mingw32.cmake",
    # "Utilities/ConanProfiles/aarch64-linux-gnu",
    # "Utilities/ConanProfiles/x86_64-unknown-linux-gnu",
    # "Utilities/ConanProfiles/x86_64-w64-mingw32",
    # "Utilities/AboutThisFolder.md",
    # ".vscode/c_cpp_properties.json",
    # ".vscode/keybindings.json",
    # ".vscode/launch.json",
    # ".vscode/settings.json",
    # ".vscode/tasks.json",
    # ".clang-format",
    # ".cmake-format",
    # "CMakeLists.txt",
    # "conanfile.py",
    # "conanfile.txt.obsolete",
    # ".gitattributes",
    # ".gitignore",
    # "LICENSE",
    # ".python-version",
    # "README.md",
    # "SolutionController.py",
    # "SolutionRenamer.py"
]

# create backup folder
timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
backup_dir = os.path.join("backup", timestamp)
os.makedirs(backup_dir, exist_ok=True)

def can_update_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        for line in file:
            if "<VCMAKE_NO_UPDATE>" in line:
                return False
    return True

def update_file(file_path):
    url = repo_url + file_path
    response = requests.get(url)
    if response.status_code == 200:
        
        # Move existing file to backup
        backup_path = os.path.join(backup_dir, file_path)
        os.makedirs(os.path.dirname(backup_path), exist_ok=True)
        shutil.move(file_path, backup_path)
        
        # Write updated file
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(response.text)
        print(f"Updated: {file_path}")
    else:
        print(f"Failed to update: {file_path}")

# Main
for file_path in files_to_update:
    if os.path.exists(file_path) and can_update_file(file_path):
        print(f"Updating: {file_path}")
        update_file(file_path)
        print(f"Done: {file_path}")
    else:
        print(f"Skipped: {file_path}")