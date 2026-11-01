// Tasks store their due date as display strings: date as 'M/D/YYYY' (from the
// date picker) and time from TimeOfDay.format(), which is locale dependent —
// '3:05 PM', '3:05 PM' or '15:05'. New tasks also store an exact 'dueAt'
// timestamp; this parser covers tasks saved before that field existed.
DateTime? parseDue(String date, String time) {
  final d = RegExp(r'^\s*(\d{1,2})/(\d{1,2})/(\d{4})\s*$').firstMatch(date);
  final t = RegExp(
    r'^\s*(\d{1,2}):(\d{2})\s*([AaPp][Mm])?\s*$',
  ).firstMatch(time.replaceAll(RegExp(r'[  ]'), ' '));
  if (d == null || t == null) return null;

  var hour = int.parse(t.group(1)!);
  final minute = int.parse(t.group(2)!);
  final meridiem = t.group(3)?.toUpperCase();
  if (meridiem == 'PM' && hour != 12) hour += 12;
  if (meridiem == 'AM' && hour == 12) hour = 0;

  return DateTime(
    int.parse(d.group(3)!),
    int.parse(d.group(1)!),
    int.parse(d.group(2)!),
    hour,
    minute,
  );
}
