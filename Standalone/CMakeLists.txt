cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

# ---- Standalone Name ----
set(PROJECT_STANDALONE_NAME VCMStandalone)
project(
    ${PROJECT_STANDALONE_NAME}
    LANGUAGES C CXX ASM
    DESCRIPTION "Executable template by Tomáš Mark 2024"
    HOMEPAGE_URL "https://github.com/tomasmark79")
# ---------------------------------

# dep: conanInstall(), CPM.cmake
option(BUILD_SHARED_LIBS "Build using shared libraries" OFF)

# ---- Include guards ----
if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(
        FATAL_ERROR
            "In-source builds not allowed. Please make a new directory (called a Build directory) and run CMake from there."
    )
endif()

# ---- Mandatory CPMs  ----
include(../cmake/CPM.cmake)
include(../cmake/tools.cmake)
cpmaddpackage(NAME VCMLib SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/..)

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
add_executable(${PROJECT_STANDALONE_NAME} ${sources})

# ---- Standalone options ----
set_target_properties(${PROJECT_STANDALONE_NAME}
                      PROPERTIES OUTPUT_NAME "${PROJECT_STANDALONE_NAME}")

target_link_libraries(${PROJECT_STANDALONE_NAME} PRIVATE dsdotname::VCMLib)

# ---- Install ----
