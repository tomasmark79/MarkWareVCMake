#include "MWVCLib/MWVCLib.hpp"

#include <iostream>
#include <mwvclib/version.h>

/* Start configure 📚 with CTRL + SHIFT + C */

MWVCLib::MWVCLib()
{

    std::cout << "MarkWareVCMakeLibrary version: " << std::endl;
    std::cout << "Version: " << MWVCLIB_VERSION << std::endl;
}

MWVCLib::~MWVCLib() {}
