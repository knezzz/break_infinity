part of infinity;

extension Lambert on Infinity {
  /// The Lambert W function, also called the omega function or product logarithm, is the solution W(x) === x*e^x.
  /// https://en.wikipedia.org/wiki/Lambert_W_function
  /// Some special values, for testing: https://en.wikipedia.org/wiki/Lambert_W_function#Special_values
  Infinity lambertW() {
    logFunction('lambert W on ${toString()}');
    Infinity _result;

    if (this < -0.3678794411710499) {
      throw UnsupportedError('lambertw is unimplemented for results less than -1, sorry!');
    } else if (mantissa < 0) {
      _result = Infinity.fromNum(fLambertW(other: toNumber()));
    } else if (layer == 0) {
      _result = Infinity.fromNum(fLambertW(other: sign * mantissa));
    } else if (layer == 1) {
      _result = dLambertW();
    } else if (layer == 2) {
      _result = dLambertW();
    } else {
      _result = Infinity.fromComponents(sign, layer - 1, mantissa, false);
    }

    logFunction('lambert W on ${toString()} is $_result', exiting: true);

    return _result;
  }

  /// from https://github.com/scipy/scipy/blob/8dba340293fe20e62e173bdf2c10ae208286692f/scipy/special/lambertw.pxd
  /// The evaluation can become inaccurate very close to the branch point
  /// at ``-1/e``. In some corner cases, `lambertw` might currently
  /// fail to converge, or can end up on the wrong branch.
  Infinity dLambertW({Infinity other, num tolerance = 1e-10}) {
    logFunction('d Lambert W on ${toString()} with ${other.toString()} tolerance is: $tolerance');

    Infinity _result;
    Infinity w;
    Infinity ew, wewz, wn;

    if (!other.mantissa.isFinite) {
      _result = other;
    } else if (other == Infinity.zero()) {
      _result = other;
    } else if (other == Infinity.one()) {
      //Split out this case because the asymptotic series blows up
      _result = Infinity.fromNum(omega);
    }

    //Get an initial guess for Halley's method
    w = other.naturalLogarithm();

    //Halley's method; see 5.9 in [1]

    for (int i = 0; i < 100; ++i) {
      ew = (-w).exp();
      wewz = w.subtract(other.multiply(ew));
      wn = w.subtract(wewz.divide(w.add(Infinity.one()).subtract(
          (w.add(Infinity.fromNum(2))).multiply(wewz).divide((Infinity.fromNum(2) * w).add(Infinity.fromNum(2))))));
      if ((wn.subtract(w)).abs() < (wn.multiply(Infinity.fromNum(tolerance)).abs())) {
        _result = wn;
        break;
      } else {
        w = wn;
      }
    }

    if (_result != null) {
      logFunction('d Lambert W on ${toString()} is $_result');
      return _result;
    }

    throw UnsupportedError('Iteration failed to converge: ${other.toString()}');
  }

  /// The Lambert W function, also called the omega function or product logarithm, is the solution W(x) === x*e^x.
  /// https://en.wikipedia.org/wiki/Lambert_W_function
  /// Some special values, for testing: https://en.wikipedia.org/wiki/Lambert_W_function#Special_values
  num fLambertW({num other, num tolerance = 1e-10}) {
    logFunction('f Lambert W on ${toString()} with ${other.toString()} tolerance is: $tolerance');

    num _result;

    num w;
    num wn;

    if (!other.isFinite) {
      _result = other;
    } else if (other == 0) {
      _result = other;
    } else if (other == 1) {
      _result = omega;
    }

    if (other < 10) {
      w = 0;
    } else {
      w = math.log(other) - math.log(math.log(other));
    }

    for (int i = 0; i < 100; ++i) {
      wn = (other * math.exp(-w) + w * w) / (w + 1);
      if ((wn - w).abs() < tolerance * wn.abs()) {
        _result = wn;
        break;
      } else {
        w = wn;
      }
    }

    if (_result != null) {
      logFunction('f Lambert W on ${toString()} is $_result');
      return _result;
    }

    throw UnsupportedError('Iteration failed to converge: ${other.toString()}');
  }
}
