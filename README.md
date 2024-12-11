# MarkWare VCMake 😎

VSCode CMake Modern C/C++ Template 🚀

# The impatient ones can start right away.

```bash
sudo apt-get update
sudo apt-get install build-essential manpages-dev
git clone https://github.com/tomasmark79/MarkWareVCMake
cd MarkWareVCMake/
code .
```
In worspace ./Standalone/Source/Main.cpp

```cpp
#include <VCMLib/VCMLib.hpp>
#include <vcmlib/version.h>

#include <iostream>

// Start here
// 👉 ./ProjectRenamer.sh <old_lib_name> <new_lib_name> <old_standalone_name> <new_standalone_name>
// 👉 build 🔨 your new standalone app CTRL + ALT + N

// Description
// It is the first file that gets compiled and linked into the final executable.
// This is the main entry point for the standalone application.
// It includes the VCMLib header file and creates an instance of the VCMLib class.

auto main(int argc, char **argv) -> int
{
    VCMLib Lib;
    std::cout << "Version: " << VCMLIB_VERSION << std::endl;

    return 0;
}
```

# Whatsapp

A project that takes the best ideas from worlds like VSCode, CMake, CPM, ModernAppStarter and C++.



# This C++ template consists of two projects

One project is a C++ library. The other project is a C++ application that links with the library. Together it is one solution.

# Briefly about the template

It is a project structure that offers extreme capabilities and flexibility. I have combined the best from multiple worlds. New parts, additional libraries, etc., can be easily added. It is a modern C++ project with a CMake configurator, but it keep compatibility to link C if necessary. The template is configured with CMake which is obohacen o CPM Packaging System, allowing us to leverage new modern project management capabilities in C/C++.

One of the other very important features of this template is its preparation for cross-compilation with support for Raspberry Pi 4. For cross-compilation, you need to build your own toolchain.

Another equally important feature of this template is that it includes its own build system and control for CMake, which is integrated into VSCode. The instructions are included in the template and are very simple. Just clone the repository from GitHub into a folder, open it in VSCode, and compile with the native compiler immediately. Everything happens within minutes.

I look forward to seeing you there!

Currently, only Linux is supported. "As soon as I get to Windows or Mac, or someone contributes, we will create extensions for these OS as well."

## Implemented ✅

(Library, Standalone)

- project renamer
- native code debug 🐞
- native compilation
- cross compilation
- configuration
- build
- install
- test
- lint for whole project 
- clang-format for whole project 
- cmake-format for whole project

## ToDo

- tests

## Rules

- FileNamesAndFoldersWithCapitalsIsGoodPractice
    no rules, only freedom

## Configuration ⚙️

### Properties

Cache for CPM headers required in project

`.vscode/c_cpp_properties.json`

### Implemented Tasks 🛠️

A major part of a lightweight yet robust CMake toolchain mechanism

`.vscode/tasks.json`

### Debugger configuration 🐞

Debug Targets. You should to edit path to your Standalone target

`.vscode/launch.json`

### ToolChain helper 🔧

Cross Compile Helper for CMake ToolChain selection

`cmake_configure.sh`

### Keyboard shortcuts giving the comfort to this project ⌨️

- Ctrl+Alt+  C  configure Lib
- Ctrl+Alt+  S  configure Standalone

- Ctrl+Alt+  B  **build** Lib
- Ctrl+Alt+  N  **build** Standalone

- Ctrl+Alt+  L  clean Lib
- Ctrl+Alt+  K  clean Standalone

- Ctrl+Alt+  I  install Lib
- Ctrl+Alt+  J  install Standalone

- Ctrl+Alt+  T  test Lib
- Ctrl+Alt+  U  test Standalone

- Ctrl+Alt+  R  lint
- Ctrl+Alt+  F  format
- Ctrl+Alt+  M  cmake-format

`~/.config/Code/User/keybindings.json`

## Thanks 🙏

*to all the awesome people who share the same mindset as me*

## and thanks to those 🌟

GitHub CoPilot
https://github.com

Kitware - CMake
https://cmake.org

VSCode IDE
https://code.visualstudio.com/license

Modern Cpp Starter
https://github.com/TheLartians/ModernCppStarter

Copyright (c) 2019-2022 Lars Melchior and contributors
https://github.com/cpm-cmake/CPM.cmake

## About me 👨‍💻

"The result of hundreds of hours (two weeks straight) of incredible fun. Time seemed to stand still. The outcome is a template that takes C++ development to a whole new level.
    
"Buy me a coffee ☕🍵 or spare some time. 🙂"

```
paypal.me/TomasMark
Bitcoin: 3JMZR6SQo65kLAxxxXKrVE7nBKrixbPgSZ
Ethereum: 0x7a6C564004EdecFf8DD9EAd8bD4Bbc5D2720BeE7
```

Thank you,

Tomáš Mark

https://tomas.digitalspace.name

tomas@digitalspace.name
