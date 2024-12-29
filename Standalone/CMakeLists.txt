cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

# ===========================
# Static or shared library
# ===========================
option(BUILD_SHARED_LIBS "Build using shared libraries" OFF)

# Linting C/C++ code
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# ===========================
# Project configuration
# ===========================
set(STANDALONE_NAME VCMStandalone)
string(TOLOWER "${STANDALONE_NAME}" STANDALONE_NAME_LOWER)
set(STANDALONE_NAMESPACE dsdotname)
project(
    ${STANDALONE_NAME}
    LANGUAGES C CXX ASM
    DESCRIPTION "Standalone template by Tomáš Mark 2024"
    HOMEPAGE_URL "https://github.com/tomasmark79")

# ---- Include guards ----
if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(FATAL_ERROR "In-source builds not allowed.
            Please make a new directory (called a Build directory) and run CMake from there.")
endif()

# CPM.cmake configuration
include(../cmake/tools.cmake)
include(../cmake/CPM.cmake)
# ===========================
# CPM dependencies
# ===========================
CPMAddPackage(NAME VCMLib SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/..)

# Glob not recommended, but the simplest way for this template
file(
    GLOB_RECURSE
    headers
    CONFIGURE_DEPENDS
    ${CMAKE_CURRENT_SOURCE_DIR}/include/*.h
    ${CMAKE_CURRENT_SOURCE_DIR}/include/*.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/include/*.hh
    ${CMAKE_CURRENT_SOURCE_DIR}/include/*.hxx)

# Glob not recommended, but the simplest way for this template
file(
    GLOB_RECURSE
    sources
    CONFIGURE_DEPENDS
    ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.c
    ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.cxx)

# ---- Create standalone executable ----
add_executable(${STANDALONE_NAME} ${sources})

# ---- Standalone options ----
set_target_properties(${STANDALONE_NAME} PROPERTIES OUTPUT_NAME "${STANDALONE_NAME}")
# ---- link developed library ----
target_link_libraries(${STANDALONE_NAME} PRIVATE dsdotname::VCMLib)

# ---- Set installation directory ----
# set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/../Build/Installed/" CACHE PATH
# "Installation Directory" FORCE)
install(TARGETS ${STANDALONE_NAME} RUNTIME DESTINATION bin)
