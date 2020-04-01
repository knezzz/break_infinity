part of infinity;

extension Exponential on Infinity {
  Infinity exp() {
    if (mantissa < 0) {
      return Infinity.one();
    }

    if (layer == 0 && mantissa <= 709.7) {
      return Infinity.fromNum(math.exp(sign * mantissa));
    } else if (layer == 0) {
      return Infinity.fromComponents(1, 1, sign * math.e.log10 * mantissa);
    } else if (layer == 1) {
      return Infinity.fromComponents(1, 2, sign * 0.4342944819032518.log10 + mantissa);
    } else {
      return Infinity.fromComponents(1, layer + 1, sign * mantissa);
    }
  }
}
