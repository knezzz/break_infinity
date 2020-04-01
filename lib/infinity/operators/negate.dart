part of infinity;

extension Negate on Infinity {
  Infinity neg() {
    logDebug('neg on ${toString()}');
    sign = -sign;
    return this;
  }

  /// Negate
  Infinity operator -() {
    return neg();
  }
}
