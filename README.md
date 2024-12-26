# MarkWare VCMake Template 🎁

### Modern configurable project template for C and C++ 

It aims for a unique design, combining an **application** and **library** **within a single solution**.

It's spectacular! Give it a try! 😎

0.0.7

---

<img width="189" alt="image" src="https://github.com/user-attachments/assets/df0f7209-aaec-4c51-a434-4455344e0d57" />

---

### Why?

If you love working in C/C++ and are at home in Linux, this is something you absolutely must try! I'm not kidding. While many ready-made solutions exist, this one is unique—tailored precisely to the needs of modern OOP development in C++ using Modern CMake and the latest Conan 2. Of course, it also allows writing in pure C or Objective-C if desired. This solution offers numerous advantages that I personally find invaluable.

### Benefits

- **Quick Start**: Ready to use immediately after cloning (only initial environment setup required).  
- **Cross-Platform Support**: Runs natively on Linux 🐧, macOS 🍏, and Windows via WSL 🪟.  
- **Native C/C++ Debugging**: Enables seamless step-by-step debugging, regardless of the operating system used for development.  
- **Cross-Compilation Support**: Facilitates compilation for multiple platforms with the help of Conan 2 and CMake.  
- **Modularity**: Easily extendable and customizable to meet your project's unique requirements.  

This template is designed for maximum customization, making it easier to create modern applications using proven tools and technologies.

### Integrated template configurations

- **Visual Studio Code**: Preconfigured settings for a streamlined development experience.  
- **Conan 2**: Simplifies dependency management and integrates external libraries seamlessly.  
- **Modern CMake**: Leverages advanced configuration and build practices for modern development.  
- **CPM.cmake**: Lightweight dependency management without external installations.  
- **CPM.license**: Automates third-party license management.  
- **ModernCppStarter**: Inspired by industry best practices for initializing C++ projects.  
- **TemplateRenamer**: Simplifies renaming the template to align with your project.  
- **Clang and CMake Formatters**: Ensures clean, consistent code and build script formatting.  

---

### Benefits for Developers

- Accelerated project initialization with pre-configured tools.
- Adherence to modern development standards in C and C++.
- Easy integration of additional tools and libraries.
- Broad support for various environments and build systems.

This template serves as an ideal starting point for developers who want to efficiently work on modern projects while leveraging the advantages of proven technologies.

---

### Workflow video presentation

https://github.com/user-attachments/assets/88ef7e5d-f72d-4a20-abce-b7e3e6c85389

---

### List of Dependencies 🔃

- **Visual Studio Code**: [Download](https://code.visualstudio.com) (mandatory)
  Recomended extensions for VSCode
  - natqe.reload | ms-vscode.cpptools | jeff-hykin.better-cpp-syntax | FleeXo.cpp-class-creator | amiralizadeh9480.cpp-helper | xaver.clang-format | josetr.cmake-language-support-vscode | ms-vscode-remote.remote-ssh | ms-vscode-remote.remote-ssh-edit | ms-vscode.remote-explorer | yzhang.markdown-all-in-one | shd101wyy.markdown-preview-enhanced

####

- **CMake**: [Download](https://cmake.org/download/) (mandatory)
- **Python 3**: [Download](https://www.python.org/downloads/) (mandatory)
- **Conan 2 Configurator**: [Installation Guide](https://docs.conan.io/2/installation.html) (mandatory)
- **Compilers**: [GCC](https://gcc.gnu.org) or [Clang](https://clang.llvm.org) (mandatory), ...
- **CMake Formatter**: [Documentation](https://cmake-format.readthedocs.io/en/latest/) (optional)
- **Clang Formatter**: [Documentation](https://clang.llvm.org/docs/ClangFormat.html) (optional)
- **Cross-Compiler with Toolchain and Sysroot**: [crosstool-NG](https://crosstool-ng.github.io) (optional)

---

### Prepare development environment

This template solution can be used on virtually any platform. **On Linux and macOS, it is essentially a native solution**. If you are on **Windows**, you only **need to enable WSL**, install a distribution such as Debian, and then connect to it in the VSCode editor using the **WSL extension**. VSCode on Windows will then behave as if it were installed directly on Linux. The **Quick Start below are common to all existing platforms**. On Windows, you will just use the aforementioned WSL interface.

---

### Windows user? You need to activate WSL - folow those steps

In Windows powershell console as Administrator run those commands

```powershell
wsl --install
wsl --list --online
wsl --install Debian
wsl --set-default-version 2
shutdown /r
```
After restarting your Windows, you need to install the required VSCode extension for Remote WSL connection.
1. In VSCode, install mandatory extensions such as `ms-vscode-remote.remote-wsl` and `ms-vscode.cpptools`.
2. In VSCode, run the task `WSL: Connect to WSL`.

Afterwards, your VSCode editor will be connected to the WSL environment.

3. Finally, open the project template folder `/mnt/c/dev/MyAwesomeApp` in VSCode.
4. You will need to install some VSCode extensions again because the VSCode environment has changed.
5. Close VSCode.
6. The next launch of VSCode can be done with the `code .` command from the WSL Debian bash console, and everything will work.
7. Let's continue to the **Quick Start** section, which is the same for all platforms.
---

### Quick Start

```bash

# required apt packages 
sudo apt update && sudo apt upgrade -y
sudo apt install cmake python3-pip curl git libssl-dev \
libbz2-dev libcurses-ocaml-dev build-essential gdb libffi-dev \
libsqlite3-dev liblzma-dev libreadline-dev libtk-img-dev

# install and configure pyenv
curl https://pyenv.run | bash
pyenv install 3.9.2
pyenv virtualenv 3.9.2 env392
pip install --upgrade pip

# install latest conan
pip install conan

# create default conan profile
conan profile detect --force
```

If conan have found compiler configuration is done.

```bash
# clone template project
git clone https://github.com/tomasmark79/MarkWareVCMake ./NameOfMyAwesomeApp
cd NameOfMyAwesomeApp/

# use renamer if you want
./TemplateRenamer.sh VCMLib MyAwesomeLibrary VCMStandalone MyAwesomeStandalone

# and finally launch Visual Studio Code from the current folder
code .

```

---

# That's all. 

# 🚀 From this point, you have a fully functional solution whether you are on Linux, macOS, or Windows.

---

### Implemented VSCode Tasks

#### Shift + F7 - Task Menu

|Task                    |  |Description
|------------------------|--|-------------------------------------
|**Zero to Hero**        |🦸|Clean -> Conan -> Configure -> Build
|**Clean**               |🧹|Remove entire desired Build folder
|**Conan**               |🗡️|Build Conan 2 dependencies
|**Configure**           |🔧|CMake configuration
|**Build**               |🔨|VMake build
|**Collect Licenses**    |📜|from attached CPM.cmake packages
|**Install Artefacts**   |📌|install to `/Build/Installed/*`
|**Release Artefacts**   |📦|release tar.gz archives
|**Permutate All Tasks** |🕧|permutate throught all task scenarios

###

| Icons meaning     |  |Description
|-------------------|--|----
|**Library**        |📚| it only applies to the library
|**Standalone**     |🎯| it only applies to the Standalone

#### F5 - Debug

- Initiates the debugging process.

#### F7 - Build Native Debug
 
- Directly builds the project without displaying a menu.

#### Ctrl + Alt + M

- recursive CMake-format for CMake based files

#### Ctrl + Alt + F

- recursive Clang-format for C++ based files

#### Ctrl + Shift + Alt + B

- shellcheck project .sh scripts for `CmakeController.sh`, `TemplateRenamer.sh`

---
  
### Default architectures

- x86_64-linux-gnu (used by default Conan profile)
- aarch64-linux-gnu
- x86_64-w64-mingw32

---

### Default build types

- Debug
- Release
- RelWithDebInfo
- MinSizeRel

---

### Project Structure

`tree -a --prune -I '.git|Build' --dirsfirst --gitignore`

```txt
.
├── cmake
│   ├── Modules
│   │   └── FindX11.cmake
│   ├── CPM.cmake
│   └── tools.cmake
├── include
│   └── VCMLib
│       └── VCMLib.hpp
├── Utilities
│   ├── CMakeToolChains
│   │   ├── aarch64.cmake
│   │   └── X86_64-w64-mingw32.cmake
│   ├── ConanProfiles
│   │   ├── aarch64
│   │   ├── default
│   │   └── x86_64-w64-mingw32
│   ├── ConanPythonConfigurer
│   │   └── conanfile.py
│   └── AboutThisFolder.md
├── Source
│   └── VCMLib.cpp
├── Standalone
│   ├── Source
│   │   └── Main.cpp
│   ├── CMakeLists.txt
│   └── LICENSE
├── .vscode
│   ├── c_cpp_properties.json
│   ├── keybindings.json
│   ├── launch.json
│   ├── settings.json
│   └── tasks.json
├── .clang-format
├── CMakeController.sh
├── .cmake-format
├── CMakeLists.txt
├── conanfile.txt
├── .gitattributes
├── .gitignore
├── LICENSE
├── .python-version
├── README.md
└── TemplateRenamer.sh
```

### Project Structure Description

- **cmake/**
  - **Modules/**  
    Contains custom CMake modules (e.g., FindX11.cmake) that help locate system libraries or provide extra CMake functionality.
  - **CPM.cmake**  
    Manages third-party dependencies via the CMake Package Manager.
  - **tools.cmake**  
    Provides auxiliary CMake functions and macros to simplify the build process.

- **include/**
  - **VCMLib/**  
    Houses public header files for the core VCMLib library, exposing its functionality to other parts of the project.

- **Utilities/**
  - **CMakeToolChains/**  
    Includes toolchain files for cross-compiling (e.g., aarch64.cmake, X86_64-w64-mingw32.cmake).
  - **ConanProfiles/**  
    Stores Conan configuration profiles for different target platforms (e.g., aarch64, x86_64-w64-mingw32).
  - **ConanPythonConfigurer/**  
    Contains a conanfile.py for Python-based Conan configuration.
  - **AboutThisFolder.md**  
    Explains the purpose and usage of the MarkWareUtilities folder.

- **Source/**
  - **VCMLib.cpp**  
    Implements the core functionality of the VCMLib library.

- **Standalone/**
  - **Source/Main.cpp**  
    Entry point for the standalone application that uses VCMLib.
  - **CMakeLists.txt**  
    Handles build instructions for the standalone application.
  - **LICENSE**  
    License file specific to the standalone application.

- **.vscode/**
  - **c_cpp_properties.json**  
    Configures C/C++ IntelliSense and compiler settings in VS Code.
  - **keybindings.json**  
    Defines custom keyboard shortcuts.
  - **launch.json**  
    Specifies debugging configurations for VS Code.
  - **settings.json**  
    Holds project-specific VS Code settings.
  - **tasks.json**  
    Defines build-or-run tasks for automation in VS Code.

- **.clang-format**  
  Defines code formatting rules for C++ based on ClangFormat.
- **CMakeController.sh**  
  A convenience script for configuring, building, and cleaning the project via CMake.
- **.cmake-format**  
  Provides formatting rules for CMake files.
- **CMakeLists.txt**  
  Top-level build configuration for the entire project.
- **conanfile.txt**  
  Lists external dependencies managed by Conan.
- **.gitattributes**  
  Specifies Git’s handling of certain files (e.g., line endings, diff behavior).
- **.gitignore**  
  Tells Git which files and directories to ignore in the repository.
- **LICENSE**  
  The main license file covering the entire project.
- **.python-version**  
  Indicates which Python version to use with this project.
- **README.md**  
  Provides instructions, documentation, and an overview of the project.
- **TemplateRenamer.sh**  
  Script used to rename or customize template components across the project.

---

### Acknowledgements

I would like to extend my gratitude to everyone who has contributed directly or indirectly to this project.
Special thanks to all the developers of the tools utilized in this template.
A heartfelt thank you to Lars Melchior TheLartians for his various CPM extensions.
Appreciation also goes to Sleepy Monax for his feedback on macOS.

---

### About the Author 🧑🏻‍💻

This template is the culmination of countless hours of dedicated work, designed to elevate C++ development to new heights.

If you find this project helpful and would like to support its development, consider making a donation:

```
PayPal: paypal.me/TomasMark
Bitcoin: 3JMZR6SQo65kLAxxxXKrVE7nBKrixbPgSZ
Ethereum: 0x7a6C564004EdecFf8DD9EAd8bD4Bbc5D2720BeE7
```

### todo
- missing license writting when Standalone
- cpack in cooperation packageProject target
- port workflow bash scripts to windows (PowerShell?)
