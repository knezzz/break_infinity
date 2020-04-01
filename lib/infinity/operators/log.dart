part of infinity;

extension Log on Infinity {
  /// iterated log/repeated log: The result of applying log(base) 'times' times in a row. Approximately equal to subtracting (times) from the number's slog representation. Equivalent to tetrating to a negative height.
  /// Works with negative and positive real heights.
  Infinity iteratedLog({int times = 1, Infinity base}) {
    logDebug('Iterated log ${toString()}: Times: $times: Base: ${base.toString()}');
    Infinity _result;

    if (times < 0) {
      _result = base.tetrate(height: -times.toDouble(), other: this);
    } else {
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
          _result = _result;
        } else if (i > 100) {
          _result = _result;
        }
      }

      //handle fractional part
      if (_result == null && fraction > 0 && fraction < 1) {
        if (base == Infinity.fromNum(10)) {
          _result = layerAdd10(-fraction);
        } else {
          _result = layerAdd(-fraction, base);
        }
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

    return Infinity.fromComponents(mantissa.toInt().sign, 0, mantissa.log10);
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
