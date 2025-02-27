from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMake, cmake_layout, CMakeDeps
from conan.tools.system import package_manager

# Do NOT use cmake_layout(self) - it is incompatible with MWVCMake

class MarkWareVCMakeRecipe(ConanFile):
    
    name = "vcmlib"
    version = "1.0"
    
    # Settings
    settings = "os", "compiler", "build_type", "arch"
    generators = "CMakeToolchain", "CMakeDeps"
    
    # Binary configuration
    options = {"shared": [True, False], "fPIC": [True, False]}
    default_options = {"shared": False, "fPIC": True}
    
    # ----------------------------------------------------------
    # Consuming recipe
    # ----------------------------------------------------------
    
    def system_requirements(self):
        apt = package_manager.Apt(self)
        # apt.install(["libsdl2-dev"])

    def configure(self):
        self.options["*"].shared = False # this replaced shared flag from SolutionController and works

    def requirements(self):
        self.requires("zlib/[~1.3]")
        self.requires("fmt/[~11.1]") # required by cpm package
        self.requires("nlohmann_json/[~3.11]")

    def build_requirements(self):
        self.tool_requires("cmake/[>3.14]")
    
    # ----------------------------------------------------------    
    # Creating library recipe
    # ----------------------------------------------------------
    
    # Optional metadata
    license = "<Put the package license here>"
    author = "<Put your name here> <And your email here>"
    url = "<Package recipe repository url here, for issues about the package>"
    description = "<Description of hello package here>"
    topics = ("<Put some tag here>", "<here>", "<and here>")
   
    # Sources are located in the same place as this recipe, copy them to the recipe
    exports_sources = "CMakeLists.txt", "src/*", "include/*", "cmake/*", "LICENSE", "README.md"
    
    def config_options(self):
        if self.settings.os == "Windows":
            del self.options.fPIC

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def package(self):
        cmake = CMake(self)
        cmake.install()

    def package_info(self):
        self.cpp_info.libs = ["vcmlib"]
