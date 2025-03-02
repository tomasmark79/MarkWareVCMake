"""
C++ Project Requirements Initializer
"""

import argparse
import logging
import os
import platform
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Dict, List, Optional

# Constants --------------------------------------------------------------------
PYTHON_VERSION = "3.12.8"
SETUP_CPP_VERSION = "1.1.0"

PACKAGE_MANAGERS: Dict[str, Dict[str, List[str]]] = {
    "Linux": {
        "system": [
            "git", "nodejs", "npm", "python3", "python3-pip", "curl", 
            "pipx", "gdb"
        ]
    },
    "Darwin": {
        "brew": [
            "git", "node", "python", "curl", "gnu-sed", "libffi", "sqlite",
            "xz", "readline", "tk", "openssl", "bzip2", "gdb"
        ]
    },
    "Windows": {
        "choco": ["git", "nodejs", "python3", "curl", "gdb"]
    }
}

# Helpers ---------------------------------------------------------------------
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[logging.StreamHandler()]
)
logger = logging.getLogger(__name__)


class OSType:
    LINUX = "Linux"
    MACOS = "Darwin"
    WINDOWS = "Windows"

    @classmethod
    def current(cls) -> str:
        return platform.system()

    @classmethod
    def is_windows(cls) -> bool:
        return cls.current() == cls.WINDOWS

def run_command(
    command: List[str],
    shell: bool = False,
    check: bool = True,
    cwd: Optional[Path] = None,
    env: Optional[Dict[str, str]] = None
) -> subprocess.CompletedProcess:
    """Error handling"""
    logger.info("Executing: %s", " ".join(command))
    
    env = env or os.environ.copy()
    if OSType.is_windows():
        env["PATH"] = f"{os.environ['PATH']};{str(Path.home() / '.pyenv' / 'pyenv-win' / 'bin')}"
    
    try:
        return subprocess.run(
            command,
            shell=shell,
            check=check,
            cwd=cwd,
            env=env,
            capture_output=True,
            text=True
        )
    except subprocess.CalledProcessError as e:
        logger.error("Command failed: %s\nSTDOUT: %s\nSTDERR: %s",
                     e.cmd, e.stdout, e.stderr)
        raise

# System setup components -----------------------------------------------------
class SystemSetup:
    """Handle OS-specific package management"""
    
    @staticmethod
    def install_system_packages() -> None:
        """Install platform-specific system packages"""
        current_os = OSType.current()
        
        if current_os == OSType.LINUX:
            logger.info("Installing Linux system packages...")
            run_command(["sudo", "apt-get", "update", "-qq"])
            run_command(["sudo", "apt-get", "install", "-y", "--no-install-recommends"] + PACKAGE_MANAGERS[current_os]["system"])
            
        elif current_os == OSType.MACOS:
            logger.info("Installing macOS system packages...")
            if not shutil.which("brew"):
                run_command('curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash', shell=True)
            run_command(["brew", "install"] + PACKAGE_MANAGERS[current_os]["brew"])
            
        elif current_os == OSType.WINDOWS:
            logger.info("Installing Windows system packages...")
            if not shutil.which("choco"):
                ps_command = 'Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString(\'https://chocolatey.org/install.ps1\'))'
                run_command(['powershell', '-Command', ps_command], shell=True)
            run_command(["choco", "install", "-y"] + PACKAGE_MANAGERS[current_os]["choco"])

class DevelopmentEnvironment:
    """Configure development tools and environments"""
    
    @staticmethod
    def setup_cpp() -> None:
        """Configure C++ development tools using setup-cpp"""
        logger.info("Setting up C++ toolchain...")
        if OSType.is_windows():
            # Windows doesn't use sudo
            run_command(["npm", "install", "-g", f"setup-cpp@{SETUP_CPP_VERSION}"])
        else:
            run_command(["sudo", "npm", "install", "-g", f"setup-cpp@{SETUP_CPP_VERSION}"])
        
        setup_command = [
            "setup-cpp",
            "--nala", "false",
            "--compiler", "llvm",
            "--cmake", "true",
            "--ninja", "true",
            "--task", "true",
            "--vcpkg", "true",
            "--conan", "true",
            "--make", "true",
            "--clang-tidy", "true",
            "--clang-format", "true",
            "--cppcheck", "true",
            "--cpplint", "true",
            "--cmakelang", "true",
            "--cmake-format", "true",
            "--cmake-lint", "true",
            "--gcovr", "true",
            "--doxygen", "true",
            "--ccache", "true"
        ]
        run_command(setup_command)

        run_command(["conan", "profile", "detect", "--force"])
        run_command(["npm", "cache", "clean", "--force"])

    @staticmethod
    def install_vscode() -> None:
        """Install the latest version of Visual Studio Code"""
        logger.info("Installing Visual Studio Code...")
        
        current_os = OSType.current()
        
        if current_os == OSType.LINUX:
            # Install VSCode on Linux using the official Microsoft repository
            try:
                # Import Microsoft's GPG key
                run_command([
                    "curl", "-sSL", "https://packages.microsoft.com/keys/microsoft.asc",
                    "-o", "/tmp/microsoft.asc"
                ])
                run_command([
                    "sudo", "gpg", "--dearmor", "-o", "/usr/share/keyrings/microsoft-archive-keyring.gpg",
                    "/tmp/microsoft.asc"
                ])
                
                # Add the VS Code repository
                sources_file = "/etc/apt/sources.list.d/vscode.list"
                if not os.path.exists(sources_file):
                    source_line = "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/code stable main"
                    run_command([
                        "sudo", "bash", "-c", f"echo '{source_line}' > {sources_file}"
                    ])
                
                # Update apt and install VS Code
                run_command(["sudo", "apt-get", "update"])
                run_command(["sudo", "apt-get", "install", "-y", "code"])
                
                logger.info("VS Code has been installed successfully")
            except subprocess.CalledProcessError as e:
                logger.error("Failed to install VS Code: %s", str(e))
                
        elif current_os == OSType.MACOS:
            # Install VS Code on macOS using Homebrew
            try:
                run_command(["brew", "install", "--cask", "visual-studio-code"])
                logger.info("VS Code has been installed successfully")
            except subprocess.CalledProcessError as e:
                logger.error("Failed to install VS Code: %s", str(e))
                
        elif current_os == OSType.WINDOWS:
            # Install VS Code on Windows using Chocolatey
            try:
                run_command(["choco", "install", "-y", "vscode"])
                logger.info("VS Code has been installed successfully")
            except subprocess.CalledProcessError as e:
                logger.error("Failed to install VS Code: %s", str(e))


def main() -> int:
    """Main setup workflow"""
    parser = argparse.ArgumentParser(description="Cross-platform development environment setup")
    parser.add_argument("--dry-run", action="store_true", help="Validate without making changes")
    parser.add_argument("--skip-vscode", action="store_true", help="Skip VS Code installation")
    args = parser.parse_args()
    
    if args.dry_run:
        logger.info("Dry run mode enabled - no changes will be made")
        return 0
    
    try:
        SystemSetup.install_system_packages()

        run_command(["pipx", "ensurepath"])

        DevelopmentEnvironment.setup_cpp()
        
        if not args.skip_vscode:
            DevelopmentEnvironment.install_vscode()

        #if OSType.current() == OSType.LINUX:
        #    run_command(["rm", "-rf", "/tmp/*"])
        
        logger.info("Environment setup completed successfully")
        return 0
        
    except subprocess.CalledProcessError as e:
        logger.error("Setup failed during command: %s", e.cmd)
        return 1
    except Exception as e:
        logger.error("Unexpected error: %s", str(e))
        return 2

if __name__ == "__main__":
    sys.exit(main())