import 'dart:math' as math;

import 'package:infinity/infinity/infinity.dart';
import 'package:infinity/infinity/infinity_constants.dart';

extension InfinityExtensions on Infinity {
  Infinity round() {
    logDebug('round on ${toString()}');
    if (mantissa < 0) {
      return Infinity.zero();
    } else if (layer == 0) {
      return Infinity.fromComponents(sign, 0, mantissa.roundToDouble());
    }

    return this;
  }

  Infinity floor() {
    logDebug('floor on ${toString()}');
    if (mantissa < 0) {
      return Infinity.zero();
    } else if (layer == 0) {
      return Infinity.fromComponents(sign, 0, mantissa.floorToDouble());
    }

    return this;
  }

  Infinity ceil() {
    logDebug('ceil on ${toString()}');
    if (mantissa < 0) {
      return Infinity.zero();
    } else if (layer == 0) {
      return Infinity.fromComponents(sign, 0, mantissa.ceilToDouble());
    }

    return this;
  }

  Infinity truncate() {
    logDebug('truncate on ${toString()}');
    if (mantissa < 0) {
      return Infinity.zero();
    } else if (layer == 0) {
      return Infinity.fromComponents(sign, 0, mantissa.truncateToDouble());
    }

    return this;
  }

  Infinity reciprocal() {
    logDebug('reciprocal on ${toString()}');
    if (mantissa == 0) {
      return Infinity.nan();
    } else if (layer == 0) {
      return Infinity.fromComponents(sign, 0, 1 / mantissa);
    } else {
      return Infinity.fromComponents(sign, layer, -mantissa);
    }
  }

  Infinity divide(Infinity other) {
    logVerbose('Dividing ${toString()} and ${other.toString()}');
    return multiply(other.reciprocal());
  }

  Infinity abs() {
    logDebug('abs on ${toString()}');
    sign = 1;
    return this;
  }

  Infinity neg() {
    logDebug('neg on ${toString()}');
    sign = -sign;
    return this;
  }

  Infinity subtract(Infinity other) {
    logVerbose('Subtracting ${toString()} and ${other.toString()}');

    return add(other.neg());
  }

  Infinity operator +(dynamic other) {
    final Infinity _inf = _getInfinity(other);

    if (_inf != null) {
      return add(_inf);
    }

    throw ArgumentError('Bad arguments to add: $this + $other');
  }

  Infinity operator *(dynamic other) {
    final Infinity _inf = _getInfinity(other);

    if (_inf != null) {
      return multiply(_inf);
    }

    throw ArgumentError('Bad arguments to multiply: $this * $other');
  }

  Infinity operator -(dynamic other) {
    final Infinity _inf = _getInfinity(other);

    if (_inf != null) {
      return subtract(_inf);
    }

    throw ArgumentError('Bad arguments to subtract: $this - $other');
  }

  /// Negate
  Infinity operator -() {
    return neg();
  }

  Infinity operator /(dynamic other) {
    final Infinity _inf = _getInfinity(other);

    if (_inf != null) {
      return divide(_inf);
    }

    throw ArgumentError('Bad arguments to divide: $this / $other');
  }

  bool operator >(dynamic other) {
    final Infinity _inf = _getInfinity(other);

    if (_inf != null) {
      return _inf.compare(this) == -1;
    }

    throw ArgumentError('Bad arguments: $this / $other');
  }

  bool operator <(dynamic other) {
    final Infinity _inf = _getInfinity(other);

    if (_inf != null) {
      return _inf.compare(this) == 1;
    }

    throw ArgumentError('Bad arguments: $this / $other');
  }

  bool operator >=(dynamic other) {
    return !(this < other);
  }

  bool operator <=(dynamic other) {
    return !(this > other);
  }

  Infinity max(dynamic other) {
    logDebug('max: ${toString()} and ${other.toString()}');
    final Infinity _inf = _getInfinity(other);

    if (_inf != null) {
      return _inf > this ? _inf : this;
    }

    throw ArgumentError('Bad arguments for max: $this / $other');
  }

  Infinity min(dynamic other) {
    logDebug('min: ${toString()} and ${other.toString()}');
    final Infinity _inf = _getInfinity(other);

    if (_inf != null) {
      return _inf < this ? _inf : this;
    }

    throw ArgumentError('Bad arguments for min: $this / $other');
  }

  Infinity maxAbs(dynamic other) {
    logDebug('maxAbs: ${toString()} and ${other.toString()}');
    final Infinity _inf = _getInfinity(other);

    if (_inf != null) {
      return cmpAbs(_inf) < 0 ? _inf : this;
    }

    throw ArgumentError('Bad arguments for max: $this / $other');
  }

  Infinity minAbs(dynamic other) {
    logDebug('minAbs: ${toString()} and ${other.toString()}');

    final Infinity _inf = _getInfinity(other);

    if (_inf != null) {
      return cmpAbs(_inf) > 0 ? _inf : this;
    }

    throw ArgumentError('Bad arguments for min: $this / $other');
  }

  Infinity clamp(dynamic min, dynamic max) {
    logDebug('clamp: $min - $max');

    final Infinity _min = _getInfinity(min);
    final Infinity _max = _getInfinity(max);

    return this.max(_min).min(_max);
  }

  Infinity clampMin(dynamic min) {
    logDebug('clampMin: $min');
    final Infinity _min = _getInfinity(min);

    return max(_min);
  }

  Infinity clampMax(dynamic max) {
    logDebug('clampMax: $max');

    final Infinity _max = _getInfinity(max);

    return min(_max);
  }

  Infinity absLog10() {
    logDebug('absLog10 on ${toString()}');

    if (sign == 0) {
      return Infinity.nan();
    } else if (layer > 0) {
      return Infinity.fromComponents(mantissa.sign.toInt(), --layer, mantissa.abs());
    } else {
      return Infinity.fromComponents(1, 0, log10(mantissa));
    }
  }

  Infinity pow(Infinity other) {
    logDebug('Pow ${toString()} on ${other.toString()}');
    if (sign == 0) {
      return this;
    } else if (sign == 1 && layer == 0 && mantissa == 1) {
      return this;
    } else if (other.sign == 0) {
      return Infinity.fromComponents(1, 0, 1);
    } else if (other.sign == 1 && other.layer == 0 && other.mantissa == 1) {
      return this;
    }

    Infinity _result = (absLog10().multiply(other))._pow10();

    /// Check if end result should be round number
    if (other.isInt && isInt) {
      _result = _result.round();
    }

    if (sign == -1 && other.toNumber() % 2 == 1) {
      return _result.neg();
    }

    return _result;
  }

  Infinity root(Infinity other) {
    return pow(other.reciprocal());
  }

  Infinity ln() {
    if (sign <= 0) {
      return Infinity.nan();
    } else if (layer == 0) {
      return Infinity.fromComponents(sign, 0, math.log(mantissa));
    } else if (layer == 1) {
      return Infinity.fromComponents(mantissa.sign.toInt(), 0, mantissa.abs() * 2.302585092994046); //ln(10)
    } else if (layer == 2) {
      return Infinity.fromComponents(mantissa.sign.toInt(), 1, mantissa.abs() + 0.36221568869946325); //log10(log10(e))
    } else {
      return Infinity.fromComponents(mantissa.sign.toInt(), layer - 1, mantissa.abs());
    }
  }

  Infinity exp() {
    if (mantissa < 0) {
      return Infinity.one();
    }

    if (layer == 0 && mantissa <= 709.7) {
      return Infinity.fromNum(math.exp(sign * mantissa));
    } else if (layer == 0) {
      return Infinity.fromComponents(1, 1, sign * log10(math.e) * mantissa);
    } else if (layer == 1) {
      return Infinity.fromComponents(1, 2, sign * log10(0.4342944819032518) + mantissa);
    } else {
      return Infinity.fromComponents(1, layer + 1, sign * mantissa);
    }
  }

  Infinity factorial() {
    if (mantissa < 0 || layer == 0) {
      return add(Infinity.one()).gamma();
    } else if (layer == 1) {
      return (this * ln().subtract(Infinity.one())).exp();
    } else {
      return exp();
    }
  }

  Infinity gamma() {
    if (mantissa < 0) {
      return reciprocal();
    } else if (layer == 0) {
      if (this < Infinity.fromComponents(1, 0, 24)) {
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
      return (this * ln().subtract(Infinity.one())).exp();
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

  Infinity _pow10() {
    logDebug('_pow10 on ${toString()}');

    if (!layer.isFinite || !mantissa.isFinite) {
      return Infinity.nan();
    }

    if (layer == 0) {
      final num _newMag = math.pow(10, sign * mantissa);
      if (_newMag.isFinite && _newMag.abs() > 0.1) {
        return Infinity.fromComponents(1, 0, _newMag);
      } else {
        if (sign == 0) {
          return Infinity.one();
        } else {
          return Infinity.fromComponents(sign, ++layer, log10(mantissa));
        }
      }
    }

    if (sign > 0 && mantissa > 0) {
      return Infinity.fromComponents(sign, ++layer, mantissa);
    } else if (sign < 0 && mantissa > 0) {
      return Infinity.fromComponents(-sign, ++layer, -mantissa);
    }

    return Infinity.one();
  }

  /// Tetration/tetrate: The result of exponentiating 'this' to 'this' 'height' times in a row.  https://en.wikipedia.org/wiki/Tetration
  /// If payload != 1, then this is 'iterated exponentiation', the result of exping (payload) to base (this) (height) times. https://andydude.github.io/tetration/archives/tetration2/ident.html
  /// Works with negative and positive real heights.
  Infinity tetrate({double height = 2, Infinity other}) {
    other ??= Infinity.fromComponents(1, 0, 1);

    if (height == double.infinity) {
      final Infinity _negLn = ln().neg();
      return _negLn.lambertW().divide(_negLn);
    }

//    if(height < 0){
//
//    }

    throw UnimplementedError('Tetrate is still not fully supported!');
  }

  Infinity lambertW() {
    if (this < -0.3678794411710499) {
      throw UnsupportedError('lambertw is unimplemented for results less than -1, sorry!');
    } else if (mantissa < 0) {
      return Infinity.fromNum(fLambertW(other: toNumber()));
    } else if (layer == 0) {
      return Infinity.fromNum(fLambertW(other: sign * mantissa));
    } else if (layer == 1) {
      return dLambertW();
    } else if (layer == 2) {
      return dLambertW();
    }

    return Infinity.fromComponents(sign, layer - 1, mantissa);
  }

  Infinity dLambertW({Infinity other, num tolerance = 1e-10}) {
    Infinity w;
    Infinity ew, wewz, wn;

    if (!other.mantissa.isFinite) {
      return other;
    }
    if (other == Infinity.zero()) {
      return other;
    }
    if (other == Infinity.one()) {
      //Split out this case because the asymptotic series blows up
      return Infinity.fromNum(omega);
    }

    //Get an initial guess for Halley's method
    w = other.ln();

    //Halley's method; see 5.9 in [1]

    for (int i = 0; i < 100; ++i) {
      ew = (-w).exp();
      wewz = w.subtract(other.multiply(ew));
      wn = w.subtract(wewz.divide(w.add(Infinity.one()).subtract(
          (w.add(Infinity.fromNum(2))).multiply(wewz).divide((Infinity.fromNum(2) * w).add(Infinity.fromNum(2))))));
      if ((wn.subtract(w)).abs() < (wn.multiply(Infinity.fromNum(tolerance)).abs())) {
        return wn;
      } else {
        w = wn;
      }
    }

    throw UnsupportedError('Iteration failed to converge: ${other.toString()}');
  }

  num fLambertW({num other, num tolerance = 1e-10}) {
    num w;
    num wn;

    if (!other.isFinite) {
      return other;
    }
    if (other == 0) {
      return other;
    }
    if (other == 1) {
      return omega;
    }

    if (other < 10) {
      w = 0;
    } else {
      w = math.log(other) - math.log(math.log(other));
    }

    for (int i = 0; i < 100; ++i) {
      wn = (other * math.exp(-w) + w * w) / (w + 1);
      if ((wn - w).abs() < tolerance * wn.abs()) {
        return wn;
      } else {
        w = wn;
      }
    }

    throw UnsupportedError('Iteration failed to converge: ${other.toString()}');
  }

  Infinity _getInfinity(dynamic other) {
    Infinity _inf;
    if (other is num) {
      _inf = Infinity.fromNum(other);
    } else if (other is Infinity) {
      _inf = other;
    }

    return _inf;
  }

  num toNumber() {
    if (!layer.isFinite) {
      return double.nan;
    }

    if (layer == 0) {
      return sign * mantissa;
    } else if (layer == 1) {
      return double.parse('${normalizedMantissa}e${normalizedExponent}');
    } else {
      return mantissa > 0 ? sign > 0 ? double.infinity : double.negativeInfinity : 0;
    }
  }
}
