#include <VCMLib/VCMLib.hpp>
#include <Logger/Logger.hpp>
#include <cxxopts.hpp>
#include <iostream>
#include <fstream>
#include <memory>

// MIT License
// Copyright (c) 2024-2025 Tomáš Mark

constexpr char standaloneName[] = "VCMStandalone";

// ==============================================================================
//
// ==============================================================================
#ifdef NDEBUG
constexpr char build_type[] = "Release";
#else
constexpr char build_type[] = "Debug";
#endif

int main(int argc, const char* argv[]) {
  LOG.info(standaloneName);
  LOG.info("C++ " + std::to_string(__cplusplus));
  LOG.debug(build_type);

  try {
    // clang-format off

    // ==============================================================================
    // Initialize options
    // ==============================================================================
    auto options = std::make_unique<cxxopts::Options>(argv[0], standaloneName);
    options->positional_help("[optional args]").show_positional_help();
    options->set_width(70)
      .set_tab_expansion()
      .allow_unrecognised_options()
      .add_options()
      ("h,help", "Show help")
      ("a,assets", "Omit assets loading", cxxopts::value<bool>()->default_value("false"))
      ("o,omit", "Omit library loading", cxxopts::value<bool>()->default_value("false"));
    // clang-format on

    auto result = options->parse(argc, argv);
  
    // ==============================================================================
    // Show help
    // ==============================================================================
    if (result.count("help")) {
      LOG << Logger::Level::LOG_INFO << options->help({"", "Group"})
          << std::endl;
      return 0;
    }

    // ==============================================================================
    // Set assets path depending on platform
    // ==============================================================================
    if (result.count("assets")) {
      LOG << Logger::Level::LOG_WARNING << "Loading assets omitted [-a]"
          << std::endl;
    } else {
      const auto getAssetsRelativePath = []() -> std::string {
#ifdef _WIN32
        return "../assets/IAmAsset.txt";
#elif defined(__unix__) || defined(__linux__) || defined(__FreeBSD__) || defined(__APPLE__)
        return "../share/VCMStandalone/assets/IAmAsset.txt";
#else
        LOG.error("Set your platform path for assets folder");
        exit(1);
#endif
      };
      LOG << Logger::Level::LOG_INFO
          << "Asset file path: " << getAssetsRelativePath() << std::endl;
    }

    // ==============================================================================
    // Load library
    // ==============================================================================
    if (!result.count("omit")) {
      std::unique_ptr<library::VCMLib> lib(new library::VCMLib());
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