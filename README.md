# MarkWare VCMake

[![Ubuntu](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/ubuntu.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/ubuntu.yml)
[![MacOS](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/macos.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/macos.yml)
[![Windows](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/windows.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/windows.yml)  

## Overview  

MarkWare VCMake is a comprehensive, modern C++ project template designed for cross-platform development in Visual Studio Code. The template provides a robust foundation for both standalone executables and libraries, incorporating industry best practices and modern build tools.  

Just seconds away from starting 🚀 development in awesome C++ 💻✨  

## Key Features🎈

- **Linux**, **MacOS**, **Windows** compatible
- Modern **CMake** with **targets design**
- Modern projects design **Standalone** & **Library** 
- **Conan 2** by conanfile.py
- [**CPM.cmake**](https://github.com/cpm-cmake/CPM.cmake), [**CPM.license**](https://github.com/cpm-cmake/CPMLicenses.cmake), [**cxxopt**](https://github.com/jarro2783/cxxopts/tree/v3.2.1) ([cxxoptwiki](https://github.com/jarro2783/cxxopts/wiki))
- **Sanitizers**, **Static Analysis**, and **Hardening**
- Template **Renamer**
- Template **Upgrader**
- Counts with **Cross-compilation**
- Compatible to [**SSH**](https://code.visualstudio.com/docs/remote/ssh), [**WSL**](https://code.visualstudio.com/docs/remote/wsl) remote development
- Automated **Wrapper for CMake Build System** by [Tasks](https://code.visualstudio.com/docs/editor/tasks)
- Native C++ debugging by Microsoft [C++ extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)
- [**CMake debugger**](https://devblogs.microsoft.com/cppblog/introducing-cmake-debugger-in-vs-code-debug-your-cmake-scripts-using-open-source-cmake-debugger/)
- GitHub [Actions](https://docs.github.com/en/actions) workflows for continuous integration

## Projects used this template

[MWImGuiStarter](https://github.com/tomasmark79/MWImGuiStarter)  
[MWwxWidgetsStarter](https://github.com/tomasmark79/MWwxWidgetsStarter)  
[MyPersonalDiscordBot](https://github.com/tomasmark79/MyPersonalDiscordBot)  
[snake-in-shell-cpp](https://github.com/tomasmark79/snake-in-shell-cpp)  
[MassCode2Md](https://github.com/tomasmark79/MassCode2Md)  
...

## System Requirements

### Essential Tools

- [**Visual Studio Code**](https://code.visualstudio.com/download) with C++ [extension](https://marketplace.visualstudio.com/vscode)
- [**Python 3**](https://www.python.org) (managed by [Pyenv](https://github.com/pyenv/pyenv ))
- [**Conan 2**](https://conan.io/center) for dependency management
- [**CMake**](https://cmake.org/download/) (latest version 3 recommended)
- **Code Formatters**:
  - [Clang Format](https://clang.llvm.org/docs/ClangFormat.html)
    - [CLangConfigurator](https://clang-format-configurator.site)
  - [CMake Format](https://cmake-format.readthedocs.io/en/latest/)
- **Code analyzing**:
  - [Clang Tidy](https://clang.llvm.org/extra/clang-tidy/)

## Getting Started

### Installers

#### Debian/Ubuntu based Linux

```bash
curl -sSL https://raw.githubusercontent.com/tomasmark79/MarkWareVCMake/main/.init/DebianBasedInstaller.sh | bash
```

```bash
python SolutionRenamer.py <OldLibName> <NewLibName> <OldStandaloneName> <NewStandAloneName>
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
- ⚔️ Conan create library recipe
- 📊 Conan dependencies in graph.html  
- 🔍 CLang-tidy  
- 📐📏 CLang & CMake formatting  
  
### CMake Build Options

Supports multiple build types hardcoded in `tasks.json`:
```txt
Debug, Release, RelWithDebInfo, MinSizeRel
```

Configurable CMake options for:  
  
`BUILD_SHARED_LIBS`, `USE_STATIC_RUNTIME`, `SANITIZE_ADDRESS`, `SANITIZE_UNDEFINED`, `SANITIZE_THREAD`, `SANITIZE_MEMORY`, `ENABLE_HARDENING`, `ENABLE_IPO`, `ENABLE_CCACHE`

### CLI Build everything at once

Build standalone part will also build library if linked in CMake configuration.

```bash
conan install "." --output-folder="./build/standalone/default/debug" --deployer=full_deploy --build=missing --profile default --settings build_type=Debug
source "./build/standalone/default/debug/conanbuild.sh" && cmake -S "./standalone" -B "./build/standalone/default/debug" -DCMAKE_TOOLCHAIN_FILE="conan_toolchain.cmake" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX="./build/installation/default/debug"
source "./build/standalone/default/debug/conanbuild.sh" && cmake --build "./build/standalone/default/debug"  -j 16
source "./build/standalone/default/debug/conanbuild.sh" && cmake --build "./build/standalone/default/debug" --target install -j 16

```

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

#### Renaming

by python script `SolutionRenamer.py`  

#### Upgrade custom template parts
by pyton script `SolutionUpgrader.py`  

#### Log using history

in existing log file  `Solution.log`  

### Structure 2in1

*Template is using Two projects in One Solution.*

```txt
MarkWareVCMake/
├── include/
```
Contains **library project** public header files (.hpp) intended for use in other projects or modules.

```txt
MarkWareVCMake/
├── src/
```
Contains **library project** source files (.cpp) and `internal` header files (.hpp) that are not intended for public use.

```txt
MarkWareVCMake/
├── standalone/
```
Contains just **standalone** project.

## Conventions

To avoid future issues with folder and file names, I have set these rules.

 - **All standard template folders**, including those generated later, **use lowercase letters only**.
 - User-defined folders can contain any combination of uppercase and lowercase letters.
 - All **C** and **C++** files provided in the template will use **CamelCase convention**, including an **uppercase letter at the beginning**.

### Indentation

C/C++ 2 spaces  
Python 4 spaces  

## FAQ

`Q:` **Build task error**  
Error: /home/.../Build/Standalone/default/Debug is not a directory  
Error: /home/.../Build/Library/default/Debug is not a directory  
`A:` There is nothing to build. You must first create the configurations for the product, and only then can you compile separately with the build task. The "Zero to Build," "Zero to Hero," or CMake configuration tasks will help you create the configuration, which can then be compiled.

`Q:` **CMake-tidy error**  
Error while trying to load a compilation database: Could not auto-detect compilation database from directory, etc.  
`A:` For static code analysis to work correctly, you need to have the CMake configurations prepared. Also, ensure that the `CMAKE_EXPORT_COMPILE_COMMANDS` variable is set to `ON` in CMakeLists.txt.

## Tips

`xxd -i file.bin > file.h`

## Thanks

To everyone who supported me in creating this template. These are various people and information from the web. Of course, also literature and courses that I have taken in the past. Various Discord servers and individuals who took a moment to make an indelible mark on this amazing work for me. Thank you very much!  

## Credits
dsdotname, littlemushroom


## License

MIT License
Copyright (c) 2024-2025 Tomáš Mark

This project is licensed under the MIT License. No warranty of functionality or liability is provided. If you use this project, please mention my credentials. If you need software and technical support, you can contact me.
