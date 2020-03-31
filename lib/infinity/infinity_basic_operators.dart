import 'dart:math' as math;

import 'package:infinity/infinity/infinity.dart';
import 'package:infinity/infinity/infinity_constants.dart';

extension InfinityBasicOperators on Infinity {
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
      final int _layer = layer - 1;
      return Infinity.fromComponents(mantissa.sign.toInt(), _layer, mantissa.abs());
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

    Infinity _result = (absLog10().multiply(other)).pow10();

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

  Infinity pow10() {
    logDebug('pow10 on ${toString()}');

    if (!layer.isFinite || !mantissa.isFinite) {
      return Infinity.nan();
    }
    final int _layer = layer + 1;

    if (layer == 0) {
      final num _newMag = math.pow(10, sign * mantissa);
      if (_newMag.isFinite && _newMag.abs() > 0.1) {
        return Infinity.fromComponents(1, 0, _newMag);
      } else {
        if (sign == 0) {
          return Infinity.one();
        } else {
          return Infinity.fromComponents(sign, _layer, mantissa, false);
        }
      }
    }

    if (sign > 0 && mantissa > 0) {
      return Infinity.fromComponents(sign, _layer, mantissa);
    } else if (sign < 0 && mantissa > 0) {
      return Infinity.fromComponents(-sign, _layer, -mantissa);
    }

    return Infinity.one();
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
      return double.parse('${normalizedMantissa}e$normalizedExponent');
    } else {
      return mantissa > 0 ? sign > 0 ? double.infinity : double.negativeInfinity : 0;
    }
  }
}
