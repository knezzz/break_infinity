part of infinity;

extension Pentate on Infinity {
  //Pentation/pentate: The result of tetrating 'height' times in a row. An absurdly strong operator - Decimal.pentate(2, 4.28) and Decimal.pentate(10, 2.37) are already too huge for break_eternity.js!
  // https://en.wikipedia.org/wiki/Pentation
  Infinity pentate({double height = 2, Infinity other}) {
    other ??= Infinity.fromComponents(1, 0, 1);
    logOperation('Pentate ${toString()} and ${other.toString()} : $height');

    Infinity _result;

    final double oldHeight = height;
    height = height.truncateToDouble();
    final double fracHeight = oldHeight - height;

    //I have no idea if this is a meaningful approximation for pentation to continuous heights, but it is monotonic and continuous.
    if (fracHeight != 0) {
      if (other == Infinity.one()) {
        ++height;
        other = Infinity.fromNum(fracHeight);
      } else {
        if (this == Infinity.fromNum(10)) {
          other = other.layerAdd10(fracHeight);
        } else {
          other = other.layerAdd(fracHeight.toInt(), this);
        }
      }
    }

    for (int i = 0; i < height; ++i) {
      other = tetrate(height: other.toNumber().toDouble());
      if (!other.layer.isFinite || !other.mantissa.isFinite) {
        //bail if we're NaN
        _result = other;
      } else if (i > 10) {
        //give up after 10 iterations if nothing is happening
        _result = other;
      }
    }

    _result ??= other;

    logOperation('Pentate ${toString()} is $_result', exiting: true);

    return other;
  }
}
