# MarkWare VCMake Template

### Modern, Configurable Project Template for C and C++

Author: **Tomáš Mark**  
Version: **0.0.15**

[![Ubuntu](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/ubuntu.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/ubuntu.yml)
[![MacOS](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/macos.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/macos.yml)
[![Windows](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/windows.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/windows.yml)
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
- **Native Debugging 🪲**: Allows debugging of your C/C++ code.
- **CMake Configure with Debugger 🪲**: Allows debugging of your own CMake CMakeLists.txt.
- **Cross-Platform**: Runs natively on Linux 🐧, macOS 🍏, and Windows 🪟.
- **Cross-Compilation**: Easily target multiple architectures.  
- **Highly Customizable**: Modular structure tailored to your specific project needs.  
- **Remote Development Ready**: Fully compatible with SSH, WSL, and other remote development environments.

✨✨✨

---

## Integrated Tools and Configurations

### Development Tools

🌐🌐🌐  

- **Visual Studio Code**: Preconfigured for seamless development.  
  [https://code.visualstudio.com/](https://code.visualstudio.com/)
- **Modern CMake**: Advanced configuration and build management.  
  [https://cmake.org/download/](https://cmake.org/download/)
- **Pyenv**: Simplifies Python version management.  
  [https://github.com/pyenv/pyenv](https://github.com/pyenv/pyenv)
- **Python 3**: Integrated for scripting and automation.  
  [https://www.python.org/downloads/](https://www.python.org/downloads/)
- **Conan 2**: Simplifies dependency management.  
  [https://docs.conan.io](https://docs.conan.io)
- **ModernCppStarter**: Inspired by industry best practices for initializing C++ projects.  
  [https://github.com/TheLartians/ModernCppStarter](https://github.com/TheLartians/ModernCppStarter)
- **GitHub Action Workflows**: Actively monitors the source code status across all major platforms.
   [https://github.com/tomasmark79/MarkWareVCMake/actions](https://github.com/tomasmark79/MarkWareVCMake/actions)


🌐🌐🌐

### Additional Integrations

- **CPM.cmake**: Lightweight dependency management as the add-in if neccessary.  
  [https://github.com/cpm-cmake/CPM.cmake](https://github.com/cpm-cmake/CPM.cmake)  
- **CPM.license**: Automates third-party license management.  
  [https://github.com/cpm-cmake/CPMLicenses.cmake](https://github.com/cpm-cmake/CPMLicenses.cmake)
- **Formatters**: Preconfigured for consistent code formatting.  
  - [Clang Format](https://clang.llvm.org/docs/ClangFormat.html)  
  - [CMake Format](https://cmake-format.readthedocs.io/en/latest/) 
   

**Note:**
Combining Conan 2 and CPM.cmake is generally not recommended, but it is not prohibited either. If you approach the dependency management concept with Conan 2 as the primary dependency manager and CPM.cmake as a supplementary dependency manager, everything will be fine. Just make sure to watch out for conflicts.

🗡️🗡️🗡️

---

## Development Environment Setup

⚙️⚙️⚙️

### Linux 🐧 and macOS 🍏


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

### Windows native 🪟

1. Install and configure **Pyenv** for Windows:
   [Powershell Installation Steps](https://github.com/pyenv-win/pyenv-win/blob/master/docs/installation.md#powershell)  
    ```powershell
    pyenv install 3.9.2
    pyenv global 3.9.2
    pyenv local 3.9.2
    pip install --upgrade pip
    ```
3. Install **Conan**:
    ```powershell
    pip install conan
    conan profile detect --force
    ```  

### Windows 🪟 via WSL 🐧

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
3. Connect to WSL and open the project in VSCode
   ```bash
   code .
   ```

---


## Quick Start

🚀🚀🚀  
1. Clone the template:
   ```bash
   git clone https://github.com/tomasmark79/MarkWareVCMake
   cd MarkWareVCMake/
   ```
2. Rename components:
   ```bash
   python SolutionRenamer.py VCMLib MyLibrary VCMStandalone MyStandalone
   ```
3. Open the project in VSCode:
   ```bash
   code .
   ```
4. File SolutionUpgrader.py can update the template files from the repository that you choose. More information inside the script.

From this point, you have a fully functional solution for developing Linux binaries, regardless of the host platform. 
 
🚀🚀🚀

---

git ## Preconfigured Conan toolchain architectures

🌍🌍🌍  

- `Default` (automatic system default compiler toolchain selection)  
- `x86_64-bookworm-linux-gnu` (requires cross-compilation toolchain)  
- `x86_64-w64-mingw32` (requires cross-compilation toolchain)  
- `aarch64-linux-gnu` (requires cross-compilation toolchain)  

It is easy to add a new architecture.

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

## Implemented `VSCode` Tasks

### MarkWare Tasks

| Key binding set to                | ` SHIFT + F7`                                                 |      
| --------------------------------- | ------------------------------------------------------------- |
| **Zero to Hero**                  | Clean → Conan → Configure → Build                             |
| **Zero to Release**               | Clean → Conan → Configure → Build → Install → Tarball release |
| **Clean**                         | Removes the entire build folder                               |
| **Conan**                         | Builds Conan dependencies                                     |
| **Configure**                     | Configures CMake                                              |
| **Configure with CMake Debugger** | Configures CMake with debugging of CMakeLists.txt. Requiring CMake > 3.27. Awesome feature to debug large CMake CMakeLists configurations. Add breakpoint to some line. Select this task in menu and afterwards select launch.json task "Debug CMakeLists.txt library".|
| **Build** `F7`                    | Builds the project                                            |
| **Collect Licenses**              | Gathers licenses from CPM dependencies                        |
| **Install Artefacts**             | Installs to **/Build/Installed/**                             |
| **Release Artefacts**             | Tarballs to **/Build/Artefacts/**                             |
| **Conan graph.html**              | Create html output of Conan dependencies                      |
| **Lint C/C++**                    | C/C++ files diagnostics                                       |
| **Format C/C++**                  | Formatting for C/C++ files                                    |
| **Format CMake**                  | Formatting for CMake files                                    |

### MarkWare Special Tasks

| Key binding set to      | `Shift + Ctrl + S`                       |
| ----------------------- | --------------------------------------------- |
| **Permutate All Tasks** | Permutate over all the tasks for all
|                         | the architecturtes and build types. |
| this means will does    | Clean → Conan → Configure → Build → Install Art. → Release Art. |

---

### Another key bindings

- `F5`: Start Standalone with debugging.
- `Ctrl + Alt + M`: Format all CMake files.
- `Ctrl + Alt + F`: Format all C++ files.
- `Ctrl + Alt + L`: Lint all C++ files.

---

## Command Line

### Command Line Control

CLI control of the projects is also available.

**The real intention of this template is to completely avoid the command line when it is not absolutely necessary.** However, there may be situations where manual work is required, so I have listed some task scenarios here as examples. You can extract these commands yourself from the `SolutionController.log` file, which is automatically created in the main directory of the project file system, as the VSCode tasks are used.

#### Library Release **default conan profile** system compiler

```bash
conan install "/home/tomas/dev/cpp/projects/MarkWareVCMake" --output-folder="/home/tomas/dev/cpp/projects/MarkWareVCMake/Build/Library/default/Debug" --build=missing --profile default --settings build_type=Debug -o *:shared=False
source "/home/tomas/dev/cpp/projects/MarkWareVCMake/Build/Library/default/Debug/conanbuild.sh" && cmake -S "." -B "/home/tomas/dev/cpp/projects/MarkWareVCMake/Build/Library/default/Debug" -DCMAKE_TOOLCHAIN_FILE="/home/tomas/dev/cpp/projects/MarkWareVCMake/Build/Library/default/Debug/conan_toolchain.cmake" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX="/home/tomas/dev/cpp/projects/MarkWareVCMake/Build/Install/default/Debug"
source "/home/tomas/dev/cpp/projects/MarkWareVCMake/Build/Library/default/Debug/conanbuild.sh" && cmake --build "/home/tomas/dev/cpp/projects/MarkWareVCMake/Build/Library/default/Debug"  -j 16
```

#### Standalone Release **Cross** build with **x86_64-w64-mingw32** toolchain compiler

```bash
Remove: Build/Standalone/x86_64-w64-mingw32/Release
conan install "/home/tomas/dev/cpp/projects/MarkWareVCMake" --output-folder="/home/tomas/dev/cpp/projects/MarkWareVCMake/Build/Standalone/x86_64-w64-mingw32/Release" --build=missing --profile x86_64-w64-mingw32 --settings build_type=Release -o *:shared=False
source "/home/tomas/dev/cpp/projects/MarkWareVCMake/Build/Standalone/x86_64-w64-mingw32/Release/conanbuild.sh" && cmake -S "./Standalone" -B "/home/tomas/dev/cpp/projects/MarkWareVCMake/Build/Standalone/x86_64-w64-mingw32/Release" -DCMAKE_TOOLCHAIN_FILE="/home/tomas/dev/cpp/projects/MarkWareVCMake/Build/Standalone/x86_64-w64-mingw32/Release/conan_toolchain.cmake" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="/home/tomas/dev/cpp/projects/MarkWareVCMake/Build/Install/x86_64-w64-mingw32/Release"
source "/home/tomas/dev/cpp/projects/MarkWareVCMake/Build/Standalone/x86_64-w64-mingw32/Release/conanbuild.sh" && cmake --build "/home/tomas/dev/cpp/projects/MarkWareVCMake/Build/Standalone/x86_64-w64-mingw32/Release"  -j 16
```

---

### What This Template Offers Over Basic Templates
|                                          | MarkWareVCMake                         | ModernCppStarter | cmake_template |
| ---------------------------------------- | -------------------------------------- | ---------------- | -------------- |
| Minimal setup required                   | yes                                    | yes              | yes            |
| Supports best practices + Modern CMake   | yes                                    | yes              | yes            |
| Stanadlone->Library concept              | yes                                    | yes              | yes            |
| Highly Customizable                      | yes                                    | yes              | yes            |
| Github workflow with badges              | yes                                    | yes              | not sure       |
| PackageProject.cmake                     | yes                                    | author           | no             |
| Dependency solution CPM.cmake integrated | yes                                    | author           | no             |
| CPM.license integrated                   | yes                                    | author           | no             |
| CPM.tools integrated                     | yes                                    | author           | no             |
| LintC, clang-format, cmake-format        | VSCode Tasks + shortcuts + cli         | only cli         | no             |
| Solution Renamer                         | yes                                    | no               | no             |
| Dependency solution by Conan             | yes, wrapped by tasks in VSCode        | no               | no             |
| CMake generators by Conan preconfigured  | yes                                    | no               | no             |
| Cross-Compilation preconfigured          | yes, require toolchain                 | no               | no             |
| Cross-Compilation targets preconfigured  | linux, windows, raspberry pi 4/5       | no               | no             |
| VSCode CMake controller                  | yes                                    | no               | no             |
| VSCode Tasks via Menu and Shortcuts      | yes                                    | no               | no             |
| Clean                                    | Removes the entire build folder        | no               | no             |
| Conan                                    | Builds Conan dependencies              | no               | no             |
| Configure                                | Configures CMake                       | only cli         | only cli       |
| Build                                    | Builds the project                     | only cli         | only cli       |
| Collect Licenses                         | Gathers licenses from CPM dependencies | no               | no             |
| Install Artefacts                        | Installs to /Build/Installed/          | no               | no             |
| Release Artefacts                        | Tarballs to /Build/Artefacts/          | no               | no             |
| Lint C/C++                               | C/C++ files diagnostics                | only cli         | only cli       |
| Format C/C++                             | Recursive formatting for C/C++ files   | only cli         | only cli       |
| Format CMake                             | Recursive formatting for CMake files   | only cli         | only cli       |
| Permutate All Tasks                      | Executes all task scenarios (testing)  | no               | no             |
| Loging runned commands                   | yes, to file                           | no               | no             |
| C/C++ tests                              | not yet                                | yes              | yes            |
| Doxygen                                  | not yet                                | yes              | no             |

---

## License

This template is licensed under MIT License.  
