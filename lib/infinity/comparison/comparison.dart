part of infinity;

extension LessThen on Infinity {
  int compare(Infinity other) {
    logDebug('Comparing ${toString()} with ${other.toString()}');

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

  bool operator >(dynamic other) {
    final Infinity _inf = getInfinity(other);

    if (_inf != null) {
      return _inf.compare(this) == -1;
    }

    throw ArgumentError('Bad arguments: $this / $other');
  }

  bool operator <(dynamic other) {
    final Infinity _inf = getInfinity(other);

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
    final Infinity _inf = getInfinity(other);

    if (_inf != null) {
      return _inf > this ? _inf : this;
    }

    throw ArgumentError('Bad arguments for max: $this / $other');
  }

  Infinity min(dynamic other) {
    logDebug('min: ${toString()} and ${other.toString()}');
    final Infinity _inf = getInfinity(other);

    if (_inf != null) {
      return _inf < this ? _inf : this;
    }

    throw ArgumentError('Bad arguments for min: $this / $other');
  }

  Infinity maxAbs(dynamic other) {
    logDebug('maxAbs: ${toString()} and ${other.toString()}');
    final Infinity _inf = getInfinity(other);

    if (_inf != null) {
      return cmpAbs(_inf) < 0 ? _inf : this;
    }

    throw ArgumentError('Bad arguments for max: $this / $other');
  }

  Infinity minAbs(dynamic other) {
    logDebug('minAbs: ${toString()} and ${other.toString()}');

    final Infinity _inf = getInfinity(other);

    if (_inf != null) {
      return cmpAbs(_inf) > 0 ? _inf : this;
    }

    throw ArgumentError('Bad arguments for min: $this / $other');
  }
}
