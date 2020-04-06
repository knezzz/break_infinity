part of infinity;

Infinity _handlePentateString(String value) {
  //Handle x^^^y format.
  final List<String> pentationParts = value.split('^^^');
  if (pentationParts.length == 2) {
    final double base = double.tryParse(pentationParts.first);
    double height;
    double payload = 1;

    final List<String> pentationHeightParts = pentationParts.last.split(';');

    if (pentationHeightParts.length == 2) {
      height = double.tryParse(pentationHeightParts.first);
      payload = double.tryParse(pentationHeightParts.last);

      if (!payload.isFinite) {
        payload = 1;
      }
    } else {
      height = double.tryParse(pentationParts.last);
    }

    if (base.isFinite && height.isFinite) {
      return Infinity.fromNum(base).pentate(height: height, other: Infinity.fromNum(payload));
    }
  }

  return null;
}

Infinity _handleTetrateString(String value) {
  //Handle x^^y format.
  final List<String> tetrateParts = value.split('^^');
  if (tetrateParts.length == 2) {
    final double base = double.tryParse(tetrateParts.first);
    double height;
    double payload = 1;

    final List<String> tetrateHeightParts = tetrateParts.last.split(';');

    if (tetrateHeightParts.length == 2) {
      height = double.tryParse(tetrateHeightParts.first);
      payload = double.tryParse(tetrateHeightParts.last);

      if (!payload.isFinite) {
        payload = 1;
      }
    } else {
      height = double.tryParse(tetrateParts.last);
    }

    if (base.isFinite && height.isFinite) {
      return Infinity.fromNum(base).tetrate(height: height, other: Infinity.fromNum(payload));
    }
  }

  return null;
}

Infinity _handlePowString(String value) {
  //Handle x^y format.
  final List<String> tetrateParts = value.split('^');
  if (tetrateParts.length == 2) {
    final double base = double.tryParse(tetrateParts.first);
    final double height = double.tryParse(tetrateParts.last);

    if (base.isFinite && height.isFinite) {
      return Infinity.fromNum(base).pow(Infinity.fromNum(height));
    }
  }

  return null;
}

Infinity _handlePtString(String value) {
  Infinity _result;

  //handle X PT Y format.
  final List<String> ptParts = value.contains('pt') ? value.split('pt') : value.split('p');

  if (ptParts.length == 2) {
    final double height = double.tryParse(ptParts.first);
    final String _formated = ptParts.last.replaceAll('(', '').replaceAll(')', '');
    double payload = double.tryParse(_formated);

    if (!payload.isFinite) {
      payload = 1;
    }

    if (height.isFinite) {
      _result = Infinity.fromNum(10).tetrate(height: height, other: Infinity.fromNum(payload));
    }
  }

  return _result;
}

Infinity _handleEString(String value) {
  Infinity _result;

  if (value.contains('e^')) {
    _result = _handleEPowFormat(value);
  } else {
    //handle X PT Y format.
    final List<String> eParts = value.split('e');
    final int _eCount = eParts.length - 1;

    final num mantissa = double.tryParse(eParts[0]);
    num exponent = double.tryParse(eParts[eParts.length - 1]);

    print('E count: $_eCount');
    print('E count: $eParts');

    if (_eCount == 0) {
      final double numberAttempt = double.tryParse(value);

      if (numberAttempt != null) {
        _result = Infinity.fromNum(numberAttempt);
      }
    } else if (_eCount == 1) {
      final double numberAttempt = double.tryParse(eParts.first.isEmpty ? '1$value' : value);

      if (numberAttempt != null && numberAttempt != 0) {
        _result = Infinity.fromNum(numberAttempt);
      } else {
        _result = Infinity.fromComponents(mantissa.sign.toInt(), 1, exponent + mantissa.abs().log10());
      }
    } else {
      if (mantissa == null || mantissa == 0) {
        _result = Infinity.zero();
      } else if (_eCount >= 2) {
        final double _v = double.tryParse(eParts[eParts.length - 2]);

        if (_v.isFinite) {
          exponent *= _v.sign;
          exponent += _v.magLog10();
        }
      }

      if (_result == null) {
        if (!mantissa.isFinite) {
          _result = Infinity.fromComponents(eParts[0] == '-' ? -1 : 1, _eCount, exponent);
        } else {
          if (_eCount == 2) {
            _result = Infinity.fromComponents(1, 2, exponent, false).multiply(Infinity.fromNum(mantissa));
          } else {
            _result = Infinity.fromComponents(mantissa.sign.toInt(), _eCount, exponent);
          }
        }
      }
    }
  }

  _result ??= Infinity.zero();
  _result.normalize();

  return _result;
}

Infinity _handleEPowFormat(String value) {
  int sign = 1;
  num layer;
  num mantissa;

  final List<String> _newParts = value.split('e^');

  if (_newParts.length == 2) {
    if (_newParts.first[0] == '-') {
      sign = -1;
    }

    String layerString = '';

    List<int> _chars = _newParts[1].runes.toList(growable: false);

    _chars.forEach((int charCode) {
      if ((charCode >= 43 && charCode <= 57) || charCode == 101) {
        //is "0" to "9" or "+" or "-" or "." or "e" (or "," or "/")
        layerString += charCode.toString();
      } else {
        //we found the end of the layer count
        layer = double.tryParse(layerString);
        mantissa = double.tryParse(_newParts[1].substring(_chars.indexOf(charCode) + 1));
      }
    });

    if (layer != null && mantissa != null) {
      return Infinity.fromComponents(sign, layer, mantissa);
    }
  }

  return null;
}
