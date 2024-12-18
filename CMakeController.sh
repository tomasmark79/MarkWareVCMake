#!/bin/bash
# This script is a controller for CMake tasks
# (c) Tomáš Mark 2024

GREEN='\033[0;32m' NC='\033[0m' YELLOW='\033[1;33m'
workSpaceDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Arguments and defaults
taskName=$1
buildArch=$2
buildType=${3:-"Release"} # Default to "Release" if not specified

echo -e "${GREEN}CMakeController.sh: args:"
echo -e "${GREEN}taskName : $taskName"
echo -e "${GREEN}buildArch: $buildArch"
echo -e "${GREEN}buildType: $buildType"
echo -e "${GREEN}workSpaceDir: $workSpaceDir${NC}"

# ---------------------------------------------------------------------------------

# Install Conan dependencies
function conan_install() {
    local buildDir=$1

    # compose Conan command
    local conanCommand="conan install $workSpaceDir --output-folder=$buildDir --build=missing --profile=default --settings=build_type=$buildType"
    echo $conanCommand

    # Activate Python environment
    source /home/tomas/.pyenv/versions/3.9.2/envs/env392/bin/activate # user should change this to their own Python environment

    # Run Conan in env
    $conanCommand || exit 1
}

# Confirure by CMake
function cmake_configure() {
    local sourceDir=$1
    local buildDir=$2

    # Check for Conan toolchain - is supposed to be in the build directory always
    if [ -f "$buildDir/conan_toolchain.cmake" ]; then
        toolchainFile="-DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake"
    else
        # Kept for manual selection via existing CMake toolchain aarh64.cmake within the workspace
        toolchainFile="" # default
        [[ $buildArch == "Aarch64" ]] && toolchainFile="-DCMAKE_TOOLCHAIN_FILE=$workSpaceDir/aarch64.cmake"
    fi

    # Compose CMake configure command
    local configureCommand="cmake -S $sourceDir -B $workSpaceDir/$buildDir $toolchainFile -DCMAKE_BUILD_TYPE=$buildType"
    echo $configureCommand

    # Run CMake configure
    $configureCommand || exit 1

}

function cmake_build() {
    local buildDir=$1
    cmake --build "$buildDir" --target all -j $(nproc)
}

function clean_build() {
    local buildDir=$1
    rm -rf "$buildDir"
}

function cmake_test() {
    local buildDir=$1
    ctest --output-on-failure -C $buildType -T test --build-config $buildType --test-dir "$buildDir"
}

function cmake_install() {
    local buildDir=$1
    cmake --build "$buildDir" --target install
}

function cmake_write_licenses() {
    local buildDir=$1
    cmake --build "$buildDir" --target write-licenses -j
}

# ---------------------------------------------------------------------------------
#   Folder splitter
# ---------------------------------------------------------------------------------
#   library=$1      bool
#   standalone=$2   bool
# ---------------------------------------------------------------------------------

# Directory structure helper
function get_build_dir() {
    local type=$1
    echo "Build/${type}/${buildArch}/${buildType}"
}

# Install Conan dependencies and configure CMake
function ConanInstall() {
    if [ "$1" == "true" ]; then
        conan_install "$(get_build_dir Library)"
    fi
    if [ "$2" == "true" ]; then
        conan_install "$(get_build_dir Standalone)"
    fi
}

# Configure by CMake
function Configure() {
    if [ "$1" == "true" ]; then
        cmake_configure "." "$(get_build_dir Library)"
    fi
    if [ "$2" == "true" ]; then
        cmake_configure "./Standalone" "$(get_build_dir Standalone)"
    fi
}

# Build by CMake
function Build() {
    if [ "$1" == "true" ]; then
        cmake_build "$(get_build_dir Library)"
    fi
    if [ "$2" == "true" ]; then
        cmake_build "$(get_build_dir Standalone)"
    fi
}

# Clean build directory
function Clean() {
    if [ "$1" == "true" ]; then
        clean_build "$(get_build_dir Library)"
    fi
    if [ "$2" == "true" ]; then
        clean_build "$(get_build_dir Standalone)"
    fi
}

# Install by CMake
function Install() {
    if [ "$1" == "true" ]; then
        cmake_install "$(get_build_dir Library)"
    fi
    if [ "$2" == "true" ]; then
        cmake_install "$(get_build_dir Standalone)"
    fi
}

# Write licenses by CMake
function WriteLicenses() {
    if [ "$1" == "true" ]; then
        cmake_write_licenses "$(get_build_dir Library)"
    fi
    if [ "$2" == "true" ]; then
        cmake_write_licenses "$(get_build_dir Standalone)"
    fi
}

# ---------------------------------------------------------------------------------
#   Task controller
# ---------------------------------------------------------------------------------
#   library=$1      bool
#   standalone=$2   bool
# ---------------------------------------------------------------------------------

case $taskName in

# --- Conan Install ---
"Conan Install (Library)")
    ConanInstall true false
    exit 0
    ;;
"Conan Install (Standalone)")
    ConanInstall false true
    exit 0
    ;;
"Conan Install All")
    ConanInstall true true
    exit 0
    ;;

# --- Configure ---
"Configure (Library)")
    Configure true false
    exit 0
    ;;
"Configure (Standalone)")
    Configure false true
    exit 0
    ;;
"Configure All")
    Configure true true
    exit 0
    ;;

# --- Build ---
"Build (Library)")
    Build true false
    exit 0
    ;;
"Build (Standalone)")
    Build false true
    exit 0
    ;;
"Build All")
    Build true true
    exit 0
    ;;

# --- Clean ---
"Clean (Library)")
    Clean true false
    exit 0
    ;;
"Clean (Standalone)")
    Clean false true
    exit 0
    ;;
"Clean All")
    Clean true true
    exit 0
    ;;

# --- Install ---
"Install (Library)")
    Install true false
    exit 0
    ;;
"Install (Standalone)")
    Install false true
    exit 0
    ;;
"Install All")
    Install true true
    exit 0
    ;;

# --- Write licenses ---
"Write Licenses (Library)")
    WriteLicenses true false
    exit 0
    ;;
"Write Licenses (Standalone)")
    WriteLicenses false true
    exit 0
    ;;
"Write Licenses All")
    WriteLicenses true true
    exit 0
    ;;

*)
    echo "Unknown task: $taskName"
    exit 1
    ;;
esac