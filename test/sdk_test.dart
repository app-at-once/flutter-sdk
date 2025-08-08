import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Basic Tests', () {
    test('basic arithmetic test', () {
      expect(2 + 2, equals(4));
    });

    test('string test', () {
      expect('hello'.toUpperCase(), equals('HELLO'));
    });

    test('list test', () {
      var list = [1, 2, 3];
      expect(list.length, equals(3));
    });
  });
}