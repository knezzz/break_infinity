part of infinity;

extension Reciprocal on Infinity {
  Infinity reciprocal() {
    logAbbreviation('reciprocal on ${toString()}');
    if (mantissa == 0) {
      return Infinity.nan();
    } else if (layer == 0) {
      return Infinity.fromComponents(sign, 0, 1 / mantissa);
    } else {
      return Infinity.fromComponents(sign, layer, -mantissa);
    }
  }
}
