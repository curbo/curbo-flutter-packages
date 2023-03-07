import 'package:intl/intl.dart' show NumberFormat;

class CurrencyFormat {
  static String format(
    num value, {
    String name = "US \$",
    String locale = 'en_US',
    int limit = 999999,
    bool decimal = true,
  }) {
    final decimalDigits = !decimal
        ? 0
        : _isInteger(value)
            ? 0
            : 2;

    if (value > limit) {
      return NumberFormat.compactSimpleCurrency(
        name: name,
        locale: locale,
        decimalDigits: decimalDigits,
      ).format(value);
    }
    return NumberFormat.simpleCurrency(
      name: name,
      locale: locale,
      decimalDigits: decimalDigits,
    ).format(value);
  }

  static bool _isInteger(num value) =>
      value is int || value == value.roundToDouble();
}
