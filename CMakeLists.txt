cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

cmake_policy(SET CMP0091 NEW)

# ===========================
# Static or shared library
# ===========================
option(BUILD_SHARED_LIBS "Build using shared libraries" OFF)

# Linting C/C++ code
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# ===========================
# Project configuration
# ===========================
set(LIBRARY_NAME VCMLib)
string(TOLOWER "${LIBRARY_NAME}" LIBRARY_NAME_LOWER)
set(LIBRARY_NAMESPACE dsdotname)
project(
    ${LIBRARY_NAME}
    VERSION 0.0.10
    LANGUAGES C CXX ASM
    DESCRIPTION "library template Copyright (c) 2024 TomasMark [at] digitalspace.name"
    HOMEPAGE_URL "https://github.com/tomasmark79")

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(FATAL_ERROR "In-source builds not allowed.
        Please make a new directory (called a Build directory) and run CMake from there.")
endif()

# CPM.cmake configuration
include(cmake/tools.cmake)
include(cmake/CPM.cmake)

# ===========================
# CPM dependencies
# ===========================
CPMAddPackage("gh:fmtlib/fmt#11.0.2")
CPMAddPackage("gh:TheLartians/PackageProject.cmake@1.12.0")
CPMAddPackage("gh:cpm-cmake/CPMLicenses.cmake@0.0.7")
CPMAddPackage("gh:nlohmann/json@3.11.3")
CPMAddPackage("gh:tomasmark79/EmojiTools#main")

# CPM licenses generation target enough to exist at the top level of the project
cpm_licenses_create_disclaimer_target(write-licenses "${CMAKE_CURRENT_BINARY_DIR}/third_party.txt"
    "${CPM_PACKAGES}")

# ===========================
# find_packade section
# ===========================
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules")

find_package(Threads REQUIRED) # system

# find_package(X11 REQUIRED) # cmake/Modules/FindX11.cmake
# find_package(dpp CONFIG REQUIRED) # conan
# find_package(BZip2 REQUIRED) # conan
# find_package(CURL REQUIRED) # conan

# ===========================
# Source and header files Glob not recommended, but the simplest way for this template
# ===========================
file(
    GLOB_RECURSE
    headers
    CONFIGURE_DEPENDS
    ${CMAKE_CURRENT_SOURCE_DIR}/include/*.h
    ${CMAKE_CURRENT_SOURCE_DIR}/include/*.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/include/*.hh
    ${CMAKE_CURRENT_SOURCE_DIR}/include/*.hxx)
file(
    GLOB_RECURSE
    sources
    CONFIGURE_DEPENDS
    ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.c
    ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.cxx)

# ===========================
# Create library
# ===========================
add_library(${LIBRARY_NAME})
target_sources(${LIBRARY_NAME} PRIVATE ${headers} ${sources})

# ===========================
# Set library properties
# ===========================
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# if various C++ standards are used, use target_compile_features
# target_compile_features(${LIBRARY_NAME} PUBLIC cxx_std_17)

# ===========================
# Set library headers
# ===========================
# header-only libraries change all PUBLIC flags to INTERFACE and create an interface target:
# <add_library(${LIBRARY_NAME} INTERFACE)>
target_include_directories(
    ${LIBRARY_NAME}
    PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
    PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/Source> # for exceptions 😎
    $<INSTALL_INTERFACE:include/${LIBRARY_NAME}-${PROJECT_VERSION}>)

# ===========================
# Set library definitions
# ===========================
# note: generator expressions are evaluated during generation of the buildsystem, and not during processing of CMakeLists.txt files
target_compile_options(
    ${LIBRARY_NAME}
    PUBLIC "$<$<COMPILE_LANG_AND_ID:CXX,MSVC>:/permissive-;/W4>"
    PUBLIC "$<$<AND:$<NOT:$<COMPILE_LANG_AND_ID:CXX,MSVC>>,$<NOT:$<PLATFORM_ID:Darwin>>>:-Wall;-Wextra;-Wpedantic;-MMD;-MP>"
    PUBLIC "$<$<AND:$<NOT:$<COMPILE_LANG_AND_ID:CXX,MSVC>>,$<PLATFORM_ID:Darwin>>:-Wall;-Wextra;-Wpedantic>"
    )

# ===========================
# Set library linking
# ===========================
target_link_libraries(
    ${LIBRARY_NAME}
    PUBLIC Threads::Threads # System
    PRIVATE fmt::fmt # CPM
    PRIVATE $<BUILD_INTERFACE:dsdotname::EmojiTools>
    PRIVATE $<BUILD_INTERFACE:nlohmann_json::nlohmann_json>

    # Conan example
    # BZip2::BZip2
    # CURL::libcurl
)

# ===========================
# Set library installation
# ===========================
packageProject(

    # the name of the target to export
    NAME ${LIBRARY_NAME}

    # the version of the target to export
    VERSION ${PROJECT_VERSION}

    # a temporary directory to create the config files
    BINARY_DIR ${PROJECT_BINARY_DIR}

    # location of the target's public headers
    INCLUDE_DIR "/include"

    # should match the target's INSTALL_INTERFACE include directory
    INCLUDE_DESTINATION include/${LIBRARY_NAME_LOWER}-${PROJECT_VERSION}

    # (optional) option to install only header files with matching pattern
    INCLUDE_HEADER_PATTERN "*.h"

    # semicolon separated list of the project's dependencies
    DEPENDENCIES "fmt#11.0.2;CPMLicenses.cmake@0.0.7;json@3.11.3;EmojiTools@0.0.1"

    # (optional) create a header containing the version info Note: that the path to headers should be
    # lowercase
    VERSION_HEADER "${LIBRARY_NAME_LOWER}/version.h"

    # (optional) create a export header using GenerateExportHeader module
    EXPORT_HEADER "${LIBRARY_NAME_LOWER}/export.h"

    # (optional) install your library with a namespace (Note: do NOT add extra '::')
    NAMESPACE ${LIBRARY_NAMESPACE}

    # (optional) define the project's version compatibility, defaults to `AnyNewerVersion` supported
    # values: `AnyNewerVersion|SameMajorVersion|SameMinorVersion|ExactVersion`
    COMPATIBILITY AnyNewerVersion

    # (optional) option to disable the versioning of install destinations
    DISABLE_VERSION_SUFFIX YES

    # (optional) option to ignore target architecture for pack age resolution defaults to YES for
    # header only (i.e. INTERFACE) libraries
    ARCH_INDEPENDENT YES

    # (optional) option to generate CPack variables
    CPACK YES)

# ===========================
# Set installation directory
# ===========================
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/${LIBRARY_NAME} DESTINATION include/)
