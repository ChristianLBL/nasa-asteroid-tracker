import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_asteroid_tracker/utils/number_formatter.dart';

void main() {
  group('NumberFormatter Tests', () {
    test('formatDistance should format large numbers with commas', () {
      expect(NumberFormatter.formatDistance(1234567.89), '1,234,567.89');
    });

    test('formatDistance should format small numbers correctly', () {
      expect(NumberFormatter.formatDistance(123.45), '123.45');
    });

    test('formatDistance should handle zero', () {
      expect(NumberFormatter.formatDistance(0), '0');
    });

    test('formatVelocity should format large numbers with commas', () {
      expect(NumberFormatter.formatVelocity(54000.5), '54,000.5');
    });

    test('formatVelocity should format small numbers correctly', () {
      expect(NumberFormatter.formatVelocity(100.25), '100.25');
    });

    test('formatVelocity should handle integers', () {
      expect(NumberFormatter.formatVelocity(1000), '1,000');
    });
  });
}
