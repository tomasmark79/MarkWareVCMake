#include <VCMLib/VCMLib.hpp>
#include <chrono>
#include <iostream>
#include <memory>
#include <thread>
#include <vcmlib/version.h>

// Standalone main entry point

auto main(int argc, char *argv[], char *env[]) -> int
{
    // init VCMLib instance
    std::unique_ptr<VCMLib> Lib = std::make_unique<VCMLib>();

    // five seconds delay
    std::this_thread::sleep_for(std::chrono::seconds(5));

    // bye bye
    std::cout << "Bye bye!" << std::endl;

    return 0;
}
