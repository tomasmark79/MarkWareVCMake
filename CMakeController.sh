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
    cmake -S . -B Build/$archBuildType/Library/$buildType $toolchainFile || exit 1
    ;;
"CMake: configure (Standalone)")
    cmake -S Standalone -B Build/$archBuildType/Standalone/$buildType $toolchainFile || exit 1
    ;;
"CMake: build (Library)")
    cmake -S . -B Build/$archBuildType/Library/$buildType $toolchainFile || exit 1
    cmake --build Build/$archBuildType/Library/$buildType -j $(nproc)
    ;;
"CMake: build (Standalone)")
    cmake -S Standalone -B Build/$archBuildType/Standalone/$buildType $toolchainFile || exit 1
    cmake --build Build/$archBuildType/Standalone/$buildType -j $(nproc)
    ;;
"CMake: clean (Library)")
    rm -rf Build/$archBuildType/Library/$buildType
    ;;
"CMake: clean (Standalone)")
    rm -rf Build/$archBuildType/Standalone/$buildType
    ;;
"CMake: install (Library)")
    cmake -S . -B Build/$archBuildType/Library/$buildType $toolchainFile || exit 1
    cmake --build Build/$archBuildType/Library/$buildType --target install
    ;;
"CMake: install (Standalone)")
    cmake -S Standalone -B Build/$archBuildType/Standalone/$buildType $toolchainFile || exit 1
    cmake --build Build/$archBuildType/Standalone/$buildType --target install
    ;;
"CMake: test (Library)")
    cmake --build Build/$archBuildType/Library/$buildType --target install || exit 1
    ctest --output-on-failure -C $buildType -T test --build-config $buildType --test-dir Build/$archBuildType/Library/$buildType
    ;;
"CMake: test (Standalone)")
    cmake -S Standalone -B Build/$archBuildType/Standalone/$buildType $toolchainFile || exit 1
    ctest --output-on-failure -C $buildType -T test --build-config $buildType --test-dir Build/$archBuildType/Standalone/$buildType
    ;;
*)
    echo "Unknown task: $taskName"
    exit 1
    ;;
esac
