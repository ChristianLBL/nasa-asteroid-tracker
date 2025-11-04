import 'package:intl/intl.dart';

class NumberFormatter {
  static String formatDistance(double distance) {
    final formatter = NumberFormat('#,###.##');
    return formatter.format(distance);
  }

  static String formatVelocity(double velocity) {
    final formatter = NumberFormat('#,###.##');
    return formatter.format(velocity);
  }
}
