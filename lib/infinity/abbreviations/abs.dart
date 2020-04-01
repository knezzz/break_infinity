part of infinity;

extension Abs on Infinity {
  Infinity abs() {
    logDebug('abs on ${toString()}');
    sign = 1;
    return this;
  }

  Infinity absLog10() {
    logDebug('absLog10 on ${toString()}');

    if (sign == 0) {
      return Infinity.nan();
    } else if (layer > 0) {
      final num _layer = layer - 1;
      return Infinity.fromComponents(mantissa.sign.toInt(), _layer, mantissa.abs());
    } else {
      return Infinity.fromComponents(1, 0, mantissa.log10);
    }
  }
}
