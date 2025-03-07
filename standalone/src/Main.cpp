#include <VCMLib/VCMLib.hpp>
#include <Logger/Logger.hpp>
#include <cxxopts.hpp>
#include <iostream>
#include <fstream>
#include <memory>

// MIT License
// Copyright (c) 2024-2025 Tomáš Mark

constexpr char standaloneName[] = "VCMStandalone";

/// @brief process command line arguments
int parseTemplateOptions(int argc, const char* argv[]) {
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
    auto result = options->parse(argc, argv);
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
  } catch (const cxxopts::exceptions::exception& e) {
    LOG << Logger::Level::LOG_ERROR << "error parsing options: " << e.what();
    return 1;
  }
  return 0;
}

/// @brief Main Standalone entry point
int main(int argc, const char* argv[]) {
  LOG.info(standaloneName);
  LOG.info("C++ " + std::to_string(__cplusplus));
  LOG << Logger::Level::LOG_INFO << static_cast<std::string>(ASSET_PATH)
      << std::endl;
  LOG << Logger::Level::LOG_INFO << static_cast<std::string>(ASSET_FILES)
      << std::endl;

  return parseTemplateOptions(argc, argv);
}