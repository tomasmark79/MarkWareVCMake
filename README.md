# MarkWare VCMake Template 🎁
v0.0.7

### Modern Configurable Project Template for C and C++ 🎁

This template offers a comprehensive solution for quickly starting development in C and C++. It is designed to be easily customizable and enables the creation of modern applications using proven tools and technologies. The template integrates the following components:

- **Visual Studio Code**: Support for the development environment with preconfigured settings.
- **Conan 2**: Dependency management for seamless integration of external libraries.
- **Modern CMake**: Advanced configuration and build system leveraging modern best practices.
- **CPM.cmake**: Simple dependency management without requiring external package installations.
- **CPM.license**: Automated management of third-party licenses.
- **ModernCppStarter**: Inspired by best practices for initializing modern C++ projects.
- **TemplateRenamer**: Easily rename the template to suit your project.
- **Clang and CMake Formatters**: Automated formatting for code and build scripts.

---

### Key Features

- **Quick Start**: Ready to use immediately after cloning.
- **Flexibility**: Supports the creation of applications with statically or dynamically linked libraries.
- **Cross-Platform Support**: Works natively on Linux 🐧, macOS 🍏 and on Windows via WSL 🪟. 
- **Cross-Compilation Support**: Enables compilation for various platforms with help of Conan 2 and CMake.
- **Modularity**: Easily extendable and customizable to meet project needs.

---

### Benefits for Developers

- Accelerated project initialization with pre-configured tools.
- Adherence to modern development standards in C and C++.
- Easy integration of additional tools and libraries.
- Broad support for various environments and build systems.

This template serves as an ideal starting point for developers who want to efficiently work on modern projects while leveraging the advantages of proven technologies.

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
### Workflow video presentation

https://github.com/user-attachments/assets/88ef7e5d-f72d-4a20-abce-b7e3e6c85389

### Prepare development environment

This template solution can be used on virtually any platform. **On Linux and macOS, it is essentially a native solution**. If you are on **Windows**, you only **need to enable WSL**, install a distribution such as Debian, and then connect to it in the VSCode editor using the **WSL extension**. VSCode on Windows will then behave as if it were installed directly on Linux. The **Quick Start below are common to all existing platforms**. On Windows, you will just use the aforementioned WSL interface.

```bash

sudo apt update && sudo apt upgrade -y
sudo apt install cmake python3-pip curl git libssl-dev libbz2-dev libcurses-ocaml-dev build-essential libffi-dev libsqlite3-dev liblzma-dev libreadline-dev libtk-img-dev

# pyenv for Python venv support
curl https://pyenv.run | bash
pyenv install 3.9.2
pyenv local 3.9.2
pyenv global 3.9.2
pyenv prefix
pyenv virtualenv 3.9.2 env392
pip install --upgrade pip

# install latest conan
pip install conan

# clone 
git clone https://github.com/tomasmark79/MarkWareVCMake ./NameOfMyAwesomeApp
cd NameOfMyAwesomeApp/
./TemplateRenamer.sh VCMLib MyAwesomeLibrary VCMStandalone MyAwesomeStandalone
code .
```

### Quick Start Windows

In Windows powershell as Administrator

```powershell
wsl --install
wsl --list --online
wsl --install Debian
wsl --set-default-version 2
shutdown /r
```

In Debian bash under Windows WSL2

```bash

# install essentials via apt package manager
sudo apt update && sudo apt upgrade -y
sudo apt install cmake python3-pip curl git libssl-dev libbz2-dev libcurses-ocaml-dev build-essential libffi-dev libsqlite3-dev liblzma-dev libreadline-dev libtk-img-dev 

# pyenv for Python venv support
curl https://pyenv.run | bash
pyenv install 3.9.2
pyenv local 3.9.2
pyenv global 3.9.2
pyenv prefix
pyenv virtualenv 3.9.2 env392
pip install --upgrade pip

# install latest conan
pip install conan

# clone project to Windows filesystem
git clone https://github.com/tomasmark79/MarkWareVCMake /mnt/c/dev/MyAwesomeApp
cd /mnt/c/dev/MyAwesomeApp
```

In Windows UI
- Open VSCode
- Install extension for WSL connection support  (id: ms-vscode-remote.remote-wsl)
- In tasks select and run `WSL> Connect to WSL`
- Open project folder from /mnt/c/dev/MyAwesomeApp
  
And Enjoy! 🚀 You are with your VSCode within the WSL environemt as you are sitting within Linux OS.

You need to continue settings your Conan 2 profiles, etc. This all is the same as for native Linux, or Mac.


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
