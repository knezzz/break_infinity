part of infinity;

extension Divide on Infinity {
  Infinity divide(Infinity other) {
    logOperation('Divide ${toString()} and ${other.toString()}');
    final Infinity _result = multiply(other.reciprocal());

    logOperation('${toString()} / ${other.toString()} = $_result', exiting: true);
    return _result;
  }

  Infinity operator /(dynamic other) {
    final Infinity _inf = getInfinity(other);
    Infinity _result;

    if (_inf != null) {
      _result = divide(_inf);

      /// (lukaknezic): Find out better way to do this!
      // If result of mod is 0 then round up the division!
      _result.roundMantissa(value: this % _inf == Infinity.zero());

      return _result;
    }

    throw ArgumentError('Bad arguments to divide: $this / $other');
  }

  Infinity operator ~/(dynamic other) {
    final Infinity _inf = getInfinity(other);
    Infinity _result;

    if (_inf != null) {
      _result = divide(_inf).truncate();
      _result.roundMantissa();
      return _result;
    }

    throw ArgumentError('Bad arguments to floor-divide: $this ~/ $other');
  }
}
