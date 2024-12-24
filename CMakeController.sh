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
# ---------------------------------------------------------------------------------
# x86_64-linux-gnu is using default conan profile - change to fit your needs
# ---------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------

# Install Conan dependencies
function conan_install() {
    local buildDir=$1

    # x86_64-linux-gnu
    if [ "$buildArch" == "x86_64-linux-gnu" ]; then
        # Generate Static/Shared targets at simple level
        # taken from Library cmakelists.txt line 10: option(BUILD_SHARED_LIBS "Build using shared libraries" OFF or ON)
        # default is "-o *:shared=False"
        local buildSharedLibs=$(grep -oP 'BUILD_SHARED_LIBS\s+\KON' CMakeLists.txt)
        [[ $buildSharedLibs == "ON" ]] && buildSharedLibs="-o *:shared=True" || buildSharedLibs="-o *:shared=False"

        # compose Conan command
        local conanCommand="conan install $workSpaceDir --output-folder=$buildDir --build=missing --profile=default --settings=build_type=$buildType $buildSharedLibs"
        echo $conanCommand

        # Activate Python environment
        source /home/tomas/.pyenv/versions/3.9.2/envs/env392/bin/activate # user should change this to their own Python environment

        # Run Conan in env
        $conanCommand || exit 1
        return
    fi

    # Cross-compilation to aarch64-linux-gnu
    if [ "$buildArch" == "aarch64-linux-gnu" ]; then
        # Generate Static/Shared targets at simple level
        # taken from Library cmakelists.txt line 10: option(BUILD_SHARED_LIBS "Build using shared libraries" OFF or ON)
        # default is "-o *:shared=False"
        local buildSharedLibs=$(grep -oP 'BUILD_SHARED_LIBS\s+\KON' CMakeLists.txt)
        [[ $buildSharedLibs == "ON" ]] && buildSharedLibs="-o *:shared=True" || buildSharedLibs="-o *:shared=False"

        # compose Conan command
        local conanCommand="conan install $workSpaceDir --output-folder=$buildDir --build=missing --profile=aarch64 --settings=build_type=$buildType $buildSharedLibs"
        echo $conanCommand

        # Activate Python environment
        source /home/tomas/.pyenv/versions/3.9.2/envs/env392/bin/activate # user should change this to their own Python environment

        # Run Conan in env
        $conanCommand || exit 1

        return
    fi

    # Cross-compilation to Windows 64-bit
    if [ "$buildArch" == "x86_64-w64-mingw32" ]; then
        # Generate Static/Shared targets at simple level
        # taken from Library cmakelists.txt line 10: option(BUILD_SHARED_LIBS "Build using shared libraries" OFF or ON)
        # default is "-o *:shared=False"
        local buildSharedLibs=$(grep -oP 'BUILD_SHARED_LIBS\s+\KON' CMakeLists.txt)
        [[ $buildSharedLibs == "ON" ]] && buildSharedLibs="-o *:shared=True" || buildSharedLibs="-o *:shared=False"

        # compose Conan command
        local conanCommand="conan install $workSpaceDir --output-folder=$buildDir --build=missing --profile=x86_64-w64-mingw32 --settings=build_type=$buildType $buildSharedLibs"
        echo $conanCommand

        # Activate Python environment
        source /home/tomas/.pyenv/versions/3.9.2/envs/env392/bin/activate # user should change this to their own Python environment

        # Run Conan in env
        $conanCommand || exit 1

        return
    fi

}

# Configure by CMake
function cmake_configure() {
    local sourceDir=$1
    local buildDir=$2

    # Cross-compilation - I guess conanbuild.sh may be runned everytime but for now we will run it only for aarch64-linux-gnu
    if [ "$buildArch" == "aarch64-linux-gnu" ] || [ "$buildArch" == "x86_64-w64-mingw32" ]; then
        echo "source $workSpaceDir/$buildDir/conanbuild.sh"
        source $workSpaceDir/$buildDir/conanbuild.sh
    fi

    # Check for Conan toolchain - is supposed to be in the build directory always
    if [ -f "$buildDir/conan_toolchain.cmake" ]; then
        toolchainFile="-DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake"
    else
        # Kept for manual selection via existing CMake toolchain aarh64.cmake within the workspace
        toolchainFile="" # default
        [[ $buildArch == "aarch64-linux-gnu" ]] && toolchainFile="-DCMAKE_TOOLCHAIN_FILE=$workSpaceDir/aarch64.cmake"
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

function cmake_build_cpm_licenses() {
    local buildDir=$1
    cmake --build "$buildDir" --target write-licenses
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

function Build() {
    if [ "$1" == "true" ]; then
        cmake_build "$(get_build_dir Library)"
    fi
    if [ "$2" == "true" ]; then
        cmake_build "$(get_build_dir Standalone)"
    fi
}

function BuildLicenses() {
    if [ "$1" == "true" ]; then
        cmake_build_cpm_licenses "$(get_build_dir Library)"
    fi
    if [ "$2" == "true" ]; then
        cmake_build_cpm_licenses "$(get_build_dir Standalone)"
    fi
}

function Configure() {
    if [ "$1" == "true" ]; then
        cmake_configure "." "$(get_build_dir Library)"
    fi
    if [ "$2" == "true" ]; then
        cmake_configure "./Standalone" "$(get_build_dir Standalone)"
    fi
}

function ConanInstall() {
    if [ "$1" == "true" ]; then
        conan_install "$(get_build_dir Library)"
    fi
    if [ "$2" == "true" ]; then
        conan_install "$(get_build_dir Standalone)"
    fi
}

function Clean() {
    if [ "$1" == "true" ]; then
        clean_build "$(get_build_dir Library)"
    fi
    if [ "$2" == "true" ]; then
        clean_build "$(get_build_dir Standalone)"
    fi
}

function Install() {
    if [ "$1" == "true" ]; then
        cmake_install "$(get_build_dir Library)"
    fi
    if [ "$2" == "true" ]; then
        cmake_install "$(get_build_dir Standalone)"
    fi
}

# TODO - implement
# TODO - need refactor redundant code

function ArchiveArtifacts() {
    local outputDir="ReleaseArtifacts"
    mkdir -p "$outputDir"

    # Architecture differencies - convert to common names

    if [ "$buildArch" == "x86_64-linux-gnu" ]; then

        if [ "$1" == "true" ]; then
            local libraryName=$(grep -oP 'set\(PROJECT_LIBRARY_NAME\s+\K\w+' CMakeLists.txt)
            local libraryVersion=$(grep -oP 'VERSION\s+\K\d+\.\d+\.\d+' CMakeLists.txt)
            local libraryArchiveName="$libraryName-$libraryVersion-$buildArch-$buildType.tar.gz"
            local tarCommand="tar -czf $outputDir/$libraryArchiveName -C $(get_build_dir Library) "
            if [ -f "$(get_build_dir Library)/lib$libraryName.a" ]; then
                tarCommand+="lib$libraryName.a"
            elif [ -f "$(get_build_dir Library)/lib$libraryName.so" ]; then
                tarCommand+="lib$libraryName.so"
            fi
            echo $tarCommand
            $tarCommand
        fi

        if [ "$2" == "true" ]; then
            # Standalone
            local standaloneName=$(grep -oP 'set\(PROJECT_STANDALONE_NAME\s+\K\w+' Standalone/CMakeLists.txt)
            # Version taken from Library CMakeLists.txt
            local standaloneVersion=$(grep -oP 'VERSION\s+\K\d+\.\d+\.\d+' CMakeLists.txt)
            local standaloneArchiveName="$standaloneName-$standaloneVersion-$buildArch-$buildType.tar.gz"
            local tarCommand="tar -czf $outputDir/$standaloneArchiveName -C $(get_build_dir Standalone) $standaloneName"
            echo $tarCommand
            $tarCommand
        fi

    fi

    if [ "$buildArch" == "aarch64-linux-gnu" ]; then

        if [ "$1" == "true" ]; then
            local libraryName=$(grep -oP 'set\(PROJECT_LIBRARY_NAME\s+\K\w+' CMakeLists.txt)
            local libraryVersion=$(grep -oP 'VERSION\s+\K\d+\.\d+\.\d+' CMakeLists.txt)
            local libraryArchiveName="$libraryName-$libraryVersion-$buildArch-$buildType.tar.gz"
            local tarCommand="tar -czf $outputDir/$libraryArchiveName -C $(get_build_dir Library) "
            if [ -f "$(get_build_dir Library)/lib$libraryName.a" ]; then
                tarCommand+="lib$libraryName.a"
            elif [ -f "$(get_build_dir Library)/lib$libraryName.so" ]; then
                tarCommand+="lib$libraryName.so"
            fi
            echo $tarCommand
            $tarCommand
        fi

        if [ "$2" == "true" ]; then
            # Standalone
            local standaloneName=$(grep -oP 'set\(PROJECT_STANDALONE_NAME\s+\K\w+' Standalone/CMakeLists.txt)
            # Version taken from Library CMakeLists.txt
            local standaloneVersion=$(grep -oP 'VERSION\s+\K\d+\.\d+\.\d+' CMakeLists.txt)
            local standaloneArchiveName="$standaloneName-$standaloneVersion-$buildArch-$buildType.tar.gz"
            local tarCommand="tar -czf $outputDir/$standaloneArchiveName -C $(get_build_dir Standalone) $standaloneName"
            echo $tarCommand
            $tarCommand
        fi
    fi

    if [ "$buildArch" == "x86_64-w64-mingw32" ]; then

        if [ "$1" == "true" ]; then
            local libraryName=$(grep -oP 'set\(PROJECT_LIBRARY_NAME\s+\K\w+' CMakeLists.txt)
            local libraryVersion=$(grep -oP 'VERSION\s+\K\d+\.\d+\.\d+' CMakeLists.txt)
            local libraryArchiveName="$libraryName-$libraryVersion-$buildArch-$buildType.tar.gz"
            local tarCommand="tar -czf $outputDir/$libraryArchiveName -C $(get_build_dir Library) "
            if [ -f "$(get_build_dir Library)/lib$libraryName.a" ]; then
                tarCommand+="lib$libraryName.a"
            elif [ -f "$(get_build_dir Library)/lib$libraryName.dll" ]; then
                tarCommand+="lib$libraryName.dll"
            fi
            echo $tarCommand
            $tarCommand
        fi

        if [ "$2" == "true" ]; then
            # Standalone
            local standaloneName=$(grep -oP 'set\(PROJECT_STANDALONE_NAME\s+\K\w+' Standalone/CMakeLists.txt)
            # Version taken from Library CMakeLists.txt
            local standaloneVersion=$(grep -oP 'VERSION\s+\K\d+\.\d+\.\d+' CMakeLists.txt)
            local standaloneArchiveName="$standaloneName-$standaloneVersion-$buildArch-$buildType.tar.gz"
            local tarCommand="tar -czf $outputDir/$standaloneArchiveName -C $(get_build_dir Standalone) $standaloneName.exe"
            echo $tarCommand
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

# --- Rebuild ---

" ")
    notify-send "This is only empty task"
    exit 0
    ;;

"Rebuild Library")
    Clean true false
    ConanInstall true false
    Configure true false
    Build true false
    exit 0
    ;;

"Rebuild Standalone")
    Clean false true
    ConanInstall false true
    Configure false true
    Build false true
    exit 0
    ;;

"Rebuild 🧹⚔️⚙️🔨")
    Clean true true
    ConanInstall true true
    Configure true true
    Build true true
    exit 0
    ;;

# --- Build ---
"Build Library")
    Build true false
    exit 0
    ;;
"Build Standalone")
    Build false true
    exit 0
    ;;
"Build 🔨")
    Build true true
    exit 0
    ;;

# --- Configure ---
"Configure Library")
    Configure true false
    exit 0
    ;;
"Configure Standalone")
    Configure false true
    exit 0
    ;;
"Configure ⚙️")
    Configure true true
    exit 0
    ;;

# --- Conan Install ---
"Conan Library")
    ConanInstall true false
    exit 0
    ;;
"Conan Standalone")
    ConanInstall false true
    exit 0
    ;;
"Conan ⚔️")
    ConanInstall true true
    exit 0
    ;;

# --- Clean ---
"Clean Library")
    Clean true false
    exit 0
    ;;
"Clean Standalone")
    Clean false true
    exit 0
    ;;
"Clean 🧹")
    Clean true true
    exit 0
    ;;

# --- Install ---
"Install Standalone")
    Install true false
    exit 0
    ;;
"Install Library")
    Install false true
    exit 0
    ;;
"Install 📌")
    Install true true
    exit 0
    ;;

# --- Write licenses ---
"Licenses Library")
    BuildLicenses true false
    exit 0
    ;;
"Licenses Standalone")
    BuildLicenses false true
    exit 0
    ;;
"Licenses 📜")
    BuildLicenses true true
    exit 0
    ;;

# --- Archive Artifacts ---
"Archive Artifacts Library")
    ArchiveArtifacts true false
    exit 0
    ;;

"Archive Artifacts Standalone")
    ArchiveArtifacts false true
    exit 0
    ;;

"Archive Artifacts 📦")
    ArchiveArtifacts true true
    exit 0
    ;;

*)
    echo "Unknown task: $taskName"
    exit 1
    ;;
esac
