cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

# (c) Tomáš Mark 2024

# ---- Project attributes ----
set(PROJECT_LIBRARY_NAMESPACE name.digitalspace.www)
set(PROJECT_LIBRARY_NAME VCMLib)

# ---- Static | Shared ----
# TODO
option(BUILD_SHARED_LIBS "Build using shared libraries" OFF)

# ---- Project ----
project(
    ${PROJECT_LIBRARY_NAME}
    VERSION 0.0.1
    LANGUAGES C CXX ASM
)

# ---- Include guards ----
if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(
        FATAL_ERROR
            "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there."
    )
endif()

# ---- Modules finding example ---- https://cmake.org/cmake/help/v3.28/manual/cmake-modules.7.html
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake/Modules")
find_package(Threads REQUIRED) # std::threads
find_package(X11 REQUIRED)

# ---- Dependencies ----
include(cmake/CPM.cmake)

# PackageProject.cmake will be used to make our target installable
CPMAddPackage("gh:TheLartians/PackageProject.cmake@1.12.0")
CPMAddPackage("gh:fmtlib/fmt#11.0.2")

# Note: globbing sources is considered bad practice as CMake's generators may not detect new files
# automatically. Keep that in mind when changing files, or explicitly mention them here.
file(GLOB_RECURSE headers CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/include/*.h
     ${CMAKE_CURRENT_SOURCE_DIR}/include/*.hpp
)
file(GLOB_RECURSE sources CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.c
     ${CMAKE_CURRENT_SOURCE_DIR}/Source/*.cpp
)

# ---- Create library ----

# Note: for header-only libraries change all PUBLIC flags to INTERFACE and create an interface
# target: add_library(${PROJECT_LIBRARY_NAME} INTERFACE)
add_library(${PROJECT_LIBRARY_NAME} ${headers} ${sources})
set_target_properties(${PROJECT_LIBRARY_NAME} PROPERTIES CXX_STANDARD 17)

# being a cross-platform target, we enforce standards conformance on MSVC
target_compile_options(
    ${PROJECT_LIBRARY_NAME} PUBLIC "$<$<COMPILE_LANG_AND_ID:CXX,MSVC>:/permissive->" # Strict
                                                                                     # conformance
)
# target_compile_options(${PROJECT_LIBRARY_NAME} PRIVATE "-Werror")

# ---- Third Party ----
CPMAddPackage(
    NAME CPMLicenses.cmake
    GITHUB_REPOSITORY cpm-cmake/CPMLicenses.cmake
    VERSION 0.0.7
)
cpm_licenses_create_disclaimer_target(
    write-licenses-${PROJECT_LIBRARY_NAME} "${CMAKE_CURRENT_BINARY_DIR}/third_party.txt" "${CPM_PACKAGES}"
)

# EmojiTools
CPMAddPackage(
    NAME EmojiToolsLib
    GIT_TAG main
    GITHUB_REPOSITORY tomasmark79/EmojiTools
    OPTIONS "EMOJI_INSTALL NO" # create an installable target
)
if(EmojiToolsLib_ADDED)
    target_link_libraries(${PROJECT_LIBRARY_NAME} PRIVATE name.digitalspace.www::EmojiToolsLib)
endif()

# headers
target_include_directories(
    ${PROJECT_LIBRARY_NAME}
    PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>

           $<INSTALL_INTERFACE:include/${PROJECT_LIBRARY_NAME}-${PROJECT_VERSION}>
    PRIVATE ${PROJECT_SOURCE_DIR}/Source
)

# ---- Modules headers & link libraries example ----
target_link_libraries(${PROJECT_LIBRARY_NAME} PRIVATE stdc++fs Threads::Threads)
target_include_directories(${PROJECT_LIBRARY_NAME} PUBLIC ${X11_INCLUDE_DIR})

# ---- Package ----
string(TOLOWER "${PROJECT_LIBRARY_NAME}/version.h" VERSION_HEADER_LOCATION)

packageProject(
    NAME ${PROJECT_LIBRARY_NAME}
    VERSION ${PROJECT_VERSION}
    NAMESPACE ${PROJECT_LIBRARY_NAMESPACE}
    BINARY_DIR ${PROJECT_BINARY_DIR}
    INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include
    INCLUDE_DESTINATION include/${PROJECT_LIBRARY_NAME}-${PROJECT_VERSION}
    VERSION_HEADER "${VERSION_HEADER_LOCATION}"
    COMPATIBILITY SameMajorVersion
    DEPENDENCIES "fmt 11.0.2"
)

# ---- Install ----
include(GNUInstallDirs)
install(
    TARGETS EmojiToolsLib
    EXPORT ${PROJECT_LIBRARY_NAME}Targets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    INCLUDES
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_LIBRARY_NAME}-${PROJECT_VERSION}
)
