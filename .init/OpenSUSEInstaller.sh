#!/bin/bash

sudo zypper refresh && sudo zypper update -y
sudo zypper install -y python3-pip curl git libopenssl-devel \
libbz2-devel ncurses-devel gcc-c++ make \
libffi-devel sqlite3-devel xz-devel readline-devel \
tk-devel clang-tools-extra npm gdb mc vim

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
sudo zypper refresh && sudo zypper install -y code

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