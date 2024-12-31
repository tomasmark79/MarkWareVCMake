import os
import requests
import shutil
from datetime import datetime
import sys
import subprocess

# URL of the repository with the updated files
repo_url = "https://raw.githubusercontent.com/tomasmark79/MarkWareVCMake/refs/heads/main/"

# Double-check function to prevent local file updates even if they are uncommented.
# Add the "<VCMAKE_NO_UPDATE>" directive directly to the file you want to doubly protect.

# No fear - all locally updated files are backed up in the "backup" folder with a timestamp.

# List of files to update - UNCOMMENT the files you want to update or create

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
    # ".gitattributes",
    # ".gitignore",
    # "LICENSE",
    # ".python-version",
    # "README.md",
    # "SolutionController.py",
    # "SolutionRenamer.py",
    "SolutionUpgrade.py"
]

# Create backup folder with a timestamp
timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
backup_dir = os.path.join("backup", timestamp)
os.makedirs(backup_dir, exist_ok=True)

# Function to check if a file can be updated
def can_update_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        for line in file:
            if "<VCMAKE_NO_UPDATE>" in line:
                return False
    return True

# Function to update a file
def update_file(file_path):
    url = repo_url + file_path
    response = requests.get(url)
    if response.status_code == 200:
        if os.path.exists(file_path):
            # Move existing file to backup folder
            backup_path = os.path.join(backup_dir, file_path)
            os.makedirs(os.path.dirname(backup_path), exist_ok=True)
            shutil.move(file_path, backup_path)
        
        # Write updated file
        dir_name = os.path.dirname(file_path)
        if dir_name and not os.path.exists(dir_name):
            os.makedirs(dir_name, exist_ok=True)
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(response.text)
        print(f"Updated: {file_path}")
    else:
        print(f"Failed to update: {file_path}")

# Main script
for file_path in files_to_update:
    if os.path.exists(file_path):
        if can_update_file(file_path):
            print(f"Updating: {file_path}")
            update_file(file_path)
            print(f"Done: {file_path}")
        else:
            print(f"Skipped: {file_path}")
    else:
        print(f"Creating new file: {file_path}")
        update_file(file_path)
        print(f"Created: {file_path}")

# Update the script itself and restart
if "SolutionUpgrade.py" in files_to_update:
    print("Updating SolutionUpgrade.py")
    # Create a temporary copy of the script
    temp_script_path = "SolutionUpgrade_temp.py"
    shutil.copy("SolutionUpgrade.py", temp_script_path)
    update_file("SolutionUpgrade.py")
    print("Restarting script...")
    subprocess.Popen([sys.executable, temp_script_path])
    sys.exit()