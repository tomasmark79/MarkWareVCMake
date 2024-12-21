cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

# ---- (c) Tomáš Mark 2024 ----

# ---- Project Library namespace::name  ----
set(PROJECT_LIBRARY_NAMESPACE dsdotname)
set(PROJECT_LIBRARY_NAME VCMLib) # for change use ./TemplateRenamer.sh

# ---- Generate Static/Shared targets (used by Conan as well) ----
option(BUILD_SHARED_LIBS "Build using shared libraries" OFF)

# ---- Project ----
project(${PROJECT_LIBRARY_NAME} VERSION 0.0.1 LANGUAGES C CXX ASM)

# ---- Include guards ----
if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(
        FATAL_ERROR
        "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there."
    )
endif()

# ---- CPMs  ----
include(cmake/CPM.cmake)

# include(cmake/Dependencies.cmake)
CPMAddPackage("gh:TheLartians/PackageProject.cmake@1.12.0")
CPMAddPackage("gh:fmtlib/fmt#11.0.2")
CPMAddPackage("gh:cpm-cmake/CPMLicenses.cmake@0.0.7")

if(CPMLicenses.cmake_ADDED)
    cpm_licenses_create_disclaimer_target(
        write-licenses-${PROJECT_LIBRARY_NAME} "${CMAKE_CURRENT_BINARY_DIR}/third_party.txt"
        "${CPM_PACKAGES}"
    )
endif()

CPMAddPackage(NAME EmojiTools GITHUB_REPOSITORY tomasmark79/EmojiTools GIT_TAG main OPTIONS "EMOJI_INSTALL NO")

# ---- CMake Modules ----
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake/Modules")

find_package(Threads REQUIRED)
find_package(X11 REQUIRED)

# ---- Conan ----
# find_package(dpp CONFIG REQUIRED) # CONFIG means find_package require dpp-config.cmake file
find_package(BZip2 REQUIRED)
find_package(CURL REQUIRED)

# Glob not recommended, but the simplest way for this template
file(GLOB_RECURSE headers CONFIGURE_DEPENDS
    ${CMAKE_CURRENT_SOURCE_DIR}/include/*.h
    ${CMAKE_CURRENT_SOURCE_DIR}/include/*.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/include/*.hh
    ${CMAKE_CURRENT_SOURCE_DIR}/include/*.hxx
)

# Glob not recommended, but the simplest way for this template
file(GLOB_RECURSE sources CONFIGURE_DEPENDS
    ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.c
    ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.cxx
)

# ---- Create library ----
add_library(${PROJECT_LIBRARY_NAME} ${headers} ${sources})

# ---- Library features ----
target_compile_features(${PROJECT_LIBRARY_NAME} PUBLIC cxx_std_17)

# ---- Library options
target_compile_options(${PROJECT_LIBRARY_NAME} PUBLIC "-Wall" "-Wextra" "-Wpedantic")

# header-only libraries change all PUBLIC flags to INTERFACE and create an interface target:
# <add_library(${PROJECT_LIBRARY_NAME} INTERFACE)>
target_include_directories(
    ${PROJECT_LIBRARY_NAME}
    PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include/${PROJECT_LIBRARY_NAME}-${PROJECT_VERSION}>
    # PRIVATE ${PROJECT_SOURCE_DIR}/Source
)

# being a cross-platform target, we enforce standards conformance on MSVC
target_compile_options(
    ${PROJECT_LIBRARY_NAME} PUBLIC "$<$<COMPILE_LANG_AND_ID:CXX,MSVC>:/permissive->" # Strict conformance
)

# ---- Link libraries ----
target_link_libraries(${PROJECT_LIBRARY_NAME}
    PUBLIC
    BZip2::BZip2
    CURL::libcurl
    Threads::Threads
    dsdotname::EmojiTools
)


# ---- Packaging ----
string(TOLOWER "${PROJECT_LIBRARY_NAME}" PROJECT_LIBRARY_NAME_LOWER)
packageProject(
# the name of the target to export
NAME ${PROJECT_LIBRARY_NAME}
# the version of the target to export
VERSION ${PROJECT_VERSION}
# a temporary directory to create the config files
BINARY_DIR ${PROJECT_BINARY_DIR}
# location of the target's public headers
INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include
# should match the target's INSTALL_INTERFACE include directory
INCLUDE_DESTINATION include/${PROJECT_LIBRARY_NAME}-${PROJECT_VERSION}
# (optional) option to install only header files with matching pattern
INCLUDE_HEADER_PATTERN "*.h"
# semicolon separated list of the project's dependencies
DEPENDENCIES "fmt 7.1.3;cpm-cmake/CPMLicenses.cmake@0.0.7;EmojiTools@0.0.1"
# (optional) create a header containing the version info
# Note: that the path to headers should be lowercase
VERSION_HEADER "${PROJECT_LIBRARY_NAME_LOWER}/version.h"
# (optional) create a export header using GenerateExportHeader module
EXPORT_HEADER "${PROJECT_LIBRARY_NAME}/export.h"
# (optional) install your library with a namespace (Note: do NOT add extra '::')
NAMESPACE ${PROJECT_LIBRARY_NAMESPACE}
# (optional) define the project's version compatibility, defaults to `AnyNewerVersion`
# supported values: `AnyNewerVersion|SameMajorVersion|SameMinorVersion|ExactVersion`
COMPATIBILITY AnyNewerVersion
# (optional) option to disable the versioning of install destinations
DISABLE_VERSION_SUFFIX YES
# (optional) option to ignore target architecture for package resolution
# defaults to YES for header only (i.e. INTERFACE) libraries
ARCH_INDEPENDENT YES
# (optional) option to generate CPack variables
CPACK YES
)

# ---- Install ---- TODO
