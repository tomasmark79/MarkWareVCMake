#####################################################################
# Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process 
#####################################################################

function Update-Environment {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Run as administrator check
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Please run as Administrator!"
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    exit
}

# Install Chocolatey if not installed
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Output "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Update-Environment
}

# Install development packages for Windows from Chocolatey
Write-Output "Installing basic development tools..."
choco install --yes --no-progress git curl python vcpkg doxygen.install ccache make cmake ninja llvm msys2 vscode mingw

# Refresh environment variables after installation
Update-Environment

# Update pip and install Python dependencies
Write-Output "Upgrading pip and installing Python dependencies..."
try {
    python -m pip install --upgrade pip
    python -m pip install --upgrade conan clang-tidy clang-format cmake-format gcovr
} catch {
    Write-Warning "Error installing Python packages: $_"
    Write-Output "You may need to manually install Python dependencies after restart."
}

# Set up conan profile
Write-Output "Setting up Conan profile..."
try {
    conan profile detect --force
} catch {
    Write-Warning "Error setting up Conan profile: $_"
    Write-Output "You may need to manually set up Conan profile after installation."
}

Write-Output "Installation completed!"
Write-Output "You may need to restart your computer for all changes to take effect."