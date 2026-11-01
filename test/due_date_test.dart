import 'package:flutter_test/flutter_test.dart';
import 'package:remindmi/app/helper/due_date.dart';

void main() {
  test('parses 12-hour times', () {
    expect(parseDue('11/1/2026', '3:05 PM'), DateTime(2026, 11, 1, 15, 5));
    expect(parseDue('1/9/2027', '12:30 AM'), DateTime(2027, 1, 9, 0, 30));
    expect(parseDue('1/9/2027', '12:30 PM'), DateTime(2027, 1, 9, 12, 30));
  });

  test('parses narrow no-break space from newer locales', () {
    expect(parseDue('11/1/2026', '7:00 am'), DateTime(2026, 11, 1, 7));
  });

  test('parses 24-hour times', () {
    expect(parseDue('12/31/2026', '23:59'), DateTime(2026, 12, 31, 23, 59));
  });

  test('returns null for unparseable input', () {
    expect(parseDue('', ''), isNull);
    expect(parseDue('2026-11-01', '3:05 PM'), isNull);
  });
}
