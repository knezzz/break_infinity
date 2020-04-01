part of infinity;

extension Round on Infinity {
  Infinity round() {
    logDebug('round on ${toString()}');
    if (mantissa < 0) {
      return Infinity.zero();
    } else if (layer == 0) {
      return Infinity.fromComponents(sign, 0, mantissa.roundToDouble());
    }

    return this;
  }

  Infinity floor() {
    logDebug('floor on ${toString()}');
    if (mantissa < 0) {
      return Infinity.zero();
    } else if (layer == 0) {
      return Infinity.fromComponents(sign, 0, mantissa.floorToDouble());
    }

    return this;
  }

  Infinity ceil() {
    logDebug('ceil on ${toString()}');
    if (mantissa < 0) {
      return Infinity.zero();
    } else if (layer == 0) {
      return Infinity.fromComponents(sign, 0, mantissa.ceilToDouble());
    }

    return this;
  }

  Infinity truncate() {
    logDebug('truncate on ${toString()}');
    if (mantissa < 0) {
      return Infinity.zero();
    } else if (layer == 0) {
      return Infinity.fromComponents(sign, 0, mantissa.truncateToDouble());
    }

    return this;
  }
}
