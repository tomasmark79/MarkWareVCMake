#include <VCMLib/VCMLib.hpp>
#include <vcmlib/version.h>
#include <Logger.hpp>
#include <iostream>
#include <memory>

namespace standalone {
  constexpr const char* something = "Something!";
  void saySomething() { std::cout << something << std::endl; }
  void logSomething() { LOG.info(something); }
}  // namespace standalone

// You may set sanitizer flags in CMakeLists.txt - default is enabled
namespace sanitizer {
  void scream() {
    char checkSanitizer[2];
    checkSanitizer[3] = 'a';
    int* checkSanitizerArr = new int[10];
    delete[] checkSanitizerArr;
    checkSanitizerArr[22] = 0;
  }
}  // namespace sanitizer

int main() {

  // c++11
  std::unique_ptr<library::VCMLib> lib(new library::VCMLib());

  // c++14+
  // std::unique_ptr<library::VCMLib> lib = std::make_unique<library::VCMLib>();

  // sanitizer::scream();
  standalone::saySomething();
  standalone::logSomething();

  return 0;
}