part of infinity;

extension Logarithm on Infinity {
  Infinity naturalLogarithm() {
    logFunction('Natural logarithm ${toString()}');

    Infinity _result;

    if (sign <= 0) {
      _result = Infinity.nan();
    } else if (layer == 0) {
      _result = Infinity.fromComponents(sign, 0, math.log(mantissa));
    } else if (layer == 1) {
      _result = Infinity.fromComponents(mantissa.sign.toInt(), 0, mantissa.abs() * 2.302585092994046); //ln(10)
    } else if (layer == 2) {
      _result =
          Infinity.fromComponents(mantissa.sign.toInt(), 1, mantissa.abs() + 0.36221568869946325); //log10(log10(e))
    } else {
      _result = Infinity.fromComponents(mantissa.sign.toInt(), layer - 1, mantissa.abs());
    }

    logFunction('Natural logarithm on ${toString()} is $_result');

    return _result;
  }
}
