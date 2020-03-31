library infinity;

import 'dart:math';

import 'package:infinity/infinity/infinity_constants.dart';
import 'package:infinity/infinity/logger.dart';

class Infinity with Logger {
  Infinity(this.mantissa, this.exponent);

  Infinity.zero() {
    mantissa = 0;
    layer = 0;
    sign = 0;
  }

  Infinity.one() {
    mantissa = 1;
    layer = 0;
    sign = 1;
  }

  Infinity.nan() {
    mantissa = double.nan;
    layer = 0;
    sign = 0;
  }

  Infinity.fromNum(num value, [bool normalizeNumber = true]) {
    logVerbose('--> Infinity from number: $value');
    mantissa = value.toDouble().abs();
    _sign = value.sign.toInt();
    layer = 0;

    if (normalizeNumber) {
      normalize();
    }
  }

  Infinity.fromComponents(this._sign, this.layer, this.mantissa, [bool normalizeNumber = true]) {
    logVerbose('--> Infinity from components: [$_sign, $layer, $mantissa]');

    if (normalizeNumber) {
      normalize();
    }
  }

  void fromMantissaExponent(num mag, num exponent, [bool normalizeNumber = true]) {
    layer = 1;
    _sign = mag.toInt().sign;
    _normalizeMantissa = exponent + log10(mag.abs());

    if (normalizeNumber) {
      normalize();
    }

    logDebug('Value: ${toStringWithDecimalPlaces(places: 1)}');
  }

  bool get isInt => mantissa - mantissa.round() == 0;

  num mantissa;
  num exponent;

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

  num layer;

  num get normalizedMantissa {
    if (sign == 0) {
      return 0;
    } else if (layer == 0) {
      final int _exp = log10(mantissa).floor();
      num _man;

      if (mantissa == 5e-324) {
        _man = 5;
      } else {
        _man = mantissa / powerOf10(_exp);
      }

      return sign * _man;
    } else if (layer == 1) {
      final num _residue = mantissa - mantissa.floor();

      return sign * pow(10, _residue);
    }

    return sign;
  }

  set _normalizeMantissa(num value) {
    if (layer <= 2) {
      fromMantissaExponent(value, normalizedExponent);
    } else {
      sign = value.toInt().sign;
      if (sign == 0) {
        layer = 0;
        exponent = 0;
      }
    }
  }

  num get normalizedExponent {
    if (sign == 0) {
      return 0;
    } else if (layer == 0) {
      return log10(mantissa).floor();
    } else if (layer == 1) {
      return mantissa.floor();
    } else if (layer == 2) {
      return (mantissa.sign * pow(10, mantissa.abs())).floor();
    } else {
      return mantissa * double.infinity;
    }
  }

  set _normalizeExponent(num value) {
    fromMantissaExponent(normalizedMantissa, value);
  }

  final Map<int, num> _powersOf10 = <int, num>{};

  num powerOf10(int power) {
    if (_powersOf10 == null) {
      logVerbose('Adding powers of 10 lookup table!', debugString: toDebugString());
      for (int i = numberExpMin + 1; i <= numberExpMax; i++) {
        _powersOf10.putIfAbsent(i, () {
          return num.tryParse('1e$i');
        });
      }
      logInfo('Lookup table size: ${_powersOf10.length}');
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

    num absmag = mantissa.abs();
    num signmag = mantissa.sign;

    if (absmag >= expLimit) {
      layer += 1;
      mantissa = signmag * log10(absmag);
      return;
    } else {
      while (absmag < layerDown && layer > 0) {
        layer -= 1;

        if (layer == 0) {
          mantissa = pow(10, mantissa).toDouble();
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

  Infinity add(Infinity other) {
    logInfo('Adding ${toString()} and ${other.toString()}');

    if (!layer.isFinite) {
      return this;
    }

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
      return Infinity.zero();
    }

    if (layer >= 2 || other.layer >= 2) {
      return maxAbs(other);
    }

    final bool _compare = cmpAbs(other) > 0;
    final Infinity a = _compare ? this : other;
    final Infinity b = _compare ? other : this;

    if (a.layer == 0 && b.layer == 0) {
      logVerbose('Numbers are still in layer 0', debugString: a.toDebugString());
      return Infinity.fromNum(a.sign * a.mantissa + b.sign * b.mantissa);
    }

    final int layerA = a.layer.toInt() * a.mantissa.toInt().sign;
    final int layerB = b.layer.toInt() * b.mantissa.toInt().sign;

    if (layerA - layerB >= 2) {
      return a;
    }

    if (layerA == 0 && layerB == -1) {
      if ((b.mantissa - log10(a.mantissa)).abs() > maxSignificantDigits) {
        logVerbose('Returning bigger number!', debugString: a.toDebugString());
        return a;
      } else {
        final num _magdiff = pow(10, log10(a.mantissa) - b.mantissa).toDouble();
        final num _mantissa = b.sign + (a.sign * _magdiff);

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
        final num _magdiff = pow(10, a.mantissa - log10(b.mantissa)).toDouble();
        final num _mantissa = b.sign + (a.sign * _magdiff);

        logVerbose('Number magDif: $_magdiff');
        logVerbose('Number mantissa: $_mantissa');
        return Infinity.fromComponents(_mantissa.sign.toInt(), 1, log10(b.mantissa) + log10(_mantissa.abs()));
      }
    }

    if ((a.mantissa - b.mantissa).abs() > maxSignificantDigits) {
      logVerbose('Returning bigger number!', debugString: a.toDebugString());
      return a;
    } else {
      final num _magdiff = pow(10, a.mantissa - b.mantissa).toDouble();
      final num _mantissa = b.sign + (a.sign * _magdiff);

      logVerbose('Number magDif: $_magdiff');
      logVerbose('Number mantissa: $_mantissa');
      return Infinity.fromComponents(_mantissa.sign.toInt(), 1, b.mantissa + log10(_mantissa.abs()));
    }
  }

  Infinity multiply(Infinity other) {
    logInfo('Multiplying ${toString()} and ${other.toString()}');

    if (!layer.isFinite) {
      logVerbose('This layer is not finite!');
      return this;
    }

    if (!other.layer.isFinite) {
      logVerbose('Other layer is not finite!');
      return other;
    }

    if (sign == 0 || other.sign == 0) {
      return Infinity.zero();
    }

    if (layer == other.layer && mantissa == -other.mantissa) {
      return Infinity.fromComponents(sign * other.sign, 0, 1, false);
    }

    final bool _compare = layer > other.layer || (layer == other.layer && mantissa.abs() > other.mantissa.abs());
    final Infinity a = _compare ? this : other;
    final Infinity b = _compare ? other : this;

    if (a.layer == 0 && b.layer == 0) {
      return Infinity.fromNum(a.sign * b.sign * a.mantissa * b.mantissa);
    }

    if (a.layer >= 3 || (a.layer - b.layer >= 2)) {
      return Infinity.fromComponents(a.sign * b.sign, a.layer, a.mantissa);
    }

    if (a.layer == 1 && b.layer == 0) {
      return Infinity.fromComponents(a.sign * b.sign, 1, a.mantissa + log10(b.mantissa));
    } else if (a.layer == 1 && b.layer == 1) {
      return Infinity.fromComponents(a.sign * b.sign, 1, a.mantissa + b.mantissa);
    } else if (a.layer == 2 && b.layer == 1) {
      final Infinity _newMag = Infinity.fromComponents(a.mantissa.sign.toInt(), a.layer - 1, a.mantissa.abs())
          .add(Infinity.fromComponents(b.mantissa.sign.toInt(), b.layer - 1, b.mantissa.abs()));
      return Infinity.fromComponents(a.sign * b.sign, _newMag.layer + 1, _newMag.sign * _newMag.mantissa);
    }

    if (a.layer == 2 && b.layer == 2) {
      final Infinity _newMag = Infinity.fromComponents(a.mantissa.sign.toInt(), a.layer - 1, a.mantissa.abs())
          .add(Infinity.fromComponents(b.mantissa.sign.toInt(), b.layer - 1, b.mantissa.abs()));
      return Infinity.fromComponents(a.sign * b.sign, _newMag.layer + 1, _newMag.sign * _newMag.mantissa);
    }

    return Infinity.zero();
  }

  Infinity maxAbs(Infinity other) {
    logDebug('maxAbs ${toString()} and ${other.toString()}');

    return cmpAbs(other) > 0 ? other : this;
  }

  int compare(Infinity other) {
    logInfo('Comparing ${toString()} with ${other.toString()}');

    if (sign > other.sign) {
      return 1;
    }
    if (sign < other.sign) {
      return -1;
    }
    return sign * cmpAbs(other);
  }

  int cmpAbs(Infinity other) {
    logDebug('cmpAbs ${toString()} and ${other.toString()}');

    final int layerA = (mantissa > 0 ? layer : -layer).toInt();
    final int layerB = (other.mantissa > 0 ? other.layer : -other.layer).toInt();

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

      return '${normalizedMantissa}e$normalizedExponent';
    } else if (layer == 1) {
      return '${normalizedMantissa}e$normalizedExponent';
    } else {
      if (layer <= maxEsInRow) {
        return (sign == -1 ? '-' : '') + ''.padRight(layer.toInt(), 'e') + mantissa.toString();
      } else {
        return (sign == -1 ? '-' : '') + '(${'e^$layer'})' + mantissa.toString();
      }
    }
  }

  String toStringWithDecimalPlaces({int places = 2}) {
    if (layer == 0) {
      if ((mantissa < 1e21 && mantissa > 1e-7) || mantissa == 0) {
        return (sign * mantissa).toStringAsFixed(places);
      }

      return '${valueWithDecimalPlaces(normalizedMantissa, places)}e${valueWithDecimalPlaces(normalizedExponent, places)}';
    } else if (layer == 1) {
      return '${valueWithDecimalPlaces(normalizedMantissa, places)}e${valueWithDecimalPlaces(normalizedExponent, places)}';
    } else {
      if (layer <= maxEsInRow) {
        return (sign == -1 ? '-' : '') + ''.padRight(layer.toInt(), 'e') + valueWithDecimalPlaces(mantissa, places);
      } else {
        return (sign == -1 ? '-' : '') + '(${'e^$layer'})' + valueWithDecimalPlaces(mantissa, places);
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

  /// Can't override == and hashCode in extension class
  /// see: https://dart.dev/tools/diagnostic-messages#extension_declares_member_of_object
  @override
  bool operator ==(dynamic other) {
    if (other is Infinity) {
      return sign == other.sign && layer == other.layer && mantissa == other.mantissa;
    }

    return false;
  }

  @override
  int get hashCode {
    return <num>[sign, layer, mantissa].hashCode;
  }
}
