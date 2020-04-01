part of infinity;

extension Add on Infinity {
  Infinity add(Infinity other) {
    logInfo('Add ${toString()} and ${other.toString()}');
    Infinity _result;

    final bool _compare = cmpAbs(other) > 0;
    final Infinity a = _compare ? this : other;
    final Infinity b = _compare ? other : this;

    final int layerA = a.layer.toInt() * a.mantissa.toInt().sign;
    final int layerB = b.layer.toInt() * b.mantissa.toInt().sign;

    if (!layer.isFinite) {
      _result = this;
    } else if (!other.layer.isFinite) {
      _result = other;
    } else if (sign == 0) {
      _result = other;
    } else if (other.sign == 0) {
      _result = this;
    } else if (sign == -other.sign && layer == other.layer && mantissa == other.mantissa) {
      _result = Infinity.zero();
    } else if (layer >= 2 || other.layer >= 2) {
      _result = maxAbs(other);
    } else if (a.layer == 0 && b.layer == 0) {
      logVerbose('Numbers are still in layer 0', debugString: a.toDebugString());
      _result = Infinity.fromNum(a.sign * a.mantissa + b.sign * b.mantissa);
    } else if (layerA - layerB >= 2) {
      _result = a;
    } else if (layerA == 0 && layerB == -1) {
      if ((b.mantissa - a.mantissa.log10).abs() > maxSignificantDigits) {
        logVerbose('Returning bigger number!', debugString: a.toDebugString());
        _result = a;
      } else {
        final num _magdiff = math.pow(10, a.mantissa.log10 - b.mantissa).toDouble();
        final num _mantissa = b.sign + (a.sign * _magdiff);

        logVerbose('Number magDif: $_magdiff');
        logVerbose('Number mantissa: $_mantissa');
        _result = Infinity.fromComponents(_mantissa.sign.toInt(), 1, b.sign + _mantissa.abs().log10);
      }
    } else if (layerA == 1 && layerB == 0) {
      if ((a.mantissa - b.mantissa.log10).abs() > maxSignificantDigits) {
        logVerbose('Returning bigger number!', debugString: a.toDebugString());
        _result = a;
      } else {
        final num _magdiff = math.pow(10, a.mantissa - b.mantissa.log10).toDouble();
        final num _mantissa = b.sign + (a.sign * _magdiff);

        logVerbose('Number magDif: $_magdiff');
        logVerbose('Number mantissa: $_mantissa');
        _result = Infinity.fromComponents(_mantissa.sign.toInt(), 1, b.mantissa.log10 + _mantissa.abs().log10);
      }
    } else if ((a.mantissa - b.mantissa).abs() > maxSignificantDigits) {
      logVerbose('Returning bigger number!', debugString: a.toDebugString());
      _result = a;
    } else {
      final num _magdiff = math.pow(10, a.mantissa - b.mantissa).toDouble();
      final num _mantissa = b.sign + (a.sign * _magdiff);

      logVerbose('Number magDif: $_magdiff');
      logVerbose('Number mantissa: $_mantissa');
      _result = Infinity.fromComponents(_mantissa.sign.toInt(), 1, b.mantissa + _mantissa.abs().log10);
    }

    return _result;
  }

  Infinity operator +(dynamic other) {
    final Infinity _inf = getInfinity(other);

    if (_inf != null) {
      return add(_inf);
    }

    throw ArgumentError('Bad arguments to add: $this + $other');
  }
}
