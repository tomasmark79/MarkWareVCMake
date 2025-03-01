#include <VCMLib/VCMLib.hpp>
#include <Logger/Logger.hpp>
#include <cxxopts.hpp>
#include <iostream>
#include <memory>

// MIT License
// Copyright (c) 2024-2025 Tomáš Mark

constexpr char standaloneName[] = "VCMStandalone";

#ifdef NDEBUG
constexpr char build_type[] = "Release";
#else
constexpr char build_type[] = "Debug";
#endif

int main(int argc, const char* argv[]) {
  { LOG.info(standaloneName); }
  { LOG.info("C++ " + std::to_string(__cplusplus)); }
  { LOG.debug(build_type); }

  try {
    std::unique_ptr<cxxopts::Options> allocated(
        new cxxopts::Options(argv[0], standaloneName));
    auto& options = *allocated;

    options.positional_help("[optional args]").show_positional_help();

    // clang-format off

    options.set_width(70)
      .set_tab_expansion()
      .allow_unrecognised_options()
      .add_options()
      ("h,help", "Show help")
      ("o,ommit", "Ommit library loading", cxxopts::value<bool>()->default_value("false"));

    // clang-format on

    auto result = options.parse(argc, argv);

    if (result.count("help")) {
      LOG << Logger::Level::LOG_INFO << options.help({"", "Group"})
          << std::endl;
      return 0;
    }

    if (!result.count("ommit")) {
      std::unique_ptr<library::VCMLib> lib(new library::VCMLib());
    } else {
      LOG << Logger::Level::LOG_WARNING << "Loading library ommited [-o]"
          << std::endl;
    }

  } catch (const cxxopts::exceptions::exception& e) {
    LOG << Logger::Level::LOG_ERROR << "error parsing options: " << e.what();
    return 1;
  }

  return 0;
}