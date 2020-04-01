part of infinity;

extension Factorial on Infinity {
  Infinity factorial() {
    if (mantissa < 0 || layer == 0) {
      return add(Infinity.one()).gamma();
    } else if (layer == 1) {
      return (this * naturalLogarithm().subtract(Infinity.one())).exp();
    } else {
      return exp();
    }
  }
}
