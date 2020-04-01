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
      expect(_infinity.toNumber().roundToDouble(), 2e50);
    });

    test('Biggest number addition', () {
      Infinity _infinity = Infinity.fromNum(1e305);
      expect(_infinity.toNumber(), 1e305);

      _infinity = _infinity + 1e305;

      expect(_infinity.toNumber(), 2e305);
    });

    test('Bigger than biggest addition!', () {
      Infinity _infinity = Infinity.fromNum(1e308);
      expect(_infinity.toNumber(), 1e308);

      _infinity = _infinity + 1e308;

      expect(_infinity.toNumber(), double.infinity);
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
      expect(_infinity.toNumber().roundToDouble(), 9e49);
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
      Infinity _infinity = Infinity.fromNum(5e307);
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

  group('Power', () {
    group('Simple powers', () {
      test('Simple pow 2^16', () {
        Infinity _infinity = Infinity.fromNum(2);
        expect(_infinity.toNumber(), 2);

        _infinity = _infinity.pow(Infinity.fromNum(16));

        expect(_infinity.toNumber(), 65536);
      });

      test('Simple pow 2^20', () {
        Infinity _infinity = Infinity.fromNum(2);
        expect(_infinity.toNumber(), 2);

        _infinity = _infinity.pow(Infinity.fromNum(20));

        expect(_infinity.toNumber(), 1048576);
      });

      test('Simple pow 2^24', () {
        Infinity _infinity = Infinity.fromNum(2);
        expect(_infinity.toNumber(), 2);

        _infinity = _infinity.pow(Infinity.fromNum(24));

        expect(_infinity.toNumber(), 16777216);
      });

      test('Simple pow 2^28', () {
        Infinity _infinity = Infinity.fromNum(2);
        expect(_infinity.toNumber(), 2);

        _infinity = _infinity.pow(Infinity.fromNum(28));

        expect(_infinity.toNumber(), 268435456);
      });

      test('Simple pow 2^32', () {
        Infinity _infinity = Infinity.fromNum(2);
        expect(_infinity.toNumber(), 2);

        _infinity = _infinity.pow(Infinity.fromNum(32));

        expect(_infinity.toNumber(), 4294967296);
      });

      test('Simple pow 2^36', () {
        Infinity _infinity = Infinity.fromNum(2);
        expect(_infinity.toNumber(), 2);

        _infinity = _infinity.pow(Infinity.fromNum(36));

        expect(_infinity.toNumber(), 68719476736);
      });

      test('Simple pow 2^40', () {
        Infinity _infinity = Infinity.fromNum(2);
        expect(_infinity.toNumber(), 2);

        _infinity = _infinity.pow(Infinity.fromNum(40));

        expect(_infinity.toNumber(), 1099511627776);
      });
    });

    test('Complex pow', () {
      Infinity _infinity = Infinity.fromNum(2.1);
      expect(_infinity.toNumber(), 2.1);

      _infinity = _infinity.pow(Infinity.fromNum(24));

      expect(_infinity.toNumber().toStringAsFixed(6), '54108198.377272');
    });

    group('Big powers', () {
      test('Big pow', () {
        Infinity _infinity = Infinity.fromNum(1e13);
        expect(_infinity.toNumber(), 1e13);

        _infinity = _infinity.pow(Infinity.fromNum(10));

        expect(_infinity.toNumber(), 1e130);
      });

      test('Big pow 1e20', () {
        Infinity _infinity = Infinity.fromNum(1e20);
        expect(_infinity.toNumber(), 1e20);

        _infinity = _infinity.pow(Infinity.fromNum(12));

        expect(_infinity.toNumber(), 1e240);
      });
    });

    test('Biggest number pow', () {
      Infinity _infinity = Infinity.fromNum(1e308);
      expect(_infinity.toNumber(), 1e308);

      _infinity = _infinity.pow(Infinity.fromNum(1e100));

      expect(_infinity.toNumber(), double.infinity);
    });

    test('Biggest complex number pow', () {
      Infinity _infinity = Infinity.fromNum(1e70);
      expect(_infinity.toNumber(), 1e70);

      _infinity = _infinity.pow(Infinity.fromNum(4.2));

      expect(_infinity.toNumber(), 1e294);
    });

    test('Infinity pow infinity?', () {
      Infinity _infinity = Infinity.fromNum(1e308);
      expect(_infinity.toNumber(), 1e308);

      _infinity = _infinity.pow(Infinity.fromNum(1e308));

      expect(_infinity.toNumber(), double.infinity);
    });
  });

  group('Tetrate', () {
    test('Small tetrate', () {
      Infinity _infinity = Infinity.fromNum(2);
      expect(_infinity.toNumber(), 2);

      _infinity = _infinity.tetrate(height: 4);
      print('${_infinity.toString()}');

      expect(_infinity.toNumber(), 65536);
    });

    test('Big tetrate', () {
      Infinity _infinity = Infinity.fromNum(2);
      expect(_infinity.toNumber(), 2);

      _infinity = _infinity.tetrate(height: 5);
      print('${_infinity.toString()}');

      expect(_infinity.toNumber(), double.infinity);
    });

    test('Huge tetrate', () {
      Infinity _infinity = Infinity.fromNum(2);
      expect(_infinity.toNumber(), 2);

      _infinity = _infinity.tetrate(height: 6);
      print('${_infinity.toString()}');

      expect(_infinity.toNumber(), double.infinity);
    });

    test('Infinity tetrate', () {
      Infinity _infinity = Infinity.fromNum(1e308);
      expect(_infinity.toNumber(), 1e308);

      _infinity = _infinity.tetrate(height: 1e308);

      expect(_infinity.toNumber(), double.infinity);
      expect(_infinity.toString(), '(e^1e+308)310.48855071650047');
    });
  });

  group('Pentate', () {
    test('Small pentate', () {
      Infinity _infinity = Infinity.fromNum(2);
      expect(_infinity.toNumber(), 2);

      _infinity = _infinity.pentate(height: 3);
      print('${_infinity.toString()}');

      expect(_infinity.toNumber(), 65536);
    });

    test('Weird pentate', () {
      Infinity _infinity = Infinity.fromNum(2.1);
      expect(_infinity.toNumber(), 2.1);

      _infinity = _infinity.pentate(height: 3);
      print('${_infinity.toString()}');

      expect(_infinity.toNumber(), double.infinity);
    });

    test('Big pentate', () {
      Infinity _infinity = Infinity.fromNum(2);
      expect(_infinity.toNumber(), 2);

      _infinity = _infinity.pentate(height: 4);
      print('${_infinity.toString()}');

      expect(_infinity.toNumber(), double.infinity);
    });
  });
//
//  group('Random edge cases', () {
//    test('7 / 100 * 100', () {
//      Infinity _infinity = Infinity.fromNum(7);
//      expect(_infinity.toNumber(), 7);
//
//      _infinity = _infinity / 100 * 100;
//      expect(_infinity.toNumber(), 7);
//    });
//  });
//
//  group('Factorials', () {
//    test('Simple factorials', () {
//      Infinity _infinity = Infinity.fromNum(10);
//      expect(_infinity.toNumber(), 10);
//
//      _infinity = _infinity.factorial();
//      expect(_infinity.toNumber(), 3628800);
//    });
//
//    test('Bigger factorials', () {
//      Infinity _infinity = Infinity.fromNum(25);
//      expect(_infinity.toNumber(), 25);
//
//      _infinity = _infinity.factorial();
//      expect(_infinity.toNumber(), 3628800);
//    });
//  });
}
