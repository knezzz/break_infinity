part of infinity;

extension Root on Infinity {
  Infinity superSquareRoot() {
    if (sign == 1 && layer >= 3) {
      return Infinity.fromComponents(sign, layer - 1, mantissa, false);
    }
    final Infinity lnx = naturalLogarithm();
    return lnx.divide(lnx.lambertW());
  }

  Infinity cubeRoot() {
    return pow(Infinity.fromNum(1 / 3));
  }

  Infinity squareRoot() {
    if (layer == 0) {
      return Infinity.fromNum(math.sqrt(sign * mantissa));
    } else if (layer == 1) {
      return Infinity.fromComponents(1, 2, mantissa.log10 - 0.3010299956639812);
    } else {
      final Infinity _result =
          Infinity.fromComponents(sign, layer - 1, mantissa, false) / Infinity.fromComponents(1, 0, 2, false);
      _result.layer += 1;
      _result.normalize();
      return _result;
    }
  }

  Infinity root(Infinity other) {
    return pow(other.reciprocal());
  }
}
