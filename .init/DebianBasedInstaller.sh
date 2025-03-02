#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install python3-pip curl git libssl-dev \
libbz2-dev libcurses-ocaml-dev build-essential \
libffi-dev libsqlite3-dev liblzma-dev libreadline-dev \
libtk-img-dev clang-format clang-tidy npm gdb mc vim -y

# PyEnv
curl https://pyenv.run | bash
pyenv install 3.12.8
pyenv virtualenv 3.12.8 env3128
pyenv global 3.12.8
pip install --upgrade pip

# Download and install Visual Studio Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update && sudo apt install -y code

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
cd MarkWareVCMake/

# Start Visual Studio Code
code .