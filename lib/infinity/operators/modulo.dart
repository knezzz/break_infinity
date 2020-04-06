part of infinity;

extension Modulo on Infinity {
  Infinity modulo(Infinity other) {
    logOperation('Mod ${toString()} and ${other.toString()}');
    Infinity _result;

    if (other == Infinity.zero()) {
      _result = Infinity.zero();
    } else if (sign * other.sign == -1) {
      _result = abs().modulo(other.abs()).neg();
    } else if (sign == -1) {
      _result = abs().modulo(other.abs());
    } else {
      _result = subtract(divide(other).floor().multiply(other));
    }

    logOperation('${toString()} % ${other.toString()} = $_result', exiting: true);
    return _result;
  }

  Infinity operator %(dynamic other) {
    final Infinity _inf = getInfinity(other);

    if (_inf != null) {
      return modulo(_inf);
    }

    throw ArgumentError('Bad arguments to mod: $this % $other');
  }
}
