
#include <VCMLib/VCMLib.hpp>
#include <vcmlib/version.h>
#include <chrono>
#include <iostream>
#include <memory>
#include <thread>

int main()
{
  std::unique_ptr<VCMLib> lib = std::make_unique<VCMLib>(); // cpp14 +
  // std::unique_ptr<VCMLib> lib(new VCMLib()); // cpp11 -

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
