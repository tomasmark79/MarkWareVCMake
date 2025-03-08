#include <string>
#include <fstream>
#include <iostream>
#include <memory>

// Platform-specific includes
#ifdef _WIN32
  #include <windows.h>
#elif defined(__APPLE__)
  #include <mach-o/dyld.h>
  #include <limits.h>
#else  // Linux
  #include <unistd.h>
  #include <limits.h>
#endif

// MIT License
// Copyright (c) 2024-2025 Tomáš Mark

namespace FileSystemManager {
  // Get executable path in a cross-platform way
  std::string getExecutableDirectory();

  // Get executable path in a cross-platform way
  std::string getExecutableDirectory() {
    std::string path;

#ifdef _WIN32
    // Windows implementation
    char buffer[MAX_PATH];
    GetModuleFileNameA(NULL, buffer, MAX_PATH);
    path = buffer;

    // Remove executable name to get just the directory
    size_t pos = path.find_last_of("\\/");
    if (pos != std::string::npos) { path = path.substr(0, pos); }
#elif defined(__APPLE__)
    // macOS implementation
    char buffer[PATH_MAX];
    uint32_t bufferSize = PATH_MAX;
    if (_NSGetExecutablePath(buffer, &bufferSize) == 0) {
      char realPath[PATH_MAX];
      if (realpath(buffer, realPath) != nullptr) {
        path = realPath;

        // Remove executable name
        size_t pos = path.find_last_of("/");
        if (pos != std::string::npos) { path = path.substr(0, pos); }
      }
    }
#else
    // Linux implementation
    char buffer[PATH_MAX];
    ssize_t count = readlink("/proc/self/exe", buffer, PATH_MAX);
    if (count != -1) {
      buffer[count] = '\0';
      path = buffer;

      // Remove executable name
      size_t pos = path.find_last_of("/");
      if (pos != std::string::npos) { path = path.substr(0, pos); }
    }
#endif

    return path;
  }
}  // namespace FileSystemManager