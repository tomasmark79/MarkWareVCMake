#!/bin/bash
# Script to install pyenv and set up a Python environment
# Usage: bash pyEnvInstaller.sh [PYTHON_VERSION]
#   PYTHON_VERSION: Python version to install (default: 3.9.2)

# ubuntu 22.04 tested

set -e  # Exit immediately if a command exits with a non-zero status

# MIT License
# Copyright (c) 2024-2025 Tomáš Mark

# Set default Python version
PYTHON_VERSION=${1:-3.9.2}
LOG_FILE="/tmp/pyenv_install_$(date +%Y%m%d%H%M%S).log"

echo "=== Python Environment Setup ==="
echo "Installing for Python version $PYTHON_VERSION"
echo "Full log available at $LOG_FILE"

# Helper functions
log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"; }
error() { log "ERROR: $*"; exit 1; }

log "Installing required dependencies..."

# Install dependencies based on OS
if command -v apt-get &> /dev/null; then
    log "Debian/Ubuntu system detected"
    sudo apt-get update -qq &>> "$LOG_FILE" || error "Failed to update package lists"
    sudo apt-get install -y --no-install-recommends \
        curl git libssl-dev libbz2-dev libreadline-dev \
        libsqlite3-dev build-essential zlib1g-dev \
        libffi-dev liblzma-dev tk-dev &>> "$LOG_FILE" || error "Failed to install dependencies"
elif command -v dnf &> /dev/null; then
    log "Fedora/RHEL system detected"
    sudo dnf install -y curl git openssl-devel bzip2-devel readline-devel \
        sqlite-devel zlib-devel libffi-devel xz-devel tk-devel &>> "$LOG_FILE" || error "Failed to install dependencies"
elif command -v brew &> /dev/null; then
    log "macOS system detected"
    brew install openssl readline sqlite3 xz zlib tcl-tk &>> "$LOG_FILE" || error "Failed to install dependencies"
else
    error "Unsupported package manager. Please install dependencies manually."
fi

log "Installing pyenv..."
curl -s https://pyenv.run | bash &>> "$LOG_FILE" || error "Failed to install pyenv"

# Check if pyenv is already installed
if command -v pyenv &>/dev/null; then
    log "pyenv is already installed, updating..."
    pyenv update &>> "$LOG_FILE" || log "pyenv update failed, continuing with existing installation"
fi


# Detect shell and configure appropriate RC file
SHELL_RC=""
if [[ -n "$ZSH_VERSION" ]]; then
    SHELL_RC="$HOME/.zshrc"
elif [[ -n "$BASH_VERSION" ]]; then
    SHELL_RC="$HOME/.bashrc"
else
    SHELL_RC="$HOME/.bashrc"  # Default to bashrc
fi

log "Configuring shell environment in $SHELL_RC"

# Add to shell RC file if not already present
add_to_shell_rc() {
    if ! grep -q "$1" "$SHELL_RC"; then
        echo "$1" >> "$SHELL_RC"
        log "Added to $SHELL_RC: $1"
    fi
}

add_to_shell_rc 'export PYENV_ROOT="$HOME/.pyenv"'
add_to_shell_rc '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"'
add_to_shell_rc 'eval "$(pyenv init --path)"'
add_to_shell_rc 'eval "$(pyenv virtualenv-init -)"'

# Load pyenv into current shell
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

# Install Python version if not already installed
if ! pyenv versions | grep -q "$PYTHON_VERSION"; then
    log "Installing Python $PYTHON_VERSION (this may take a few minutes)..."
    pyenv install "$PYTHON_VERSION" &>> "$LOG_FILE" || error "Failed to install Python $PYTHON_VERSION"
else
    log "Python $PYTHON_VERSION is already installed"
fi

# Create and activate virtualenv
ENV_NAME="env${PYTHON_VERSION//./}"
if ! pyenv virtualenvs | grep -q "$ENV_NAME"; then
    log "Creating virtualenv $ENV_NAME..."
    pyenv virtualenv "$PYTHON_VERSION" "$ENV_NAME" &>> "$LOG_FILE" || error "Failed to create virtualenv"
else
    log "Virtualenv $ENV_NAME already exists"
fi

# Set as global Python
log "Setting $PYTHON_VERSION as global Python version..."
pyenv global "$PYTHON_VERSION" &>> "$LOG_FILE" || error "Failed to set global Python version"

# Update pip
log "Updating pip..."
if command -v pipx &>/dev/null; then
    pipx install --upgrade pip &>> "$LOG_FILE" || log "Failed to upgrade pip with pipx, trying with Python directly"
else
    python -m pip install --upgrade pip &>> "$LOG_FILE" || log "Failed to upgrade pip"
fi

log "Python environment setup complete!"
log "To activate in new shell, run: source $SHELL_RC"
log "To use virtualenv, run: pyenv activate $ENV_NAME"