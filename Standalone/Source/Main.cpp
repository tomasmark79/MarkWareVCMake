
#include <VCMLib/VCMLib.hpp>
#include <vcmlib/version.h>
#include <chrono>
#include <iostream>
#include <memory>
#include <thread>

namespace Standalone
{} // namespace Standalone

int main()
{
  // c++14+ way to create a unique pointer
  std::unique_ptr<library::VCMLib> lib = std::make_unique<library::VCMLib>();

  // c++11 way to create a unique pointer
  // std::unique_ptr<library::VCMLib> lib(new library::VCMLib());

  // is-is-only-for-testing-purposes ------------👇🏻
  {
    char checkSanitizer[2];
    checkSanitizer[3] = 'a';
    int* checkSanitizerArr = new int[10];
    delete[] checkSanitizerArr;
    checkSanitizerArr[0] = 0;
  }
  // is-is-only-for-testing-purposes ------------👆🏻
  // is-is-only-for-testing-purposes ------------👇🏻
  {
    std::cout << "Wait for 5 seconds please ..." << std::endl;
    std::this_thread::sleep_for(std::chrono::seconds(5));
    std::cout << "Bye bye!" << std::endl;
  }
  // is-is-only-for-testing-purposes ------------👆🏻

  return 0;
}