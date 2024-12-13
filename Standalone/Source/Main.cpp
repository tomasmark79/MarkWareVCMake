#include <VCMLib/VCMLib.hpp>
#include <iostream>
#include <vcmlib/version.h>

// Start here
// 👉 ./ProjectRenamer.sh <old_lib_name> <new_lib_name> <old_standalone_name> <new_standalone_name>
// 👉 build 🔨 your new standalone app CTRL + ALT + C

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