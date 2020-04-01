part of infinity;

extension Divide on Infinity {
  Infinity divide(Infinity other) {
    logDebug('Divide ${toString()} and ${other.toString()}');
    final Infinity _result = multiply(other.reciprocal());
    return _result;
  }

  Infinity operator /(dynamic other) {
    final Infinity _inf = getInfinity(other);

    if (_inf != null) {
      return divide(_inf);
    }

    throw ArgumentError('Bad arguments to divide: $this / $other');
  }
}
