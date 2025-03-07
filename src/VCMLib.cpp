#include <VCMLib/VCMLib.hpp>
#include <VCMLib/version.h>
#include <iostream>

// MIT License
// Copyright (c) 2024-2025 Tomáš Mark

namespace library {

  VCMLib::VCMLib() {
    std::cout << "--- VCMLib v." << VCMLIB_VERSION << " instantiated ---"
              << std::endl;
  }

  VCMLib::~VCMLib() {
    std::cout << "--- VCMLib uninstantiated ---" << std::endl;
  }

}  // namespace library