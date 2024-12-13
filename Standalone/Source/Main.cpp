#include <VCMLib/VCMLib.hpp>
#include <iostream>
#include <vcmlib/version.h>

// Standalone applications are the ones that are not part of a library
// (c) Tomáš Mark 2024

auto main(int argc, char **argv) -> int
{
    VCMLib Lib;
    std::cout << "Version: " << VCMLIB_VERSION << std::endl;

    return 0;
}