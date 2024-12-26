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
- **Native Linux C/C++ Debugging**: Enables seamless step-by-step debugging.  
- **Cross-Platform Support**: Runs natively on Linux 🐧, macOS 🍏, and Windows via WSL 🪟.  
- **Cross-Compilation Support**: Facilitates compilation for multiple platforms with the help of Conan 2 and CMake.  
- **Modularity**: Easily extendable and customizable to meet your project's unique requirements.  

This template is designed for maximum customization, making it easier to create modern applications using proven tools and technologies.

### Integrated template configurations

- **Visual Studio Code**: Preconfigured settings for a streamlined development experience.
  https://code.visualstudio.com/
- **Conan 2**: Simplifies dependency management and integrates external libraries seamlessly.
  https://docs.conan.io
- **Modern CMake**: Leverages advanced configuration and build practices for modern development.
  https://cmake.org/download/
- **Python 3**:
  https://www.python.org/downloads/
- **Pyenv**:
  https://github.com/pyenv/pyenv
- **CPM.cmake**: Lightweight dependency management without external installations.
  - https://github.com/cpm-cmake/CPM.cmake
- **CPM.license**: Automates third-party license management.
  https://github.com/cpm-cmake/CPMLicenses.cmake
- **ModernCppStarter**: Inspired by industry best practices for initializing C++ projects.
  https://github.com/TheLartians/ModernCppStarter
- **Clang and CMake Formatters**: Ensures clean, consistent code and build script formatting.
  https://clang.llvm.org/docs/ClangFormat.html
  https://cmake-format.readthedocs.io/en/latest/

---

### Benefits for Developers

- Accelerated project initialization with pre-configured tools.
- Adherence to modern development standards in C and C++.
- Easy integration of additional tools and libraries.
- Broad support for various environments and build systems.

This template serves as an ideal starting point for developers who want to efficiently work on modern projects while leveraging the advantages of proven technologies.

---

# FAQ

##### Why not use the CMake extension by Microsoft in VS Code? 🤷🏻‍♂️

😏 While the existing CMake extension is adequate for simple native scenarios, it falls short when it comes to cross-compilation. It lacks the reliability needed for more complex, cross-platform development tasks.

---

### Project Video Tour (en subtitles)

https://github.com/user-attachments/assets/88ef7e5d-f72d-4a20-abce-b7e3e6c85389

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

### Quick Start all operating systems

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

### If conan have found compiler configuration is done.

```bash
# clone solution to folder ./AwesomeLibraryWithStandalone

git clone https://github.com/tomasmark79/MarkWareVCMake ./AwesomeLibraryWithStandalone
cd AwesomeLibraryWithStandalone/

# rename library and standalone to your fit

./TemplateRenamer.sh VCMLib MyAwesomeLibrary VCMStandalone MyAwesomeStandalone

# and finally

code .
```

---

# That's all. 

# 🚀 From this point, you have a fully functional solution for making Linux binaries whether you are on Linux, macOS, or Windows.

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
  
### Preconfigured architectures

- x86_64-linux-gnu (used natively by conan default profile)
- aarch64-linux-gnu (require cross compilation 👇🏻)
- x86_64-w64-mingw32 (require cross compilation 👇🏻)

---

### Preconfigured build types

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

## If you want more 🦸🏼

### Cross-Compilation 🤩 How-To 🍒

It’s easier than you might think! All you need for cross-compilation is a properly configured toolchain for the target platform. Once this requirement is met, the project will handle the rest, leveraging cross-compilation to its fullest potential.

Everything starts and ends with creating the toolchain, and for that, we use the **ng-crosstool** utility.

#### Cross-Compiling to Windows 64-bit

As an example, here’s how to set up a configuration for building binary targets for the Windows 64-bit OS:

In the bash console:

```bash
# Install the ng-crosstool utility
pip install ng-crosstool

# List available target architectures
ct-ng list-samples

# Import configuration to the ct configurator
ct-ng x86_64-w64-mingw32

# Use menu to configure your toolchain
ct-ng menuconfig

# And build the toolchain ☕
ct-ng build
```

Creating the toolchain takes ages, so treat yourself to something good to eat in the meantime. 🙂 

#### When toolchain is done.

If you kept the default output settings, you’ll find your new toolchain at: `~/x-tools/`.

#### Now for the final step:

we need to **tell Conan** about the **new toolchain**.  

Create a new profile file for Conan, typically located in `~/.conan2/profiles`.  

The file will be named `x86_64-w64-mingw32` and should contain:

```ini
[settings]
os=Windows
arch=x86_64
compiler=gcc
compiler.cppstd=17
compiler.libcxx=libstdc++11
compiler.version=13
build_type=Release

[buildenv]
CMAKE_SYSROOT=/home/changetoyouruser/x-tools/x86_64-w64-mingw32/x86_64-w64-mingw32/sys-root
CC=/home/changetoyouruser/x-tools/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-gcc
CXX=/home/changetoyouruser/x-tools/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-g++
LD=/home/changetoyouruser/x-tools/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-ld
AR=/home/changetoyouruser/x-tools/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-ar
AS=/home/changetoyouruser/x-tools/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-as
RANLIB=/home/changetoyouruser/x-tools/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-ranlib
STRIP=/home/changetoyouruser/x-tools/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-strip
RC=/home/changetoyouruser/x-tools/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-windres
```

And that’s it. 💆🏻  The template already knows the `x86_64-w64-mingw32` architecture profile, because I already added this architecture configuration. You can now select it when performing any task in the task menu immediately.

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
