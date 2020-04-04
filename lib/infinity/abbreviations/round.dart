part of infinity;

extension Round on Infinity {
  Infinity round() {
    logAbbreviation('round on ${toString()}');
    Infinity _result;

    if (mantissa < 0) {
      _result = Infinity.zero();
    } else if (layer == 0) {
      _result = Infinity.fromComponents(sign, 0, mantissa.roundToDouble(), false);
    }

    _result ??= this;

    logAbbreviation('round result ${_result.toString()}');
    return _result;
  }

  Infinity floor() {
    logAbbreviation('floor on ${toString()}');
    Infinity _result;

    if (mantissa < 0) {
      _result = Infinity.zero();
    } else if (layer == 0) {
      _result = Infinity.fromComponents(sign, 0, mantissa.floorToDouble(), false);
    }

    _result ??= this;

    logAbbreviation('floor result ${_result.toString()}');
    return _result;
  }

  Infinity ceil() {
    logAbbreviation('ceil on ${toString()}');
    Infinity _result;

    if (mantissa < 0) {
      _result = Infinity.zero();
    } else if (layer == 0) {
      _result = Infinity.fromComponents(sign, 0, mantissa.ceilToDouble(), false);
    }

    _result ??= this;

    logAbbreviation('ceil result ${_result.toString()}');
    return _result;
  }

  Infinity truncate() {
    logAbbreviation('truncate on ${toString()}');
    Infinity _result;

    if (mantissa < 0) {
      _result = Infinity.zero();
    } else if (layer == 0) {
      _result = Infinity.fromComponents(sign, 0, mantissa.truncateToDouble(), false);
    }

    _result ??= this;

    logAbbreviation('truncate result ${_result.toString()}');
    return _result;
  }
}
