enum Severity { verbose, debug, info, warning, error, critical }

/// Logger is mixin that will log messages to console if debug is set to on
/// [debug] will default to false so it doesn't clog the terminal
mixin Logger {
  final bool debug = true;
  final Severity showSeverity = Severity.verbose;

  bool _showLog(Severity severity) {
    return debug && severity.index >= showSeverity.index;
  }

  void logDebug(String message, {Severity severity = Severity.debug, StackTrace stackTrace}) {
    if (_showLog(severity)) {
      print('${_getPrefix(severity)}$message');
    }
  }

  void logError(Object error, {StackTrace stackTrace}) {
    logDebug(error.toString(), stackTrace: stackTrace, severity: Severity.error);
  }

  void logVerbose(Object error, {String debugString, StackTrace stackTrace}) {
    logDebug(error.toString(), stackTrace: stackTrace, severity: Severity.verbose);
    if (debugString != null) {
      logDebug(debugString, severity: Severity.verbose);
    }
  }

  String _getPrefix(Severity severity) {
    final String _timeStamp = _getTimestamp();
    return '[${severity.toString().replaceAll('Severity.', '').substring(0, 1).toUpperCase()}] [P3] $_timeStamp [$runtimeType] - ';
  }

  String _getTimestamp() {
    final DateTime _now = DateTime.now();

    String _format(int value, {int padding = 2}) {
      return value.toString().padLeft(padding, '0');
    }

    return '${_format(_now.hour)}:${_format(_now.minute)}:${_format(_now.second)}.${_format(_now.millisecond, padding: 3)}';
  }
}
