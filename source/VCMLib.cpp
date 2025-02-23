#include <VCMLib/version.h>
#include <VCMLib/VCMLib.hpp>
#include <iostream>

namespace library {

  VCMLib::VCMLib() {
    std::cout << "--- VCMLib v." << VCMLIB_VERSION << " instantiated ---"
              << std::endl;
  }

  VCMLib::~VCMLib() {
    std::cout << "--- VCMLib uninstantiated ---" << std::endl;
  }

}  // namespace library