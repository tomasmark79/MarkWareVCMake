
![c++temp-toplogo](https://github.com/user-attachments/assets/5201de77-2df3-46a2-a59e-cfe985b33cdb)

# MarkWare VCMake

[![Ubuntu](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/ubuntu.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/ubuntu.yml)
[![MacOS](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/macos.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/macos.yml)
[![Windows](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/windows.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/windows.yml)  

## Overview  
MarkWare VCMake is a comprehensive, modern C++ project template designed for cross-platform development in Visual Studio Code. The template provides a robust foundation for both standalone executables and libraries, incorporating industry best practices and modern build tools.

With automatic installers you are just seconds away from starting 🚀 development. 💻✨  

## Key Features🎈

- Modern projects design **Standalone** & **Library** 
- The template is universal for **Linux**, **MacOS**, **Windows**
- Modern **CMake** with **targets object design**
- Integrated **Conan 2** with declaration in conanfile.py
- Target linking with [**CPM.cmake**](https://github.com/cpm-cmake/CPM.cmake), [**CPM.license**](https://github.com/cpm-cmake/CPMLicenses.cmake)
- Extended argument parsing with [**cxxopt**](https://github.com/jarro2783/cxxopts/tree/v3.2.1) ([cxxoptwiki](https://github.com/jarro2783/cxxopts/wiki))
- **Sanitizers**, **Static Analysis**, and **Hardening**
- Created with an emphasis on **Cross-compilation** capabilities
- Automated **Wrapper for CMake Build System** by [VSCode Tasks](https://code.visualstudio.com/docs/editor/tasks)
- Native C++ debugging by Microsoft [C++ extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)
- [**CMake debugger**](https://devblogs.microsoft.com/cppblog/introducing-cmake-debugger-in-vs-code-debug-your-cmake-scripts-using-open-source-cmake-debugger/)
- GitHub [Actions](https://docs.github.com/en/actions) workflows for continuous integration
- Template **Renamer**
- Template **Upgrader**
- Compatible with [**SSH**](https://code.visualstudio.com/docs/remote/ssh), [**WSL**](https://code.visualstudio.com/docs/remote/wsl) remote development

## Some of My Older Projects Using MarkWare VCMake

[MWImGuiStarter](https://github.com/tomasmark79/MWImGuiStarter), [MWwxWidgetsStarter](https://github.com/tomasmark79/MWwxWidgetsStarter),  [MyPersonalDiscordBot](https://github.com/tomasmark79/MyPersonalDiscordBot), [snake-in-shell-cpp](https://github.com/tomasmark79/snake-in-shell-cpp), [MassCode2Md](https://github.com/tomasmark79/MassCode2Md)  

## Getting Started

**Important Decision!**  
For MarkWare VCMake to function properly, you need to have the software installed that is used either directly by the project configuration itself or by the workflow that occurs in VSCode when working with MarkWare VCMake. You have two options. You can manually add dependencies one by one, which might be the more complex but better option for already used systems, or you can use automatic installation scripts, which are most suitable for a freshly installed system, as the scripts will install everything from scratch to a functional solution.

### Manual Installation

As a developer, you will most likely already have most of the tools listed below installed on your system.

Tools
- [git](https://git-scm.com)
- [curl](https://curl.se) (optional)
- [make](https://www.gnu.org/software/make/) [ninja](https://ninja-build.org)
- [cmake](https://cmake.org/download/)
- [ccache](https://ccache.dev/download.html)
- [vscode](https://code.visualstudio.com/download) with C++ [extension](https://marketplace.visualstudio.com/vscode)
- [pyenv](https://github.com/pyenv/pyenv) (optional)
  - [python 3](https://www.python.org)
    - [pip](https://pypi.org/project/pip/) - [PipHub](https://pypi.org)
      - [clang tidy](https://clang.llvm.org/extra/clang-tidy/)
      - [clang format](https://clang.llvm.org/docs/ClangFormat.html) >= 19.1.0- [WebClangConfigurator](https://clang-format-configurator.site)
      - [cmake format](https://cmake-format.readthedocs.io/en/latest/)
    - [conan 2](https://conan.io/center) - [ConanHub](https://conan.io/center)
- [vcpkg](https://vcpkg.io/en/) (not implemented yet)
- [doxygen](https://www.doxygen.nl) (not implemented yet)
- [gcovr](https://gcovr.com/en/stable/) (not implemented yet)

Compilers
- [mingw](https://www.mingw-w64.org)
- [llvm](https://llvm.org)
- [clang](https://clang.llvm.org)
- [gcc](https://gcc.gnu.org)
- [msvc](https://visualstudio.microsoft.com/vs/features/cplusplus/)
- [intel C++ compiler](https://software.intel.com/content/www/us/en/develop/tools/oneapi/components/dpc-compiler.html)

Crosstools
- [crosstool-ng](https://crosstool-ng.github.io)

### Automatic installation for fresh systems

#### Debian

```bash
curl -sSL https://raw.githubusercontent.com/tomasmark79/MarkWareVCMake/main/.init/installers/DebianBasedInstaller.sh | bash
```

#### Fedora

```bash
curl -sSL https://raw.githubusercontent.com/tomasmark79/MarkWareVCMake/main/.init/installers/FedoraInstaller.sh | bash
```

#### Windows

```powershell
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/tomasmark79/MarkWareVCMake/main/.init/installers/WindowsInstaller.ps1' -OutFile 'WindowsInstaller.ps1'; Set-ExecutionPolicy Bypass -Scope Process -Force; .\WindowsInstaller.ps1"
```

*Note for Windows Users: The CMake generator argument `-G "MinGW Makefiles"` is hardcoded in the `SolutionController.py` script at line 227. If you prefer to use a different CMake generator, please modify this line accordingly.*

### Cloning the Repository

To clone the MarkWare VCMake repository, execute the following command:

```bash
git clone https://github.com/tomasmark79/MarkWareVCMake ./
```

### Launching Visual Studio Code

To start Visual Studio Code from the root directory of MarkWare VCMake, use the following command:

```bash
code .
```

## Development Workflow

One of the first things you should do when you open VSCode is to install the necessary extensions and copy the contents of the `keybindings.json` configuration file into the system keybindings file, which is initially empty. This ensures that the keyboard shortcuts, which maximize user comfort and experience, will work correctly.

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
- ⚔️ Conan create library recipe
- 📊 Conan dependencies in graph.html  
- 🔍 CLang-tidy  
- 📐📏 CLang & CMake formatting  
  
### CMake Build Options

Supports multiple build types as specified in `tasks.json`:
```txt
- Debug
- Release
- RelWithDebInfo
- MinSizeRel
```

### Configurable CMake Options

The following CMake options can be configured to tailor the build process to your specific needs:

- `BUILD_SHARED_LIBS`: Build shared libraries instead of static ones.
- `USE_STATIC_RUNTIME`: Use the static runtime library.
- `SANITIZE_ADDRESS`: Enable address sanitizer.
- `SANITIZE_UNDEFINED`: Enable undefined behavior sanitizer.
- `SANITIZE_THREAD`: Enable thread sanitizer.
- `SANITIZE_MEMORY`: Enable memory sanitizer.
- `ENABLE_HARDENING`: Enable hardening options for increased security.
- `ENABLE_IPO`: Enable interprocedural optimization.
- `ENABLE_CCACHE`: Enable ccache for faster recompilation.

These options provide flexibility and control over the build configuration, allowing you to optimize for performance, security, and development efficiency.

### Manual Configuration and Build Options

#### Linux

Install Conan dependencies

```bash
conan install "." --output-folder="./build/standalone/default/debug" --deployer=full_deploy --build=missing --profile default --settings build_type=Debug
```

Configure Solution

```bash
source "./build/standalone/default/debug/conanbuild.sh" && cmake -S "./standalone" -B "./build/standalone/default/debug" -DCMAKE_TOOLCHAIN_FILE="conan_toolchain.cmake" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX="./build/installation/default/debug"
```

Build Solution

```bash
source "./build/standalone/default/debug/conanbuild.sh" && cmake --build "./build/standalone/default/debug"  -j 16
```

Install Solution

```bash
source "./build/standalone/default/debug/conanbuild.sh" && cmake --build "./build/standalone/default/debug" --target install -j 16
```

## Toolchains for Cross-Compilation

The solution includes a few predefined toolchain names that I actively use, so I decided to leave them in the template. **The toolchain names match the profile names used via Conan 2**. You can adjust them as needed. To start, it's good to know that `default` is the profile that Conan 2 creates first.

snippet from task.json
```json
{
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

## Maintenance

### Renaming

Renaming the executable and library, including all necessary strings and classes, is handled by the Python script `SolutionRenamer.py`.

### Update files of your choice from the repository

Updating individual files from the remote repository with the option to back up updated components is handled by the Python script `SolutionUpgrader.py`.

### Log using history

Workflow activities related to the project are logged in the file `Solution.log`.


## Additional Information on Template Structure

### Folders

```txt
MarkWareVCMake/
├── include/ Contains **library project** public header files (.hpp) intended for use in other projects or modules.
```

```txt
MarkWareVCMake/
├── src/ Contains **library project** source files (.cpp) and `internal` header files (.hpp) that are not intended for public use.
```

```txt
MarkWareVCMake/
├── standalone/ Contains just **standalone** project.
```

```txt
MarkWareVCMake/
├── assets/ Contains project **assets**. All content included in this folder is accessible via file path by macro ASSET_PATH.
```

## Argument Management for Standalone

The C++ source code uses a basic [**cxxopt**](https://github.com/jarro2783/cxxopts/tree/v3.2.1) implementation described below.

  - `-o` omit library loading
  - `-h` show help

## FAQ

`Q:` **Build task error**  
Error: /home/.../Build/Standalone/default/Debug is not a directory  
Error: /home/.../Build/Library/default/Debug is not a directory  
`A:` There is nothing to build. You must first create the configurations for the product, and only then can you compile separately with the build task. The "Zero to Build," "Zero to Hero," or CMake configuration tasks will help you create the configuration, which can then be compiled.

`Q:` **CMake-tidy error**  
Error while trying to load a compilation database: Could not auto-detect compilation database from directory, etc.  
`A:` For static code analysis to work correctly, you need to have the CMake configurations prepared. Also, ensure that the `CMAKE_EXPORT_COMPILE_COMMANDS` variable is set to `ON` in CMakeLists.txt.

## Tips

Transform binary file to C source code under Linux
```bash
xxd -i file.bin > file.h
```

## Thanks

To everyone who supported me in creating this template. These are various people and information from the web. Of course, also literature and courses that I have taken in the past. Various Discord servers and individuals who took a moment to make an indelible mark on this amazing work for me. Thank you very much!  

## Credits
tomasmark79, littlemushroom

## License

MIT License
Copyright (c) 2024-2025 Tomáš Mark

This project is licensed under the MIT License. No warranty of functionality or liability is provided. If you use this project, please mention my credentials. If you need software and technical support, you can contact me.
