import 'package:intl/intl.dart';

class DateUtils {
  static String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatDateTime(String dateTimeString) {
    // Handle NASA's date format: "2015-Sep-08 20:28"
    final dateFormat = DateFormat('yyyy-MMM-dd HH:mm');
    final date = dateFormat.parse(dateTimeString);
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }
}
