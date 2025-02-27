# MarkWare VCMake C++ project template

[![Ubuntu](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/ubuntu.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/ubuntu.yml)
[![MacOS](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/macos.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/macos.yml)
[![Windows](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/windows.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/windows.yml)  

## Overview

MarkWare VCMake is a comprehensive, modern C++ project template designed for cross-platform development in Visual Studio Code. The template provides a robust foundation for both standalone executables and libraries, incorporating industry best practices and modern build tools.

"To safely use this template, you need to have at least intermediate knowledge in software development and be familiar with the technologies that the template uses."

### Video Tutorial in native Czech Language  

1. first welcome video  
https://youtu.be/6IOuiS095dQ

1. second welcome video  
https://youtu.be/itUd76yTvQk

English subtitles via YouTube transcription.
  
### Key Features 🎈

- Seamless cross-platform compatibility (Linux, macOS, Windows)
- **Cross-compilation support** for various architectures
- ModernCppStarter ideas
- Modern dependency management with Conan and CPM
- Advanced debugging and profiling capabilities
- Support for sanitizers, static analysis, and hardening
- Compatibility with SSH and Windows Subsystem for Linux (WSL)

### Integrated Technologies 🎈

- Solution Renamer and Upgrader
- Build system using modern CMake
- Automated tasks and shortcuts in VSCode
- C++ Main Standalone project configuration
- C++ Class like library project configuration
- C++ simple singleton logger class
- Conanfile.py dependency template
- CPM.cmake, CPM.PackageProject and CPM.license
- GitHub Actions workflows for continuous integration

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

## Getting Started

### Installation Steps

#### Debian based Linux setup

```bash

# Update system packages
sudo apt update && sudo apt upgrade -y

# Install essentials packages for development
sudo apt install python3-pip curl git libssl-dev libbz2-dev \
libcurses-ocaml-dev build-essential gdb libffi-dev libsqlite3-dev \
liblzma-dev libreadline-dev libtk-img-dev clang-format clang-tidy

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

# Download and install Visual Studio Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update && sudo apt install code

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
python SolutionRenamer.py <OldLibName> <NewLibName> <OldStandaloneName> <NewStandAloneName>
```

3. Launch VSCode and configure shortcuts:
```bash
code .
```

## Development Workflow

### Keyboard Shortcuts

- `Shift+F7`: TASK MENU (standalone, library, both)  
- `F7`: 🔨 Quick build Standalone  
- `F5`: 🪲 Quick debug Standalone  
- `Ctrl+Alt+R`: just Launch Standalone binary  
- `Ctrl+Alt+L`: 🔍 clang-tidy
- `Ctrl+Alt+F`: 📐 clang-format  
- `Ctrl+Alt+M`: 📏 cmake-format 

### Automatic Tasks

By `Shift+F7` invoked **TASK MENU** includes the following automation commands:  

- 🚀 Zero to Build means 🧹 🗡️ 🔧 🔨
- 🦸 Zero to Hero means  🧹 🗡️ 🔧 🔨 📌 🗜️
- 🧹 Clean build directories  
- 🗡️ Dependency installation with Conan 2  
- 🔧 CMake configuration  
- 🪲 CMake configuration with CMake 🦉 debugger  
- 🔨 Build (Re-Build F7)  
- 📜 License collection with CPM for CPM  
- 📌 Install artefacts  
- 🗜️ Release tarballs  
- 🛸 Run CPack  
- 📊 Conan dependencies in graph.html  
- 🔍 clang-tidy  
- 📐📏 formatting  
  
### Build Configuration

- Supports multiple build types hardcoded in `tasks.json`:
  ```txt
  Debug, Release, RelWithDebInfo, MinSizeRel
  ```

- Configurable CMake options for:  
  
  `BUILD_SHARED_LIBS`, `USE_STATIC_RUNTIME`, `SANITIZE_ADDRESS`, `SANITIZE_UNDEFINED`, `SANITIZE_THREAD`, `SANITIZE_MEMORY`, `ENABLE_HARDENING`, `ENABLE_IPO`, `ENABLE_CCACHE`

## Additional Features

### Cross-Compilation Support

The template includes preconfigured menu items. The default Conan profile represents the default value in the buildArch definition. Other profiles can be edited and supplemented according to your existing Conan profiles.

```json
{
    /* ARCH ITEMS */
    "id": "buildArch",
    "type": "pickString",
    "description": "Select target architecture",
    "options": [
        "default", 
        "x86_64-clang-linux-gnu",
        "x86_64-w64-mingw32",
        "aarch64-rpi4-linux-gnu"
    ],
    "default": "default"
}
```

### Project Maintenance

- Solution renaming utility with python script `SolutionRenamer.py`  
- Automatic upgrade functionality with pyton script `SolutionUpgrader.py`  
- `SolutionController.py` is a driver that connects the functioning of tasks, invoking tools like Conan, CMake, and some others.  
- Comprehensive logging system `Solution.log`  

### Project Structure

```txt
MarkWareVCMake/
├── include/
```
Contains public header files (.hpp) intended for use in other projects or modules.

```txt
MarkWareVCMake/
├── src/
```
Contains source files (.cpp) and `internal` header files (.hpp) that are not intended for public use.

## FAQ

`Q:` **Build task error**  
Error: /home/.../Build/Standalone/default/Debug is not a directory  
Error: /home/.../Build/Library/default/Debug is not a directory  
`A:` There is nothing to build. You must first create the configurations for the product, and only then can you compile separately with the build task. The "Zero to Build," "Zero to Hero," or CMake configuration tasks will help you create the configuration, which can then be compiled.

`Q:` **CMake-tidy error**  
Error while trying to load a compilation database: Could not auto-detect compilation database from directory, etc.  
`A:` For static code analysis to work correctly, you need to have the CMake configurations prepared. Also, ensure that the `CMAKE_EXPORT_COMPILE_COMMANDS` variable is set to `ON` in CMakeLists.txt.

## Conventions

To avoid future issues with folder and file names, I have set these rules.

 - **All standard template folders**, including those generated later, **use lowercase letters only**.
 - User-defined folders can contain any combination of uppercase and lowercase letters.
 - All **C** and **C++** files provided in the template will use **CamelCase convention**, including an **uppercase letter at the beginning**.

### Indentation

C/C++ 2 spaces  
Python 4 spaces  

## Resources

VSCode - https://code.visualstudio.com/download  
pyenv - https://github.com/pyenv/pyenv  
Conan hub - https://conan.io/center  
CMake - https://cmake.org/download/  
clang-tidy - https://clang.llvm.org/extra/clang-tidy/  
clang-format - https://clang.llvm.org/docs/ClangFormat.html  
clang-format - https://clang-format-configurator.site  
cmake-format - https://cmake-format.readthedocs.io/en/latest/  

## Thanks

To everyone who supported me in creating this template. These are various people and information from the web. Of course, also literature and courses that I have taken in the past. Various Discord servers and individuals who took a moment to make an indelible mark on this amazing work for me. Thank you very much!  

## License

MIT License
Copyright (c) 2024-2025 Tomáš Mark

This project is licensed under the MIT License. No warranty of functionality or liability is provided. If you use this project, please mention my credentials. If you need software and technical support, you can contact me via the contacts listed on the digitalspace.name website.  
