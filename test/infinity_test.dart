import 'package:flutter_test/flutter_test.dart';
import 'package:infinity/infinity.dart';

void main() {
  Infinity _getBigNumber(Infinity infinity) {
    return infinity * infinity;
  }

  test('Adds double to Infinity', () {
    final Infinity _double = Infinity.fromDouble(1e308);

    Infinity _newBig;
    for (int i = 0; i < 100; i++) {
      print('-------------------');
      print('Addition: $i - ${(_newBig ?? _double).toString()} + ${_double.toString()} = ');

      _newBig = (_newBig ?? _double) + _double;

      print(_newBig.toString());
      print(_newBig.toDebugString());
    }
  });

  test('Adds bug', () {
    final Infinity _double = Infinity.fromDouble(1e308);

    Infinity _times2 = _double + 1e308;

    print(_double.toDebugString());
    print(_double);
    print(_times2.toDebugString());
    print(_times2);
    print(_times2 + _double);
    print(_times2 + _times2);
  });

  test('Can multiply big Infinities', () {
    final Infinity _double = Infinity.fromDouble(1e308);

    Infinity _newBig;
    for (int i = 0; i < 100; i++) {
      _newBig = _getBigNumber(_newBig ?? _double);
      print('-------------------');
      print('Multiplication: $i');
      print(_newBig.toString());
      print(_newBig.toDebugString());
    }
  });
}
