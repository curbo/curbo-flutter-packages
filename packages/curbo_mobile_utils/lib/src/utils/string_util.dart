import 'package:intl/intl.dart';

extension StringExtension on String {
  bool get isNullOrEmpty => this.isEmpty;

  bool get isNotNullOrNotEmpty => !this.isNullOrEmpty;

  String get capitalize {
    if (this.isEmpty) {
      return this;
    }

    return this[0].toUpperCase() + this.substring(1);
  }

  DateTime toDateTime(String pattern) => DateFormat(pattern).parse(this);

  int toInt() => int.tryParse(this) ?? 0;

  bool isRequired() => (this.isNotEmpty);

  bool isValidName({bool split = true}) {
    if (this.isEmpty) return false;

    final RegExp regex = RegExp(r"^[a-zA-ZáéíñóúüÁÉÍÑÓÚÜ.'-]+");

    if (split) {
      final words = this.split(" ");

      if (words.length < 2) return false;

      for (var w in words) {
        if (w.length < 2) return false;

        return regex.hasMatch(w);
      }

      return true;
    }

    return regex.hasMatch(this);
  }

  bool isValidPassword({minLength = 6}) {
    return (this.isNotEmpty && this.length >= minLength);
  }

  bool isPhoneNumber() {
    if (this.isEmpty) return false;

    RegExp regex =
        new RegExp(r'^[+]*[1-9]{1,2}[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');

    return regex.hasMatch(this);
  }

  bool isEmail() {
    if (this.isEmpty) return false;

    RegExp regex = new RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    return regex.hasMatch(this);
  }

  bool isUrl() {
    if (this.isEmpty) return false;

    RegExp regex = new RegExp(
        r"^(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#[\]@!\$&'\(\)\*\+,;=.]+$");

    return regex.hasMatch(this);
  }

  bool isDominicanDNI() {
    if (this.isEmpty) return false;

    RegExp regex = new RegExp(r'^[0-9]{3}-[0-9]{7}-[0-9]{1}$');

    return regex.hasMatch(this);
  }
}
