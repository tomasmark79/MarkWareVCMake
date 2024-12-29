import os # for path manipulation
import sys # for command line arguments
import subprocess # for executing shell commands
import shutil # for file operations

GREEN = "\033[0;32m"
YELLOW = "\033[0;33m"
RED = "\033[0;31m"
NC = "\033[0m"
LIGHTBLUE = "\033[1;34m"

workSpaceDir = os.path.dirname(os.path.abspath(__file__))
nameOfScript = os.path.basename(__file__) + " (python version)"
scriptAuthor = "(c) Tomáš Mark 2004"
scriptVersion = "0.0.1"
taskName = sys.argv[1] if len(sys.argv) > 1 else None
buildArch = sys.argv[2] if len(sys.argv) > 2 else None
buildType = sys.argv[3] if len(sys.argv) > 3 else "Release"
isCrossCompilation = False

# user defined variables
buildFolderName = "Build"
installOutputDir = os.path.join(workSpaceDir, buildFolderName, "Install")
artefactsOutputDir = os.path.join(workSpaceDir, buildFolderName, "Artefacts")

def exit_ok(message):
    print(f"{GREEN}{message}{NC}")
    sys.exit(0)

def exit_with_error(message):
    print(f"{RED}{message}{NC}")
    sys.exit(1)

if not taskName:
    exit_with_error("Task name is missing. Exiting.")

print(f"/{'-'*61}\\")
print(f"{YELLOW}{nameOfScript} {scriptAuthor} v {scriptVersion} {NC}")
print(f"{'-'*63}")
print(f"{LIGHTBLUE}taskName\t: {taskName}{NC}")
print(f"{'-'*63}")
print(f"{GREEN}Build Arch\t: {buildArch}")
print(f"{GREEN}Build Type\t: {buildType}")
print(f"{GREEN}Work Space\t: {workSpaceDir}{NC}")
print(f"{GREEN}Install to\t: {installOutputDir}{NC}")
print(f"{GREEN}Artefacts to\t: {artefactsOutputDir}{NC}")
print(f"\\{'-'*61}/")

def log2file(message):
    with open(os.path.join(workSpaceDir, "SolutionController.log"), "a") as log_file:
        log_file.write(message + "\n")

def execute_command(cmd):
    print(f"{LIGHTBLUE}> Executed: {cmd}{NC}")
    log2file(cmd)
    result = subprocess.run(cmd, shell=True)
    if result.returncode != 0:
        exit_with_error(f"Command failed: {cmd}")

def get_build_dir(type):
    return os.path.join(buildFolderName, type, buildArch, buildType)

def is_cross():
    global isCrossCompilation
    if buildArch in ["x86_64-linux-gnu", "aarch64-linux-gnu", "x86_64-unknown-linux-gnu", "x86_64-w64-mingw32", "SPECIALTASK"]:
        isCrossCompilation = buildArch != "x86_64-linux-gnu"
    else:
        exit_with_error("Unknown build architecture. Exiting.")

is_cross()

def conan_install(build_dir):
    conan_with_shared_libs = "-o *:shared=True" if "ON" in open("CMakeLists.txt").read() else "-o *:shared=False"
    conan_cmd = f"conan install {workSpaceDir} --output-folder={build_dir} --build=missing --profile={'default' if not isCrossCompilation else buildArch} --settings=build_type={buildType} {conan_with_shared_libs}"
    execute_command(conan_cmd)

def cmake_configure(source_dir, build_dir):
    toolchain_file = ""
    if os.path.isfile(os.path.join(build_dir, "conan_toolchain.cmake")):
        print(f"{LIGHTBLUE}Using CONAN: True{NC}")
        toolchain_file = "-DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake"
        if isCrossCompilation:
            print(f"{YELLOW}Cross compilation is enabled{NC}")
            env_cmd = f"source {os.path.join(workSpaceDir, build_dir, 'conanbuild.sh')}"
            log2file(env_cmd)
            execute_command(env_cmd)
    else:
        print(f"{LIGHTBLUE}Using CONAN: False{NC}")
        if buildArch == "x86_64-unknown-linux-gnu":
            toolchain_file = f"-DCMAKE_TOOLCHAIN_FILE={os.path.join(workSpaceDir, 'Utilities', 'CMakeToolChains', 'x86_64-unknown-linux-gnu.cmake')}"
        elif buildArch == "x86_64-w64-mingw32":
            toolchain_file = f"-DCMAKE_TOOLCHAIN_FILE={os.path.join(workSpaceDir, 'Utilities', 'CMakeToolChains', 'x86_64-w64-mingw32.cmake')}"
        elif buildArch == "aarch64-linux-gnu":
            toolchain_file = f"-DCMAKE_TOOLCHAIN_FILE={os.path.join(workSpaceDir, 'Utilities', 'CMakeToolChains', 'aarch64-linux-gnu.cmake')}"

    conf_cmd = f"cmake -S {source_dir} -B {os.path.join(workSpaceDir, build_dir)} {toolchain_file} -DCMAKE_BUILD_TYPE={buildType} -DCMAKE_INSTALL_PREFIX={os.path.join(installOutputDir, buildArch, buildType)}"
    execute_command(conf_cmd)

def cmake_build(build_dir):
    cmd = f"cmake --build {build_dir} --target all -j {os.cpu_count()}"
    execute_command(cmd)

def cmake_build_cpm_licenses(build_dir):
    cmd = f"cmake --build {build_dir} --target write-licenses"
    execute_command(cmd)

def clean_build_folder(build_dir):
    cmd = f"rm -rf {build_dir}"
    execute_command(cmd)

def cmake_install(build_dir):
    cmd = f"cmake --build {build_dir} --target install"
    execute_command(cmd)

def build_spltr(library, standalone):
    if library:
        cmake_build(get_build_dir("Library"))
    if standalone:
        cmake_build(get_build_dir("Standalone"))

def license_spltr(library, standalone):
    if library:
        cmake_build_cpm_licenses(get_build_dir("Library"))
    if standalone:
        cmake_build_cpm_licenses(get_build_dir("Standalone"))

def configure_spltr(library, standalone):
    if library:
        cmake_configure(".", get_build_dir("Library"))
    if standalone:
        cmake_configure("./Standalone", get_build_dir("Standalone"))

def conan_spltr(library, standalone):
    if library:
        conan_install(get_build_dir("Library"))
    if standalone:
        conan_install(get_build_dir("Standalone"))

def clean_spltr(library, standalone):
    if library:
        clean_build_folder(get_build_dir("Library"))
    if standalone:
        clean_build_folder(get_build_dir("Standalone"))

def install_spltr(library, standalone):
    if library:
        cmake_install(get_build_dir("Library"))
    if standalone:
        cmake_install(get_build_dir("Standalone"))

def artefacts_spltr(library, standalone):
    os.makedirs(artefactsOutputDir, exist_ok=True)
    library_version = "0.0.0"
    library_name = "library"
    standalone_name = "standalone"

    if buildArch in ["x86_64-linux-gnu", "aarch64-linux-gnu"]:
        if library:
            libraries = ["lib{}.a".format(library_name), "lib{}.so".format(library_name)]
            archive_name = "{}-{}-{}-{}.tar.gz".format(library_name, library_version, buildArch, buildType)
            source_dir = get_build_dir("Library")
            files_to_archive = " ".join([lib for lib in libraries if os.path.isfile(os.path.join(source_dir, lib))])
            if files_to_archive:
                tar_command = f"tar -czf {os.path.join(artefactsOutputDir, archive_name)} -C {source_dir} {files_to_archive}"
                print(f"{LIGHTBLUE}{tar_command}{NC}")
                execute_command(tar_command)
            else:
                print("No library files found to archive.")

        if standalone:
            standalone_archive_name = "{}-{}-{}-{}.tar.gz".format(standalone_name, library_version, buildArch, buildType)
            tar_command = f"tar -czf {os.path.join(artefactsOutputDir, standalone_archive_name)} -C {get_build_dir('Standalone')} {standalone_name}"
            print(f"{LIGHTBLUE}{tar_command}{NC}")
            execute_command(tar_command)

    if buildArch == "x86_64-w64-mingw32":
        if library:
            libraries = ["lib{}.a".format(library_name), "lib{}.dll".format(library_name), "lib{}.dll.a".format(library_name), "lib{}.lib".format(library_name), "lib{}.pdb".format(library_name), "lib{}.exp".format(library_name), "lib{}.def".format(library_name)]
            archive_name = "{}-{}-{}-{}.tar.gz".format(library_name, library_version, buildArch, buildType)
            source_dir = get_build_dir("Library")
            files_to_archive = " ".join([lib for lib in libraries if os.path.isfile(os.path.join(source_dir, lib))])
            if files_to_archive:
                tar_command = f"tar -czf {os.path.join(artefactsOutputDir, archive_name)} -C {source_dir} {files_to_archive}"
                print(f"{LIGHTBLUE}{tar_command}{NC}")
                execute_command(tar_command)
            else:
                print("No library files found to archive.")

        if standalone:
            standalone_archive_name = "{}-{}-{}-{}.tar.gz".format(standalone_name, library_version, buildArch, buildType)
            tar_command = f"tar -czf {os.path.join(artefactsOutputDir, standalone_archive_name)} -C {get_build_dir('Standalone')} {standalone_name}.exe"
            print(f"{LIGHTBLUE}{tar_command}{NC}")
            execute_command(tar_command)

def lint_c():
    lint_cmd = f"find \"{workSpaceDir}/\" ! -path \"{workSpaceDir}/Build/*\" -type f \\( -name '*.c' -o -name '*.cpp' -o -name '*.h' -o -name '*.hpp' \\) -exec clang-tidy -p \"{get_build_dir('Library')}\" {{}} +"
    execute_command(lint_cmd)
    if subprocess.run(lint_cmd, shell=True).returncode != 0:
        lint_cmd = f"find \"{workSpaceDir}/\" ! -path \"{workSpaceDir}/Build/*\" -type f \\( -name '*.c' -o -name '*.cpp' -o -name '*.h' -o -name '*.hpp' \\) -exec clang-tidy -p \"{get_build_dir('Standalone')}\" {{}} +"
        execute_command(lint_cmd)

def format_clang():
    lint_cmd = f"find \"{workSpaceDir}/\" ! -path \"{workSpaceDir}/Build/*\" -type f \\( -name '*.c' -o -name '*.cpp' -o -name '*.h' -o -name '*.hpp' \\) -exec sh -c 'echo \"Processing: {{}}\"; clang-format -i {{}} && echo \"Done: {{}}\"' \\;"
    execute_command(lint_cmd)

def format_cmake():
    lint_cmd = f"find \"{workSpaceDir}/\" ! -path \"{workSpaceDir}/Build/*\" ! -path \"{workSpaceDir}/cmake/*\" ! -path \"{workSpaceDir}/Utilities/*\" -type f \\( -name 'CMakeLists.txt' -o -name '*.cmake' \\) -exec sh -c 'echo \"Processing: {{}}\"; cmake-format --enable-markup -i {{}} && echo \"Done: {{}}\"' \\;"
    execute_command(lint_cmd)

def permutate_all_tasks():
    shutil.rmtree("Build", ignore_errors=True)
    shutil.rmtree("ReleaseArtefacts", ignore_errors=True)
    for arch in ["x86_64-linux-gnu", "aarch64-linux-gnu", "x86_64-w64-mingw32"]:
        for type in ["Debug", "Release", "RelWithDebInfo", "MinSizeRel"]:
            global buildArch, buildType
            buildArch = arch
            buildType = type
            clean_spltr(True, True)
            conan_spltr(True, True)
            configure_spltr(True, True)
            build_spltr(True, True)
            license_spltr(True, True)
            install_spltr(True, True)
            artefacts_spltr(True, True)

task_map = {
    "Zero to Hero 🦸": lambda: (clean_spltr(True, True), conan_spltr(True, True), configure_spltr(True, True), build_spltr(True, True), exit_ok("")),
    "📚 Zero to Hero 🦸": lambda: (clean_spltr(True, False), conan_spltr(True, False), configure_spltr(True, False), build_spltr(True, False), exit_ok("")),
    "🎯 Zero to Hero 🦸": lambda: (clean_spltr(False, True), conan_spltr(False, True), configure_spltr(False, True), build_spltr(False, True), exit_ok("")),
    "Clean 🧹": lambda: (clean_spltr(True, True), exit_ok("")),
    "📚 Clean 🧹": lambda: (clean_spltr(True, False), exit_ok("")),
    "🎯 Clean 🧹": lambda: (clean_spltr(False, True), exit_ok("")),
    "Conan 🗡️": lambda: (conan_spltr(True, True), exit_ok("")),
    "📚 Conan 🗡️": lambda: (conan_spltr(True, False), exit_ok("")),
    "🎯 Conan 🗡️": lambda: (conan_spltr(False, True), exit_ok("")),
    "Configure 🔧": lambda: (configure_spltr(True, True), exit_ok("")),
    "📚 Configure 🔧": lambda: (configure_spltr(True, False), exit_ok("")),
    "🎯 Configure 🔧": lambda: (configure_spltr(False, True), exit_ok("")),
    "Build 🔨": lambda: (build_spltr(True, True), exit_ok("")),
    "📚 Build 🔨": lambda: (build_spltr(True, False), exit_ok("")),
    "🎯 Build 🔨": lambda: (build_spltr(False, True), exit_ok("")),
    "Collect Licenses 📜": lambda: (license_spltr(True, True), exit_ok("")),
    "📚 Collect Licenses 📜": lambda: (license_spltr(True, False), exit_ok("")),
    "🎯 Collect Licenses 📜": lambda: (license_spltr(False, True), exit_ok("")),
    "Install Artefacts 📌": lambda: (install_spltr(True, True), exit_ok("")),
    "📚 Install Artefacts 📌": lambda: (install_spltr(True, False), exit_ok("")),
    "🎯 Install Artefacts 📌": lambda: (install_spltr(False, True), exit_ok("")),
    "Release Artefacts 📦": lambda: (artefacts_spltr(True, True), exit_ok("")),
    "📚 Release Artefacts 📦": lambda: (artefacts_spltr(True, False), exit_ok("")),
    "🎯 Release Artefacts 📦": lambda: (artefacts_spltr(False, True), exit_ok("")),
    "Permutate All Tasks 🕧": lambda: (permutate_all_tasks(), exit_ok("")),
    "🔍 Lint C/C++ files": lambda: (lint_c(), exit_ok("")),
    "📐 Format C/C++ files (Clang)": lambda: (format_clang(), exit_ok("")),
    "📏 Format CMake files": lambda: (format_cmake(), exit_ok("")),
    "": lambda: exit_ok("")
}

if taskName in task_map:
    task_map[taskName]()
else:
    print(f"Received unknown task: {taskName}")
    exit_with_error("Task name is missing. Exiting.")