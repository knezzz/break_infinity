part of infinity;

extension Factorial on Infinity {
  Infinity factorial() {
    logFunction('Factorial of ${toString()}!');
    Infinity _result;

    if (mantissa < 0 || layer == 0) {
      _result = add(Infinity.one()).gamma();
    } else if (layer == 1) {
      _result = (this * naturalLogarithm().subtract(Infinity.one())).exp();
    } else {
      _result = exp();
    }

    logFunction('Factorial of ${toString()}! is $_result');

    return _result;
  }
}
