#include "VCMLib/VCMLib.hpp"

#include <EmojiTools/EmojiTools.hpp>
#include <iostream>
#include <vcmlib/version.h>

// CPM dependencies example
#include <nlohmann/json.hpp>
using json = nlohmann::json;

// Conan dependencies example
// #include "bzlib.h"
// #include <curl/curl.h>

VCMLib::VCMLib()
{
    std::cout << "--- VCMLib v." << VCMLIB_VERSION << " instantiated ---" << std::endl;

    // remove me ------------------👇🏻
    json j = {
        {"pi", 3.141}
    };
    std::cout << "--- nlohmann/json.hpp" << j.dump() << " linked ---" << std::endl;
    // Conan dependencies example
    // std::cout << "--- " << curl_version() << " linked ---" << std::endl;
    // std::cout << "--- " << BZ2_bzlibVersion() << " linked ---" << std::endl;
    // remove me ------------------👆🏻
}

VCMLib::~VCMLib()
{
    std::cout << "--- VCMLib uninstantiated ---" << std::endl;
}
