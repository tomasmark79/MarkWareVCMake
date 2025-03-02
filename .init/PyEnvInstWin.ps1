#Requires -Version 5.1

# Enable TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

choco install -y git python nodejs curl

# I just like pipx
python -m pip install --user pipx
pipx ensurepath
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "User") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "Machine")

$python_version = "3.13.2"
curl -o pyenv-win.zip -L https://github.com/pyenv-win/pyenv-win/archive/master.zip
Expand-Archive -Path pyenv-win.zip -DestinationPath "$env:USERPROFILE\.pyenv"
$env:PYENV_ROOT = "$env:USERPROFILE\.pyenv\pyenv-win"
$env:Path += ";$env:PYENV_ROOT\bin;$env:PYENV_ROOT\shims"
pyenv install $python_version
pyenv virtualenv $python_version env
pyenv global "$python_version/env"