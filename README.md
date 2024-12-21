# MarkWare VCMake Template 🎁
v0.0.4

### Brief Description 😊

This solution represents a **complete workflow** for **modern** C/C++ software development. It integrates technologies such as **VSCode**, **Conan**, **CMake**, **CPM.cmake**, **ModernCppStarter**, **TemplateRenamer**, **Formatters**, and more into a single functional unit. It allows you to create a **Standalone Application** and a **library** *immediately*. 🎉

### Integrated Configurations 🔧

- **VSCode** is an indispensable editor, ranking first due to its flexibility and configurability.
- **Tasks** are jobs that build a robust system using **Conan** and **CMake**.
- **CMake**, as a modern configurator with object-oriented elements, provides enormous flexibility.
- **CPM.cmake** adds simplified support for fetching packages from GitHub, ensuring an easier way to obtain such packages.
- **Conan 2**, which manages dependencies, is the cherry on top 🍒, allowing you to easily add libraries that your project may need.
- **ModernCppStarter** is a project structure proven over many years and projects for developing programs and libraries. The essence of this structure is also embedded in this project.
- **Formatters** are simple scripts that quickly reformat C/C++ and CMake files.

### Integrated tasks

```txt
                            [ for Library and Standalone at once]
    "Build 🔨",             - CMake: --build --target all
    "Rebuild 🧹⚔️⚙️🔨",       - all steps at once (clean, conan, configure, build)
    
    "Configure ⚙️",          - CMake: -S -B
    "Conan ⚔️",              - Conan: install
    "Clean 🧹",             - rm -rf respective folder
    "Install 📌",           - CMake: --build --target install
    "Licenses 📜",          - CMake: --build --target write-licenses

                            [ the same as above but splited for only Standalone or Lib ]
    "Build Standalone",     
    "Rebuild Standalone",
    "Configure Standalone",
    "Conan Standalone",
    "Clean Standalone",
    "Install Standalone",
    "Licenses Standalone",
                            
    "Build Library",
    "Rebuild Library",
    "Configure Library",
    "Conan Library",
    "Clean Library",
    "Install Library",
    "Licenses Library",
```                

### Screen shot of menu selector
<div style="text-align:center">
  <img width="773" alt="image" src="https://github.com/user-attachments/assets/edfaab22-feb2-4c69-89bc-908501e9252e" />
</div>


### My Goal 🎯

To create a project template for myself that is flexible, works out of the box, and saves me a lot of time.

### The Result of My Efforts 🚀

Is a modular and intelligently designed project structure that gives me enormous flexibility and decision-making power at every point on how the project will be configured. For others, it may take a while to get used to the project, but in return, you will be pleasantly surprised at how simple it actually is. 😄

### Dependencies 🔃

 - Linux 🐧 or Mac
 - VSCode - https://code.visualstudio.com
 - CMake - https://cmake.org/download/
 - Python3 - https://www.python.org/downloads/
 - Conan2 Configurator - https://docs.conan.io/2/installation.html
 - Compilers - https://gcc.gnu.org, https://clang.llvm.org, ...
 - Cmake-formatter - https://cmake-format.readthedocs.io/en/latest/
 - Clang-formatter - https://clang.llvm.org/docs/ClangFormat.html
 - Cross-compiler with a toolchain and a sysroot - https://crosstool-ng.github.io

### Quick Start 💣

```bash
# clone 
git clone https://github.com/tomasmark79/MarkWareVCMake ./NameOfMyAwesomeApp
cd NameOfMyAwesomeApp/
code .
```

### ToDo

- 🚧 add installation CMake configuration
- prepare list of commands to only CLI workflow
- port to MS Windows family OS
- included some other features useful for devs

### Project Structure

```txt
tree -a --prune -I '.git|Build|Hidden'
.
├── .clang-format - configuration file for clang-format, a tool to format C/C++/Java/JavaScript/Objective-C/Protobuf code
├── cmake - directory containing CMake-related scripts and modules
│   ├── CPM.cmake - is a cross-platform CMake script that adds dependency management capabilities to CMake
│   ├── Modules - directory for custom CMake modules
│   │   └── FindX11.cmake - custom CMake module to find X11 libraries
│   └── tools.cmake - CMake script for additional tools and utilities
├── CMakeController.sh - shell script to control CMake build process
├── .cmake-format - configuration file for cmake-format, a tool to format CMake scripts
├── CMakeLists.txt - main CMake build script for library
├── CMakeUserPresets.json - JSON file containing user presets for CMake
├── conanfile.txt - Conan package manager configuration file
├── .gitattributes - Git configuration file for defining attributes per path
├── .gitignore - Git configuration file to specify untracked files to ignore
├── include - directory containing header files
│   └── VCMLib - directory for VCMLib library headers
│       └── VCMLib.hpp - header file for VCMLib library
├── LICENSE - license file for the project
├── .python-version - file specifying the Python version for the project
├── README.md - markdown file containing the project documentation
├── Source - directory containing source files
│   └── VCMLib.cpp - source file for VCMLib library
├── Standalone - directory for standalone application
│   ├── CMakeLists.txt - CMake build script for standalone application
│   ├── LICENSE - license file for standalone application
│   └── Source - directory containing source files for standalone application
│       └── Main.cpp - main source file for standalone application
├── TemplateRenamer.sh - shell script to rename names for standalone and library
└── .vscode - directory containing Visual Studio Code configuration files
├── c_cpp_properties.json - VSCode configuration file for C/C++ properties
├── keybindings.json - VSCode configuration file for custom keybindings
├── launch.json - VSCode configuration file for debugging settings
├── settings.json - VSCode configuration file for workspace settings
└── tasks.json - VSCode configuration file for defining tasks
```

##### Useful to Know

`└── TemplateRenamer.sh`

This shell script is a very powerful renamer for the entire project. After cloning the repository into your folder, you can use this script to create your own names for both the library and the application. The names must not be the same.

```bash
Usage: ./TemplateRenamer.sh <old_lib_name> <new_lib_name> <old_standalone_name> <new_standalone_name>
```
  
### My Code Codex
               
I use capital letters at the beginning of words for naming all new folders and files.  
One exception: No capital letter in the "include" folder is intentional!


### Inspirations and help for you

I drew inspiration from the following projects:

- [ModernCppStarter](https://github.com/TheLartians/ModernCppStarter)
- [PackageProject.cmake](https://github.com/TheLartians/PackageProject.cmake)
- [CPM.cmake](https://github.com/cpm-cmake/CPM.cmake)
- [CPMLicenses.cmake](https://github.com/cpm-cmake/CPMLicenses.cmake.git)
- 


Thanks to Sleepy Monax for Mac OS feedback.

---

### About Me 👨‍💻

"The result of a lot of hours of incredible work. Time seemed to stand still. The outcome is a template that takes C++ development to a whole new level. 
    
"Buy me a coffee ☕🍵 or spare some time. 🙂"

Tomáš Mark 2024

```
paypal.me/TomasMark
Bitcoin: 3JMZR6SQo65kLAxxxXKrVE7nBKrixbPgSZ
Ethereum: 0x7a6C564004EdecFf8DD9EAd8bD4Bbc5D2720BeE7
```
