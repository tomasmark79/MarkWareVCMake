#!/bin/bash

# This script is a controller for CMake tasks
# (c) Tomáš Mark 2024

export CMakeControllerVersion="0.0.1"

GREEN="\033[0;32m" NC="\033[0m"
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
# ---------------------------------------------------------------------------------
# x86_64-linux-gnu is using default conan profile - change to fit your needs
# ---------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------

# Install Conan dependencies
function conanInstall() {
    local buildDir=$1

    # Conan is running thank to .python-version file within project in virtual environment
    # Global Static/Shared building depends on cmakelists.txt line:
    # option(BUILD_SHARED_LIBS "Build using shared libraries" OFF or ON)
    # default is "-o *:shared=False"
    local conanWithSharedLibs
    conanWithSharedLibs=$(grep -oP 'BUILD_SHARED_LIBS\s+\KON' CMakeLists.txt)
    [[ $conanWithSharedLibs == "ON" ]] && conanWithSharedLibs="-o *:shared=True" || conanWithSharedLibs="-o *:shared=False"
    # ------------------------------------------------------------------------------------

    if [ "$buildArch" == "x86_64-linux-gnu" ]; then
        local conanCmd="conan install $workSpaceDir --output-folder=$buildDir --build=missing --profile=default --settings=build_type=$buildType $conanWithSharedLibs"
    fi

    # Cross-compilation to aarch64-linux-gnu
    if [ "$buildArch" == "aarch64-linux-gnu" ]; then
        local conanCmd="conan install $workSpaceDir --output-folder=$buildDir --build=missing --profile=$buildArch --settings=build_type=$buildType $conanWithSharedLibs"
    fi

    # Cross-compilation to Windows 64-bit
    if [ "$buildArch" == "x86_64-w64-mingw32" ]; then
        local conanCmd="conan install $workSpaceDir --output-folder=$buildDir --build=missing --profile=$buildArch --settings=build_type=$buildType $conanWithSharedLibs"
    fi

    echo "$conanCmd"
    $conanCmd || exit 1

}

# Configure by CMake
function cmakeConfigure() {
    local sourceDir=$1
    local buildDir=$2

    # Cross-compilation - I guess conanbuild.sh may be runned everytime but for now we will run it only for aarch64-linux-gnu
    if [ "$buildArch" == "aarch64-linux-gnu" ] || [ "$buildArch" == "x86_64-w64-mingw32" ]; then
        echo "source $workSpaceDir/$buildDir/conanbuild.sh"
        # shellcheck source=/dev/null
        source "$workSpaceDir/$buildDir/conanbuild.sh"
    fi

    # Check for Conan toolchain - is supposed to be in the build directory always
    if [ -f "$buildDir/conan_toolchain.cmake" ]; then
        toolchainFile="-DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake"
    else
        # Kept for manual selection via existing CMake toolchain aarh64.cmake within the workspace
        toolchainFile="" # default
        [[ $buildArch == "aarch64-linux-gnu" ]] && toolchainFile="-DCMAKE_TOOLCHAIN_FILE=$workSpaceDir/aarch64-linux-gnu.cmake"
    fi

    # Compose CMake configure command
    
    #TODO: Add sanitizers and static analyzers
    # -DUSE_SANITIZER=<Address | Memory | MemoryWithOrigins | Undefined | Thread | Leak | 'Address;Undefined'>
    # local configureCommand="cmake -S $sourceDir -B $workSpaceDir/$buildDir $toolchainFile -DCMAKE_BUILD_TYPE=$buildType -DUSE_SANITIZER=Address -DUSE_STATIC_ANALYZER=clang-tidy -DUSE_CCACHE=YES"
    
    local configureCommand="cmake -S $sourceDir -B $workSpaceDir/$buildDir $toolchainFile -DCMAKE_BUILD_TYPE=$buildType"
    echo "$configureCommand"

    # Run CMake configure
    $configureCommand || exit 1

}

function cmakeBuild() {
    local buildDir=$1
    cmake --build "$buildDir" --target all -j "$(nproc)"
}

function cmakeBuildCpmLicenses() {
    local buildDir=$1
    cmake --build "$buildDir" --target write-licenses
}

function cleanBuild() {
    local buildDir=$1
    rm -rf "$buildDir"
}

# not used yet
# function cmakeTest() {
#     local buildDir=$1
#     ctest --output-on-failure -C "$buildType" -T test --build-config "$buildType" --test-dir "$buildDir"
# }

function cmakeInstall() {
    local buildDir=$1
    cmake --build "$buildDir" --target install
}

# ---------------------------------------------------------------------------------
#   Folder splitter
# ---------------------------------------------------------------------------------
#   library=$1      bool
#   standalone=$2   bool
# ---------------------------------------------------------------------------------

# Directory structure helper
function getBuildDir() {
    local type=$1
    echo "Build/${type}/${buildArch}/${buildType}"
}

function cmakeBuildSplitter() {
    if [ "$1" == "true" ]; then
        cmakeBuild "$(getBuildDir Library)"
    fi
    if [ "$2" == "true" ]; then
        cmakeBuild "$(getBuildDir Standalone)"
    fi
}

function cmakeBuildCpmLicensesSplitter() {
    if [ "$1" == "true" ]; then
        cmakeBuildCpmLicenses "$(getBuildDir Library)"
    fi
    if [ "$2" == "true" ]; then
        cmakeBuildCpmLicenses "$(getBuildDir Standalone)"
    fi
}

function cmakeConfigureSplitter() {
    if [ "$1" == "true" ]; then
        cmakeConfigure "." "$(getBuildDir Library)"
    fi
    if [ "$2" == "true" ]; then
        cmakeConfigure "./Standalone" "$(getBuildDir Standalone)"
    fi
}

function conanInstallSplitter() {
    if [ "$1" == "true" ]; then
        conanInstall "$(getBuildDir Library)"
    fi
    if [ "$2" == "true" ]; then
        conanInstall "$(getBuildDir Standalone)"
    fi
}

function cleanBuildSplitter() {
    if [ "$1" == "true" ]; then
        cleanBuild "$(getBuildDir Library)"
    fi
    if [ "$2" == "true" ]; then
        cleanBuild "$(getBuildDir Standalone)"
    fi
}

function cmakeInstallSplitter() {
    if [ "$1" == "true" ]; then
        cmakeInstall "$(getBuildDir Library)"
    fi
    if [ "$2" == "true" ]; then
        cmakeInstall "$(getBuildDir Standalone)"
    fi
}

function releaseArtefactsSplitter() {
    local outputDir="ReleaseArtefacts"
    mkdir -p "$outputDir"

    local conanWithSharedLibs
    libraryVersion=$(grep -oP 'VERSION\s+\K\d+\.\d+\.\d+' CMakeLists.txt)
    local libraryName
    libraryName=$(grep -oP 'set\(PROJECT_LIBRARY_NAME\s+\K\w+' CMakeLists.txt)
    local standaloneName
    standaloneName=$(grep -oP 'set\(PROJECT_STANDALONE_NAME\s+\K\w+' Standalone/CMakeLists.txt)

    local tarCommand

    if [ "$buildArch" == "x86_64-linux-gnu" ]; then

        if [ "$1" == "true" ]; then
            local libraryArchiveName="$libraryName-$libraryVersion-$buildArch-$buildType.tar.gz"
            tarCommand="tar -czf $outputDir/$libraryArchiveName -C $(getBuildDir Library) "
            if [ -f "$(getBuildDir Library)/lib$libraryName.a" ]; then
                tarCommand+="lib$libraryName.a"
            elif [ -f "$(getBuildDir Library)/lib$libraryName.so" ]; then
                tarCommand+="lib$libraryName.so"
            fi
            echo "$tarCommand"
            $tarCommand
        fi

        if [ "$2" == "true" ]; then
            local standaloneArchiveName="$standaloneName-$libraryVersion-$buildArch-$buildType.tar.gz"
            tarCommand="tar -czf $outputDir/$standaloneArchiveName -C $(getBuildDir Standalone) $standaloneName"
            echo "$tarCommand"
            $tarCommand
        fi

    fi

    if [ "$buildArch" == "aarch64-linux-gnu" ]; then

        if [ "$1" == "true" ]; then
            local libraryArchiveName="$libraryName-$libraryVersion-$buildArch-$buildType.tar.gz"
            tarCommand="tar -czf $outputDir/$libraryArchiveName -C $(getBuildDir Library) "
            if [ -f "$(getBuildDir Library)/lib$libraryName.a" ]; then
                tarCommand+="lib$libraryName.a"
            elif [ -f "$(getBuildDir Library)/lib$libraryName.so" ]; then
                tarCommand+="lib$libraryName.so"
            fi
            echo "$tarCommand"
            $tarCommand
        fi

        if [ "$2" == "true" ]; then
            local standaloneArchiveName="$standaloneName-$libraryVersion-$buildArch-$buildType.tar.gz"
            tarCommand="tar -czf $outputDir/$standaloneArchiveName -C $(getBuildDir Standalone) $standaloneName"
            echo "$tarCommand"
            $tarCommand
        fi
    fi

    if [ "$buildArch" == "x86_64-w64-mingw32" ]; then

        if [ "$1" == "true" ]; then
            local libraryArchiveName="$libraryName-$libraryVersion-$buildArch-$buildType.tar.gz"
            tarCommand="tar -czf $outputDir/$libraryArchiveName -C $(getBuildDir Library) "
            if [ -f "$(getBuildDir Library)/lib$libraryName.a" ]; then
                tarCommand+="lib$libraryName.a"
            elif [ -f "$(getBuildDir Library)/lib$libraryName.dll" ]; then
                tarCommand+="lib$libraryName.dll"
            fi
            echo "$tarCommand"
            $tarCommand
        fi

        if [ "$2" == "true" ]; then
            local standaloneArchiveName="$standaloneName-$libraryVersion-$buildArch-$buildType.tar.gz"
            tarCommand="tar -czf $outputDir/$standaloneArchiveName -C $(getBuildDir Standalone) $standaloneName.exe"
            echo "$tarCommand"
            $tarCommand
        fi
    fi

}

# ---------------------------
#   Task controller
# ---------------------------
#   library=$1      bool
#   standalone=$2   bool
# ---------------------------

case $taskName in

"")
    exit 0
    ;;

# --- Zero to Hero ---

"Zero to Hero 🦸")
    cleanBuildSplitter true true
    conanInstallSplitter true true
    cmakeConfigureSplitter true true
    cmakeBuildSplitter true true
    exit 0
    ;;

"📚 Zero to Hero 🦸")
    cleanBuildSplitter true false
    conanInstallSplitter true false
    cmakeConfigureSplitter true false
    cmakeBuildSplitter true false
    exit 0
    ;;

"🎯 Zero to Hero 🦸")
    cleanBuildSplitter false true
    conanInstallSplitter false true
    cmakeConfigureSplitter false true
    cmakeBuildSplitter false true
    exit 0
    ;;

# --- Clean ---

"Clean 🧹")
    cleanBuildSplitter true true
    exit 0
    ;;

"📚 Clean 🧹")
    cleanBuildSplitter true false
    exit 0
    ;;

"🎯 Clean 🧹")
    cleanBuildSplitter false true
    exit 0
    ;;

# --- Conan Install ---

"Conan 🗡️")
    conanInstallSplitter true true
    exit 0
    ;;

"📚 Conan 🗡️")
    conanInstallSplitter true false
    exit 0
    ;;

"🎯 Conan 🗡️")
    conanInstallSplitter false true
    exit 0
    ;;

# --- Configure ---

"Configure 🔧")
    cmakeConfigureSplitter true true
    exit 0
    ;;

"📚 Configure 🔧")
    cmakeConfigureSplitter true false
    exit 0
    ;;

"🎯 Configure 🔧")
    cmakeConfigureSplitter false true
    exit 0
    ;;

# --- Build ---

"Build 🔨")
    cmakeBuildSplitter true true
    exit 0
    ;;

"📚 Build 🔨")
    cmakeBuildSplitter true false
    exit 0
    ;;

"🎯 Build 🔨")
    cmakeBuildSplitter false true
    exit 0
    ;;

# --- Collect licenses ---

"Collect Licenses 📜")
    cmakeBuildCpmLicensesSplitter true true
    exit 0
    ;;

"📚 Collect Licenses 📜")
    cmakeBuildCpmLicensesSplitter true false
    exit 0
    ;;

"🎯 Collect Licenses 📜")
    cmakeBuildCpmLicensesSplitter false true
    exit 0
    ;;

# --- Install artefacts ---

"Install Artefacts 📌")
    cmakeInstallSplitter true true
    exit 0
    ;;

"📚 Install Artefacts 📌")
    cmakeInstallSplitter true false
    exit 0
    ;;

"🎯 Install Artefacts 📌")
    cmakeInstallSplitter false true
    exit 0
    ;;

# --- Release Artefacts ---

"Release Artefacts 📦")
    releaseArtefactsSplitter true true
    exit 0
    ;;

"📚 Release Artefacts 📦")
    releaseArtefactsSplitter true false
    exit 0
    ;;

"🎯 Release Artefacts 📦")
    releaseArtefactsSplitter false true
    exit 0
    ;;

# --- Permutate ---

"Permutate All Tasks 🕧")
    rm -rf Build
    rm -rf ReleaseArtefacts

    for buildArch in x86_64-linux-gnu aarch64-linux-gnu x86_64-w64-mingw32; do
        for buildType in Debug Release RelWithDebInfo MinSizeRel; do
            cleanBuildSplitter true true
            conanInstallSplitter true true
            cmakeConfigureSplitter true true
            cmakeBuildSplitter true true
            cmakeBuildCpmLicensesSplitter true true
            cmakeInstallSplitter true true
            releaseArtefactsSplitter true true
        done
    done
    exit 0
    ;;

*)
    echo "Unknown task: $taskName"
    exit 1
    ;;
esac
