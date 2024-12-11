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

/* -------------------------------------- 💡 --------------------------------------
- Ctrl+Alt+  C  configure Lib
- Ctrl+Alt+  S  configure S

- Ctrl+Alt+  B  build Lib
- Ctrl+Alt+  N  build S

- Ctrl+Alt+  L  clean Lib
- Ctrl+Alt+  K  clean S

- Ctrl+Alt   I  install Lib
- Ctrl+Alt+  J  install S

- Ctrl+Alt+  T  test Lib
- Ctrl+Alt+  U  test S

- Ctrl+Alt+  R  lint
- Ctrl+Alt+  F  format
- Ctrl+Alt+  M  cmake-format
-------------------------------------------------------------------------------- */
