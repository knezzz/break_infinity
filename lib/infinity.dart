library infinity;

import 'dart:math';

import 'package:infinity/logger.dart';

double log10(num num) {
  return log10e * log(num);
}

const int indexOf0InPowersOf10 = 323;
const double expn1 = 0.36787944117144232159553; // exp(-1)
const double omega = 0.56714329040978387299997;

class Infinity with Logger {
  Infinity(this.mantissa, this.exponent);

  Infinity.zero() {
    mantissa = 0;
    layer = 0;
    sign = 0;
  }

  Infinity.fromDouble(double value) {
    mantissa = value.abs();
    _sign = value.toInt().sign;
    layer = 0;

    normalize();
  }

  Infinity.fromNum(num value) {
    mantissa = value.toDouble().abs();
    _sign = value.toInt().sign;
    layer = 0;

    normalize();
  }

  Infinity.fromComponents(this._sign, this.layer, this.mantissa) {
    normalize();
  }

  void fromMantissaExponent(int mag, int exponent) {
    layer = 1;
    _sign = mag.sign;
    mantissa = exponent + log10(mag.abs());

    normalize();
  }

  int maxSignificantDigits = 17; //Maximum number of digits of precision to assume in Number

  /// If we're ABOVE this value, increase a layer. (9e15 is close to the largest double eger that can fit in a Number.)
  static const double expLimit = 9e15;
  double layerDown = log10(expLimit); //If we're BELOW this value, drop down a layer. About 15.954.

  ///At layer 0, smaller non-zero numbers than this become layer 1 numbers with negative mag. After that the pattern continues as normal.
  double firstNegLayer = 1 / expLimit;

  int numberExpMax = 308; //The largest exponent that can appear in a Number, though not all mantissas are valid here.
  int numberExpMin = -324; //The smallest exponent that can appear in a Number, though not all mantissas are valid here.
  int maxEsInRow = 5; //For default toString behaviour, when to swap from eee... to (e^n) syntax.

  double mantissa;
  double exponent;

  int _sign;

  int get sign => _sign;
  set sign(int value) {
    if (value == 0) {
      _sign = 0;
      layer = 0;
      mantissa = 0;
    } else {
      _sign = value;
    }
  }

  int layer;

  int get _mantissa {
    if (sign == 0) {
      return 0;
    } else if (layer == 0) {
      final int _exp = log10(mantissa).floor();
      int _man;

      if (mantissa == 5e-324) {
        _man = 5;
      } else {
        _man = mantissa ~/ powerOf10(_exp);
      }

      return sign * _man;
    } else if (layer == 1) {
      final double _residue = mantissa - mantissa.floor();

      return (sign * pow(10, _residue)).toInt();
    }

    return sign;
  }

  set _mantissa(int value) {
    if (layer <= 2) {
      fromMantissaExponent(value, _exponent);
    } else {
      sign = value.sign;
      if (sign == 0) {
        layer = 0;
        exponent = 0;
      }
    }
  }

  int get _exponent {
    if (sign == 0) {
      return 0;
    } else if (layer == 0) {
      return log10(mantissa).floor();
    } else if (layer == 1) {
      return mantissa.floor();
    } else if (layer == 2) {
      return (mantissa.sign * pow(10, mantissa.abs())).floor();
    } else {
      return (mantissa * double.infinity).toInt();
    }
  }

  set _exponent(int value) {
    fromMantissaExponent(_mantissa, value);
  }

  Map<int, int> _powersOf10;

  int powerOf10(int power) {
    if (_powersOf10 == null) {
      logVerbose('Adding powers of 10 lookup table!', debugString: toDebugString());
      for (int i = numberExpMin + 1; i <= numberExpMax; i++) {
        _powersOf10.putIfAbsent(i, () {
          return int.tryParse('1e$i');
        });
      }
      logVerbose('Lookup table size: ${_powersOf10.length}', debugString: toDebugString());
    }

    return _powersOf10[power + indexOf0InPowersOf10];
  }

  void normalize() {
    /*
      PSEUDOCODE:
      Whenever we are partially 0 (sign is 0 or mag and layer is 0), make it fully 0.
      Whenever we are at or hit layer 0, extract sign from negative mag.
      If layer === 0 and mag < FIRST_NEG_LAYER (1/9e15), shift to 'first negative layer' (add layer, log10 mag).
      While abs(mag) > EXP_LIMIT (9e15), layer += 1, mag = maglog10(mag).
      While abs(mag) < LAYER_DOWN (15.954) and layer > 0, layer -= 1, mag = pow(10, mag).

      When we're done, all of the following should be true OR one of the numbers is not IsFinite OR layer is not IsInteger (error state):
      Any 0 is totally zero (0, 0, 0).
      Anything layer 0 has mag 0 OR mag > 1/9e15 and < 9e15.
      Anything layer 1 or higher has abs(mag) >= 15.954 and < 9e15.
      We will assume in calculations that all Decimals are either erroneous or satisfy these criteria. (Otherwise: Garbage in, garbage out.)
      */
    logDebug('Normalizing: $sign - $mantissa - $layer');

    if (sign == 0 || (mantissa == 0 && layer == 0)) {
      sign = 0;
      mantissa = 0;
      layer = 0;
      return;
    }

    if (layer == 0 && mantissa < 0) {
      //extract sign from negative mag at layer 0
      mantissa = -mantissa;
      sign = -sign;
    }

    //Handle shifting from layer 0 to negative layers.
    if (layer == 0 && mantissa < firstNegLayer) {
      layer += 1;
      mantissa = log10(mantissa);
      return;
    }

    double absmag = mantissa.abs();
    double signmag = mantissa.sign;

    if (absmag >= expLimit) {
      layer += 1;
      mantissa = signmag * log10(absmag);
      return;
    } else {
      while (absmag < layerDown && layer > 0) {
        layer -= 1;

        if (layer == 0) {
          mantissa = pow(10, mantissa);
        } else {
          mantissa = signmag * pow(10, absmag);
          absmag = mantissa.abs();
          signmag = mantissa.sign;
        }
      }

      if (layer == 0) {
        if (mantissa < 0) {
          //extract sign from negative mag at layer 0
          mantissa = -mantissa;
          sign = -sign;
        } else if (mantissa == 0) {
          //excessive rounding can give us all zeroes
          sign = 0;
        }
      }
    }

    return;
  }

  Infinity operator -(dynamic other) {
    if (other is num) {
      logVerbose('Other num is not `Infinity`');
      other = Infinity.fromNum(other);
    }

    if (other is Infinity) {
      return this + other.neg();
    }

    throw ArgumentError('Bad arguments to subtract: $this - $other');
  }

  Infinity operator +(dynamic other) {
    logDebug('Adding ${toString()} and ${other.toString()}');

    if (!layer.isFinite) {
      return this;
    }

    if (other is num) {
      logVerbose('Other num is not `Infinity`');
      other = Infinity.fromNum(other);
    }

    if (other is Infinity) {
      if (!other.layer.isFinite) {
        return other;
      }

      if (sign == 0) {
        return other;
      }

      if (other.sign == 0) {
        return this;
      }

      if (sign == -other.sign && layer == other.layer && mantissa == other.mantissa) {
        return Infinity(0, 0);
      }

      if (layer >= 2 || other.layer >= 2) {
        return maxAbs(other);
      }

      Infinity a;
      Infinity b;

      if (_cmpabs(other) > 0) {
        a = this;
        b = other;
      } else {
        a = other;
        b = this;
      }

      if (a.layer == 0 && b.layer == 0) {
        logVerbose('Numbers are still in layer 0', debugString: a.toDebugString());
        return Infinity.fromDouble(a.sign * a.mantissa + b.sign * b.mantissa);
      }

      int layerA = a.layer * a.mantissa.toInt().sign;
      int layerB = b.layer * b.mantissa.toInt().sign;

      if (layerA - layerB >= 2) {
        return a;
      }

      if (layerA == 0 && layerB == -1) {
        if ((b.mantissa - log10(a.mantissa)).abs() > maxSignificantDigits) {
          logVerbose('Returning bigger number!', debugString: a.toDebugString());
          return a;
        } else {
          final double _magdiff = pow(10, log10(a.mantissa) - b.mantissa);
          final double _mantissa = b.sign + (a.sign * _magdiff);

          logVerbose('Number magDif: $_magdiff');
          logVerbose('Number mantissa: $_mantissa');
          return Infinity.fromComponents(_mantissa.sign.toInt(), 1, b.sign + log10(_mantissa.abs()));
        }
      }

      if (layerA == 1 && layerB == 0) {
        if ((a.mantissa - log10(b.mantissa)).abs() > maxSignificantDigits) {
          logVerbose('Returning bigger number!', debugString: a.toDebugString());
          return a;
        } else {
          final double _magdiff = pow(10, a.mantissa - log10(b.mantissa));
          final double _mantissa = b.sign + (a.sign * _magdiff);

          logVerbose('Number magDif: $_magdiff');
          logVerbose('Number mantissa: $_mantissa');
          return Infinity.fromComponents(_mantissa.sign.toInt(), 1, log10(b.mantissa) + log10(_mantissa.abs()));
        }
      }

      if ((a.mantissa - b.mantissa).abs() > maxSignificantDigits) {
        logVerbose('Returning bigger number!', debugString: a.toDebugString());
        return a;
      } else {
        final double _magdiff = pow(10, a.mantissa - b.mantissa);
        final double _mantissa = b.sign + (a.sign * _magdiff);

        logVerbose('Number magDif: $_magdiff');
        logVerbose('Number mantissa: $_mantissa');
        return Infinity.fromComponents(_mantissa.sign.toInt(), 1, b.mantissa + log10(_mantissa.abs()));
      }
    }

    throw ArgumentError('Bad arguments to add: $this + $other');
  }

  Infinity operator *(dynamic other) {
    if (!layer.isFinite) {
      return this;
    }

    if (other is num) {
      other = Infinity.fromNum(other);
    }

    if (other is Infinity) {
      if (!other.layer.isFinite) {
        return other;
      }

      if (sign == 0 || other.sign == 0) {
        return Infinity.zero();
      }

      if (layer == other.layer && mantissa == -other.mantissa) {
        return Infinity.fromComponents(sign * other.sign, 0, 1);
      }

      Infinity a;
      Infinity b;

      if (layer > other.layer || (layer == other.layer && mantissa.abs() > other.mantissa.abs())) {
        a = this;
        b = other;
      } else {
        a = other;
        b = this;
      }

      if (a.layer == 0 && b.layer == 0) {
        return Infinity.fromDouble(a.sign * b.sign * a.mantissa * b.mantissa);
      }

      if (a.layer >= 3 || (a.layer - b.layer >= 2)) {
        return Infinity.fromComponents(a.sign * b.sign, a.layer, a.mantissa);
      }

      if (a.layer == 1 && b.layer == 0) {
        return Infinity.fromComponents(a.sign * b.sign, 1, a.mantissa + log10(b.mantissa));
      } else if (a.layer == 1 && b.layer == 1) {
        return Infinity.fromComponents(a.sign * b.sign, 1, a.mantissa + b.mantissa);
      } else if (a.layer == 2 && b.layer == 1) {
        Infinity _newMag = Infinity.fromComponents(a.mantissa.sign.toInt(), a.layer - 1, a.mantissa.abs()) +
            Infinity.fromComponents(b.mantissa.sign.toInt(), b.layer - 1, b.mantissa.abs());
        return Infinity.fromComponents(a.sign * b.sign, _newMag.layer + 1, _newMag.sign * _newMag.mantissa);
      }

      if (a.layer == 2 && b.layer == 2) {
        Infinity _newMag = Infinity.fromComponents(a.mantissa.sign.toInt(), a.layer - 1, a.mantissa.abs()) +
            Infinity.fromComponents(b.mantissa.sign.toInt(), b.layer - 1, b.mantissa.abs());
        return Infinity.fromComponents(a.sign * b.sign, _newMag.layer + 1, _newMag.sign * _newMag.mantissa);
      }
    }

    throw ArgumentError('Bad arguments to multiply: $this * $other');
  }

  Infinity round() {
    if (mantissa < 0) {
      return Infinity.zero();
    } else if (layer == 0) {
      return Infinity.fromComponents(sign, 9, mantissa.roundToDouble());
    }

    return this;
  }

  Infinity floor() {
    if (mantissa < 0) {
      return Infinity.zero();
    } else if (layer == 0) {
      return Infinity.fromComponents(sign, 9, mantissa.floorToDouble());
    }

    return this;
  }

  Infinity ceil() {
    if (mantissa < 0) {
      return Infinity.zero();
    } else if (layer == 0) {
      return Infinity.fromComponents(sign, 9, mantissa.ceilToDouble());
    }

    return this;
  }

  Infinity truncate() {
    if (mantissa < 0) {
      return Infinity.zero();
    } else if (layer == 0) {
      return Infinity.fromComponents(sign, 9, mantissa.truncateToDouble());
    }

    return this;
  }

  Infinity abs() {
    sign = 1;
    return this;
  }

  Infinity neg() {
    sign = -sign;
    return this;
  }

  Infinity maxAbs(Infinity other) {
    return _cmpabs(other) > 0 ? other : this;
  }

  int _cmpabs(Infinity other) {
    int layerA = mantissa > 0 ? layer : -layer;
    int layerB = other.mantissa > 0 ? other.layer : -other.layer;

    if (layerA > layerB) {
      return 1;
    }

    if (layerA < layerB) {
      return -1;
    }

    if (mantissa > other.mantissa) {
      return 1;
    }

    if (mantissa < other.mantissa) {
      return -1;
    }

    return 0;
  }

  @override
  String toString() {
    if (layer == 0) {
      if ((mantissa < 1e21 && mantissa > 1e-7) || mantissa == 0) {
        return (sign * mantissa).toString();
      }

      return '${_mantissa}e$_exponent';
    } else if (layer == 1) {
      return '${_mantissa}e$_exponent';
    } else {
      if (layer <= maxEsInRow) {
        return (sign == -1 ? '-' : '') + ''.padRight(layer, 'e') + mantissa.toStringAsFixed(0);
      } else {
        return (sign == -1 ? '-' : '') + '${'e^$layer'}' + mantissa.toStringAsFixed(0);
      }
    }
  }

  String toStringWithDecimalPlaces({int places = 2}) {
    if (layer == 0) {
      if ((mantissa < 1e21 && mantissa > 1e-7) || mantissa == 0) {
        return (sign * mantissa).toStringAsFixed(places);
      }

      return '${valueWithDecimalPlaces(_mantissa, places)}e${valueWithDecimalPlaces(_exponent, places)}';
    } else if (layer == 1) {
      return '${valueWithDecimalPlaces(_mantissa, places)}e${valueWithDecimalPlaces(_exponent, places)}';
    } else {
      if (layer <= maxEsInRow) {
        return (sign == -1 ? '-' : '') + ''.padRight(layer, 'e') + valueWithDecimalPlaces(mantissa, places);
      } else {
        return (sign == -1 ? '-' : '') + '${'e^$layer'}' + valueWithDecimalPlaces(mantissa, places);
      }
    }
  }

  String toDebugString() {
    return 'Sign: $_sign Mantissa: $mantissa Layer: $layer :: ${toStringWithDecimalPlaces(places: 4)}';
  }

  String valueWithDecimalPlaces(num value, int places) {
    int len = places + 1;
    int numDigits = log10(value.abs()).ceil();
    num rounded = (value * pow(10, len - numDigits)).round() * pow(10, numDigits - len);

    return rounded.toStringAsFixed(max(len - numDigits, 0));
  }
}
