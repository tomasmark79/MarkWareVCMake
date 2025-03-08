#include "Logger/Logger.hpp"
#include "VCMLib/VCMLib.hpp"
#include "Utils.hpp"
#include <cxxopts.hpp>
#include <fstream>
#include <iostream>
#include <memory>

// MIT License
// Copyright (c) 2024-2025 Tomáš Mark

constexpr char standaloneName[] = "VCMStandalone";
std::string standaloneExecutablePath = getExecutableDirectory();

#ifndef ASSET_PATH
  #define ASSET_PATH ""
#endif
#ifndef FIRST_ASSET_FILE
  #define FIRST_ASSET_FILE ""
#endif
#ifndef ASSET_FILES
  #define ASSET_FILES ""
#endif

/// @brief Main Standalone entry point
int main(int argc, const char *argv[]) {

  // ---basic-information------is-safe-to-delete 👇🏻
  LOG.info(standaloneName);
  LOG.info("C++ " + std::to_string(__cplusplus));
  // ----------------------------------delete me 👆🏻

  // ---assets-testing---------is-safe-to-delete 👇🏻
  std::string assetFp = standaloneExecutablePath + "/" +
                        static_cast<std::string>(ASSET_PATH) + "/" +
                        static_cast<std::string>(FIRST_ASSET_FILE);
  std::ifstream file(assetFp);
  try {
    if (file.is_open()) {
      LOG.info("Opened first asset file: " + assetFp);
    } else {
      LOG.error("No assets found: " + assetFp);
    }
  } catch (const std::exception &e) {
    LOG.error("Error opening first asset file: " + assetFp);
  }
  // ----------------------------------delete me 👆🏻

  // ---argument-parsing-------is-safe-to-delete 👇🏻
  try {
    // clang-format off
    auto options = std::make_unique<cxxopts::Options>(argv[0], standaloneName);
    options->positional_help("[optional args]").show_positional_help();
    options->set_width(70)
      .set_tab_expansion()
      .allow_unrecognised_options()
      .add_options()
      ("h,help", "Show help")
      ("o,omit", "Omit library loading", cxxopts::value<bool>()->default_value("false"));
    // clang-format on

    const auto result = options->parse(argc, argv);

    if (result.count("help")) {
      LOG << Logger::Level::LOG_INFO << options->help({"", "Group"})
          << std::endl;
      return 0;
    }
    if (!result.count("omit")) {
      std::unique_ptr<library::VCMLib> lib =
          std::make_unique<library::VCMLib>();
    } else {
      LOG << Logger::Level::LOG_WARNING << "Loading library omitted [-o]"
          << std::endl;
    }
  } catch (const cxxopts::exceptions::exception &e) {
    LOG << Logger::Level::LOG_ERROR << "error parsing options: " << e.what();
    return 1;
  }
  // ----------------------------------delete me 👆🏻

  return 0;
}