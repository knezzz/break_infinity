part of infinity;

extension Pow on Infinity {
  Infinity square() {
    return pow(Infinity.fromNum(2));
  }

  Infinity cube() {
    return pow(Infinity.fromNum(2));
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

  Infinity pow10() {
    logDebug('pow10 on ${toString()}');

    if (!layer.isFinite || !mantissa.isFinite) {
      return Infinity.nan();
    }
    final num _layer = layer + 1;

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
}
