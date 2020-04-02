part of infinity;

extension Clamp on Infinity {
  Infinity clamp(dynamic min, dynamic max) {
    logAbbreviation('clamp: $min - $max');

    final Infinity _min = getInfinity(min);
    final Infinity _max = getInfinity(max);

    return this.max(_min).min(_max);
  }

  Infinity clampMin(dynamic min) {
    logAbbreviation('clampMin: $min');
    final Infinity _min = getInfinity(min);

    return max(_min);
  }

  Infinity clampMax(dynamic max) {
    logAbbreviation('clampMax: $max');

    final Infinity _max = getInfinity(max);

    return min(_max);
  }
}
