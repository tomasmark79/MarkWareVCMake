#ifndef LOGGER_H
#define LOGGER_H

#include <iostream>
#include <sstream>
#include <string>
#include <chrono>
#include <iomanip>
#include <memory>
#include <mutex>

#ifdef _WIN32
  #include <windows.h>
#endif

class Logger {
public:
  enum class Level {
    LOG_DEBUG,
    LOG_INFO,
    LOG_WARNING,
    LOG_ERROR,
    LOG_CRITICAL
  };

  // C++11 Singleton
  static Logger& getInstance() {
    static Logger instance;
    return instance;
  }

  Logger(const Logger&) = delete;
  Logger& operator=(const Logger&) = delete;

  void log(Level level, const std::string& message) {
    std::lock_guard<std::mutex> lock(logMutex);

    auto now = std::chrono::system_clock::now();
    auto now_time = std::chrono::system_clock::to_time_t(now);
    std::tm now_tm = *std::localtime(&now_time);

    std::cout << "[" << std::put_time(&now_tm, "%d-%m-%Y %H:%M:%S") << "] "
              << "[" << name << "] "
              << "[" << levelToString(level) << "] ";

    setConsoleColor(level);
    std::cout << message;

    resetConsoleColor();
    std::cout << std::endl;
  }

  // Stream support for different log levels
  Logger& operator<<(Level level) {
    currentLevel = level;
    return *this;
  }

  template<typename T>
  Logger& operator<<(const T& message) {
    std::lock_guard<std::mutex> lock(logMutex);

    if (!messageStream.str().empty()) { messageStream << " "; }
    messageStream << message;
    return *this;
  }

  Logger& operator<<(std::ostream& (*os)(std::ostream&)) {
    log(currentLevel, messageStream.str());
    messageStream.str("");  // Clear the stream
    messageStream.clear();  // Clear any error flags
    return *this;
  }

  void debug(const std::string& message) { log(Level::LOG_DEBUG, message); }
  void info(const std::string& message) { log(Level::LOG_INFO, message); }
  void warning(const std::string& message) { log(Level::LOG_WARNING, message); }
  void error(const std::string& message) { log(Level::LOG_ERROR, message); }
  void critical(const std::string& message) {
    log(Level::LOG_CRITICAL, message);
  }

private:
  std::string name =
      "VCMLib";  // string name may be affected by SolutionRenamer.py
  std::mutex logMutex;

  Level currentLevel = Level::LOG_INFO;  // Default log level
  std::ostringstream messageStream;

  Logger() = default;
  ~Logger() = default;

  std::string levelToString(Level level) const {
    switch (level) {
      case Level::LOG_DEBUG: return "DEB";
      case Level::LOG_INFO: return "INF";
      case Level::LOG_WARNING: return "WAR";
      case Level::LOG_ERROR: return "ERR";
      case Level::LOG_CRITICAL: return "CRI";
      default: return "UNKNOWN";
    }
  }

  void setConsoleColor(Level level) {
#ifdef _WIN32
    HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
    switch (level) {
      case Level::LOG_DEBUG:
        SetConsoleTextAttribute(hConsole,
            FOREGROUND_BLUE | FOREGROUND_GREEN | FOREGROUND_INTENSITY);
        break;
      case Level::LOG_INFO:
        SetConsoleTextAttribute(
            hConsole, FOREGROUND_GREEN | FOREGROUND_INTENSITY);
        break;
      case Level::LOG_WARNING:
        SetConsoleTextAttribute(
            hConsole, FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_INTENSITY);
        break;
      case Level::LOG_ERROR:
        SetConsoleTextAttribute(
            hConsole, FOREGROUND_RED | FOREGROUND_INTENSITY);
        break;
      case Level::LOG_CRITICAL:
        SetConsoleTextAttribute(
            hConsole, FOREGROUND_RED | FOREGROUND_BLUE | FOREGROUND_INTENSITY);
        break;
      default:
        SetConsoleTextAttribute(
            hConsole, FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE);
        break;
    }
#else
    switch (level) {
      case Level::LOG_DEBUG:
        std::cout << "\033[34m";  // Blue
        break;
      case Level::LOG_INFO:
        std::cout << "\033[32m";  // Green
        break;
      case Level::LOG_WARNING:
        std::cout << "\033[33m";  // Yellow
        break;
      case Level::LOG_ERROR:
        std::cout << "\033[31m";  // Red
        break;
      case Level::LOG_CRITICAL:
        std::cout << "\033[95m";  // Lila
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
};  // class Logger

// Define LOG macro for easy access
#define LOG Logger::getInstance()

// call logger examples
// Logger::getInstance().log(Logger::Level::INFO, something);
// Logger::getInstance().info(something);
// LOG.info(something);
// LOG << Logger::Level::LOG_INFO << "Loading library ommited" << std::endl;

#endif  // LOGGER_H
