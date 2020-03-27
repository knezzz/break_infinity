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

  void logInfo(Object info) {
    logDebug(info.toString(), severity: Severity.info);
  }

  void logVerbose(Object error, {String debugString, StackTrace stackTrace}) {
    logDebug(error.toString(), stackTrace: stackTrace, severity: Severity.verbose);
    if (debugString != null) {
      logDebug(debugString, severity: Severity.verbose);
    }
  }

  String _getPrefix(Severity severity) {
    final String _timeStamp = _getTimestamp();
    return '${_getSeverityColor(severity)}[${severity.toString().replaceAll('Severity.', '').substring(0, 1).toUpperCase()}] $_timeStamp [$runtimeType] - ';
  }

  String _getTimestamp() {
    final DateTime _now = DateTime.now();

    String _format(int value, {int padding = 2}) {
      return value.toString().padLeft(padding, '0');
    }

    return '${_format(_now.hour)}:${_format(_now.minute)}:${_format(_now.second)}.${_format(_now.millisecond, padding: 3)}';
  }

  String _getSeverityColor(Severity severity) {
    switch (severity) {
      case Severity.verbose:
        return '\x1b[37m';
      case Severity.debug:
        return '\x1b[94m';
      case Severity.info:
        return '\x1b[93m';
      case Severity.warning:
        return '\x1b[33m';
      case Severity.error:
        return '\x1b[91m';
      case Severity.critical:
        return '\x1b[31m';
    }

    return '';
  }
}
