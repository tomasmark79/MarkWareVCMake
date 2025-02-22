import os
import sys
import subprocess
import shutil
import platform
import glob
import re
import tarfile
import uuid
import json

# Get the Python version
pythonVersion = sys.version.split()[0]

GREEN = "\033[0;32m"
YELLOW = "\033[0;33m"
RED = "\033[0;31m"
NC = "\033[0m"
LIGHTBLUE = "\033[1;34m"

def exit_ok(msg):
    print(f"{GREEN}{msg}{NC}")
    sys.exit(0)

def exit_with_error(msg):
    print(f"{RED}{msg}{NC}")
    sys.exit(1)

# Get the directory of the script
workSpaceDir = os.path.dirname(os.path.abspath(__file__))

# Script version and author
scriptVersion = "0.0.4"
scriptAuthor = "(c) Tomáš Mark 2024-2025"
nameOfScript = "MarkWare " + os.path.basename(__file__) + \
    " " + scriptAuthor + f"\nv {scriptVersion}" + \
    f" is using Python runtime version: {pythonVersion}\n"

# Get the task name and other parameters from the command line
buildProduct = sys.argv[1] if len(sys.argv) > 1 else None
taskName = sys.argv[2] if len(sys.argv) > 2 else None
buildArch = sys.argv[3] if len(sys.argv) > 3 else None
buildType = sys.argv[4] if len(sys.argv) > 4 else "Not Defined"

# Calculate the flags for library and standalone
lib_flag = buildProduct in ["both", "library"]
st_flag = buildProduct in ["both", "standalone"]

# Cross compilation flag
isCrossCompilation = False

# Unique ID for debugging CMake
unique_id = str(uuid.uuid4())

# Build folder name 
buildFolderName = "Build"

# Output directories
installOutputDir = os.path.join(workSpaceDir, buildFolderName, "Install")
artefactsOutputDir = os.path.join(workSpaceDir, buildFolderName, "Artefacts")

# Check if the task name is not empty
if not taskName:
    exit_with_error("Task name is missing. Exiting.")

# remove comments with important not correctly trailing commas
def remove_comments(json_str):
    import re
    # Odstraní // komentáře
    json_str = re.sub(r'//.*', '', json_str)
    # Odstraní /* ... */ bloky
    json_str = re.sub(r'/\*.*?\*/', '', json_str, flags=re.DOTALL)
    # Odstraní závěrečné čárky v objektech a seznamech
    json_str = re.sub(r',\s*([}\]])', r'\1', json_str)
    return json_str

# Load tasks.json and get the valid archs and build types
tasks_path = os.path.join(workSpaceDir, ".vscode", "tasks.json")
if os.path.isfile(tasks_path):
    with open(tasks_path, "r", encoding="utf-8") as f:
        raw_content = f.read()
    # Remove comments and trailing commas from JSON
    clean_content = remove_comments(raw_content)
    tasks_config = json.loads(clean_content)
    valid_archs = []
    valid_build_types = []
    for inp in tasks_config.get("inputs", []):
        if inp.get("id") == "buildArch":
            valid_archs = inp.get("options", [])
        if inp.get("id") == "buildType":
            valid_build_types = inp.get("options", [])
    if not valid_archs:
        exit_with_error("Architecture definitions (buildArch) are missing in tasks.json")
    if not valid_build_types:
        exit_with_error("Build type definitions (buildType) are missing in tasks.json")
else:
    exit_with_error(f"File tasks.json not found: {tasks_path}")

# debug print all available tasks
# print(f"{YELLOW}Available archs: {valid_archs}{NC}")
# print(f"{YELLOW}Available build types: {valid_build_types}{NC}")    

# Print out the welcom and configuration
print(f"{YELLOW}{nameOfScript}{NC}")
print(f"{LIGHTBLUE}taskName\t: {taskName}{NC}")
print(f"{GREEN}Build Arch\t: {buildArch}")
print(f"Build Type\t: {buildType}")
print(f"Work Space\t: {workSpaceDir}{NC}")
print(f"Install to\t: {installOutputDir}{NC}")
print(f"Artefacts to\t: {artefactsOutputDir}{NC}")

isCrossCompilation = False

if not buildArch == "noNeedArch":
    if buildArch in valid_archs:
        isCrossCompilation = (buildArch != "default")
    else:
        if "darwin" in platform.system().lower():
            isCrossCompilation = False
        else:
            exit_with_error("Undefined build architecture. Exiting.")

print(f"{YELLOW}Cross\t\t: {isCrossCompilation}{NC}")

### Get version and names from CMakeLists.txt
def get_version_and_names():
    with open('CMakeLists.txt', 'r') as file:
        cmake_content = file.read()
    with open('Standalone/CMakeLists.txt', 'r') as file:
        standalone_content = file.read()
    lib_ver = re.search(r'VERSION\s+(\d+\.\d+\.\d+)', cmake_content).group(1)
    lib_name = re.search(r'set\(LIBRARY_NAME\s+(\w+)', cmake_content).group(1)
    st_name = re.search(r'set\(STANDALONE_NAME\s+(\w+)', standalone_content).group(1)
    return lib_ver, lib_name, st_name

### Log to file, revision 1
def log2file(message):
    with open(os.path.join(workSpaceDir, "Solution.log"), "a") as f:
        f.write(message + "\n")

### Execute command, revision 1
def execute_command(cmd):
    print(f"{LIGHTBLUE}> Executed: {cmd}{NC}")
    log2file(cmd)
    if platform.system().lower() == "windows":
        result = subprocess.run(cmd, shell=True)
    else:
        result = subprocess.run(cmd, shell=True, executable="/bin/bash")
    if result.returncode != 0:
        exit_with_error(f"Command failed: {cmd}")

### Execute subprocess with shell, revision 1
def execute_subprocess(cmd, executable):
    print(f"{LIGHTBLUE}> Executed: {cmd}{NC}")
    log2file(cmd)
    result = subprocess.run(cmd, shell=True, executable=executable)
    if result.returncode != 0:
        exit_with_error(f"Command failed: {cmd}")

def get_build_dir(kind):
    return os.path.join(buildFolderName, kind, buildArch, buildType)

### Conan install, revision 2
def conan_install(bdir):
    with open("CMakeLists.txt") as f:
        cmake_content = f.read()
    profile = "default" if not isCrossCompilation else buildArch
    exeCmd = f'conan install "{workSpaceDir}" --output-folder="{os.path.join(workSpaceDir, bdir)}" --deployer=full_deploy --build=missing --profile {profile} --settings build_type={buildType}'
    
    execute_command(exeCmd)

### CMake configuration, revision 2
def cmake_configure(src, bdir, isCMakeDebugger=False):
    
    conan_toolchain_file_path = os.path.join(workSpaceDir, bdir, "conan_toolchain.cmake")
    
    # Conan
    # ---------------------------------------------------------------------------------
    if os.path.isfile(conan_toolchain_file_path):
        print(f"{LIGHTBLUE} using file: conan_toolchain.cmake {NC}")
        print(f"{LIGHTBLUE} using file:", conan_toolchain_file_path, NC)
        DCMAKE_TOOLCHAIN_FILE_CMD = f'-DCMAKE_TOOLCHAIN_FILE="{conan_toolchain_file_path}"'

        if platform.system().lower() in ["linux", "darwin"]: 
            # CMake configuration for Linux and MacOS with Conan toolchain
            conan_build_sh_file = os.path.join(workSpaceDir, bdir, "conanbuild.sh")

            
            if (not isCMakeDebugger):
                bashCmd = f'source "{conan_build_sh_file}" && cmake -S "{src}" -B "{os.path.join(workSpaceDir, bdir)}" {DCMAKE_TOOLCHAIN_FILE_CMD} -DCMAKE_BUILD_TYPE={buildType} -DCMAKE_INSTALL_PREFIX="{os.path.join(installOutputDir, buildArch, buildType)}"'
            else:
                
                print (f"uuid: {unique_id}")
                
                launch_json_path = os.path.join(workSpaceDir, ".vscode", "launch.json")
                
                try:
                    with open(launch_json_path, 'r') as file:
                        launch_data = json.load(file)
                    
                    for config in launch_data.get("configurations", []):
                        if "pipeName" in config:
                            config["pipeName"] = f"/tmp/cmake-debugger-pipe-{unique_id}"
                    
                    with open(launch_json_path, 'w') as file:
                        json.dump(launch_data, file, indent=4)
                except json.JSONDecodeError as e:
                    print(f"Error decoding JSON: {e}")
                    exit(1) 
                print("If you want to debug CMake, please put a breakpoint in your CMakeLists.txt and start debugging in Visual Studio Code.")
                bashCmd = f'source "{conan_build_sh_file}" && cmake -S "{src}" -B "{os.path.join(workSpaceDir, bdir)}" {DCMAKE_TOOLCHAIN_FILE_CMD} -DCMAKE_BUILD_TYPE={buildType} -DCMAKE_INSTALL_PREFIX="{os.path.join(installOutputDir, buildArch, buildType)}" --debugger --debugger-pipe /tmp/cmake-debugger-pipe-{unique_id}'

            # Execute comfigure bash command
            execute_subprocess(bashCmd, "/bin/bash")
        
        if platform.system().lower() == "windows":
            # CMake configuration for Windows x64 with Conan toolchain    
            conan_build_bat_file = os.path.join(workSpaceDir, bdir, "conanbuild.bat")
            winCmd = f'call "{conan_build_bat_file}" && cmake -S "{src}" -B "{os.path.join(workSpaceDir, bdir)}" {DCMAKE_TOOLCHAIN_FILE_CMD} -DCMAKE_BUILD_TYPE={buildType} -DCMAKE_INSTALL_PREFIX="{os.path.join(installOutputDir, buildArch, buildType)}"'
            execute_subprocess(winCmd, "cmd.exe")

    # CMake solo
    # This command condition will miss find_package(Conan's packages) in CMakeLists.txt
    # But it is useful for CMake projects without Conan
    # ---------------------------------------------------------------------------------
    if not os.path.isfile(conan_toolchain_file_path):
        if buildArch in valid_archs and buildArch != "default":
            # CMake configuration for cross-compilation with solo toolchain
            cmake_toolchain_file = os.path.join(workSpaceDir, "Utilities", "CMakeToolChains", buildArch + ".cmake")
            DCMAKE_TOOLCHAIN_FILE_CMD = f"-DCMAKE_TOOLCHAIN_FILE=" + cmake_toolchain_file
            print(f"{LIGHTBLUE} using file:", cmake_toolchain_file, NC)
        else:
            # CMake native
            DCMAKE_TOOLCHAIN_FILE_CMD = ""   
        # CMake solo command
        cmd = f'cmake -S "{src}" -B "{os.path.join(workSpaceDir, bdir)}" {DCMAKE_TOOLCHAIN_FILE_CMD} -DCMAKE_BUILD_TYPE={buildType} -DCMAKE_INSTALL_PREFIX="{os.path.join(installOutputDir,buildArch,buildType)}"'
        execute_command(cmd)

### CMake build, revision 3
def cmake_build(bdir, target=None):
    
    # --target is optional
    if target is None:
        target = ""
    else:
        target = f"--target {target}"    
        
    conan_build_sh_file = os.path.join(workSpaceDir, bdir, 'conanbuild.sh')
    if os.path.exists(conan_build_sh_file):
        bashCmd = f'source "{conan_build_sh_file}" && cmake --build "{os.path.abspath(bdir)}" {target} -j {os.cpu_count()}'
    else:
        bashCmd = f'cmake --build "{os.path.abspath(bdir)}" {target} -j {os.cpu_count()}'
    execute_subprocess(bashCmd, "/bin/bash")

### Clean build folder, revision 1   
def clean_build_folder(bdir):
    print(f"{LIGHTBLUE}> Removing build directory: {bdir}{NC}")
    log2file(f"Remove: {bdir}")
    shutil.rmtree(bdir, ignore_errors=True)


def build_spltr(lib, st):
    if lib:
        cmake_build(get_build_dir("Library"))
    if st:
        cmake_build(get_build_dir("Standalone"))

def configure_spltr(lib, st):
    if lib:
        cmake_configure(".", get_build_dir("Library"), False)
    if st:
        cmake_configure("./Standalone", get_build_dir("Standalone"), False)
        
def configure_spltr_cmake_debugger(lib, st):
    if lib:
        cmake_configure(".", get_build_dir("Library"), True)
    if st:
        cmake_configure("./Standalone", get_build_dir("Standalone"), True)

def cmake_install(bdir):
    cmake_build(bdir, target="install")        

def conan_spltr(lib, st):
    if lib:
        conan_install(get_build_dir("Library"))
    if st:
        conan_install(get_build_dir("Standalone"))

def clean_spltr(lib, st):
    if lib:
        clean_build_folder(get_build_dir("Library"))
    if st:
        clean_build_folder(get_build_dir("Standalone"))

def install_spltr(lib, st):
    if lib:
        cmake_install(get_build_dir("Library"))
    if st:
        cmake_install(get_build_dir("Standalone"))

def license_spltr(lib, st):
    lib_ver, lib_name, st_name = get_version_and_names()
    if lib:
        cmake_build(get_build_dir("Library"), f"write-licenses-{lib_name}")
    if st:
        cmake_build(get_build_dir("Standalone"), f"write-licenses-{st_name}")

def create_archive(source_dir, out_path):
    with tarfile.open(out_path, "w:gz") as tar:
        tar.add(source_dir, arcname=".")
    print(f"Created archive: {out_path}")

def artefacts_spltr(lib, st):
    os.makedirs(artefactsOutputDir, exist_ok=True)
    lib_ver, lib_name, st_name = get_version_and_names()
    
    print(f"buildArch: {buildArch}")
    print(f"buildType: {buildType}")
    print(f"artefactsOutputDir: {artefactsOutputDir}")
    print(f"valid_archs: {valid_archs}")
    
    if buildArch in valid_archs:
        if lib:
            archive_name = f"{lib_name}-{lib_ver}-{buildArch}-{buildType}.tar.gz"
            source_dir = os.path.join(installOutputDir, buildArch, buildType)
            
            if os.listdir(source_dir):
                print(f"Creating archive for library from: {source_dir}")
                out_path = os.path.join(artefactsOutputDir, archive_name)
                create_archive(source_dir, out_path)
            else:
                print(f"No content found in {source_dir} for library.")
            
        if st:
            st_archive_name = f"{st_name}-{lib_ver}-{buildArch}-{buildType}.tar.gz"
            source_dir = os.path.join(installOutputDir, buildArch, buildType)
            
            if os.listdir(source_dir):
                print(f"Creating archive for standalone from: {source_dir}")
                out_path = os.path.join(artefactsOutputDir, st_archive_name)
                create_archive(source_dir, out_path)
            else:
                print(f"No content found in {source_dir} for standalone.")

def run_cpack(lib, st):
    if lib:
        cmake_build(get_build_dir("Library"), target="package")
    if st:
        cmake_build(get_build_dir("Standalone"), target="package")

def find_clang_tidy():
    for version in range(20, 0, -1):
        clang_tidy_cmd = f"clang-tidy-{version}"
        if shutil.which(clang_tidy_cmd):
            return clang_tidy_cmd
    return "clang-tidy"  # Fallback to default clang-tidy if no versioned one is found

def clang_tidy_spltr(lib, st):
    clang_tidy_cmd = find_clang_tidy()
    
    def run_clang_tidy(bdir):
        for root, _, files in os.walk(workSpaceDir):
            if "Build" in root:
                continue
            for file in files:
                if file.endswith((".c", ".cpp", ".h", ".hpp")):
                    full_path = os.path.join(root, file)
                    cmd = f'{clang_tidy_cmd} -p "{bdir}" "{full_path}"'
                    print(f"Analyzing: {full_path}")
                    execute_command(cmd)
                    print(f"Done: {full_path}")
    
    if lib:
        bdir = get_build_dir("Library")
        run_clang_tidy(bdir)
    if st:
        bdir = get_build_dir("Standalone")
        run_clang_tidy(bdir)


def find_clang_format():
    for version in range(20, 0, -1):
        clang_format_cmd = f"clang-format-{version}"
        if shutil.which(clang_format_cmd):
            return clang_format_cmd
    return "clang-format"  # Fallback to default clang-format if no versioned one is found

def clang_format():
    clang_format_cmd = find_clang_format()
    
    for root, _, files in os.walk(workSpaceDir):
        if "Build" in root:
            continue
        for file in files:
            if file.endswith((".c", ".cpp", ".h", ".hpp")):
                full_path = os.path.join(root, file)
                cmd = f'{clang_format_cmd} -i "{full_path}"'
                print(f"Processing: {full_path}")
                execute_command(cmd)
                print(f"Done: {full_path}")

def cmake_format():
    for root, _, files in os.walk(workSpaceDir):
        if "Build" in root or "cmake" in root or "Utilities" in root:
            continue
        for file in files:
            if file == "CMakeLists.txt" or file.endswith(".cmake"):
                full_path = os.path.join(root, file)
                cmd = f'cmake-format --enable-markup -i "{full_path}"'
                print(f"Processing: {full_path}")
                execute_command(cmd)
                print(f"Done: {full_path}")

def conan_graph():
    cmd = f'conan graph info "{workSpaceDir}" --format=html > graph.html'
    execute_command(cmd)

# ------ help functions for task map --------------------------

def zero_to_build():
    clean_spltr(lib_flag, st_flag)
    conan_spltr(lib_flag, st_flag)
    configure_spltr(lib_flag, st_flag)
    build_spltr(lib_flag, st_flag)

def zero_to_hero():
    zero_to_build()
    install_spltr(lib_flag, st_flag)
    artefacts_spltr(lib_flag, st_flag)

# ------ task map ---------------------------------------------

task_map = {
    "🚀 Zero to Build": zero_to_build,
    "🦸 Zero to Hero": zero_to_hero,
    "🧹 Clean folder": lambda: clean_spltr(lib_flag, st_flag),
    "🗡️ Conan install": lambda: conan_spltr(lib_flag, st_flag),
    "🔧 CMake configure": lambda: configure_spltr(lib_flag, st_flag),
    "🪲 CMake configure with debugger": lambda: configure_spltr_cmake_debugger(lib_flag, st_flag),
    "🔨 Build": lambda: build_spltr(lib_flag, st_flag),
    "📜 Collect Licenses": lambda: license_spltr(lib_flag, st_flag),
    "📌 Install Artefacts": lambda: install_spltr(lib_flag, st_flag),
    "📦 Release Tarballs": lambda: artefacts_spltr(lib_flag, st_flag),
    "🛸 Run CPack": lambda: run_cpack(lib_flag, st_flag),
    "🔍 clang-tidy": lambda: clang_tidy_spltr(lib_flag, st_flag),
    "📐 clang-format": clang_format,
    "📏 cmake-format": cmake_format,
    "⚔️ conan graph.html": conan_graph,
    "": lambda: exit_ok(""),
}

if taskName in task_map:
    task_map[taskName]()
else:
    print(f"Received unknown task: {taskName}")
    exit_with_error("Task name is missing. Exiting.")
    
# Copyright (c) 2024 Tomáš Mark