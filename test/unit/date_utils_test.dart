import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_asteroid_tracker/utils/date_utils.dart';

void main() {
  group('DateUtils Tests', () {
    test('formatDate should format date string correctly', () {
      final result = DateUtils.formatDate('2024-01-15');
      expect(result, '15 Jan 2024');
    });

    test('formatDate should handle different months', () {
      final result = DateUtils.formatDate('2024-12-25');
      expect(result, '25 Dec 2024');
    });

    test('formatDateTime should format NASA date format correctly', () {
      final result = DateUtils.formatDateTime('2024-Jan-15 10:30');
      expect(result, '15 Jan 2024, 10:30');
    });

    test('formatDateTime should handle different times', () {
      final result = DateUtils.formatDateTime('2024-Dec-25 23:59');
      expect(result, '25 Dec 2024, 23:59');
    });
  });
}
