part of infinity;

extension Multiply on Infinity {
  Infinity multiply(Infinity other) {
    logInfo('Multiply ${toString()} and ${other.toString()}');
    Infinity _result;

    final bool _compare = layer > other.layer || (layer == other.layer && mantissa.abs() > other.mantissa.abs());
    final Infinity a = _compare ? this : other;
    final Infinity b = _compare ? other : this;

    if (!layer.isFinite) {
      logVerbose('This layer is not finite!');
      return this;
    } else if (!other.layer.isFinite) {
      logVerbose('Other layer is not finite!');
      return other;
    } else if (sign == 0 || other.sign == 0) {
      return Infinity.zero();
    } else if (layer == other.layer && mantissa == -other.mantissa) {
      return Infinity.fromComponents(sign * other.sign, 0, 1, false);
    } else if (a.layer == 0 && b.layer == 0) {
      return Infinity.fromNum(a.sign * b.sign * a.mantissa * b.mantissa);
    } else if (a.layer >= 3 || (a.layer - b.layer >= 2)) {
      return Infinity.fromComponents(a.sign * b.sign, a.layer, a.mantissa);
    } else if (a.layer == 1 && b.layer == 0) {
      return Infinity.fromComponents(a.sign * b.sign, 1, a.mantissa + b.mantissa.log10);
    } else if (a.layer == 1 && b.layer == 1) {
      return Infinity.fromComponents(a.sign * b.sign, 1, a.mantissa + b.mantissa);
    } else if (a.layer == 2 && b.layer == 1) {
      final Infinity _newMag = Infinity.fromComponents(a.mantissa.sign.toInt(), a.layer - 1, a.mantissa.abs())
          .add(Infinity.fromComponents(b.mantissa.sign.toInt(), b.layer - 1, b.mantissa.abs()));
      return Infinity.fromComponents(a.sign * b.sign, _newMag.layer + 1, _newMag.sign * _newMag.mantissa);
    } else if (a.layer == 2 && b.layer == 2) {
      final Infinity _newMag = Infinity.fromComponents(a.mantissa.sign.toInt(), a.layer - 1, a.mantissa.abs())
          .add(Infinity.fromComponents(b.mantissa.sign.toInt(), b.layer - 1, b.mantissa.abs()));
      return Infinity.fromComponents(a.sign * b.sign, _newMag.layer + 1, _newMag.sign * _newMag.mantissa);
    }

    _result ??= Infinity.zero();
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
