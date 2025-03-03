#Requires -Version 5.1

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script requires administrative privileges. Please run PowerShell as an administrator." -ForegroundColor Red
    exit 1
}

# Function to display status messages
function Write-Status($message) {
    Write-Host "[INFO] $message" -ForegroundColor Green
}

# Function to handle errors
function Handle-Error($errorMessage) {
    Write-Host "[ERROR] $errorMessage" -ForegroundColor Red
    Write-Host "Installation failed. Please fix the error and try again." -ForegroundColor Red
    exit 1
}

try {
    Write-Status "Enabling TLS 1.2..."
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # Check for Chocolatey and handle existing installation
    $chocoPath = "C:\ProgramData\chocolatey"
    
    if (Test-Path $chocoPath) {
        Write-Status "Chocolatey installation found at $chocoPath"
        
        # Try to ensure Chocolatey is in the PATH
        if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
            Write-Status "Updating PATH to include Chocolatey..."
            $env:Path = "$env:Path;$chocoPath\bin"
            
            # If still not working, repair installation
            if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
                Write-Status "Repairing Chocolatey installation..."
                Set-ExecutionPolicy Bypass -Scope Process -Force
                [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
                try {
                    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
                }
                catch {
                    Handle-Error "Failed to repair Chocolatey: $_"
                }
            }
        }
        
        # Upgrade Chocolatey
        Write-Status "Upgrading Chocolatey..."
        try {
            choco upgrade chocolatey -y
        } catch {
            Write-Status "Chocolatey upgrade failed, continuing with existing version: $_"
        }
    }
    else {
        # Fresh installation
        Write-Status "Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        try {
            iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        }
        catch {
            Handle-Error "Failed to install Chocolatey: $_"
        }
    }

    # Verify Chocolatey is working
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Handle-Error "Unable to access Chocolatey after installation/repair attempts"
    }

    # Rest of the script remains unchanged
    Write-Status "Installing required packages via Chocolatey..."
    try {
        choco install -y git python nodejs curl
        if ($LASTEXITCODE -ne 0) { throw "Chocolatey installation returned error code $LASTEXITCODE" }
    } catch {
        Handle-Error "Failed to install packages via Chocolatey: $_"
    }

    # Install pipx
    Write-Status "Installing pipx..."
    try {
        python -m pip install --user pipx
        pipx ensurepath
    }
    catch {
        Handle-Error "Failed to install pipx: $_"
    }
    
    # Update PATH for current session
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "User") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "Machine")
    
    # Rest of the script continues as before...
    # Install setup-cpp, pyenv-win, etc.
}
catch {
    Handle-Error "An unexpected error occurred: $_"
}