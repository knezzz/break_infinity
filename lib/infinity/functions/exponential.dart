part of infinity;

extension Exponential on Infinity {
  Infinity exp() {
    logFunction('Exp on ${toString()}');

    Infinity _result;

    if (mantissa < 0) {
      _result = Infinity.one();
    } else if (layer == 0 && mantissa <= 709.7) {
      _result = Infinity.fromNum(math.exp(sign * mantissa));
    } else if (layer == 0) {
      _result = Infinity.fromComponents(1, 1, sign * math.e.log10() * mantissa);
    } else if (layer == 1) {
      _result = Infinity.fromComponents(1, 2, sign * 0.4342944819032518.log10() + mantissa);
    } else {
      _result = Infinity.fromComponents(1, layer + 1, sign * mantissa);
    }

    logFunction('Exp on ${toString()} is $_result', exiting: true);

    return _result;
  }
}
