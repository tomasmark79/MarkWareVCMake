#!/bin/bash
# (c) Tomáš Mark 2024

# system declarations
GREEN="\033[0;32m" YELLOW="\033[0;33m" RED="\033[0;31m" NC="\033[0m" LIGHTBLUE="\033[1;34m"
workSpaceDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
nameOfScript=$(basename "$0")
scriptAuthor="(c) Tomáš Mark 2004"
scriptVersion="0.0.2"
taskName=$1
buildArch=$2
buildType=${3:-"Release"} # Default to "Release" if not specified

# user declarations
buildFolderName="Build"
installOutputDir="$workSpaceDir/${buildFolderName}/Install"
artefactsOutputDir="$workSpaceDir/${buildFolderName}/Artefacts"

function exitOk() {
    echo -e "${GREEN}$1${NC}"
    exit 0
}

function exitWithError() {
    echo -e "${RED}$1${NC}"
    exit 1
}

if [ -z "$taskName" ]; then
    exitWithError "Task name is missing. Exiting."
fi

if [ -z "$buildArch" ]; then
    exitWithError "Build architecture is missing. Exiting."
fi

# Print out the configuration
echo -e "/-------------------------------------------------------------\\"
echo -e "${YELLOW}${nameOfScript} ${scriptAuthor} v ${scriptVersion} ${NC}"
echo -e "---------------------------------------------------------------"
echo -e "${LIGHTBLUE}taskName\t: $taskName${NC}"
echo -e "---------------------------------------------------------------"
echo -e "${GREEN}Build Arch\t: $buildArch"
echo -e "${GREEN}Build Type\t: $buildType"
echo -e "${GREEN}Work Space\t: $workSpaceDir${NC}"
echo -e "${GREEN}Install to\t: $installOutputDir${NC}"
echo -e "${GREEN}Artefacts to\t: $artefactsOutputDir${NC}"
echo -e "\\-------------------------------------------------------------/"

function log2file() {
    local message=$1
    echo "$message" >>"$workSpaceDir/SolutionController.log"

}

function executeCommand() {
    local cmd=$1
    echo -e "${LIGHTBLUE}$cmd${NC}"
    log2file "$cmd"
    $cmd
}

function getBuildDir() {
    local type=$1
    echo "${buildFolderName}/${type}/${buildArch}/${buildType}"
}

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

    executeCommand "$conanCmd" || exit 1
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

    echo "install workSpaceDir: $workSpaceDir"
    echo "install buildArch: $buildArch"
    echo "install buildType: $buildType"
    local configureCommand="cmake -S $sourceDir -B $workSpaceDir/$buildDir $toolchainFile -DCMAKE_BUILD_TYPE=$buildType -DCMAKE_INSTALL_PREFIX=$installOutputDir/$buildArch/$buildType"

    executeCommand "$configureCommand" || exit 1
}

function cmakeBuild() {
    local buildDir=$1
    local cmd
    cmd="cmake --build $buildDir --target all -j $(nproc)"
    executeCommand "$cmd" || exit 1
}

function cmakeBuildCpmLicenses() {
    local buildDir=$1
    local cmd
    cmd="cmake --build $buildDir --target write-licenses"
    executeCommand "$cmd" || exit 1
}

function cleanBuildFolder() {
    local buildDir=$1
    local cmd
    cmd="rm -rf $buildDir"
    executeCommand "$cmd" || exit 1
}

function cmakeInstall() {
    local buildDir=$1
    local cmd
    cmd="cmake --build $buildDir --target install"
    executeCommand "$cmd" || exit 1
}

# not used yet
# ctest --output-on-failure -C "$buildType" -T test --build-config "$buildType" --test-dir "$buildDir"

function buildSpltr() {
    if [ "$1" == "true" ]; then
        cmakeBuild "$(getBuildDir Library)"
    fi
    if [ "$2" == "true" ]; then
        cmakeBuild "$(getBuildDir Standalone)"
    fi
}

function licenseSpltr() {
    if [ "$1" == "true" ]; then
        cmakeBuildCpmLicenses "$(getBuildDir Library)"
    fi
    if [ "$2" == "true" ]; then
        cmakeBuildCpmLicenses "$(getBuildDir Standalone)"
    fi
}

function configureSpltr() {
    if [ "$1" == "true" ]; then
        cmakeConfigure "." "$(getBuildDir Library)"
    fi
    if [ "$2" == "true" ]; then
        cmakeConfigure "./Standalone" "$(getBuildDir Standalone)"
    fi
}

function conanSpltr() {
    if [ "$1" == "true" ]; then
        conanInstall "$(getBuildDir Library)"
    fi
    if [ "$2" == "true" ]; then
        conanInstall "$(getBuildDir Standalone)"
    fi
}

function cleanSpltr() {
    if [ "$1" == "true" ]; then
        cleanBuildFolder "$(getBuildDir Library)"
    fi
    if [ "$2" == "true" ]; then
        cleanBuildFolder "$(getBuildDir Standalone)"
    fi
}

function installSpltr() {
    if [ "$1" == "true" ]; then
        cmakeInstall "$(getBuildDir Library)"
    fi
    if [ "$2" == "true" ]; then
        cmakeInstall "$(getBuildDir Standalone)"
    fi
}

function aretfactsSpltr() {

    mkdir -p "$artefactsOutputDir"

    local conanWithSharedLibs
    libraryVersion=$(grep -oP 'VERSION\s+\K\d+\.\d+\.\d+' CMakeLists.txt)
    local libraryName
    libraryName=$(grep -oP 'set\(PROJECT_LIBRARY_NAME\s+\K\w+' CMakeLists.txt)
    local standaloneName
    standaloneName=$(grep -oP 'set\(PROJECT_STANDALONE_NAME\s+\K\w+' Standalone/CMakeLists.txt)

    # L I N U X 🐧
    # tar x86_64-linux-gnu
    # tar aarch64-linux-gnu
    if [ "$buildArch" == "x86_64-linux-gnu" ] || [ "$buildArch" == "aarch64-linux-gnu" ]; then

        # LIBRARY
        if [ "$1" == "true" ]; then

            # List of library files to archive
            local libraries=("lib$libraryName.a" "lib$libraryName.so")
            local archiveName="$libraryName-$libraryVersion-$buildArch-$buildType.tar.gz"
            local sourceDir
            sourceDir=$(getBuildDir Library)
            local filesToArchive=""

            # Collect library files to archive
            for lib in "${libraries[@]}"; do
                if [ -f "$sourceDir/$lib" ]; then
                    filesToArchive+=" $lib" # gap is important
                fi
            done

            # Archive library files if found
            if [ -n "$filesToArchive" ]; then
                local tarCommand="tar -czf $artefactsOutputDir/$archiveName -C $sourceDir $filesToArchive"
                echo -e "${LIGHTBLUE}$tarCommand${NC}"
                $tarCommand
            else
                echo "No library files found to archive."
            fi
        fi

        # STANDALONE
        if [ "$2" == "true" ]; then
            local standaloneArchiveName="$standaloneName-$libraryVersion-$buildArch-$buildType.tar.gz"
            tarCommand="tar -czf $artefactsOutputDir/$standaloneArchiveName -C $(getBuildDir Standalone) $standaloneName"
            echo -e "${LIGHTBLUE}$tarCommand${NC}"
            $tarCommand
        fi

    fi

    # W i n d o w s 🪟
    # tar x86_64-w64-mingw32
    if [ "$buildArch" == "x86_64-w64-mingw32" ]; then
        # LIBRARY
        if [ "$1" == "true" ]; then

            # List of library files to archive
            local libraries=("lib$libraryName.a" "lib$libraryName.dll" "lib$libraryName.dll.a" "lib$libraryName.lib" "lib$libraryName.pdb" "lib$libraryName.exp" "lib$libraryName.def")
            local archiveName="$libraryName-$libraryVersion-$buildArch-$buildType.tar.gz"
            local sourceDir
            sourceDir=$(getBuildDir Library)
            local filesToArchive=""

            # Collect library files to archive
            for lib in "${libraries[@]}"; do
                if [ -f "$sourceDir/$lib" ]; then
                    filesToArchive+=" $lib" # gap is important
                fi
            done

            # Archive library files if found
            if [ -n "$filesToArchive" ]; then
                local tarCommand="tar -czf $artefactsOutputDir/$archiveName -C $sourceDir $filesToArchive"
                echo -e "${LIGHTBLUE}$tarCommand${NC}"
                $tarCommand
            else
                echo "No library files found to archive."
            fi
        fi

        # STANDALONE
        if [ "$2" == "true" ]; then
            local standaloneArchiveName="$standaloneName-$libraryVersion-$buildArch-$buildType.tar.gz"
            tarCommand="tar -czf $artefactsOutputDir/$standaloneArchiveName -C $(getBuildDir Standalone) $standaloneName.exe"
            echo -e "${LIGHTBLUE}$tarCommand${NC}"
            $tarCommand
        fi
    fi
}

# /------------------------------------
#   Task receiver from tasks.json
# \------------------------------------
case $taskName in

# --- Zero to Hero ---

"Zero to Hero 🦸")
    cleanSpltr true true
    conanSpltr true true
    configureSpltr true true
    buildSpltr true true
    exitOk ""
    ;;

"📚 Zero to Hero 🦸")
    cleanSpltr true false
    conanSpltr true false
    configureSpltr true false
    buildSpltr true false
    exitOk ""
    ;;

"🎯 Zero to Hero 🦸")
    cleanSpltr false true
    conanSpltr false true
    configureSpltr false true
    buildSpltr false true
    exitOk ""
    ;;

# --- Clean ---

"Clean 🧹")
    cleanSpltr true true
    exitOk ""
    ;;

"📚 Clean 🧹")
    cleanSpltr true false
    exitOk ""
    ;;

"🎯 Clean 🧹")
    cleanSpltr false true
    exitOk ""
    ;;

# --- Conan Install ---

"Conan 🗡️")
    conanSpltr true true
    exitOk ""
    ;;

"📚 Conan 🗡️")
    conanSpltr true false
    exitOk ""
    ;;

"🎯 Conan 🗡️")
    conanSpltr false true
    exitOk ""
    ;;

# --- Configure ---

"Configure 🔧")
    configureSpltr true true
    exitOk ""
    ;;

"📚 Configure 🔧")
    configureSpltr true false
    exitOk ""
    ;;

"🎯 Configure 🔧")
    configureSpltr false true
    exitOk ""
    ;;

# --- Build ---

"Build 🔨")
    buildSpltr true true
    exitOk ""
    ;;

"📚 Build 🔨")
    buildSpltr true false
    exitOk ""
    ;;

"🎯 Build 🔨")
    buildSpltr false true
    exitOk ""
    ;;

# --- Collect licenses ---

"Collect Licenses 📜")
    licenseSpltr true true
    exitOk ""
    ;;

"📚 Collect Licenses 📜")
    licenseSpltr true false
    exitOk ""
    ;;

"🎯 Collect Licenses 📜")
    licenseSpltr false true
    exitOk ""
    ;;

# --- Install artefacts ---

"Install Artefacts 📌")
    installSpltr true true
    exitOk ""
    ;;

"📚 Install Artefacts 📌")
    installSpltr true false
    exitOk ""
    ;;

"🎯 Install Artefacts 📌")
    installSpltr false true
    exitOk ""
    ;;

# --- Release Artefacts ---

"Release Artefacts 📦")
    aretfactsSpltr true true
    exitOk ""
    ;;

"📚 Release Artefacts 📦")
    aretfactsSpltr true false
    exitOk ""
    ;;

"🎯 Release Artefacts 📦")
    aretfactsSpltr false true
    exitOk ""
    ;;

# --- Permutate ---

"Permutate All Tasks 🕧")
    rm -rf Build
    rm -rf ReleaseArtefacts

    for buildArch in x86_64-linux-gnu aarch64-linux-gnu x86_64-w64-mingw32; do
        for buildType in Debug Release RelWithDebInfo MinSizeRel; do
            cleanSpltr true true
            conanSpltr true true
            configureSpltr true true
            buildSpltr true true
            licenseSpltr true true
            installSpltr true true
            aretfactsSpltr true true
        done
    done
    exitOk ""
    ;;

"")
    exitOk ""
    ;;

*)
    echo "Received unknown task: $taskName"
    exitWithError "Task name is missing. Exiting."
    ;;

esac