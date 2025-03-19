import 'dart:collection';

import 'package:flutter/cupertino.dart';

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

final today = DateTime.now();
final firstDay = DateTime(today.year - 10, today.month, today.day);
final lastDay = DateTime(today.year + 10, today.month, today.day);

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = {
  for (var item in List.generate(50, (index) => index)) DateTime.utc(firstDay.year, firstDay.month, item * 5): List.generate(item % 4 + 1, (index) => Event('Event $item | ${index + 1}'))
}..addAll({
    today: [
      const Event('Today\'s Event 1'),
      const Event('Today\'s Event 2'),
      const Event('Today\'s Event 3'),
      const Event('Today\'s Event 4'),
      const Event('Today\'s Event 5'),
      const Event('Today\'s Event 6'),
      const Event('Today\'s Event 7'),
      const Event('Today\'s Event 8'),
      const Event('Today\'s Event 9'),
      const Event('Today\'s Event 10'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}





/////////
enum CalendarFormat { month, twoWeeks, week }

typedef DayBuilder = Widget? Function(BuildContext context, DateTime day);

/// Signature for a function that creates a widget for a given `day`.
/// Additionally, contains the currently focused day.
typedef FocusedDayBuilder = Widget? Function(
    BuildContext context, DateTime day, DateTime focusedDay);

/// Signature for a function returning text that can be localized and formatted with `DateFormat`.
typedef TextFormatter = String Function(DateTime date, dynamic locale);

/// Gestures available for the calendar.
enum AvailableGestures { none, verticalSwipe, horizontalSwipe, all }

/// Days of the week that the calendar can start with.
enum StartingDayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

/// Returns a numerical value associated with given `weekday`.
///
/// Returns 1 for `StartingDayOfWeek.monday`, all the way to 7 for `StartingDayOfWeek.sunday`.
int getWeekdayNumber(StartingDayOfWeek weekday) {
  return StartingDayOfWeek.values.indexOf(weekday) + 1;
}

/// Returns `date` in UTC format, without its time part.
DateTime normalizeDate(DateTime date) {
  return DateTime.utc(date.year, date.month, date.day);
}

/// Checks if two DateTime objects are the same day.
/// Returns `false` if either of them is null.
bool isSameDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return false;
  }

  return a.year == b.year && a.month == b.month && a.day == b.day;
}
