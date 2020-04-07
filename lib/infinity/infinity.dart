part of infinity;

class Infinity with Logger implements Comparable<Infinity> {
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
    logNewInfinity('Infinity from number: $value - Normalize: $normalizeNumber');
    mantissa = value.toDouble().abs();
    _sign = value.sign.toInt();
    layer = 0;

    if (normalizeNumber) {
      normalize();
    }

    logNormalizedInfinity('Infinity normalized: ${toDebugString()}');
  }

  Infinity.fromComponents(this._sign, this.layer, this.mantissa, [bool normalizeNumber = true]) {
    logNewInfinity('Infinity from components: [$_sign, $layer, $mantissa] - Normalize: $normalizeNumber');

    if (normalizeNumber) {
      normalize();
    }

    logNormalizedInfinity('Infinity normalized: ${toDebugString()}');
  }

  Infinity.fromString(String value) {
    logNewInfinity('Infinity from string: [$value]');
    Infinity _result;

    value = value.toLowerCase();

    if (value.contains('^^^')) {
      _result = _handlePentateString(value);
    } else if (value.contains('^^')) {
      _result = _handleTetrateString(value);
    } else if (value.contains('^')) {
      _result = _handlePowString(value);
    } else if (value.contains('pt') || value.contains('p')) {
      _result = _handlePtString(value);
    } else if (value.contains('e')) {
      _result = _handleEString(value);
    }

    if (_result != null) {
      sign = _result.sign;
      mantissa = _result.mantissa;
      layer = _result.layer;
    }

    logNormalizedInfinity('Infinity normalized: ${toDebugString()}');
  }

  bool get isInt =>
      (layer == 0 && mantissa - mantissa.round() == 0) ||
      (layer == 1 && (toNumber() - toNumber().roundToDouble() == 0));
  bool get isNegative => sign == -1;
  bool get isPositive => sign == 1;

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
  bool _roundResult = false;

  num get normalizedMantissa {
    if (sign == 0) {
      return 0;
    } else if (layer == 0) {
      final int _exp = mantissa.log10().round();
      num _man;

      if (mantissa == 5e-324) {
        _man = 5;
      } else {
        _man = mantissa / powerOf10(_exp);
      }

      return sign * _man;
    } else if (layer == 1) {
      final num _residue = mantissa - mantissa.floor();

      if (_roundResult) {
        return (sign * math.pow(10, _residue)).roundToDouble(); // Lose precision for doubles, gain accuracy on int
      }

      return sign * math.pow(10, _residue); // Lose precision for doubles, gain accuracy on int
    }

    return sign;
  }

  num get normalizedExponent {
    if (sign == 0) {
      return 0;
    } else if (layer == 0) {
      return mantissa.log10().floor();
    } else if (layer == 1) {
      return mantissa.floor();
    } else if (layer == 2) {
      return (mantissa.sign * math.pow(10, mantissa.abs())).floor();
    } else {
      return mantissa * double.infinity;
    }
  }

  void roundMantissa({bool value = true}) {
    _roundResult = value;
  }

  num powerOf10(num power) {
    return double.tryParse('1e$power');
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
      mantissa = mantissa.log10();
      return;
    }

    num absmag = mantissa.abs();
    num signmag = mantissa.sign;

    if (absmag >= expLimit) {
      layer += 1;
      mantissa = signmag * absmag.log10();
      return;
    } else {
      while (absmag < layerDown && layer > 0) {
        layer -= 1;

        if (layer == 0) {
          mantissa = math.pow(10, mantissa).toDouble();
        } else {
          mantissa = signmag * math.pow(10, absmag);
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

  Infinity getInfinity(dynamic other) {
    Infinity _inf;
    if (other is num) {
      _inf = Infinity.fromNum(other);
    } else if (other is Infinity) {
      _inf = other;
    }

    return _inf;
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
    return '[$_sign, $mantissa, $layer] -- ${toString()}';
  }

  String valueWithDecimalPlaces(num value, int places) {
    final int len = places + 1;
    final int numDigits = value.abs().log10().ceil();
    final num rounded = (value * math.pow(10, len - numDigits)).round() * math.pow(10, numDigits - len);

    return rounded.toStringAsFixed(math.max(len - numDigits, 0));
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

  @override
  int compareTo(Infinity other) {
    logComparisons('Comparing ${toString()} with ${other.toString()}');

    if (sign > other.sign) {
      return 1;
    }
    if (sign < other.sign) {
      return -1;
    }

    return sign * cmpAbs(other);
  }
}
