#include <VCMLib/VCMLib.hpp>
#include <Logger/Logger.hpp>
#include <memory>

// MIT License
// Copyright (c) 2024-2025 Tomáš Mark

namespace san {
  void scream() {
    char cS[2];
    cS[3] = 'a';
    int* cSA = new int[3];
    delete[] cSA;
    cSA[22] = 0;
  }
}  // namespace san

int main() {
  
  #ifdef NDEBUG
  LOG.info("Release configuration!");
  #else
  LOG.info("Debug configuration!");
  #endif

  char hw[] = "Hello, World!";
  std::unique_ptr<library::VCMLib> lib;
  try {
    lib.reset(new library::VCMLib());  // c++11
    // lib = std::make_unique<library::VCMLib>();  // c++14
    //san::scream();
    { LOG.info(hw); }
    { LOG.debug(hw); }
    { LOG.warning(hw); }
    { LOG.error(hw); }
  } catch (std::exception& e) { LOG.error(e.what()); }
  return 0;
}  // main