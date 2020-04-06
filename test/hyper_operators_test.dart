import 'package:infinity/infinity.dart';
import 'package:test/test.dart';

void main() {
  group('Power', () {
    group('Simple powers', () {
      test('Simple pow 2^16', () {
        Infinity _infinity = Infinity.fromNum(2);
        expect(_infinity.toNumber(), 2);

        _infinity = _infinity ^ 16;

        expect(_infinity.toNumber(), 65536);
      });

      test('Simple pow 2^20', () {
        Infinity _infinity = Infinity.fromNum(2);
        expect(_infinity.toNumber(), 2);

        _infinity = _infinity ^ 20;

        expect(_infinity.toNumber(), 1048576);
      });

      test('Simple pow 2^28', () {
        Infinity _infinity = Infinity.fromNum(2);
        expect(_infinity.toNumber(), 2);

        _infinity = _infinity ^ 28;

        expect(_infinity.toNumber(), 268435456);
      });

      test('Complex pow', () {
        Infinity _infinity = Infinity.fromNum(2.1);
        expect(_infinity.toNumber(), 2.1);

        _infinity = _infinity ^ 24;

        expect(_infinity.toNumber().toStringAsFixed(6), '54108198.377272');
      });
    });

    group('Big powers', () {
      test('Big pow', () {
        Infinity _infinity = Infinity.fromNum(1e13);
        expect(_infinity.toNumber(), 1e13);

        _infinity = _infinity ^ 10;

        expect(_infinity.toNumber(), 1e130);
      });

      test('Big pow 1e20', () {
        Infinity _infinity = Infinity.fromNum(1e20);
        expect(_infinity.toNumber(), 1e20);

        _infinity = _infinity ^ 12;

        expect(_infinity.toNumber(), 1e240);
      });
    });

    test('Biggest complex number pow', () {
      Infinity _infinity = Infinity.fromNum(1e70);
      expect(_infinity.toNumber(), 1e70);

      _infinity = _infinity ^ 4.2;

      expect(_infinity.toNumber(), 1e294);
    });

    test('Infinity pow infinity?', () {
      Infinity _infinity = Infinity.fromNum(1e308);
      expect(_infinity.toNumber(), 1e308);

      _infinity = _infinity ^ 1e308;

      expect(_infinity.toNumber(), double.infinity);
    });
  });

  group('Tetrate', () {
    test('Small tetrate', () {
      Infinity _infinity = Infinity.fromNum(2);
      expect(_infinity.toNumber(), 2);

      _infinity = _infinity.tetrate(height: 4);

      expect(_infinity.toNumber(), 65536);
    });

    test('Big tetrate', () {
      Infinity _infinity = Infinity.fromNum(2);
      expect(_infinity.toNumber(), 2);

      _infinity = _infinity.tetrate(height: 5);

      expect(_infinity.toNumber(), double.infinity);
    });

    test('Huge tetrate', () {
      Infinity _infinity = Infinity.fromNum(2);
      expect(_infinity.toNumber(), 2);

      _infinity = _infinity.tetrate(height: 6);

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

      expect(_infinity.toNumber(), 65536);
    });

    test('Weird pentate', () {
      Infinity _infinity = Infinity.fromNum(2.1);
      expect(_infinity.toNumber(), 2.1);

      _infinity = _infinity.pentate(height: 3);

      expect(_infinity.toNumber(), double.infinity);
      expect(_infinity.toString(), 'ee23.598944666302792');
    });

    test('Big pentate', () {
      Infinity _infinity = Infinity.fromNum(2);
      expect(_infinity.toNumber(), 2);

      _infinity = _infinity.pentate(height: 4);

      expect(_infinity.toNumber(), double.infinity);
      expect(_infinity.toString(), '(e^65532.0)19727.780405607016');
    });
  });

  group('Factorials', () {
    test('Simple factorials', () {
      Infinity _infinity = Infinity.fromNum(10);
      expect(_infinity.toNumber(), 10);

      _infinity = _infinity.factorial();
      expect(_infinity.toNumber(), 3628800);
    });

    test('Big factorials', () {
      Infinity _infinity = Infinity.fromNum(14);
      expect(_infinity.toNumber(), 14);

      _infinity = _infinity.factorial();
      expect(_infinity.toNumber(), 87178291200);
    });

    test('Bigger factorials', () {
      Infinity _infinity = Infinity.fromNum(1e2);
      expect(_infinity.toNumber(), 1e2);

      _infinity = _infinity.factorial();
      expect(_infinity.toNumber(), 9.332621544394282e157);
    });

    test('Even bigger factorials', () {
      Infinity _infinity = Infinity.fromNum(1e20);
      expect(_infinity.toNumber(), 1e20);

      _infinity = _infinity.factorial();
      expect(_infinity.toNumber(), double.infinity);
    });

    test('Huge factorials', () {
      Infinity _infinity = Infinity.fromNum(1e308);
      expect(_infinity.toNumber(), 1e308);

      _infinity = _infinity.factorial();
      expect(_infinity.toNumber(), double.infinity);
    });
  });
}
