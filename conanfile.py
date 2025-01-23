from conan import ConanFile
from conan.tools.cmake import cmake_layout

class MarkWareVCMake(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    generators = "CMakeToolchain", "CMakeDeps"

    def requirements(self):
        self.requires("zlib/1.2.11") 
        self.requires("fmt/11.1.1") #required by cpm package
        self.requires("nlohmann_json/3.11.2") # is modern to have json support
        
    # def build_requirements(self):
        # self.tool_requires("cmake/3.22.6")

    # MarkWareVCMake is using self mechanism to define the layout!
    # Do not use defaull cmake_layout bellow or template goes broken!
    #def layout(self):
        # cmake_layout(self)
    

       

        
