import '../../data/models/enums.dart';

/// Formatting helpers for money, dates and durations.
///
/// Kept dependency-free on purpose. Swap for `intl` if localisation is
/// needed later.
abstract final class Format {
  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _longDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// 800 -> "£8.00", 50000 (KES) -> "KSh 500", 1550 (GEL) -> "15.50 ₾".
  /// Amounts are in the currency's minor unit; pounds unless [currency]
  /// says otherwise.
  static String money(int minor, [Currency currency = Currency.gbp]) {
    final sign = minor < 0 ? '−' : '';
    final abs = minor.abs();
    final whole = count(abs ~/ 100);
    final rem = abs % 100;
    final number = currency.showMinor || rem != 0
        ? '$whole.${rem.toString().padLeft(2, '0')}'
        : whole;
    return '$sign${currency.prefix}$number${currency.suffix}';
  }

  /// 800 -> "£8", 650 -> "£6.50", 50000 (KES) -> "KSh 500"
  static String moneyShort(int minor, [Currency currency = Currency.gbp]) {
    if (minor % 100 != 0) return money(minor, currency);
    final sign = minor < 0 ? '−' : '';
    return '$sign${currency.prefix}${count(minor.abs() ~/ 100)}${currency.suffix}';
  }

  /// 250 -> "+£2.50", -800 -> "−£8.00"
  static String moneySigned(int minor, [Currency currency = Currency.gbp]) =>
      minor >= 0 ? '+${money(minor, currency)}' : money(minor, currency);

  /// 1284 -> "1,284"
  static String count(int n) {
    final digits = n.abs().toString();
    final out = StringBuffer(n < 0 ? '−' : '');
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) out.write(',');
      out.write(digits[i]);
    }
    return out.toString();
  }

  /// 19:30
  static String time(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  /// Tue
  static String weekday(DateTime d) => _days[d.weekday - 1];

  /// Tuesday
  static String weekdayLong(DateTime d) => _longDays[d.weekday - 1];

  /// 7 Oct
  static String dayMonth(DateTime d) => '${d.day} ${_months[d.month - 1]}';

  /// Tue 7 Oct
  static String shortDate(DateTime d) => '${weekday(d)} ${dayMonth(d)}';

  /// "Tonight", "Tomorrow", or "Thu".
  static String relativeDay(DateTime d, {DateTime? now}) {
    final today = _dateOnly(now ?? DateTime.now());
    final diff = _dateOnly(d).difference(today).inDays;
    if (diff == 0) return 'Tonight';
    if (diff == 1) return 'Tomorrow';
    return weekday(d);
  }

  /// "2 days to go", "Today"
  static String daysToGo(DateTime d, {DateTime? now}) {
    final today = _dateOnly(now ?? DateTime.now());
    final diff = _dateOnly(d).difference(today).inDays;
    if (diff <= 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    return '$diff days to go';
  }

  /// 4:59
  static String minutesSeconds(Duration d) {
    final s = d.inSeconds.clamp(0, 359999);
    return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
  }

  /// 01 : 24 : 36
  static String countdown(Duration d) {
    final s = d.isNegative ? 0 : d.inSeconds;
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(s ~/ 3600)} : ${two((s % 3600) ~/ 60)} : ${two(s % 60)}';
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
