# MarkWare VCMake

[![Ubuntu](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/ubuntu.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/ubuntu.yml)
[![MacOS](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/macos.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/macos.yml)
[![Windows](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/windows.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/windows.yml)  

## Overview

MarkWare VCMake is a comprehensive, modern C++ project template designed for cross-platform development in Visual Studio Code. The template provides a robust foundation for both standalone executables and libraries, incorporating industry best practices and modern build tools.

To safely use this template, you need to have at least intermediate knowledge in software development and be familiar with the technologies that the template uses.

### Video Tutorial
Introducing a multiplatform project template for modern development in C++ directly from the author.  
Very intensive Audio Language Czech.  

English subtitles via YouTube transcript.
https://www.youtube.com/watch?v=6IOuiS095dQ  
  
### Key Features

- Cross-platform usibility (Linux, macOS, Windows)
- Cross-compile compatibility
- Conan compatibility 
- Integrated build system with CMake
- Automated VSCode tasks
- Advanced debugging capabilities
- Sanitizer, Analyzing and Hardening support
- SSH and WSL compatibility

## System Requirements

### Essential Tools

- **Visual Studio Code** with C++ extension
- **Python 3** (managed via Pyenv)
- **Conan 2** for dependency management
- **CMake** (latest version 3 recommended)
- **Code Formatters**:
  - Clang Format
  - CMake Format
- **Code analyzing**:
  - Clang Tidy

### Integrated Technologies

- GitHub Actions workflows for continuous integration
- Modern CMake Library/Standalone CMakeLists.txt configuration
- ModernCppStarter ideas with CPM.cmake for lightweight dependency management
- CPM.license for license management
- Simple logger class

## Getting Started

### Installation Steps

#### Debian based Linux setup

```bash

# Update system packages
sudo apt update && sudo apt upgrade -y

# Install essentials packages for development
sudo apt install python3-pip curl git libssl-dev libbz2-dev \
libcurses-ocaml-dev build-essential gdb libffi-dev libsqlite3-dev \
liblzma-dev libreadline-dev libtk-img-dev

# Install clang-format
sudo apt install clang-format-[version]

# Install clang-tidy
sudo apt install clang-tidy-[version]

# Install CMake
wget https://github.com/Kitware/CMake/releases/download/v3.31.5/cmake-3.31.5-linux-x86_64.sh && chmod +x cmake-3.31.5-linux-x86_64.sh && sudo ./cmake-3.31.5-linux-x86_64.sh --prefix=/usr/local

# Install PyEnv
curl https://pyenv.run | bash
pyenv install 3.9.2
pyenv virtualenv 3.9.2 env392
pyenv global 3.9.2
pip install --upgrade pip

# Install Conan
pip install conan

# Install cmake-format
pip install cmake-format


# Create default conan profile
conan profile detect --force

```

#### MacOS setup

Essentially, it uses the same steps as those used for Linux.

#### Windows Setup

Native Windows:

```powershell
# Install PyEnv
[Follow Pyenv-win installation guide]
pyenv install 3.9.2
pyenv global 3.9.2
pip install --upgrade pip

# Install Conan packaging system
pip install conan

# Create default conan profile
conan profile detect --force
```

WSL Setup (optional):
```powershell
wsl --install
wsl --install Debian
wsl --set-default-version 2
```

### Project Setup

1. Clone the repository:
```bash
git clone https://github.com/tomasmark79/MarkWareVCMake
cd MarkWareVCMake/
```

2. Optional: Customize project names:
```bash
python SolutionRenamer.py VCMLib MyLibrary VCMStandalone MyStandalone
```

3. Launch VSCode and configure shortcuts:
```bash
code .
```

## Development Workflow

### Keyboard Shortcuts

- `Shift+F7`: show user-friendly `Task Menu`  
- `F7`: 🔨 Quick build Standalone  
- `F5`: 🪲 Quick debug Standalone  
- `Ctrl+Alt+R`: just Launch Standalone binary  
- `Ctrl+Alt+L`: 🔍 clang-tidy
- `Ctrl+Alt+F`: 📐 clang-format  
- `Ctrl+Alt+M`: 📏 cmake-format  
- `Ctrl+Alt+S`: show user-friendly `Special Menu`  

### Build Configuration

- Supports multiple build types: Debug, Release, RelWithDebInfo, MinSizeRel  
- Configurable CMake options for:  
  - Various sanitizer, IPO, Hardening compiler options   
  - Shared/static libraries  
  - Static runtime linking  
  - CCache options  
  
### Cross-Compilation Support

The template includes preconfigured menu items for:  
- x86_64-clang-linux-gnu  
- x86_64-w64-mingw32  
- aarch64-linux-gnu  

May be `added/edited` in `tasks.json` and `SolutionController.py` files.

## Additional Features

### Automatic Tasks

The `user-friendly Task Menu` includes the following automation commands:

- 🧹 Clean build directories  
- 🗡️ Dependency installation with Conan 2  
- 🔧 CMake configuration (F5)
- 🪲 CMake configuration with CMake 🦉 debugger  
- 🔨 Build (Re-Build F7)  
- 📜 License collection with CPM for CPM  
- 📌 Install artefacts  
- 🗜️ Release tarballs  
- 🛸 Run CPack  
- 📊 Conan dependencies in graph.html  
- 🔍 clang-tidy  
- 📐📏 formatting   

### Project Maintenance

- Solution renaming utility with python script `SolutionRenamer.py`  
- Automatic upgrade functionality with pyton script `SolutionUpgrader.py`  
- Comprehensive logging system `Solution.log`  
- Solution controller is a driver that connects the functioning of tasks, invoking tools like conan, cmake, and some others. `SolutionController.py` runs automatically through tasks in VSCode.

### Resources
  VSCode - https://code.visualstudio.com/download  
  Conan hub - https://conan.io/center  
  CMake - https://cmake.org/download/  
  clang-tidy - https://clang.llvm.org/extra/clang-tidy/  
  clang-format - https://clang.llvm.org/docs/ClangFormat.html  
  clang-format - https://clang-format-configurator.site  
  cmake-format - https://cmake-format.readthedocs.io/en/latest/

### Thanks

To everyone who supported me in creating this template. These are various people and information from the web. Of course, also literature and courses that I have taken in the past. Various Discord servers and individuals who took a moment to make an indelible mark on this amazing work for me. Thank you very much!

## License

This project is licensed under the MIT License. No warranty of functionality or liability is provided. If you use this project, please mention my credentials. If you need software and technical support, you can contact me via the contacts listed on the digitalspace.name website.
