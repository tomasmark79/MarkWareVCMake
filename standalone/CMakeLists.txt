cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

cmake_policy(SET CMP0048 NEW) # project() command manages VERSION variables
cmake_policy(SET CMP0076 NEW) # target_sources() command creates usage requirements
cmake_policy(SET CMP0091 NEW) # MSVC runtime library flags are selected by an abstraction

# MIT License
# Copyright (c) 2024-2025 Tomáš Mark

#+-+-+-+-+-+-+-+-+-+-+
#|s|t|a|n|d|a|l|o|n|e|
#+-+-+-+-+-+-+-+-+-+-+

# === shared libraries
option(BUILD_SHARED_LIBS "Build using shared libraries" OFF)
# === runtime
include(../cmake/mw-runtime.cmake)
option(USE_STATIC_RUNTIME "Link against static runtime libraries" OFF)
# === sanitizer
include(../cmake/mw-sanitizer.cmake)
option(SANITIZE_ADDRESS "Enable Address sanitizer" OFF)
option(SANITIZE_UNDEFINED "Enable Undefined Behavior sanitizer" OFF)
option(SANITIZE_THREAD "Enable Thread sanitizer" OFF)
option(SANITIZE_MEMORY "Enable Memory sanitizer" OFF)
# === hardening
include(../cmake/mw-hardening.cmake)
option(ENABLE_HARDENING "Enable security hardening options" OFF)
# === ipo
include(../cmake/mw-ipo.cmake)
option(ENABLE_IPO "Enable Interprocedural Optimization" OFF)
# === ccache
include(../cmake/ccache.cmake)
option(ENABLE_CCACHE "Enable ccache" ON)

# Linting C/C++ code
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# ==============================================================================
# Project attributes
# ==============================================================================
set(STANDALONE_NAME VCMStandalone)
string(TOLOWER "${STANDALONE_NAME}" STANDALONE_NAME_LOWER)
set(STANDALONE_NAMESPACE dsdotname)
project(
    ${STANDALONE_NAME}
    LANGUAGES C CXX ASM
    DESCRIPTION "template Copyright (c) 2024 TomasMark [at] digitalspace.name"
    HOMEPAGE_URL "https://github.com/tomasmark79")

# ---- Include guards ----
if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(
        WARNING
            "In-source builds. Please make a new directory (called a Build directory) and run CMake from there."
    )
endif()

# ==============================================================================
# System / Conan dependencies
# ==============================================================================
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")

# ==============================================================================
# CPM.cmake dependencies - take care conflicts
# ==============================================================================
include(../cmake/CPM.cmake)
CPMAddPackage(NAME VCMLib SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/..)
cpm_licenses_create_disclaimer_target(
    write-licenses-${STANDALONE_NAME}
    "${CMAKE_CURRENT_BINARY_DIR}/${STANDALONE_NAME}_third_party.txt" "${CPM_PACKAGES}")
CPMAddPackage(
    GITHUB_REPOSITORY jarro2783/cxxopts
    VERSION 3.2.0
    OPTIONS "CXXOPTS_BUILD_EXAMPLES NO" "CXXOPTS_BUILD_TESTS NO" "CXXOPTS_ENABLE_INSTALL NO")
# ==============================================================================
# src/ for source files and `internal` header files that are not intended for public use
# ==============================================================================
file(
    GLOB_RECURSE
    sources
    CONFIGURE_DEPENDS
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.h
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.hh
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.hxx
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cxx)

# ==============================================================================
# Create target
# ==============================================================================
add_executable(${STANDALONE_NAME} ${sources})

apply_ccache(${STANDALONE_NAME})
apply_hardening(${STANDALONE_NAME})
apply_sanitizers(${STANDALONE_NAME})

# ==============================================================================
# Set compile properties
# ==============================================================================
set_target_properties(${STANDALONE_NAME} PROPERTIES OUTPUT_NAME "${STANDALONE_NAME}")

# ==============================================================================
# Set linking
# ==============================================================================
target_link_libraries(${STANDALONE_NAME} PRIVATE dsdotname::VCMLib cxxopts)

# ==============================================================================
# Add missing installation exports
# ==============================================================================
install(TARGETS ${STANDALONE_NAME} RUNTIME DESTINATION bin)
