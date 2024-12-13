
# MarkWare VCMake Template 🎁
v1.1.0rc2 

---

### Project Overview

- Another C++ template based on a modern structured foundation.
- This template incorporates the best ideas from environments like **VSCode**, **Modern CMake**, **CPM**, **ModernCppStarter**, and **C/C++**.
- It serves as a CMake wrapper replacement for the official CMake extension, which did not meet my specific needs.

#### The Fact

With this project and its settings, you can start developing in C++ within a few seconds.

### This C++ Template Project Consists of Two Parts:

- A C++ library
- A C++ standalone application that links with the library
  
### Implemented Features 

✅ - VSCode tasks for comfort  
✅ - VSCode key bindings template  
✅ - VSCode C/C++ debugger launcher  
✅ - Project renamer is awesome  
✅ - Debug - **F5**  
✅ - Interactive menu selection for all CMake tasks - **F7**  
✅ - Configure  
✅ - Cross Compile  
✅ - Clean  
✅ - Install  
✅ - C/C++ Lint - **ctrl+alt+l**  
✅ - C/C++ format (clang) - **ctrl+alt+m**  
✅ - CMake format - **ctrl+alt+f**

### TODO

- port to Windows, Mac
- some tests, sanitizing, ...

---

### Code Codex

I am using 🐫amel🐫ode🐫apitals.  
One exception: No capital letter in the "include" folder is intentional!

### Quick Start

```bash
sudo apt-get update
sudo apt-get install build-essential cmake -y
git clone https://github.com/tomasmark79/MarkWareVCMake
cd MarkWareVCMake/
code .
```

#### Rename your Library and Standalone in seconds

```bash
./TemplateRenamer.sh <old_lib_name> <new_lib_name> <old_standalone_name> <new_standalone_name>
```

---

### Template Parts Explanation

#### `.vscode/c_cpp_properties.json`

CPM is able to use cache. The path to the cache folder is stored here.

#### `.vscode/tasks.json` and `CMakeConfigure.sh`

Both files are used to smoothly glue CMake and VSCode. The result is a light and robust mechanism for controlling all CMake tasks.

#### `.vscode/launch.json`

It is the debugger definition. Thanks to predictability, it is defined out of the box. ;-)

#### `.vscode/keybindings.json`

My own keybindings. If you want to use them, you need to copy/paste the content to your user settings in `~/.config/Code/${user}/keybindings.json`.

---

### Thank You 

*To all the awesome people who share the same mindset as me* 🙏

### Thank to those

Use those links to get more documentation to used technologies in my template.

https://github.com/cpm-cmake/CPM.cmake

https://cmake.org

https://github.com/TheLartians/ModernCppStarter


---

### About Me 👨‍💻

"The result of a lot of hours of incredible fun. Time seemed to stand still. The outcome is a template that takes C++ development to a whole new level. 
    
"Buy me a coffee ☕🍵 or spare some time. 🙂"

```
paypal.me/TomasMark
Bitcoin: 3JMZR6SQo65kLAxxxXKrVE7nBKrixbPgSZ
Ethereum: 0x7a6C564004EdecFf8DD9EAd8bD4Bbc5D2720BeE7
```

I look forward to seeing your contributions!

### License
I built the project primarily for myself and for my future projects. If someone is interested in using the project for any purpose, they should, according to the license, mention my name in their project and also all the names of the projects that this project contains. For simplicity, I have listed the licenses that are related to the project and should be visibly mentioned in each project. Thank you for following the license terms!

Included MIT Licence

Copyright (c) Tomáš Mark 2024 

Copyright (c) 2019-2022 Lars Melchior and contributors

Copyright (c) 2020 Lars Melchior




