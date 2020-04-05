import 'package:flutter_test/flutter_test.dart';
import 'package:infinity/infinity.dart';

void main() {
  group('Addition', () {
    test('Simple addition', () {
      Infinity _infinity = Infinity.fromNum(1);
      expect(_infinity.toNumber(), 1);

      _infinity = _infinity + 10;
      expect(_infinity.toNumber(), 11);
    });

    test('Bigger number addition', () {
      Infinity _infinity = Infinity.fromNum(1e50);
      expect(_infinity.toNumber(), 1e50);

      _infinity = _infinity + 1e50;
      expect(_infinity.toNumber(), 2e50);
    });

    test('Biggest number addition', () {
      Infinity _infinity = Infinity.fromNum(1e305);
      expect(_infinity.toNumber(), 1e305);

      _infinity = _infinity + 1e305;

      expect(_infinity.toNumber(), 2e305);
    });

    test('Take bigger layer infinity', () {
      final Infinity _smaller = Infinity.fromNum(1e305);
      Infinity _infinity = Infinity.fromNum(1e305);
      expect(_infinity.toNumber(), 1e305);

      _infinity = _infinity * _infinity;
      expect(_infinity.toString(), '1e610');

      // Nothing should change
      _infinity = _infinity + _smaller;
      expect(_infinity.toNumber(), double.infinity);
      expect(_infinity.toString(), '1e610');
    });

    test('Bigger than biggest addition!', () {
      Infinity _infinity = Infinity.fromNum(1e308);
      expect(_infinity.toNumber(), 1e308);

      _infinity = _infinity + 1e308;

      expect(_infinity.toNumber(), double.infinity);
      expect(_infinity.toString(), '2e308');
    });
  });

  group('Subtraction', () {
    test('Simple subtraction', () {
      Infinity _infinity = Infinity.fromNum(1);
      expect(_infinity.toNumber(), 1);

      _infinity = _infinity - 10;
      expect(_infinity.toNumber(), -9);
    });

    test('Bigger number subtraction', () {
      Infinity _infinity = Infinity.fromNum(1e50);
      expect(_infinity.toNumber(), 1e50);

      _infinity = _infinity - 1e49;
      expect(_infinity.toNumber(), 9e49);
    });

    test('Biggest number subtraction', () {
      Infinity _infinity = Infinity.fromNum(1e305);
      expect(_infinity.toNumber(), 1e305);

      _infinity = _infinity - 1e305;

      expect(_infinity.toNumber(), 0);
    });

    test('Bigger than biggest subtraction!', () {
      Infinity _infinity = Infinity.fromNum(-1e308);
      expect(_infinity.toNumber(), -1e308);

      _infinity = _infinity - 1e308;

      expect(_infinity.toNumber(), double.negativeInfinity);
    });
  });

  group('Multiplication', () {
    test('Simple multiplication', () {
      Infinity _infinity = Infinity.fromNum(100);
      expect(_infinity.toNumber(), 100);

      _infinity = _infinity * 100;
      expect(_infinity.toNumber(), 10000);
    });

    test('Bigger number multiplication', () {
      Infinity _infinity = Infinity.fromNum(1e50);
      expect(_infinity.toNumber(), 1e50);

      _infinity = _infinity * 1e50;
      expect(_infinity.toNumber(), 1e100);
    });

    test('Biggest number multiplication', () {
      Infinity _infinity = Infinity.fromNum(5e307, false);
      expect(_infinity.toNumber(), 5e307);

      _infinity = _infinity * 2;

      expect(_infinity.toNumber(), 1e308);
    });

    test('Infinity times infinity?', () {
      Infinity _infinity = Infinity.fromNum(1e308);
      expect(_infinity.toNumber(), 1e308);

      _infinity = _infinity * _infinity;

      expect(_infinity.toNumber(), double.infinity);
    });
  });

  group('Division', () {
    test('Simple division', () {
      Infinity _infinity = Infinity.fromNum(100);
      expect(_infinity.toNumber(), 100);

      _infinity = _infinity / 100;
      expect(_infinity.toNumber(), 1);
    });

    test('Bigger number division', () {
      Infinity _infinity = Infinity.fromNum(1e50);
      expect(_infinity.toNumber(), 1e50);

      _infinity = _infinity / 2;
      expect(_infinity.toNumber(), 5e49);
    });

    test('Biggest number division', () {
      Infinity _infinity = Infinity.fromNum(1e308);
      expect(_infinity.toNumber(), 1e308);

      _infinity = _infinity * 10;

      expect(_infinity.toNumber(), double.infinity);

      _infinity = _infinity / 10;

      expect(_infinity.toNumber(), 1e308);
    });

    test('Infinity divided by infinity?', () {
      Infinity _infinity = Infinity.fromNum(1e308);
      expect(_infinity.toNumber(), 1e308);

      _infinity = _infinity / _infinity;

      expect(_infinity.toNumber(), 1);
    });
  });

  group('Division with rounding', () {
    test('Simple division with rounding', () {
      Infinity _infinity = Infinity.fromNum(100);
      expect(_infinity.toNumber(), 100);

      _infinity = _infinity ~/ 3;
      expect(_infinity.toNumber(), 33);
    });

    test('Bigger number division with rounding', () {
      Infinity _infinity = Infinity.fromNum(1e100);
      expect(_infinity.toNumber(), 1e100);

      _infinity = _infinity ~/ 3;
      expect(_infinity.toNumber(), 3e99);
    });
  });

  group('Modulus operator', () {
    test('Modulos operator simple', () {
      Infinity _infinity = Infinity.fromNum(100);
      expect(_infinity.toNumber(), 100);

      _infinity = _infinity % 6;
      expect(_infinity.toNumber(), 4);
    });

    test('Modulos operator more complex', () {
      Infinity _infinity = Infinity.fromNum(333);
      expect(_infinity.toNumber(), 333);

      _infinity = _infinity % 10;
      expect(_infinity.toNumber(), 3);
    });
  });

  group('Negate', () {
    test('Negate positive number', () {
      Infinity _infinity = Infinity.fromNum(100);
      expect(_infinity.toNumber(), 100);

      _infinity = -_infinity;
      expect(_infinity.toNumber(), -100);
    });

    test('Negate negative number', () {
      Infinity _infinity = Infinity.fromNum(-333);
      expect(_infinity.toNumber(), -333);

      _infinity = -_infinity;
      expect(_infinity.toNumber(), 333);
    });
  });
}
