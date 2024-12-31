#include "VCMLib/VCMLib.hpp"

// #include <EmojiTools/EmojiTools.hpp> // yet dissabled
#include <iostream>
#include <vcmlib/version.h>

VCMLib::VCMLib()
{
    std::cout << "--- VCMLib v." << VCMLIB_VERSION << " instantiated ---" << std::endl;
}

VCMLib::~VCMLib()
{
    std::cout << "--- VCMLib uninstantiated ---" << std::endl;
}
