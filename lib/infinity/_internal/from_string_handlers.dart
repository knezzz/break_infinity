part of infinity;

Infinity _handlePentateString(String value) {
  //Handle x^^^y format.
  final List<String> pentationParts = value.split('^^^');
  if (pentationParts.length == 2) {
    final double base = double.tryParse(pentationParts.first);
    double height;
    double payload = 1;

    final List<String> pentationHeightParts = pentationParts.last.split(';');

    if (pentationHeightParts.length == 2) {
      height = double.tryParse(pentationHeightParts.first);
      payload = double.tryParse(pentationHeightParts.last);

      if (!payload.isFinite) {
        payload = 1;
      }
    } else {
      height = double.tryParse(pentationParts.last);
    }

    if (base.isFinite && height.isFinite) {
      return Infinity.fromNum(base).pentate(height: height, other: Infinity.fromNum(payload));
    }
  }

  return null;
}

Infinity _handleTetrateString(String value) {
  //Handle x^^y format.
  final List<String> tetrateParts = value.split('^^');
  if (tetrateParts.length == 2) {
    final double base = double.tryParse(tetrateParts.first);
    double height;
    double payload = 1;

    final List<String> tetrateHeightParts = tetrateParts.last.split(';');

    if (tetrateHeightParts.length == 2) {
      height = double.tryParse(tetrateHeightParts.first);
      payload = double.tryParse(tetrateHeightParts.last);

      if (!payload.isFinite) {
        payload = 1;
      }
    } else {
      height = double.tryParse(tetrateParts.last);
    }

    if (base.isFinite && height.isFinite) {
      return Infinity.fromNum(base).tetrate(height: height, other: Infinity.fromNum(payload));
    }
  }

  return null;
}

Infinity _handlePowString(String value) {
  //Handle x^y format.
  final List<String> tetrateParts = value.split('^');
  if (tetrateParts.length == 2) {
    final double base = double.tryParse(tetrateParts.first);
    final double height = double.tryParse(tetrateParts.last);

    if (base.isFinite && height.isFinite) {
      return Infinity.fromNum(base).pow(Infinity.fromNum(height));
    }
  }

  return null;
}
