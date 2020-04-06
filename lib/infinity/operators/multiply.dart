part of infinity;

extension Multiply on Infinity {
  Infinity multiply(Infinity other) {
    logOperation('Multiply ${toString()} and ${other.toString()}', isMainOperation: true);
    Infinity _result;

    //Which number is bigger in terms of its multiplicative distance from 1?
    final bool _compare = layer > other.layer || (layer == other.layer && mantissa.abs() > other.mantissa.abs());
    final Infinity a = _compare ? this : other;
    final Infinity b = _compare ? other : this;

    // finite and nan check
    if (!layer.isFinite) {
      logVerbose('This layer is not finite!');
      _result = this;
    } else if (!other.layer.isFinite) {
      logVerbose('Other layer is not finite!');
      _result = other;
    } else if (sign == 0 || other.sign == 0) {
      //Special case - if one of the numbers is 0, return 0.
      _result = Infinity.zero();
    } else if (layer == other.layer && mantissa == -other.mantissa) {
      //Special case - Multiplying a number by its own reciprocal yields +/- 1, no matter how large.
      _result = Infinity.fromComponents(sign * other.sign, 0, 1, false);
    } else if (a.layer == 0 && b.layer == 0) {
      _result = Infinity.fromNum(a.sign * b.sign * a.mantissa * b.mantissa);
    } else if (a.layer >= 3 || (a.layer - b.layer >= 2)) {
      //Special case: If one of the numbers is layer 3 or higher or one of the numbers is 2+ layers bigger than the other, just take the bigger number.
      _result = Infinity.fromComponents(a.sign * b.sign, a.layer, a.mantissa);
    } else if (a.layer == 1 && b.layer == 0) {
      _result = Infinity.fromComponents(a.sign * b.sign, 1, a.mantissa + b.mantissa.log10());
    } else if (a.layer == 1 && b.layer == 1) {
      _result = Infinity.fromComponents(a.sign * b.sign, 1, a.mantissa + b.mantissa);
    } else if (a.layer == 2 && b.layer == 1) {
      final Infinity _newMag = Infinity.fromComponents(a.mantissa.sign.toInt(), a.layer - 1, a.mantissa.abs())
          .add(Infinity.fromComponents(b.mantissa.sign.toInt(), b.layer - 1, b.mantissa.abs()));
      _result = Infinity.fromComponents(a.sign * b.sign, _newMag.layer + 1, _newMag.sign * _newMag.mantissa);
    } else if (a.layer == 2 && b.layer == 2) {
      final Infinity _newMag = Infinity.fromComponents(a.mantissa.sign.toInt(), a.layer - 1, a.mantissa.abs())
          .add(Infinity.fromComponents(b.mantissa.sign.toInt(), b.layer - 1, b.mantissa.abs()));
      _result = Infinity.fromComponents(a.sign * b.sign, _newMag.layer + 1, _newMag.sign * _newMag.mantissa);
    }

    _result ??= Infinity.zero();

    if (isInt && other.isInt) {
      logVerbose('Multiplication is in int! Rounding result!');
      _result.roundMantissa();
    }

    logOperation('${toString()} * $other = $_result', exiting: true, isMainOperation: true);
    return _result;
  }

  Infinity operator *(dynamic other) {
    final Infinity _inf = getInfinity(other);

    if (_inf != null) {
      return multiply(_inf);
    }

    throw ArgumentError('Bad arguments to multiply: $this * $other');
  }
}
