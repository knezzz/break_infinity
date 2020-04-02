part of infinity;

extension Negate on Infinity {
  Infinity neg() {
    logAbbreviation('negate on ${toString()}');
    sign = -sign;
    return this;
  }

  /// Negate
  Infinity operator -() {
    return neg();
  }
}
