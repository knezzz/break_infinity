part of infinity;

extension Pow on Infinity {
  Infinity square() {
    return pow(Infinity.fromNum(2));
  }

  Infinity cube() {
    return pow(Infinity.fromNum(2));
  }

  Infinity pow(Infinity other) {
    logOperation('Pow ${toString()} on ${other.toString()}');
    Infinity _result;

    if (sign == 0) {
      _result = this;
    } else if (sign == 1 && layer == 0 && mantissa == 1) {
      _result = this;
    } else if (other.sign == 0) {
      _result = Infinity.fromComponents(1, 0, 1);
    } else if (other.sign == 1 && other.layer == 0 && other.mantissa == 1) {
      _result = this;
    } else {
      _result = (absLog10().multiply(other)).pow10();

      /// Check if end result should be round number
      if (other.isInt && isInt) {
        _result = _result.round();
      }

      if (sign == -1 && other.toNumber() % 2 == 1) {
        _result = _result.neg();
      }
    }

    logOperation('Pow ${toString()} on ${other.toString()} is $_result', exiting: true);

    return _result;
  }

  Infinity pow10() {
    logOperation('pow10 on ${toString()}');
    Infinity _result;
    final num _layer = layer + 1;

    if (!layer.isFinite || !mantissa.isFinite) {
      return Infinity.nan();
    } else if (layer == 0) {
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
    } else if (sign > 0 && mantissa > 0) {
      return Infinity.fromComponents(sign, _layer, mantissa);
    } else if (sign < 0 && mantissa > 0) {
      return Infinity.fromComponents(-sign, _layer, -mantissa);
    }

    _result ??= Infinity.one();

    logOperation('pow10 on ${toString()} is $_result', exiting: true);

    return _result;
  }

  Infinity operator ^(dynamic other) {
    final Infinity _inf = getInfinity(other);

    if (_inf != null) {
      return pow(_inf);
    }

    throw ArgumentError('Bad arguments for pow: $this^$other');
  }
}
