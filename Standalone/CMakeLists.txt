cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

# (c) Tomáš Mark 2024

# ---- Project attributes ----
set(PROJECT_STANDALONE_NAMESPACE dsdotname)
set(PROJECT_STANDALONE_NAME VCMStandalone) # for change use ./ProjectRenamer.sh

project(${PROJECT_STANDALONE_NAME} LANGUAGES C CXX ASM)

# --- Import tools ----
include(../cmake/tools.cmake)

# ---- Dependencies ----
include(../cmake/CPM.cmake)

CPMAddPackage(NAME VCMLib SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/..)

# ---- Create standalone executable ----
file(GLOB sources CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.cpp
     ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.c
)

add_executable(${PROJECT_STANDALONE_NAME} ${sources})

set_target_properties(
    ${PROJECT_STANDALONE_NAME} PROPERTIES CXX_STANDARD 17 OUTPUT_NAME "${PROJECT_STANDALONE_NAME}"
)

target_link_libraries(${PROJECT_STANDALONE_NAME} dsdotname::VCMLib)
