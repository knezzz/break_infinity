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

    group('PT', () {
      test('P (XPN)', () {
        final Infinity _infinity = Infinity.fromString('2P3');
        expect(_infinity.toString(), '1.0e1000');
      });

      test('PT (XPTN)', () {
        final Infinity _infinity = Infinity.fromString('2PT3');
        expect(_infinity.toString(), '1.0e1000');
      });
    });

    group('E', () {
      test('E (XeN)', () {
        final Infinity _infinity = Infinity.fromString('1e25');
        expect(_infinity.toString(), '1.0e25');
      });

      test('E (eN)', () {
        final Infinity _infinity = Infinity.fromString('e25');
        expect(_infinity.toString(), '1.0e25');
      });

      test('E (eXeN)', () {
        final Infinity _infinity = Infinity.fromString('e12e12');
        expect(_infinity.toString(), '1.018151721718182e12000000000000');
      });

      test('E (MeXeN)', () {
        final Infinity _infinity = Infinity.fromString('4e12e12');
        expect(_infinity.toString(), '4.067944321083047e12000000000000');
      });
    });
  });
}
