part of infinity;

extension Abs on Infinity {
  Infinity abs() {
    logAbbreviation('abs on ${toString()}');
    sign = 1;
    return this;
  }

  Infinity absLog10() {
    logAbbreviation('absLog10 on ${toString()}');
    Infinity _result;

    if (sign == 0) {
      _result = Infinity.nan();
    } else if (layer > 0) {
      final num _layer = layer - 1;
      _result = Infinity.fromComponents(mantissa.sign.toInt(), _layer, mantissa.abs());
    } else {
      _result = Infinity.fromComponents(1, 0, mantissa.log10());
    }

    return _result;
  }
}
