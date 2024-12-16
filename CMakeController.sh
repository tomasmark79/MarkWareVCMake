#!/bin/bash

# This script is a controller for CMake tasks
# (c) Tomáš Mark 2024

# Arguments and defaults
taskName=$1
archBuildType=$2
buildType=${3:-"Release"} # Default to "Release" if not specified

GREEN='\033[0;32m' NC='\033[0m'
echo -e "${GREEN}CMakeController.sh: args: [" $taskName $archBuildType $buildType "]${NC}"

# Determine workspace and toolchain file
workSpaceDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
toolchainFile=""
[[ $archBuildType == "Aarch64" ]] && toolchainFile="-DCMAKE_TOOLCHAIN_FILE=$workSpaceDir/aarch64.cmake"

# Helper function for cmake commands
function cmake_configure() {
    local sourceDir=$1
    local buildDir=$2
    cmake -S "$sourceDir" -B "$buildDir" $toolchainFile -DCMAKE_BUILD_TYPE=$buildType || exit 1
}

function cmake_build() {
    local buildDir=$1
    cmake --build "$buildDir" --target all -j $(nproc)
}

function cmake_clean() {
    local buildDir=$1
    rm -rf "$buildDir"
}

function cmake_test() {
    local buildDir=$1
    ctest --output-on-failure -C $buildType -T test --build-config $buildType --test-dir "$buildDir"
}

# Directory structure helper
function get_build_dir() {
    local type=$1
    echo "Build/${type}/${archBuildType}/${buildType}"
}

# Task dispatcher
case $taskName in
"Configure (Standalone)")
    cmake_configure "Standalone" "$(get_build_dir Standalone)"
    ;;
"Configure (Library)")
    cmake_configure "." "$(get_build_dir Library)"
    ;;
"Build (Standalone)")
    cmake_configure "Standalone" "$(get_build_dir Standalone)"
    cmake_build "$(get_build_dir Standalone)"
    ;;
"Build (Library)")
    cmake_configure "." "$(get_build_dir Library)"
    cmake_build "$(get_build_dir Library)"
    ;;
"Clean (Standalone)")
    cmake_clean "$(get_build_dir Standalone)"
    ;;
"Clean (Library)")
    cmake_clean "$(get_build_dir Library)"
    ;;
"Clean All")
    rm -rf Build/
    ;;
"Install (Standalone)")
    cmake_configure "Standalone" "$(get_build_dir Standalone)"
    cmake_build "$(get_build_dir Standalone)"
    cmake --build "$(get_build_dir Standalone)" --target install
    ;;
"Install (Library)")
    cmake_configure "." "$(get_build_dir Library)"
    cmake_build "$(get_build_dir Library)"
    cmake --build "$(get_build_dir Library)" --target install
    ;;
"Test (Standalone)")
    cmake_configure "Standalone" "$(get_build_dir Standalone)"
    cmake_test "$(get_build_dir Standalone)"
    ;;
"Test (Library)")
    cmake_build "$(get_build_dir Library)"
    cmake_test "$(get_build_dir Library)"
    ;;
"Collect licenses (Standalone)")
    cmake_configure "Standalone" "$(get_build_dir Standalone)"
    cmake_build "$(get_build_dir Standalone)"
    cmake --build "$(get_build_dir Standalone)" --target write-licenses -j $(nproc)
    ;;
"Collect licenses (Library)")
    cmake_configure "." "$(get_build_dir Library)"
    cmake_build "$(get_build_dir Library)"
    cmake --build "$(get_build_dir Library)" --target write-licenses -j $(nproc)
    ;;
*)
    echo "Unknown task: $taskName"
    exit 1
    ;;
esac
