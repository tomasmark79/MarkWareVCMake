#include "VCMLib/VCMLib.hpp"

#include <EmojiToolsLib/EmojiToolsLib.hpp>
#include <iostream>
#include <vcmlib/version.h>

#ifdef ENABLE_OPENSSL
#include <openssl/crypto.h>
#include <openssl/ssl.h>
#endif

#include <curl/curl.h>
#include "bzlib.h"

// Library implementation

VCMLib::VCMLib()
{
    std::cout << "--- VCMLib v." << VCMLIB_VERSION << " instantiated ---"
              << std::endl;

#ifdef OPENSSL_VERSION
    std::cout << "--- " << OPENSSL_VERSION_TEXT << " linked ---" << std::endl;
#endif

    std::cout << "--- " << curl_version() << " linked ---" << std::endl;
    std::cout << "--- " << BZ2_bzlibVersion() << " linked ---" << std::endl;
    
}

VCMLib::~VCMLib()
{
    std::cout << "--- VCMLib uninstantiated ---" << std::endl;
}
