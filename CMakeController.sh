#!/bin/bash

# This script is a controller for CMake tasks
# (c) Tomáš Mark 2024

# Arguments and defaults
taskName=$1
archBuildType=$2
buildType=${3:-"Release"} # Default to "Release" if not specified

GREEN='\033[0;32m' NC='\033[0m' YELLOW='\033[1;33m'
echo -e "${GREEN}CMakeController.sh: args: [" $taskName $archBuildType $buildType "]${NC}"

# Determine workspace and toolchain file
workSpaceDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Helper function for Conan install
function conan_install() {
    source /home/tomas/.pyenv/versions/3.9.2/envs/env392/bin/activate
    local buildDir=$1
    local conanCommand="conan install $workSpaceDir --output-folder=$buildDir --build=missing --profile=default"
    echo $conanCommand
    $conanCommand || exit 1

    # Raw Library command template runned from $workSpaceDir
    # conan install . --output-folder=Build/Library/Native/Debug --profile=default
    # conan install /home/tomas/dev/cpp/projects/MarkWareVCMake --output-folder="Build/Library/Native/Debug" --build=missing --profile=default
    # cmake -S . -B ./Build/Library/Native/Debug -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Debug
    # cmake --build ./Build/Library/Native/Debug

    # Raw Standalone command template runned from $workSpaceDir
    # conan install ./Standalone --output-folder=Build/Standalone/Native/Debug --profile=default
    # conan install /home/tomas/dev/cpp/projects/MarkWareVCMake/Standalone --output-folder="Build/Standalone/Native/Debug" --build=missing --profile=default
    # cmake -S ./Standalone -B ./Build/Standalone/Native/Debug -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Debug
    # cmake --build ./Build/Standalone/Native/Debug
}

# Helper function for CMake configure and build
function cmake_configure() {
    local sourceDir=$1
    local buildDir=$2

    # If conan_toolchain.cmake exists, use it, otherwise use own CMake default toolchain
    if [ -f "$buildDir/conan_toolchain.cmake" ]; then
        # Conan
        toolchainFile="-DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake"
    else
        # Default manual selection
        echo -e "${YELLOW}No conan_toolchain.cmake found, using manual selection${NC}"
        toolchainFile=""
        [[ $archBuildType == "Aarch64" ]] && toolchainFile="-DCMAKE_TOOLCHAIN_FILE=$workSpaceDir/aarch64.cmake"
    fi

    local configureCommand="cmake -S $sourceDir -B $workSpaceDir/$buildDir $toolchainFile -DCMAKE_BUILD_TYPE=$buildType"
    #cmake -S ./Standalone -B ./Build/Standalone/Native/Debug -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Debug
    echo $configureCommand
    $configureCommand || exit 1

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
"Conan Install (Standalone)")
    conan_install "$(get_build_dir Standalone)"
    ;;
"Conan Install (Library)")
    conan_install "$(get_build_dir Library)"
    ;;

# configure


"Configure (Standalone)")
    cmake_configure "./Standalone" "$(get_build_dir Standalone)"
    ;;


"Configure (Library)")
    cmake_configure "." "$(get_build_dir Library)"
    ;;




"Build (Standalone)")
    cmake_configure "./Standalone" "$(get_build_dir Standalone)"
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
    cmake_configure ".tandalone" "$(get_build_dir Standalone)"
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
