extension DateTimeExtension on DateTime {
  DateTime get firstHourOfDay {
    return DateTime(this.year, this.month, this.day, 0, 0, 0);
  }

  DateTime get lastHourOfDay {
    return DateTime(this.year, this.month, this.day, 23, 59, 59);
  }

  DateTime get firstDayOfWeek {
    return this.subtract(Duration(days: this.weekday - 1));
  }

  DateTime get lastDayOfWeek {
    return this.add(Duration(days: DateTime.daysPerWeek - this.weekday));
  }

  DateTime get firstDayOfMonth {
    return DateTime(this.year, this.month, 1);
  }

  DateTime get lastDayOfMonth {
    return (this.month < 12)
        ? new DateTime(this.year, this.month + 1, 0)
        : new DateTime(this.year + 1, 1);
  }
}
