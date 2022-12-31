

import conans
import os
import sys

class NTTChess(conans.ConanFile):
    name = "NTT:Chess"
    version = "0.1"
    description = ""
    license = "MIT"
    author = "thinhorigami (NTT)"
    
    settings = "os", "compiler"
    requires = [
      "libmysqlclient/8.0.30"
    ]
    generators = "cmake_find_package", "cmake"
    build_policy = "missing"

    def build(self):
      cmake = conans.CMake(self)
      cmake.definitions["CMAKE_EXPORT_COMPILE_COMMANDS"] = True
      cmake.configure()
      cmake.build()