# Run as administrator check
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Please run as Administrator!"
    exit
}

# Install Chocolatey if not installed
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Output "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    # Reload environment variables
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Install First available packages for Windows from Chocolatey
Write-Output "Installing basic development tools..."
choco install --upgrade git curl python vcpkg doxygen.install ccache llvm vscode -y --no-progress

# Reload environment variables properly
function Update-Environment {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}
Update-Environment

# # Install PyEnv for Windows
# Write-Output "Installing PyEnv for Windows..."
# Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./install-pyenv-win.ps1"; &"./install-pyenv-win.ps1"
# Update-Environment

# # Install Python 3.12.8 with PyEnv
# Write-Output "Installing Python 3.12.8 via PyEnv..."
# pyenv install 3.12.8
# pyenv global 3.12.8

# # Create a virtual environment
# Write-Output "Creating a virtual environment..."
# python -m venv .venv
# .venv\Scripts\Activate.ps1

# Update pip
Write-Output "Upgrading pip..."
python -m pip install --upgrade pip
python -m pip install --upgrade cmake ninja task conan make clang-tidy clang-format cppcheck cpplint cmake-language-server cmake-format gcovr

# Set up conan profile
Write-Output "Setting up Conan profile..."
conan profile detect --force

# Start Visual Studio Code
#Write-Output "Starting Visual Studio Code..."
#code .

Write-Output "Installation completed!"