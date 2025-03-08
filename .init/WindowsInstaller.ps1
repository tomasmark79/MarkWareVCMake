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
choco install --upgrade git curl python vcpkg doxygen.install ccache make cmake ninja llvm msys2 vscode mingw -y --no-progress

# Reload environment variables properly
function Update-Environment {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}
Update-Environment

# Update pip
Write-Output "Upgrading pip..."
python -m pip install --upgrade pip
python -m pip install --upgrade conan clang-tidy clang-format cmake-format gcovr

# Set up conan profile
Write-Output "Setting up Conan profile..."
conan profile detect --force

# Start Visual Studio Code
#Write-Output "Starting Visual Studio Code..."
#code .

Write-Output "Installation completed!"