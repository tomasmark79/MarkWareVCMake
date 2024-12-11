cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

# ---- Project ----
project(
    VCMLib
    VERSION 0.0.1
    LANGUAGES C CXX ASM
)

# ---- Include guards ----
if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(FATAL_ERROR
        "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there."
    )
endif()

# ---- Dependencies ----
include(cmake/CPM.cmake)
CPMAddPackage("gh:TheLartians/PackageProject.cmake@1.12.0")

# ---- Create library ----
file(GLOB_RECURSE headers CONFIGURE_DEPENDS
    ${CMAKE_CURRENT_SOURCE_DIR}/Include/*.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Include/*.hpp
)

file(GLOB_RECURSE sources CONFIGURE_DEPENDS
    ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.c
    ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.cpp
)

add_library(VCMLib ${headers} ${sources})

set_target_properties(VCMLib PROPERTIES
    CXX_STANDARD 17
)

target_compile_options(VCMLib PUBLIC
    "$<$<COMPILE_LANG_AND_ID:CXX,MSVC>:/permissive->" # Strict conformance
)

# EmojiTools
CPMAddPackage(
    NAME EmojiTools
    GIT_TAG main
    GITHUB_REPOSITORY tomasmark79/EmojiTools
    OPTIONS "EMOJI_INSTALL YES" # create an installable target
)

if(EmojiTools_ADDED)
    #target_include_directories(MarkWareVCMakeLibrary PRIVATE ${EmojiTools_SOURCE_DIR}/include)
    target_link_libraries(VCMLib PRIVATE EmojiTools::EmojiTools)
endif()

# self headers
target_include_directories(
    VCMLib PUBLIC
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/Include>
    $<INSTALL_INTERFACE:Include/VCMLib-${PROJECT_VERSION}>
)

string(TOLOWER "VCMLib/version.h" VERSION_HEADER_LOCATION)

packageProject(
    NAME VCMLib
    VERSION ${PROJECT_VERSION}
    NAMESPACE VCMLib
    BINARY_DIR ${PROJECT_BINARY_DIR}
    INCLUDE_DIR ${PROJECT_SOURCE_DIR}/Include
    INCLUDE_DESTINATION Include/VCMLib-${PROJECT_VERSION}
    VERSION_HEADER "${VERSION_HEADER_LOCATION}"
    COMPATIBILITY SameMajorVersion
)
