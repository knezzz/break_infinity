part of infinity;

extension Logarithm on Infinity {
  Infinity naturalLogarithm() {
    if (sign <= 0) {
      return Infinity.nan();
    } else if (layer == 0) {
      return Infinity.fromComponents(sign, 0, math.log(mantissa));
    } else if (layer == 1) {
      return Infinity.fromComponents(mantissa.sign.toInt(), 0, mantissa.abs() * 2.302585092994046); //ln(10)
    } else if (layer == 2) {
      return Infinity.fromComponents(mantissa.sign.toInt(), 1, mantissa.abs() + 0.36221568869946325); //log10(log10(e))
    } else {
      return Infinity.fromComponents(mantissa.sign.toInt(), layer - 1, mantissa.abs());
    }
  }
}
