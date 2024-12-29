#include <VCMLib/VCMLib.hpp>
#include <vcmlib/version.h>

#include <chrono>
#include <iostream>
#include <thread>

int main()
{
    std::unique_ptr<VCMLib> Lib = std::make_unique<VCMLib>();

    // remove me ------------------👇🏻
    std::cout << "Wait for 2 seconds please ..." << std::endl;
    std::this_thread::sleep_for(std::chrono::seconds(2));
    std::cout << "Bye bye!" << std::endl;
    // remove me ------------------👆🏻
    
    return 0;
}
