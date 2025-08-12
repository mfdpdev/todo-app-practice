import 'package:intl/intl.dart';

bool isSameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

List<DateTime> getWeekDates(DateTime startOfWeek) {
  return List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
}

DateTime getWeekStart(int weekOffset) {
  final now = DateTime.now();
  final weekday = now.weekday;
  final monday = now.subtract(Duration(days: weekday - 1));
  return monday.add(Duration(days: 7 * weekOffset));
}
