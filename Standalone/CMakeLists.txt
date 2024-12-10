cmake_minimum_required(VERSION 3.14...3.22)

project(MWVCStandalone LANGUAGES C CXX)

# --- Import tools ----
include(../cmake/tools.cmake)

# ---- Dependencies ----
include(../cmake/CPM.cmake)

CPMAddPackage(
    NAME MWVCLib
    SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/..
)

# ---- Create standalone executable ----
file(GLOB sources CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.cpp)

add_executable(MWVCStandalone ${sources})

set_target_properties(
    MWVCStandalone PROPERTIES CXX_STANDARD 17 OUTPUT_NAME "MWVCStandalone"
)

target_link_libraries(MWVCStandalone MWVCLib::MWVCLib)


