# MarkWare VCMake Template

### Modern, Configurable Project Template for C and C++

Author: **Tomáš Mark**  
Version: **0.0.9**

[![Ubuntu](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/ubuntu.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/ubuntu.yml)
[![MacOS](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/macos.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/macos.yml)
[![Windows](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/windows.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/windows.yml)
[![Install](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/install.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/install.yml)
---

<img width="189" alt="image" src="https://github.com/user-attachments/assets/df0f7209-aaec-4c51-a434-4455344e0d57" />

---

## Introduction

🌟🌟🌟  

The **MarkWare VCMake Template** provides a modern solution for C and C++ development by combining **application** and **library** workflows within a single configurable template. Designed for developers who value efficiency and modern tools, it simplifies project initialization while adhering to industry best practices. Built with **Modern CMake**, **Conan 2**, and **VSCode** integration, this template is an essential starting point for your next project.  

🌟🌟🌟

---

## Key Features

✨✨✨  
- **Quick Start**: Minimal setup required, ready to use immediately after cloning.  
- **Modern Standards**: Supports best practices for C and C++ development.  
- **Native Debugging**: Step-by-step debugging directly on Linux.  
- **Cross-Platform**: Runs on Linux 🐧, macOS 🍏, and Windows 🪟 (via WSL).  
- **Cross-Compilation**: Easily target multiple architectures.  
- **Highly Customizable**: Modular structure tailored to your specific project needs.  

✨✨✨

---

## Integrated Tools and Configurations

### Development Tools

🌐🌐🌐  

- **Visual Studio Code**: Preconfigured for seamless development.  
  [https://code.visualstudio.com/](https://code.visualstudio.com/)
- **Conan 2**: Simplifies dependency management.  
  [https://docs.conan.io](https://docs.conan.io)
- **Modern CMake**: Advanced configuration and build management.  
  [https://cmake.org/download/](https://cmake.org/download/)
- **Python 3**: Integrated for scripting and automation.  
  [https://www.python.org/downloads/](https://www.python.org/downloads/)
- **Pyenv**: Simplifies Python version management.  
  [https://github.com/pyenv/pyenv](https://github.com/pyenv/pyenv)
- **CPM.cmake**: Lightweight dependency management.  
  [https://github.com/cpm-cmake/CPM.cmake](https://github.com/cpm-cmake/CPM.cmake)  

🌐🌐🌐

### Additional Integrations

🔧🔧🔧  

- **CPM.license**: Automates third-party license management.  
  [https://github.com/cpm-cmake/CPMLicenses.cmake](https://github.com/cpm-cmake/CPMLicenses.cmake)
- **ModernCppStarter**: Inspired by industry best practices for initializing C++ projects.  
  [https://github.com/TheLartians/ModernCppStarter](https://github.com/TheLartians/ModernCppStarter)
- **Formatters**: Preconfigured for consistent code formatting.  
  - [Clang Format](https://clang.llvm.org/docs/ClangFormat.html)  
  - [CMake Format](https://cmake-format.readthedocs.io/en/latest/) 
   
🔧🔧🔧

### Conan 2 Notice

- In the freshly cloned default template, **Conan is not required**. You may uncomment the Conan dependency examples in marked locations to activate using Conan by template workflow.  
- If you invoke the Conan task in the task menu, Conan will be part of the project configuration even if it does not explicitly provide dependency packages to the configuration.
  
---

## Development Environment Setup

### Linux and macOS

🛠️🛠️🛠️  
1. Update system packages:
   ```bash
   sudo apt update && sudo apt upgrade -y
   sudo apt install cmake python3-pip curl git libssl-dev \
   libbz2-dev libcurses-ocaml-dev build-essential gdb libffi-dev \
   libsqlite3-dev liblzma-dev libreadline-dev libtk-img-dev
   ```
2. Install and configure **Pyenv**:
   ```bash
   curl https://pyenv.run | bash
   pyenv install 3.9.2
   pyenv virtualenv 3.9.2 env392
   pip install --upgrade pip
   ```
3. Install **Conan**:
   ```bash
   pip install conan
   conan profile detect --force
   ```  



🛠️🛠️🛠️

### Windows (via WSL)

🔑🔑🔑  
1. Enable WSL and install Debian:
   ```powershell
   wsl --install
   wsl --list --online
   wsl --install Debian
   wsl --set-default-version 2
   shutdown /r
   ```
2. Install required VSCode extensions:
   - `ms-vscode-remote.remote-wsl`
   - `ms-vscode.cpptools`
3. Connect to WSL and open the project in VSCode.
   ```bash
   code .
   ```  
🔑🔑🔑

---

## Quick Start

🚀🚀🚀  
1. Clone the template:
   ```bash
   git clone https://github.com/tomasmark79/MarkWareVCMake ./MyAwesomeProject
   cd MyAwesomeProject/
   ```
2. Rename components:
   ```bash
   ./SolutionRenamer.sh VCMLib MyLibrary VCMStandalone MyStandalone
   ```
3. Open the project in VSCode:
   ```bash
   code .
   ```

From this point, you have a fully functional solution for developing Linux binaries, regardless of the host platform. 
 
🚀🚀🚀

## configuration and build via cli

Library
```bash
cmake -S . -B Build/Library/Debug -DCMAKE_BUILD_TYPE=Debug
cmake --build Build/Library/Debug --target all
```

Standalone with Library
```bash
cmake -S ./Standalone -B Build/Standalone/Debug -DCMAKE_BUILD_TYPE=Debug
cmake --build Build/Standalone/Debug --target all
```

---

## Preconfigured Architectures

🌍🌍🌍  

- `x86_64-linux-gnu` (default native Linux profile)  
- `x86_64-unknown-linux-gnu` (requires cross-compilation toolchain)  
- `aarch64-linux-gnu` (requires cross-compilation toolchain)  
- `x86_64-w64-mingw32` (requires cross-compilation toolchain)  

🌍🌍🌍

---

## Build Types

🏗️🏗️🏗️  
- `Debug`
- `Release`
- `RelWithDebInfo`
- `MinSizeRel`  

🏗️🏗️🏗️

---

## Project Structure

📂📂📂  

```tree  
.
├── cmake
│   ├── Modules
│   │   └── FindX11.cmake
│   ├── CPM.cmake
│   └── tools.cmake
├── include
│   └── VCMLib
│       └── VCMLib.hpp
├── Source
│   └── VCMLib.cpp
├── Standalone
│   ├── Source
│   │   └── Main.cpp
│   ├── CMakeLists.txt
│   └── LICENSE
├── Utilities
│   ├── CMakeToolChains
│   │   ├── aarch64-linux-gnu.cmake
│   │   └── x86_64-w64-mingw32.cmake
│   ├── ConanProfiles
│   │   ├── aarch64-linux-gnu
│   │   ├── default
│   │   └── x86_64-w64-mingw32
│   ├── ConanPythonConfigurer
│   │   └── conanfile.py
│   └── AboutThisFolder.md
├── .vscode
│   ├── c_cpp_properties.json
│   ├── keybindings.json
│   ├── launch.json
│   ├── settings.json
│   └── tasks.json
├── .clang-format
├── .cmake-format
├── CMakeLists.txt
├── conanfile.txt
├── .gitattributes
├── .gitignore
├── LICENSE
├── .python-version
├── README.md
├── SolutionController.sh
└── SolutionRenamer.sh
```  

📂📂📂

---

## Implemented VSCode Tasks

### Task Menu (Shift + F7)  

🛠️🛠️🛠️  

| Task Menu             | Description                             |
|-----------------------|-----------------------------------------|
| **Zero to Hero**      | Clean → Conan → Configure → Build       |
| **Clean**             | Removes the entire build folder         |
| **Conan**             | Builds Conan dependencies               |
| **Configure**         | Configures CMake                        |
| **Build**             | Builds the project                      |
| **Collect Licenses**  | Gathers licenses from CPM dependencies  |
| **Install Artefacts** | Installs to `/Build/Installed/`         |
| **Release Artefacts** | Tarballs to `/Build/Artefacts/`         |
| **Lint C/C++**        | C/C++ files diagnostics                 |
| **Format C/C++**      | Recursive formatting for C/C++ files    | 
| **Format CMake**      | Recursive formatting for CMake files    |

| Special Task Menu     | Description                              |
|-----------------------|------------------------------------------|
| **Permutate All Tasks**  | Executes all task scenarios           |

### Key Shortcuts

- **F5**: Start debugging.
- **F7**: Build native debug configuration.
- **Shift + F7**: Task Menu
- **Shift + Ctrl + S**: Special Task Menu
- **Ctrl + Alt + M**: Format all CMake files.
- **Ctrl + Alt + F**: Format all C++ files.
- **Ctrl + Alt + L**: Lint all C++ files.
- **Ctrl + Shift + Alt + B**: Run ShellCheck on bash scripts.  

🛠️🛠️🛠️

---

### Comparison Overview to Similar Templates
|                                             | MarkWareVCMake                         | ModernCppStarter | cmake_template                    |
|---------------------------------------------|----------------------------------------|------------------|-----------------|
| Minimal setup required                      | yes                                    | yes              | yes             |
| Supports best practices + Modern CMake      | yes                                    | yes              | yes             |
| Stanadlone->Library concept                 | yes                                    | yes              | yes             |
| Highly Customizable                         | yes                                    | yes              | yes             |
| Github workflow with badges                 | yes                                    | yes              | not sure        |
| Dependency solution CPM.cmake integrated    | yes                                    | author           | no              |
| CPM.license integrated                      | yes                                    | author           | no              |
| CPM.tools integrated                        | yes                                    | author           | no              |
| LintC, clang-format, cmake-format           | VSCode Tasks + shortcuts + cli         | only cli         | no              |
| Solution Renamer                            | yes                                    | no               | no              |
| Dependency solution by Conan                | yes, wrapped by tasks in VSCode        | no               | no              |
| CMake generators by Conan preconfigured     | yes                                    | no               | no              |
| Cross-Compilation preconfigured             | yes, require toolchain                 | no               | no              |
| Cross-Compilation targets preconfigured     | linux, windows, raspberry pi 4/5       | no               | no              |
| VSCode CMake controller                     | yes                                    | no               | no              |
| VSCode Tasks via Menu and Shortcuts         | yes                                    | no               | no              |
| Clean                                       | Removes the entire build folder        | no               | no              |
| Conan                                       | Builds Conan dependencies              | no               | no              |
| Configure                                   | Configures CMake                       | no               | no              |
| Build                                       | Builds the project                     | no               | no              |
| Collect Licenses                            | Gathers licenses from CPM dependencies | no               | no              |
| Install Artefacts                           | Installs to /Build/Installed/          | no               | no              |
| Release Artefacts                           | Tarballs to /Build/Artefacts/          | no               | no              |
| Lint C/C++                                  | C/C++ files diagnostics                | only cli         | no              |
| Format C/C++                                | Recursive formatting for C/C++ files   | only cli         | no              |
| Format CMake                                | Recursive formatting for CMake files   | only cli         | no              |
| Permutate All Tasks                         | Executes all task scenarios (testing)  | no               | no              |
| Loging runned commands                      | yes, to file                           | no               | no              |
| C/C++ tests                                 | not yet                                | yes              | yes             |
| Doxygen                                     | not yet                                | yes              | no              |


## License

This template is licensed under MIT License.  
