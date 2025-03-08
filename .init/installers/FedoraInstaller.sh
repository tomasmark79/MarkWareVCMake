#!/bin/bash

sudo dnf update -y
sudo dnf install python3-pip curl git openssl-devel \
bzip2-devel ncurses-devel make automake gcc gcc-c++ \
libffi-devel sqlite-devel xz-devel readline-devel \
tk-devel clang-tools-extra npm gdb mc vim -y

# PyEnv
curl https://pyenv.run | bash

# Initialize pyenv in current shell
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Now pyenv commands will work
pyenv install 3.13.1
pyenv virtualenv 3.13.1 env3131
pyenv global 3.13.1
pip install --upgrade pip

# Download and install Visual Studio Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo "[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo
sudo dnf install code -y

# Install C++ tools
sudo npm install -g setup-cpp
sudo setup-cpp \
  --compiler llvm \
  --cmake true \
  --ninja true \
  --task true \
  --vcpkg true \
  --conan true \
  --make true \
  --clang-tidy true \
  --clang-format true \
  --cppcheck true \
  --cpplint true \
  --cmakelang true \
  --cmake-format true \
  --gcovr true \
  --doxygen true \
  --ccache true

# activate the c++ tools environment
source ~/.cpprc

# set up conan profile
conan profile detect --force

# Install MarkWareVCMake template
git clone https://github.com/tomasmark79/MarkWareVCMake
cd MarkWareVCMake/ || exit

# Start Visual Studio Code
code .