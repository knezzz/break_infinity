part of infinity;

extension Tetrate on Infinity {
  /// Tetration/tetrate: The result of exponentiating 'this' to 'this' 'height' times in a row.  https://en.wikipedia.org/wiki/Tetration
  /// If payload != 1, then this is 'iterated exponentiation', the result of exping (payload) to base (this) (height) times. https://andydude.github.io/tetration/archives/tetration2/ident.html
  /// Works with negative and positive real heights.
  Infinity tetrate({double height = 2, Infinity other}) {
    other ??= Infinity.fromComponents(1, 0, 1);
    logOperation('Tetrate ${toString()} and ${other.toString()} ($height)');

    Infinity _result;

    if (height == double.infinity) {
      final Infinity _negLn = naturalLogarithm().neg();
      _result = _negLn.lambertW().divide(_negLn);
    } else if (height < 0) {
      _result = iteratedLog(times: -height.toInt(), base: other);
    } else {
      final double oldHeight = height;
      height = height.truncateToDouble();

      final double fracHeight = oldHeight - height;

      logVerbose('Tetrate -- fracHeight: $fracHeight');

      if (fracHeight != 0) {
        if (other == Infinity.one()) {
          ++height;
          other = Infinity.fromNum(fracHeight);
        } else {
          logVerbose('Is infinity 10? ${toString()}');

          if (this == Infinity.fromNum(10)) {
            other = other.layerAdd10(fracHeight);
          } else {
            other = other.layerAdd(fracHeight.toInt(), this);
          }
        }
      }

      for (int i = 0; i < height; ++i) {
        other = pow(other);
        //bail if we're NaN
        if (!other.layer.isFinite || !other.mantissa.isFinite) {
          _result = other;
          break;
        }
        //shortcut
        if (other.layer - layer > 3) {
          _result = Infinity.fromComponents(other.sign, other.layer + height - i - 1, other.mantissa, false);
          break;
        }
        //give up after 100 iterations if nothing is happening
        if (i > 100) {
          _result = other;
          break;
        }
      }
    }

    _result ??= other;

    logOperation('Tetrate ${toString()} ($height) is: $_result', exiting: true);

    return _result;
  }
}
