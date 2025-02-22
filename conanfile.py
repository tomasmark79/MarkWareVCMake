from conan import ConanFile

class MarkWareVCMake(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    generators = "CMakeToolchain", "CMakeDeps"

    def configure(self):
        self.options["*"].shared = False # this replaced shared flag from SolutionController and works

    def requirements(self):
        self.requires("zlib/1.2.11")
        self.requires("fmt/11.1.1") # required by cpm package
        self.requires("nlohmann_json/3.11.2") # is modern to have json support

    # don't use this definition, it will break the build
    # ---------------------------------------- --
    # def layout(self):                        --
        # cmake_layout(self)                   --
    # ---------------------------------------- --

       

        
