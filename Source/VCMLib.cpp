#include "VCMLib/VCMLib.hpp"

#include <iostream>
#include <vcmlib/version.h>

/* Start build 🔨 with CTRL + ALT + B */

VCMLib::VCMLib()
{
    std::cout << "MarkWare VCMake Library version: " << std::endl;
    std::cout << "Version: " << VCMLIB_VERSION << std::endl;
}

VCMLib::~VCMLib() {}
