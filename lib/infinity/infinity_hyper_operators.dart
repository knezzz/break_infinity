import 'dart:math' as math;

import 'package:infinity/infinity/infinity.dart';
import 'package:infinity/infinity/infinity_basic_operators.dart';
import 'package:infinity/infinity/infinity_constants.dart';

extension InfinityHyperExtensions on Infinity {
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

  /// Tetration/tetrate: The result of exponentiating 'this' to 'this' 'height' times in a row.  https://en.wikipedia.org/wiki/Tetration
  /// If payload != 1, then this is 'iterated exponentiation', the result of exping (payload) to base (this) (height) times. https://andydude.github.io/tetration/archives/tetration2/ident.html
  /// Works with negative and positive real heights.
  Infinity tetrate({num height = 2, Infinity other}) {
    other ??= Infinity.fromComponents(1, 0, 1);
    logDebug('Tetrate ${toString()} and ${other.toString()} ($height)');

    if (height == double.infinity) {
      final Infinity _negLn = ln().neg();
      return _negLn.lambertW().divide(_negLn);
    }

    if (height < 0) {
      return iteratedLog(times: -height.toInt(), base: other);
    }

    num oldheight = height;
    height = height.truncate();

    num fracheight = oldheight - height;

    logVerbose('Tetrate -- fracheight: $fracheight');

    if (fracheight != 0) {
      if (other == Infinity.one()) {
        ++height;
        other = Infinity.fromNum(fracheight);
      } else {
        logVerbose('Is infinity 10? ${toString()}');

        if (this == Infinity.fromNum(10)) {
          other = other.layerAdd10(fracheight);
        } else {
          other = other.layerAdd(fracheight.toInt(), this);
        }
      }
    }

    for (int i = 0; i < height; ++i) {
      other = pow(other);
      //bail if we're NaN
      if (!other.layer.isFinite || !other.mantissa.isFinite) {
        return other;
      }
      //shortcut
      if (other.layer - layer > 3) {
        return Infinity.fromComponents(other.sign, other.layer + height - i - 1, other.mantissa, false);
      }
      //give up after 100 iterations if nothing is happening
      if (i > 100) {
        return other;
      }
    }

    return other;
  }

  /// The Lambert W function, also called the omega function or product logarithm, is the solution W(x) === x*e^x.
  /// https://en.wikipedia.org/wiki/Lambert_W_function
  /// Some special values, for testing: https://en.wikipedia.org/wiki/Lambert_W_function#Special_values
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

    return Infinity.fromComponents(sign, layer - 1, mantissa, false);
  }

  /// from https://github.com/scipy/scipy/blob/8dba340293fe20e62e173bdf2c10ae208286692f/scipy/special/lambertw.pxd
  /// The evaluation can become inaccurate very close to the branch point
  /// at ``-1/e``. In some corner cases, `lambertw` might currently
  /// fail to converge, or can end up on the wrong branch.
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

  /// The Lambert W function, also called the omega function or product logarithm, is the solution W(x) === x*e^x.
  /// https://en.wikipedia.org/wiki/Lambert_W_function
  /// Some special values, for testing: https://en.wikipedia.org/wiki/Lambert_W_function#Special_values
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

  //layeradd: like adding 'diff' to the number's slog(base) representation. Very similar to tetrate base 'base' and iterated log base 'base'.
  Infinity layerAdd(int diff, Infinity base) {
    num slogthis = this.slog(base: base).toNumber();
    num slogdest = slogthis + diff;

    if (slogdest >= 0) {
      return tetrate(height: slogdest, other: base);
    } else if (!slogdest.isFinite) {
      return Infinity.nan();
    } else if (slogdest >= -1) {
      return tetrate(height: slogdest + 1, other: base).log(base);
    } else {
      return tetrate(height: slogdest + 2, other: base).log(base).log(base);
    }
  }

  Infinity layerAdd10(num value) {
    num other = Infinity.fromNum(value).toNumber();
    if (other >= 1) {
      int layerAdd = other.truncate();
      other -= layerAdd;
      layer += layerAdd;
    }
    if (other <= -1) {
      int layerAdd = other.truncate();
      other -= layerAdd;
      layer += layerAdd;
      if (layer < 0) {
        for (var i = 0; i < 100; ++i) {
          layer++;
          mantissa = log10(mantissa);
          if (!mantissa.isFinite) {
            return this;
          }
          if (layer >= 0) {
            break;
          }
        }
      }
    }

    //layerAdd10: like adding 'other' to the number's slog(base) representation. Very similar to tetrate base 10 and iterated log base 10. Also equivalent to adding a fractional amount to the number's layer in its break_eternity.js representation.
    if (other > 0) {
      int subtractlayerslater = 0;
      //Ironically, this edge case would be unnecessary if we had 'negative layers'.
      while (mantissa.isFinite && mantissa < 10) {
        mantissa = math.pow(10, mantissa);
        ++subtractlayerslater;
      }

      //A^(10^B) === C, solve for B
      //B === log10(logA(C))

      if (mantissa > 1e10) {
        mantissa = log10(mantissa);
        layer++;
      }

      //Note that every integer slog10 value, the formula changes, so if we're near such a number, we have to spend exactly enough layerother to hit it, and then use the new formula.
      num otherToNextSlog = log10(math.log(1e10) / math.log(mantissa));
      if (otherToNextSlog < other) {
        mantissa = log10(1e10);
        layer++;
        other -= otherToNextSlog;
      }

      mantissa = math.pow(mantissa, math.pow(10, other));

      while (subtractlayerslater > 0) {
        mantissa = log10(mantissa);
        --subtractlayerslater;
      }
    } else if (other < 0) {
      var subtractlayerslater = 0;

      while (mantissa.isFinite && mantissa < 10) {
        mantissa = math.pow(10, mantissa);
        ++subtractlayerslater;
      }

      if (mantissa > 1e10) {
        mantissa = log10(mantissa);
        layer++;
      }

      num otherToNextSlog = log10(1 / log10(mantissa));
      if (otherToNextSlog > other) {
        mantissa = 1e10;
        layer--;
        other -= otherToNextSlog;
      }

      mantissa = math.pow(mantissa, math.pow(10, other));

      while (subtractlayerslater > 0) {
        mantissa = log10(mantissa);
        --subtractlayerslater;
      }
    }

    while (layer < 0) {
      layer++;
      mantissa = log10(mantissa);
    }
    normalize();
    return this;
  }

  /// iterated log/repeated log: The result of applying log(base) 'times' times in a row. Approximately equal to subtracting (times) from the number's slog representation. Equivalent to tetrating to a negative height.
  /// Works with negative and positive real heights.
  Infinity iteratedLog({int times = 1, Infinity base}) {
    if (times < 0) {
      return base.tetrate(height: -times.toDouble(), other: this);
    }

    final int fullTimes = times;
    times = times.truncate();
    final int fraction = fullTimes - times;

    if (layer - base.layer > 3) {
      final int layerLoss = math.min(times, layer - base.layer - 3).toInt();
      times -= layerLoss;
      layer -= layerLoss;
    }

    Infinity _result = this;
    for (int i = 0; i < times; ++i) {
      _result = log(base);
      //bail if we're NaN
      if (!_result.layer.isFinite || !_result.mantissa.isFinite) {
        return _result;
      }
      //give up after 100 iterations if nothing is happening
      if (i > 100) {
        return _result;
      }
    }

    //handle fractional part
    if (fraction > 0 && fraction < 1) {
      if (base == Infinity.fromNum(10)) {
        return layerAdd10(-fraction);
      } else {
        return layerAdd(-fraction, base);
      }
    }

    return _result;
  }

  Infinity _log10() {
    if (sign <= 0) {
      return Infinity.nan();
    } else if (layer > 0) {
      return Infinity.fromComponents(mantissa.toInt().sign, --layer, mantissa.abs());
    }

    return Infinity.fromComponents(mantissa.toInt().sign, 0, log10(mantissa));
  }

  Infinity slog({Infinity base}) {
    if (mantissa < 0) {
      return Infinity.one().neg();
    }

    int result = 0;
    Infinity copy = this;
    if (copy.layer - base.layer > 3) {
      int layerloss = (copy.layer - base.layer - 3).toInt();
      result += layerloss;
      copy.layer -= layerloss;
    }

    for (var i = 0; i < 100; ++i) {
      if (copy < Infinity.zero()) {
        copy = base.pow(copy);
        result -= 1;
      } else if (copy < Infinity.one()) {
        return Infinity.fromNum(result + copy.toNumber() - 1); //<-- THIS IS THE CRITICAL FUNCTION
        //^ Also have to change tetrate payload handling and layerAdd10 if this is changed!
      } else {
        result += 1;
        copy = copy.log(base);
      }
    }

    return Infinity.fromNum(result);
  }

  Infinity log(Infinity other) {
    if (sign <= 0 || other.sign <= 0) {
      return Infinity.nan();
    }

    if (sign == 1 && layer == 0 && mantissa == 1) {
      return Infinity.nan();
    } else if (layer == 0 && other.layer == 0) {
      return Infinity.fromComponents(sign, 0, math.log(mantissa) / math.log(other.mantissa));
    }

    return _log10() / other._log10();
  }
}
