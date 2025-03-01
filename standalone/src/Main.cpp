#include <VCMLib/VCMLib.hpp>
#include <Logger/Logger.hpp>
#include <cxxopts.hpp>
#include "SanitizerTest.hpp"
#include <memory>

// MIT License
// Copyright (c) 2024-2025 Tomáš Mark

#ifdef NDEBUG
constexpr char build_type[] = "Release";
#else
constexpr char build_type[] = "Debug";
#endif

int main(int argc, const char* argv[]) {
  char hw[] = "Welcome in MarkWare VCMake!";
  { LOG.info("C++ " + std::to_string(__cplusplus)); }
  { LOG.debug(build_type); }
  { LOG.warning(hw); }
  { LOG.error("No Error"); }
  { LOG.critical("No Critical"); }

  try {
    std::unique_ptr<cxxopts::Options> allocated(
        new cxxopts::Options(argv[0], " - example command line options"));
    auto& options = *allocated;
    options.positional_help("[optional args]").show_positional_help();

    // clang-format off

    options.set_width(70)
      .set_tab_expansion()
      .allow_unrecognised_options()
      .add_options()
      ("h,help", "Show help")
      ("o,ommit", "Ommit library", cxxopts::value<bool>()->default_value("false"))
      ("s,sanitizer", "Sanitizer test", cxxopts::value<bool>()->default_value("false"));

    // clang-format on

    auto result = options.parse(argc, argv);

    if (result.count("help")) {
      std::cout << options.help({"", "Group"}) << std::endl;
      return 0;
    }

    if (!result.count("ommit")) {
      std::cout << "Ommit library loading" << std::endl;
      std::unique_ptr<library::VCMLib> lib(new library::VCMLib());
    }

    if (result.count("sanitizer")) {
      sanitizerTest::scream();
    }

  } catch (const cxxopts::exceptions::exception& e) {
    std::cout << "error parsing options: " << e.what() << std::endl;
    return 1;
  }

  // try {
  //   std::unique_ptr<library::VCMLib> lib(new library::VCMLib());
  //   sanitizerTest::scream();
  // } catch (std::exception& e) { LOG.error(e.what()); }

  return 0;
}