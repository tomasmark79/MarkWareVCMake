cmake_minimum_required(VERSION 3.14...3.22)

project(VCMStandalone LANGUAGES C CXX)

# --- Import tools ----
include(../cmake/tools.cmake)

# ---- Dependencies ----
include(../cmake/CPM.cmake)

CPMAddPackage(
    NAME VCMLib
    SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/..
)

# ---- Create standalone executable ----
file(GLOB sources CONFIGURE_DEPENDS
    ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.c
)

add_executable(VCMStandalone ${sources})

set_target_properties(
    VCMStandalone PROPERTIES CXX_STANDARD 17 OUTPUT_NAME "VCMStandalone"
)

target_link_libraries(VCMStandalone VCMLib::VCMLib)
