
#include <VCMLib/VCMLib.hpp>
#include <vcmlib/version.h>
#include <iostream>
#include <memory>

// You may set sanitizer flags in CMakeLists.txt
const bool TEST_SANITIZER = true;

namespace standalone
{
  void saySomething()
  {
    std::cout << "Something!" << std::endl;
  }
}

namespace sanitizer
{
  // You may set sanitizer flags in CMakeLists.txt
  void scream()
  {
    char checkSanitizer[2];
    checkSanitizer[3] = 'a';
    int* checkSanitizerArr = new int[10];
    delete[] checkSanitizerArr;
    checkSanitizerArr[0] = 0;
  }
}

int main()
{
  // c++14+
  // std::unique_ptr<library::VCMLib> lib = std::make_unique<library::VCMLib>();

  // c++11
  std::unique_ptr<library::VCMLib> lib(new library::VCMLib());

  sanitizer::scream();
  standalone::saySomething();

  return 0;
}