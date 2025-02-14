#ifndef LOGGER_H
#define LOGGER_H

#include <iostream>
#include <string>
#include <chrono>
#include <iomanip>
#include <memory>
#include <mutex>

#ifdef _WIN32
  #include <windows.h>
#else
  #include <unistd.h>
#endif

// implementation example
// Logger::getInstance().log(Logger::Level::INFO, something);
// Logger::getInstance().info(something);

class Logger {
public:
  enum class Level { DEBUG, INFO, WARNING, ERROR };

  // C++11 Singleton
  static Logger& getInstance() {
    static Logger instance;
    return instance;
  }

  Logger(const Logger&) = delete;
  Logger& operator=(const Logger&) = delete;
  ~Logger() = default;

  void log(Level level, const std::string& message) {
    std::lock_guard<std::mutex> lock(logMutex);

    auto now = std::chrono::system_clock::now();
    auto now_time = std::chrono::system_clock::to_time_t(now);
    std::tm now_tm = *std::localtime(&now_time);

    std::cout << "[" << std::put_time(&now_tm, "%Y-%m-%d %H:%M:%S") << "] "
              << "[" << name << "] "
              << "[" << levelToString(level) << "] ";

    setConsoleColor(level);
    std::cout << message;

    resetConsoleColor();
    std::cout << std::endl;
  }

  void debug(const std::string& message) { log(Level::DEBUG, message); }
  void info(const std::string& message) { log(Level::INFO, message); }
  void warning(const std::string& message) { log(Level::WARNING, message); }
  void error(const std::string& message) { log(Level::ERROR, message); }

private:
  std::string name =
      "VCMLib";  // string name may be affected by SolutionRenamer.py
  std::mutex logMutex;

  Logger() = default;

  std::string levelToString(Level level) const {
    switch (level) {
      case Level::DEBUG: return "DEBUG";
      case Level::INFO: return "INFO";
      case Level::WARNING: return "WARNING";
      case Level::ERROR: return "ERROR";
      default: return "UNKNOWN";
    }
  }

  void setConsoleColor(Level level) {
#ifdef _WIN32
    HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
    switch (level) {
      case Level::DEBUG:
        SetConsoleTextAttribute(hConsole,
            FOREGROUND_BLUE | FOREGROUND_GREEN | FOREGROUND_INTENSITY);
        break;
      case Level::INFO:
        SetConsoleTextAttribute(
            hConsole, FOREGROUND_GREEN | FOREGROUND_INTENSITY);
        break;
      case Level::WARNING:
        SetConsoleTextAttribute(
            hConsole, FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_INTENSITY);
        break;
      case Level::ERROR:
        SetConsoleTextAttribute(
            hConsole, FOREGROUND_RED | FOREGROUND_INTENSITY);
        break;
      default:
        SetConsoleTextAttribute(
            hConsole, FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE);
        break;
    }
#else
    switch (level) {
      case Level::DEBUG:
        std::cout << "\033[34m";  // Blue
        break;
      case Level::INFO:
        std::cout << "\033[32m";  // Green
        break;
      case Level::WARNING:
        std::cout << "\033[33m";  // Yellow
        break;
      case Level::ERROR:
        std::cout << "\033[31m";  // Red
        break;
      default:
        std::cout << "\033[0m";  // Reset
        break;
    }
#endif
  }

  void resetConsoleColor() {
#ifdef _WIN32
    SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),
        FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE);
#else
    std::cout << "\033[0m";  // Reset
#endif
  }
};

#endif  // LOGGER_H

// Define LOG macro for easy access
#define LOG Logger::getInstance()