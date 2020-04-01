part of infinity;

extension Tetrate on Infinity {
  /// Tetration/tetrate: The result of exponentiating 'this' to 'this' 'height' times in a row.  https://en.wikipedia.org/wiki/Tetration
  /// If payload != 1, then this is 'iterated exponentiation', the result of exping (payload) to base (this) (height) times. https://andydude.github.io/tetration/archives/tetration2/ident.html
  /// Works with negative and positive real heights.
  Infinity tetrate({double height = 2, Infinity other}) {
    other ??= Infinity.fromComponents(1, 0, 1);
    logDebug('Tetrate ${toString()} and ${other.toString()} ($height)');

    if (height == double.infinity) {
      final Infinity _negLn = naturalLogarithm().neg();
      return _negLn.lambertW().divide(_negLn);
    }

    if (height < 0) {
      return iteratedLog(times: -height.toInt(), base: other);
    }

    double oldheight = height;
    height = height.truncateToDouble();

    double fracheight = oldheight - height;

    logVerbose('Tetrate -- fracheight: $fracheight');

    if (fracheight != 0) {
      if (other == Infinity.one()) {
        ++height;
        other = Infinity.fromNum(fracheight);
      } else {
        logVerbose('Is infinity 10? ${toString()}');

        if (this == Infinity.fromNum(10)) {
          other = other.layerAdd10(fracheight);
        } else {
          other = other.layerAdd(fracheight.toInt(), this);
        }
      }
    }

    for (int i = 0; i < height; ++i) {
      other = pow(other);
      //bail if we're NaN
      if (!other.layer.isFinite || !other.mantissa.isFinite) {
        return other;
      }
      //shortcut
      if (other.layer - layer > 3) {
        return Infinity.fromComponents(other.sign, other.layer + height - i - 1, other.mantissa, false);
      }
      //give up after 100 iterations if nothing is happening
      if (i > 100) {
        return other;
      }
    }

    return other;
  }
}
