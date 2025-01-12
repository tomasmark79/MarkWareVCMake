[![Ubuntu](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/ubuntu.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/ubuntu.yml)
[![MacOS](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/macos.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/macos.yml)
[![Windows](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/windows.yml/badge.svg)](https://github.com/tomasmark79/MarkWareVCMake/actions/workflows/windows.yml)  

# Tomas `Mark` Soft `Ware` `V`irtual `CMake` template  

- For advanced Medior+ developers
- C/C++ development in VSCode
- Works on Linux 🐧, macOS 🍏, and Windows 🪟
- Creates standalone executables and libraries
- Includes modern CMake templates with a built-in debugger
- Compatible with Conan
- Supports cross-compilation
- Compatible with SSH and WSL
- Flexible and highly configurable
- Follows best practices
- Works out of the box if dependencies are met

## Introduction

🌟🌟🌟  

This template started as a small C++ project and gradually became larger and larger. From the very beginning, I created the template with the goal of having a flexibly designed solution. As I gradually added more and more important features, the project may seem quite large at first glance. However, every file in the project structure has its justification, and nothing is unnecessarily redundant.

**Note:** To understand this project, you will need several hours, maybe days. The reward should be that you will subsequently be able to build any large project within 30 minutes, which will stand on solid foundations of the modern world.

🌟🌟🌟

---

## Integrated Tools and Configurations

The project contains its own **Main.cpp**, which is the main entry point for the standalone executable. It also includes **one header file** and **one implementation file** for the library. Thus, the project consists of one executable file and one library that is linked to this executable file. Together, they work in tandem.

The project also includes custom Python scripts that manage the entire workflow. These scripts come with preconfigured CMake settings, task configurations, debugger settings, and more. Everything is ready and functional right out of the box.

**Note:** The only requirement is to have all the **dependencies installed** that this project needs to function correctly.

### Technologies You Need

- **Visual Studio Code**: Preconfigured for seamless development.  
   [https://code.visualstudio.com/](https://code.visualstudio.com/)
    - [C++ Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)
    - [Better C++ Syntax](https://marketplace.visualstudio.com/items?itemName=jeff-hykin.better-cpp-syntax)
    - [Cpp Reference](https://marketplace.visualstudio.com/items?itemName=Guyutongxue.cpp-reference)
    - [C++ Class Creator](https://marketplace.visualstudio.com/items?itemName=FleeXo.cpp-class-creator)
    - [C++ Helper](https://marketplace.visualstudio.com/items?itemName=amiralizadeh9480.cpp-helper)
    - [CMake](https://marketplace.visualstudio.com/items?itemName=twxs.cmake)
    - [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools)
    - [GitHub Actions](https://marketplace.visualstudio.com/items?itemName=github.vscode-github-actions)
    - [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)
    - [Open HTML in Browser](https://marketplace.visualstudio.com/items?itemName=peakchen90.open-html-in-browser)
    - [Reload](https://marketplace.visualstudio.com/items?itemName=natqe.reload)
    - [Remote - SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)
    - [Remote - SSH: Editing Configuration Files](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh-edit)
    - [Remote Server](https://marketplace.visualstudio.com/items?itemName=ms-vscode.remote-server)
    - [Remote Development Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)
    - [Remote Explorer](https://marketplace.visualstudio.com/items?itemName=ms-vscode.remote-explorer)
    - [Remote - WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl)
- **Pyenv**: Simplifies Python version management.  
   [https://github.com/pyenv/pyenv](https://github.com/pyenv/pyenv)
- **Python 3**: Required for the project's internal workflow.  
   [https://www.python.org/downloads/](https://www.python.org/downloads/)
- **Conan 2**: Simplifies dependency management.  
   [https://docs.conan.io](https://docs.conan.io)
- **CMake**: Ideally the latest version.  
   [https://cmake.org/download/](https://cmake.org/download/)
- **Formatters**: Preconfigured for consistent code formatting.  
   - [Clang Format](https://clang.llvm.org/docs/ClangFormat.html)  
   - [CMake Format](https://cmake-format.readthedocs.io/en/latest/) 

### Technologies already included in the template

- **CPM.cmake**: Lightweight dependency management as an add-in if necessary.  
   [https://github.com/cpm-cmake/CPM.cmake](https://github.com/cpm-cmake/CPM.cmake)  
- **CPM.license**: Automates third-party license management.  
   [https://github.com/cpm-cmake/CPMLicenses.cmake](https://github.com/cpm-cmake/CPMLicenses.cmake)
- **ModernCppStarter**: Inspired by industry best practices for initializing C++ projects.  
   [https://github.com/TheLartians/ModernCppStarter](https://github.com/TheLartians/ModernCppStarter)
- **GitHub Action Workflows**: Actively monitors the source code status across all major platforms.  
   [https://github.com/tomasmark79/MarkWareVCMake/actions](https://github.com/tomasmark79/MarkWareVCMake/actions)
   
As you can see, there is quite a bit that needs to be correctly installed on your system. Additionally, cross-tool tools are missing here, which are used to create a toolchain tailored precisely to your requirements.

**Note:** Combining Conan 2 and CPM.cmake is generally not recommended, but it is not prohibited either. If you approach the dependency management concept with Conan 2 as the primary dependency manager and CPM.cmake as a supplementary dependency manager, everything will be fine. **Just make sure to watch out for conflicts.**

---

## Quick start

### Linux, MacOS

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

3. Install **Conan** via Python:
   ```bash
   pip install conan
   conan profile detect --force
   ```  

### Windows native 🪟

1. Install and configure **Pyenv** in Powershell:  
   [Powershell Installation Steps](https://github.com/pyenv-win/pyenv-win/blob/master/docs/installation.md#powershell)  
    ```powershell
    pyenv install 3.9.2
    pyenv global 3.9.2
    pyenv local 3.9.2
    pip install --upgrade pip
    ```

3. Install **Conan** in Powershell:
    ```powershell
    pip install conan
    conan profile detect --force
    ```  

### Windows 🪟 via WSL 🐧

1. Enable WSL in Powershell and install for ex. Debian based distro:
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

## Let`s go to start clone repo and build your first project!

🚀🚀🚀  

1. Clone the template:
   ```bash
   git clone https://github.com/tomasmark79/MarkWareVCMake
   cd MarkWareVCMake/
   ```

2. You may rename Standalone and Library name:
   ```bash
   python SolutionRenamer.py VCMLib MyLibrary VCMStandalone MyStandalone
   ```

3. Open the project in VSCode:
   ```bash
   code .
   ```
4. If you have all the necessary dependencies installed, set up the keyboard shortcuts for convenient control. These shortcuts are already prepared for you in the `keybindings.json` file. You need to copy the content into the system `keybindings.json` file, which can be found through the VSCode settings.

5. Once the keyboard shortcuts are functional, you can start controlling the entire setup.

6. Press `Shift+F7` to display the menu where you can choose from the available actions.

7. To simplify things at the beginning, just hit `Zero to Release 🚀`. If everything is in order, tarball archives will be created in the `Build/Artefacts` folder at the end of the process. If not, you will see an error that you need to fix to complete the build process.

🚀🚀🚀

## Detailed VSCode tasks description

**Note:** All the tasks listed below are already prepared for you and are part of every project you clone. For the keyboard shortcuts to work correctly, remember that they must be set in the system file and not just in the project folder.

### MarkWare Tasks

| Key binding set to                | ` SHIFT + F7`                                                 |      
| --------------------------------- | ------------------------------------------------------------- |
| **Zero to Hero**                  | Clean → Conan → Configure → Build                             |
| **Zero to Release**               | Clean → Conan → Configure → Build → Install → Tarball release |
| **Clean**                         | Removes the entire build folder                               |
| **Conan**                         | Builds Conan dependencies                                     |
| **Configure**                     | Configures CMake                                              |
| **Configure with CMake Debugger** | Configures CMake with a debugger. Requires CMake > 3.27 & CMake Tools VSCode extension. An awesome feature to debug CMakeLists.txt files. It is simple: add a breakpoint to any line in CMakeLists.txt and start this task. If a message `Running with debugger on.` and `Waiting for debugger client to connect...` appears in the console, you have to launch the `Debug CMake configuration` task defined in launch.json. Or press Ctrl+C to break this action. |
| **Build** `F7`                    | Builds the project.                                            |
| **Collect Licenses**              | Gathers licenses from CPM dependencies.                        |
| **Install Artifacts**             | Installs to **/Build/Installed/**.                             |
| **Release Artifacts**             | Creates tarballs in **/Build/Artifacts/**.                     |
| **Conan graph.html**              | Creates an HTML output of Conan dependencies.                  |
| **Lint C/C++**                    | Runs diagnostics on C/C++ files.                               |
| **Format C/C++**                  | Formats C/C++ files.                                           |
| **Format CMake**                  | Formats CMake files.                                           |

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

## Special Operations

### Rename script for Standalone & Library renaming

When you clone my template to your local disk at the beginning, one of the first things you will want to do is **rename** the names of the standalone application and the library. If this had to be done manually, it would be very cumbersome, so I created another Python script. `SolutionRenamer.py` changes all the necessary strings, including those that define object classes. **It is ideal to use this renaming right at the beginning to avoid manual work later on.**


### Upgrade Itself

Since the template is continuously evolving, I have also created an additional Python script, `SolutionUpgrader.py`, which allows updating the uncommented files defined within this script. Open the script and uncomment the files you want to be updated. The script creates a backup in case you accidentally update a file that was important to you. The update process involves downloading the latest files from the GitHub repository.

---

## Additional Build Settings

### The solution creates 4 build types as a classic CMake Layout

- `Debug`, `Release`, `RelWithDebInfo`, `MinSizeRel`

### Conan 2 and cmake_layout

**Note**: Since this is a custom workflow solution, it is prohibited to use CMake Layout in the `conanfile.py` settings. Other options can be used.

```python
   # it should remain commented
    # def layout(self):
      # cmake_layout(self)
```       

### The project also supports cross-compilation

**Note**: You will normally use the `Default` setting out of the box because it uses the compiler found in the system. Conan created a profile named `default` using the `conan profile detect` command, and this profile will be used by this setting.

Other settings are essentially additional profiles for the Conan manager that I have created using existing toolchains and actively use. For this reason, I have left them in the template for you as well. 

- `x86_64-bookworm-linux-gnu` (requires cross-compilation toolchain)  
- `x86_64-w64-mingw32` (requires cross-compilation toolchain)  
- `aarch64-linux-gnu` (requires cross-compilation toolchain)  

It is easy to add a new architecture.

---

## Command Line

### Command Line Control
Command line control of projects is also available.

**The real intention of this template is to completely avoid the command line unless absolutely necessary.**

However, there may be situations where manual work is required. Therefore, I have provided some task scenarios as examples. You can extract these commands yourself from the `SolutionController.log` file, which is automatically created in the main directory of the project's file system when using VSCode tasks. In any case, if Visual Studio Code is not available, you can maintain the projects using just command line commands.

---

### Comparison: What This Project Offers Over Other Existing Projects

|                                          | MarkWareVCMake                         | ModernCppStarter | cmake_template |
| ---------------------------------------- | -------------------------------------- | ---------------- | -------------- |
| Minimal setup required                   | yes                                    | yes              | yes            |
| CMake configure with Debugger            | **yes**                                | no               | no             |
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
