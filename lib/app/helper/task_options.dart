// Minutes before the due time for the early reminder; 0 = only at due time
const remindBeforeOptions = {
  0: 'Remind at due time',
  5: 'Remind 5 min before',
  15: 'Remind 15 min before',
  30: 'Remind 30 min before',
  60: 'Remind 1 hour before',
};

const repeatOptions = {
  'none': 'Does not repeat',
  'daily': 'Repeats every day',
  'everyOtherDay': 'Repeats every 2 days',
  'weekdays': 'Repeats on weekdays',
  'weekly': 'Repeats every week',
  'asNeeded': 'Whenever it\'s needed (no due time)',
};

const takeTurnsOptions = {
  false: 'Everyone assigned does it',
  true: 'Take turns',
};

const repeatShortLabels = {
  'daily': 'Daily',
  'everyOtherDay': 'Every 2 days',
  'weekdays': 'Weekdays',
  'weekly': 'Weekly',
  'asNeeded': 'As needed',
};

bool isRepeating(String repeat) => repeatShortLabels.containsKey(repeat);

// Scheduled repeats move their due date forward; 'asNeeded' has none.
bool hasSchedule(String repeat) => isRepeating(repeat) && repeat != 'asNeeded';

// The first occurrence of a repeating task after `now`, keeping its time of
// day. Missed occurrences are skipped rather than piling up.
DateTime nextOccurrence(DateTime due, String repeat, DateTime now) {
  var next = due;
  do {
    // Building from y/m/d (not adding a Duration) keeps the wall-clock time
    // the same across daylight-saving changes.
    final step = switch (repeat) {
      'weekly' => 7,
      'everyOtherDay' => 2,
      _ => 1,
    };
    next = DateTime(
      next.year,
      next.month,
      next.day + step,
      next.hour,
      next.minute,
    );
    if (repeat == 'weekdays') {
      while (next.weekday == DateTime.saturday ||
          next.weekday == DateTime.sunday) {
        next = DateTime(
          next.year,
          next.month,
          next.day + 1,
          next.hour,
          next.minute,
        );
      }
    }
  } while (!next.isAfter(now));
  return next;
}

// Same format the date picker writes into tasks: 'M/D/YYYY'
String formatTaskDate(DateTime date) =>
    '${date.month}/${date.day}/${date.year}';
