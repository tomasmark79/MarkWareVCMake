cmake_minimum_required(VERSION 3.14...3.22)

# ---- Project ----
project(
    MWVCLib
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

add_library(MWVCLib ${headers} ${sources})

set_target_properties(MWVCLib PROPERTIES
    CXX_STANDARD 17
)

target_compile_options(MWVCLib PUBLIC
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
    target_link_libraries(MWVCLib PRIVATE EmojiTools::EmojiTools)
endif()

# self headers
target_include_directories(
    MWVCLib PUBLIC
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/Include>
    $<INSTALL_INTERFACE:Include/MWVCLib-${PROJECT_VERSION}>
)

string(TOLOWER "MWVCLib/version.h" VERSION_HEADER_LOCATION)

packageProject(
    NAME MWVCLib
    VERSION ${PROJECT_VERSION}
    NAMESPACE MWVCLib
    BINARY_DIR ${PROJECT_BINARY_DIR}
    INCLUDE_DIR ${PROJECT_SOURCE_DIR}/Include
    INCLUDE_DESTINATION Include/MWVCLib-${PROJECT_VERSION}
    VERSION_HEADER "${VERSION_HEADER_LOCATION}"
    COMPATIBILITY SameMajorVersion
)
