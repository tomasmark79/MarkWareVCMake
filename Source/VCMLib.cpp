#include "VCMLib/VCMLib.hpp"

#include <EmojiTools/EmojiTools.hpp>
#include <iostream>
#include <vcmlib/version.h>

#include "bzlib.h"
#include <curl/curl.h>

// Library implementation

VCMLib::VCMLib()
{
    std::cout << "--- VCMLib v." << VCMLIB_VERSION << " instantiated ---" << std::endl;

    std::cout << "--- " << curl_version() << " linked ---" << std::endl;
    std::cout << "--- " << BZ2_bzlibVersion() << " linked ---" << std::endl;
}

VCMLib::~VCMLib()
{
    std::cout << "--- VCMLib uninstantiated ---" << std::endl;
}
