part of infinity;

extension Pentate on Infinity {
  Infinity pentate({double height = 2, Infinity other}) {
    logDebug('Pentate ${toString()} and ${other.toString()}');
    other ??= Infinity.fromComponents(1, 0, 1);

    Infinity _result;

    double oldheight = height;
    height = height.truncateToDouble();
    double fracheight = oldheight - height;

    //I have no idea if this is a meaningful approximation for pentation to continuous heights, but it is monotonic and continuous.
    if (fracheight != 0) {
      if (other == Infinity.one()) {
        ++height;
        other = Infinity.fromNum(fracheight);
      } else {
        if (this == Infinity.fromNum(10)) {
          other = other.layerAdd10(fracheight);
        } else {
          other = other.layerAdd(fracheight.toInt(), this);
        }
      }
    }

    for (int i = 0; i < height; ++i) {
      other = tetrate(height: other.toNumber().toDouble());
      //bail if we're NaN
      if (!other.layer.isFinite || !other.mantissa.isFinite) {
        _result = other;
      } else if (i > 10) {
        _result = other;
      }
    }

    _result ??= other;

    return other;
  }
}
