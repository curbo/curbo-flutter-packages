import 'package:intl/intl.dart' as intl;

class NumberFormat {
  static String format(num value,
      {String locale = 'en_US', int limit = 999999}) {
    if (value > limit) {
      return intl.NumberFormat.compact(locale: locale).format(value);
    }
    return intl.NumberFormat("#,##0", locale).format(value);
  }
}
