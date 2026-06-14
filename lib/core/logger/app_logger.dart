/// Log severity levels.
enum LogLevel {
  debug,
  info,
  warning,
  error,
}

/// Centralized logging abstraction.
///
/// Swap implementation for remote logging (Crashlytics, Sentry) in production.
abstract interface class AppLogger {
  void debug(String message, {Object? data, StackTrace? stackTrace});
  void info(String message, {Object? data, StackTrace? stackTrace});
  void warning(String message, {Object? data, StackTrace? stackTrace});
  void error(String message, {Object? error, StackTrace? stackTrace});
}

/// Console-based logger for development.
final class ConsoleAppLogger implements AppLogger {
  const ConsoleAppLogger({this.tag = 'ROMS', this.minLevel = LogLevel.debug});

  final String tag;
  final LogLevel minLevel;

  @override
  void debug(String message, {Object? data, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, data: data, stackTrace: stackTrace);
  }

  @override
  void info(String message, {Object? data, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, data: data, stackTrace: stackTrace);
  }

  @override
  void warning(String message, {Object? data, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, data: data, stackTrace: stackTrace);
  }

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, data: error, stackTrace: stackTrace);
  }

  void _log(
    LogLevel level,
    String message, {
    Object? data,
    StackTrace? stackTrace,
  }) {
    if (level.index < minLevel.index) return;

    final prefix = switch (level) {
      LogLevel.debug => '🐛 DEBUG',
      LogLevel.info => 'ℹ️ INFO',
      LogLevel.warning => '⚠️ WARN',
      LogLevel.error => '❌ ERROR',
    };

    // ignore: avoid_print
    print('[$tag] $prefix: $message${data != null ? ' | $data' : ''}');
    if (stackTrace != null) {
      // ignore: avoid_print
      print(stackTrace);
    }
  }
}
