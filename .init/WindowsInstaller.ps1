#Requires -Version 5.1

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

    # Install Chocolatey if not already installed
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
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

    # Install required packages
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
    
    # Install setup-cpp
    Write-Status "Installing setup-cpp..."
    try {
        npm install -g setup-cpp@1.1.0
    }
    catch {
        Handle-Error "Failed to install setup-cpp: $_"
    }

    Write-Status "Running setup-cpp..."
    setup-cpp --nala false --compiler llvm --cmake true --ninja true --task true --vcpkg true --conan true --make true --clang-tidy true --clang-format true --cppcheck true --cpplint true --cmakelang true --cmake-format true --cmake-lint --gcovr true --doxygen true --ccache true

    # Install pyenv-win
    Write-Status "Installing pyenv-win..."
    $python_version = "3.12.0"  # Using a version that is more likely to be supported
    
    try {
        curl -o pyenv-win.zip -L https://github.com/pyenv-win/pyenv-win/archive/master.zip
        Expand-Archive -Path pyenv-win.zip -DestinationPath "$env:USERPROFILE\.pyenv" -Force
        $env:PYENV_ROOT = "$env:USERPROFILE\.pyenv\pyenv-win-master"
        
        # Set PATH permanently for user
        $currentUserPath = [Environment]::GetEnvironmentVariable("Path", "User")
        $pyenvPaths = "$env:PYENV_ROOT\bin;$env:PYENV_ROOT\shims"
        
        if ($currentUserPath -notlike "*$pyenvPaths*") {
            [Environment]::SetEnvironmentVariable("Path", "$currentUserPath;$pyenvPaths", "User")
        }
        
        # Set PYENV_ROOT permanently
        [Environment]::SetEnvironmentVariable("PYENV_ROOT", $env:PYENV_ROOT, "User")
        
        # Update current session PATH
        $env:Path += ";$env:PYENV_ROOT\bin;$env:PYENV_ROOT\shims"
        
        # Install Python with pyenv
        Write-Status "Installing Python $python_version with pyenv-win..."
        pyenv install $python_version
        
        # Note: pyenv-win doesn't support virtualenv directly like Linux pyenv
        # Use pip to create a virtual environment instead
        Write-Status "Setting up Python environment..."
        pyenv global $python_version
        pip install virtualenv
        
        # Create directory for virtual environment
        New-Item -Path "$env:PYENV_ROOT\versions\$python_version\envs" -ItemType Directory -Force
        Set-Location -Path "$env:PYENV_ROOT\versions\$python_version\envs"
        python -m virtualenv env
        
        # Set global Python to use the virtual environment
        # Using backslash for Windows paths
        pyenv global "$python_version\envs\env"
    }
    catch {
        Handle-Error "Failed to set up Python environment: $_"
    }

    # Clean up
    Write-Status "Cleaning up..."
    Remove-Item -Path pyenv-win.zip -Force -ErrorAction SilentlyContinue
    
    Write-Status "Installation completed successfully!"
    Write-Status "Please restart your terminal or run 'refreshenv' to apply all changes."
}
catch {
    Handle-Error "An unexpected error occurred: $_"
}