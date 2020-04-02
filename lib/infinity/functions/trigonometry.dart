part of infinity;

extension Trigonometry on Infinity {
  Infinity sin() {
    if (mantissa < 0) {
      return this;
    }
    if (layer == 0) {
      return Infinity.fromNum(math.sin(sign * mantissa));
    }
    return Infinity.fromComponents(0, 0, 0);
  }

  Infinity cos() {
    if (mantissa < 0) {
      return Infinity.one();
    }
    if (layer == 0) {
      return Infinity.fromNum(math.cos(sign * mantissa));
    }
    return Infinity.fromComponents(0, 0, 0);
  }

  Infinity tan() {
    if (mantissa < 0) {
      return this;
    }
    if (layer == 0) {
      return Infinity.fromNum(math.tan(sign * mantissa));
    }
    return Infinity.fromComponents(0, 0, 0);
  }

  Infinity asin() {
    if (mantissa < 0) {
      return this;
    }
    if (layer == 0) {
      return Infinity.fromNum(math.asin(sign * mantissa));
    }
    return Infinity.nan();
  }

  Infinity acos() {
    if (mantissa < 0) {
      return Infinity.fromNum(math.acos(toNumber()));
    }
    if (layer == 0) {
      return Infinity.fromNum(math.acos(sign * mantissa));
    }
    return Infinity.nan();
  }

  Infinity atan() {
    if (mantissa < 0) {
      return this;
    }
    if (layer == 0) {
      return Infinity.fromNum(math.atan(sign * mantissa));
    }
    return Infinity.fromNum(math.atan(sign * 1.8e308));
  }

  Infinity sinh() {
    return exp().subtract(neg().exp()).divide(Infinity.fromNum(2));
  }

  Infinity cosh() {
    return exp().add(neg().exp()).divide(Infinity.fromNum(2));
  }

  Infinity tanh() {
    return sinh().divide(cosh());
  }

  Infinity asinh() {
    return add(squareRoot().add(Infinity.one()).squareRoot()).naturalLogarithm();
  }

  Infinity acosh() {
    return add(square().subtract(Infinity.one()).squareRoot()).naturalLogarithm();
  }

  Infinity atanh() {
    if (abs() > Infinity.one()) {
      return Infinity.nan();
    }

    return (add(Infinity.one()).divide(Infinity.one()).subtract(this)).naturalLogarithm().divide(Infinity.fromNum(2));
  }
}
