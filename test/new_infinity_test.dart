import 'package:infinity/infinity.dart';
import 'package:test/test.dart';

void main() {
  group('fromString', () {
    test('Pentation (X^^^N)', () {
      final Infinity _infinity = Infinity.fromString('2^^^3');
      expect(_infinity.toNumber(), 65536.0);
    });

    test('Pentation (X^^^N;Y)', () {
      final Infinity _infinity = Infinity.fromString('2^^^3;1.1');
      expect(_infinity.toNumber(), 17200126825.65138);
    });

    test('Tetration (X^^N)', () {
      final Infinity _infinity = Infinity.fromString('2^^3');
      expect(_infinity.toNumber(), 16);
    });

    test('Tetration (X^^N;Y)', () {
      final Infinity _infinity = Infinity.fromString('2^^3;2');
      expect(_infinity.toNumber(), 65536.0);
    });

    test('Pow (X^N)', () {
      final Infinity _infinity = Infinity.fromString('2^3');
      expect(_infinity.toNumber(), 8.0);
    });
  });
}
