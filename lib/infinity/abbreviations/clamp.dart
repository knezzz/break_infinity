part of infinity;

extension Clamp on Infinity {
  Infinity clamp(dynamic min, dynamic max) {
    logDebug('clamp: $min - $max');

    final Infinity _min = getInfinity(min);
    final Infinity _max = getInfinity(max);

    return this.max(_min).min(_max);
  }

  Infinity clampMin(dynamic min) {
    logDebug('clampMin: $min');
    final Infinity _min = getInfinity(min);

    return max(_min);
  }

  Infinity clampMax(dynamic max) {
    logDebug('clampMax: $max');

    final Infinity _max = getInfinity(max);

    return min(_max);
  }
}
