part of infinity;

extension Negate on Infinity {
  Infinity neg() {
    logAbbreviation('negate on ${toString()}');
    return Infinity.fromComponents(-sign, layer, mantissa);
  }

  /// Negate
  Infinity operator -() {
    return neg();
  }
}
