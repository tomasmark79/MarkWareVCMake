#!/bin/bash
taskName=$1
archBuildType=$2
buildType=$3

workSpaceDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

toolchainFile=""
if [[ $archBuildType == "Aarch64" ]]; then
    toolchainFile="-DCMAKE_TOOLCHAIN_FILE=$workSpaceDir/aarch64.cmake"
fi

case $taskName in
"CMake: configure (Library)")
    cmake -S . -B Build/$archBuildType/$buildType/Library $toolchainFile
    ;;
"CMake: configure (Standalone)")
    cmake -S Standalone -B Build/$archBuildType/$buildType/Standalone $toolchainFile
    ;;
"CMake: build (Library)")
    cmake -S . -B Build/$archBuildType/$buildType/Library $toolchainFile
    cmake --build Build/$archBuildType/$buildType/Library -j $(nproc)
    ;;
"CMake: build (Standalone)")
    cmake -S Standalone -B Build/$archBuildType/$buildType/Standalone $toolchainFile
    cmake --build Build/$archBuildType/$buildType/Standalone -j $(nproc)
    ;;
"CMake: clean (Library)")
    rm -rf Build/$archBuildType/$buildType/Library
    ;;
"CMake: clean (Standalone)")
    rm -rf Build/$archBuildType/$buildType/Standalone
    ;;
"CMake: install (Library)")
    cmake -S . -B Build/$archBuildType/$buildType/Library $toolchainFile
    cmake --build Build/$archBuildType/$buildType/Library --target install
    ;;
"CMake: install (Standalone)")
    cmake -S Standalone -B Build/$archBuildType/$buildType/Standalone $toolchainFile
    cmake --build Build/$archBuildType/$buildType/Standalone --target install
    ;;
"CMake: test (Library)")
    cmake --build Build/$archBuildType/$buildType/Library --target install
    ctest --output-on-failure -C $buildType -T test --build-config $buildType --test-dir Build/$archBuildType/$buildType/Library
    ;;
"CMake: test (Standalone)")
    cmake -S Standalone -B Build/$archBuildType/$buildType/Standalone $toolchainFile
    ctest --output-on-failure -C $buildType -T test --build-config $buildType --test-dir Build/$archBuildType/$buildType/Standalone
    ;;
*)
    echo "Unknown task: $taskName"
    exit 1
    ;;
esac
