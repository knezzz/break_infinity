part of infinity;

extension Gamma on Infinity {
  Infinity gamma() {
    if (mantissa < 0) {
      return reciprocal();
    } else if (layer == 0) {
      if (this < Infinity.fromComponents(1, 0, 24, false)) {
        return Infinity.fromNum(fGamma(sign * mantissa));
      }

      num t = mantissa - 1;
      num l = 0.9189385332046727; //0.5*math.log(2*pi)
      l = (l + ((t + 0.5) * math.log(t)));
      l = l - t;
      num n2 = t * t;
      num np = t;
      num lm = 12 * np;
      num adj = 1 / lm;
      num l2 = l + adj;

      if (l2 == l) {
        return Infinity.fromNum(l).exp();
      }

      l = l2;
      np = np * n2;
      lm = 360 * np;
      adj = 1 / lm;
      l2 = l - adj;
      if (l2 == l) {
        return Infinity.fromNum(l).exp();
      }

      l = l2;
      np = np * n2;
      lm = 1260 * np;
      num lt = 1 / lm;
      l = l + lt;
      np = np * n2;
      lm = 1680 * np;
      lt = 1 / lm;
      l = l - lt;
      return Infinity.fromNum(l).exp();
    } else if (layer == 1) {
      return (this * naturalLogarithm().subtract(Infinity.one())).exp();
    } else {
      return exp();
    }
  }

  num fGamma(num n) {
    if (!n.isFinite) {
      return n;
    }
    if (n < -50) {
      if (n == n.truncate()) {
        return double.negativeInfinity;
      }
      return 0;
    }

    num scal1 = 1;
    while (n < 10) {
      scal1 = scal1 * n;
      ++n;
    }

    n -= 1;
    double l = 0.9189385332046727; //0.5*math.log(2*Math.PI)
    l = l + (n + 0.5) * math.log(n);
    l = l - n;
    num n2 = n * n;
    num np = n;
    l = l + 1 / (12 * np);
    np = np * n2;
    l = l + 1 / (360 * np);
    np = np * n2;
    l = l + 1 / (1260 * np);
    np = np * n2;
    l = l + 1 / (1680 * np);
    np = np * n2;
    l = l + 1 / (1188 * np);
    np = np * n2;
    l = l + 691 / (360360 * np);
    np = np * n2;
    l = l + 7 / (1092 * np);
    np = np * n2;
    l = l + 3617 / (122400 * np);

    return math.exp(l) / scal1;
  }
}
