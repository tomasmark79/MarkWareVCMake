#include "VCMLib/VCMLib.hpp"

#include <EmojiToolsLib/EmojiToolsLib.hpp>
#include <iostream>

#ifdef ENABLE_OPENSSL
#    include <openssl/crypto.h>
#    include <openssl/ssl.h>
#endif

// Those are the implementations of the class VCMLib
// (c) Tomáš Mark 2024

VCMLib::VCMLib()
{

    std::cout << "-- MarkWare VCMake Library Linked --" << std::endl;

#ifdef OPENSSL_VERSION
    std::cout << OPENSSL_VERSION << std::endl;
#endif
}

VCMLib::~VCMLib() { std::cout << "-- MarkWare VCMake Library Unlinked --" << std::endl; }
