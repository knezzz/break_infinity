import 'package:infinity/infinity.dart';
import 'package:test/test.dart';

void main() {
  group('Antimatter dimensions discord', () {
    test('Big power disscusion w/o brackets', () {
      Infinity _infinity = Infinity.fromNum(2);
      _infinity = _infinity ^ Infinity.fromNum(16) ^ Infinity.fromNum(4);

      expect(_infinity.toNumber(), 18446744073709560000.0);
    });

    test('Big power disscusion w brackets', () {
      Infinity _infinity = Infinity.fromNum(2);
      _infinity = _infinity ^ (Infinity.fromNum(16) ^ Infinity.fromNum(4));

      expect(_infinity.toNumber(), double.infinity);
      expect(_infinity.toString(), '2.0035299304076943e19728');
    });
  });
}
