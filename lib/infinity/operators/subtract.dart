part of infinity;

extension Subtract on Infinity {
  Infinity subtract(Infinity other) {
    logOperation('Subtract ${toString()} and ${other.toString()}');

    final Infinity _result = add(other.neg());

    logOperation('${toString()} - ${other.toString()} = $_result', exiting: true);

    return _result;
  }

  Infinity operator -(dynamic other) {
    final Infinity _inf = getInfinity(other);

    if (_inf != null) {
      return subtract(_inf);
    }

    throw ArgumentError('Bad arguments to subtract: $this - $other');
  }
}
