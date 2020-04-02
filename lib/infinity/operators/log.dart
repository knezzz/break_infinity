part of infinity;

extension Log on Infinity {
  /// iterated log/repeated log: The result of applying log(base) 'times' times in a row. Approximately equal to subtracting (times) from the number's slog representation. Equivalent to tetrating to a negative height.
  /// Works with negative and positive real heights.
  Infinity iteratedLog({int times = 1, Infinity base}) {
    logOperation('Iterated log ${toString()}: Times: $times: Base: ${base.toString()}');
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

    logOperation('Iterated log $_result', exiting: true);

    return _result;
  }

  Infinity _log10() {
    logOperation('Log10 ${toString()}');

    Infinity _result;

    if (sign <= 0) {
      _result = Infinity.nan();
    } else if (layer > 0) {
      _result = Infinity.fromComponents(mantissa.toInt().sign, --layer, mantissa.abs());
    } else {
      _result = Infinity.fromComponents(mantissa.toInt().sign, 0, mantissa.log10());
    }

    logOperation('Log10 ${toString()} = $_result', exiting: true);

    return _result;
  }

  Infinity slog(Infinity base) {
    logOperation('slog ${toString()} Base: $base');

    int result = 0;
    Infinity copy = this;

    Infinity _result;

    if (mantissa < 0) {
      _result = Infinity.one().neg();
    } else if (copy.layer - base.layer > 3) {
      final int layerLoss = (copy.layer - base.layer - 3).toInt();
      result += layerLoss;
      copy.layer -= layerLoss;
    } else {
      for (int i = 0; i < 100; ++i) {
        if (copy < Infinity.zero()) {
          copy = base.pow(copy);
          result -= 1;
        } else if (copy < Infinity.one()) {
          _result = Infinity.fromNum(result + copy.toNumber() - 1); //<-- THIS IS THE CRITICAL FUNCTION
          //^ Also have to change tetrate payload handling and layerAdd10 if this is changed!
        } else {
          result += 1;
          copy = copy.log(base);
        }
      }
    }

    _result ??= Infinity.fromNum(result);

    logOperation('slog ${toString()} Base: $base = $_result', exiting: true);

    return _result;
  }

  Infinity log(Infinity other) {
    Infinity _result;

    if (sign <= 0 || other.sign <= 0) {
      _result = Infinity.nan();
    } else if (sign == 1 && layer == 0 && mantissa == 1) {
      _result = Infinity.nan();
    } else if (layer == 0 && other.layer == 0) {
      _result = Infinity.fromComponents(sign, 0, math.log(mantissa) / math.log(other.mantissa));
    } else {
      _result = _log10() / other._log10();
    }

    return _result;
  }
}
