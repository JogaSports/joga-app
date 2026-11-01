// Shared enums for the domain.

/// Sports on the platform. Football launches first; the others are designed
/// in from the start so the data model never assumes football.
enum Sport {
  football('Football', isLive: true),
  padel('Padel', isLive: false),
  badminton('Badminton', isLive: false);

  const Sport(this.label, {required this.isLive});
  final String label;
  final bool isLive;
}

/// Currencies game prices are charged in. Amounts are always stored in the
/// minor unit (pence, Kenyan cents, tetri), like the backend.
enum Currency {
  gbp('GBP', prefix: '£', showMinor: true),
  kes('KES', prefix: 'KSh '),
  gel('GEL', suffix: ' ₾');

  const Currency(
    this.code, {
    this.prefix = '',
    this.suffix = '',
    this.showMinor = false,
  });

  /// ISO 4217 code, as stored in the backend's `cities.currency`.
  final String code;
  final String prefix;
  final String suffix;

  /// Always show the minor unit (£8.00). Shillings and lari only show it
  /// when it isn't zero (KSh 500, 15 ₾, 15.50 ₾).
  final bool showMinor;
}

/// Cities with games, in the order the app lists them. Matches the
/// backend's `cities` table (id, country, timezone, currency, sort order).
enum City {
  bristol(
    'Bristol',
    countryCode: 'GB',
    timezone: 'Europe/London',
    currency: Currency.gbp,
    bookingFeeMinor: 100,
    underPriceMinor: 700,
  ),
  london(
    'London',
    countryCode: 'GB',
    timezone: 'Europe/London',
    currency: Currency.gbp,
    bookingFeeMinor: 100,
    underPriceMinor: 900,
  ),
  cardiff(
    'Cardiff',
    countryCode: 'GB',
    timezone: 'Europe/London',
    currency: Currency.gbp,
    bookingFeeMinor: 100,
    underPriceMinor: 700,
  ),
  nairobi(
    'Nairobi',
    countryCode: 'KE',
    timezone: 'Africa/Nairobi',
    currency: Currency.kes,
    bookingFeeMinor: 10000,
    underPriceMinor: 50000,
  ),
  tbilisi(
    'Tbilisi',
    countryCode: 'GE',
    timezone: 'Asia/Tbilisi',
    currency: Currency.gel,
    bookingFeeMinor: 200,
    underPriceMinor: 1500,
  );

  const City(
    this.label, {
    required this.countryCode,
    required this.timezone,
    required this.currency,
    required this.bookingFeeMinor,
    required this.underPriceMinor,
  });

  final String label;

  /// ISO 3166 code: GB, KE, GE.
  final String countryCode;

  /// IANA timezone, as stored in the backend.
  final String timezone;
  final Currency currency;

  /// Booking fee in this city's currency (minor units). PLACEHOLDER for
  /// Nairobi and Tbilisi until the PO decides how money works outside the
  /// UK (backend docs/DECISIONS-NEEDED.md).
  final int bookingFeeMinor;

  /// The Find screen's "Under …" price filter for this city.
  final int underPriceMinor;

  bool get isUk => countryCode == 'GB';

  /// The wallet holds pounds, so wallet credit only applies to UK games
  /// for now.
  bool get usesWallet => currency == Currency.gbp;

  /// UTC offset for this city at [instant].
  ///
  /// No timezone package needed: Nairobi (UTC+3) and Tbilisi (UTC+4) don't
  /// change their clocks, and the UK follows one fixed rule (BST from 01:00
  /// UTC on the last Sunday of March to 01:00 UTC on the last Sunday of
  /// October).
  Duration utcOffsetAt(DateTime instant) {
    switch (timezone) {
      case 'Africa/Nairobi':
        return const Duration(hours: 3);
      case 'Asia/Tbilisi':
        return const Duration(hours: 4);
      default:
        final utc = instant.toUtc();
        final bstStarts = _lastSundayOneAm(utc.year, DateTime.march);
        final bstEnds = _lastSundayOneAm(utc.year, DateTime.october);
        final isBst = !utc.isBefore(bstStarts) && utc.isBefore(bstEnds);
        return Duration(hours: isBst ? 1 : 0);
    }
  }

  /// [instant] as the time on a clock in this city. Read its fields
  /// (hour, day, weekday…) for display; don't compare it with real
  /// instants.
  DateTime wallClock(DateTime instant) {
    final utc = instant.toUtc();
    return utc.add(utcOffsetAt(utc));
  }

  /// What a clock in this city shows right now.
  DateTime clockNow() => wallClock(DateTime.now());

  /// The instant when this city's clocks show the given date and time.
  DateTime instantAt(int year, int month, int day,
      [int hour = 0, int minute = 0]) {
    final asIfUtc = DateTime.utc(year, month, day, hour, minute);
    return asIfUtc.subtract(utcOffsetAt(asIfUtc));
  }

  static DateTime _lastSundayOneAm(int year, int month) {
    final lastDay = DateTime.utc(year, month + 1, 0);
    return DateTime.utc(
        year, month, lastDay.day - (lastDay.weekday % 7), 1);
  }
}

/// Game formats. Capacity is total players across both teams.
enum GameFormat {
  fiveASide('5-a-side', Sport.football, 10),
  sevenASide('7-a-side', Sport.football, 14);

  const GameFormat(this.label, this.sport, this.capacity);
  final String label;
  final Sport sport;
  final int capacity;
}

/// Tags that help players find the right game. Joga is recreational
/// football, so there are no ability levels; "Beginner-friendly" marks
/// games that suit people new to playing or coming back to it.
enum GameTag {
  beginner('Beginner-friendly'),
  womens("Women's"),
  mixed('Mixed'),
  walking('Walking football'),
  casual('Casual');

  const GameTag(this.label);
  final String label;
}

enum UserRole { player, organiser, admin }

enum Team {
  white('White'),
  orange('Orange');

  const Team(this.label);
  final String label;
}

enum PlayerPosition {
  goalkeeper('Goalkeeper'),
  defender('Defender'),
  midfielder('Midfielder'),
  winger('Winger'),
  striker('Striker');

  const PlayerPosition(this.label);
  final String label;
}

enum PreferredFoot {
  left('Left'),
  right('Right'),
  both('Both');

  const PreferredFoot(this.label);
  final String label;
}

/// What a venue has on site. Shown on game details so players know about
/// access and safety before they book.
enum VenueFacility {
  stepFree('Step-free access'),
  accessibleToilet('Accessible toilet'),
  changingRooms('Changing rooms'),
  defibrillator('Defibrillator on site'),
  firstAid('First aid kit'),
  floodlights('Floodlit'),
  parking('Parking');

  const VenueFacility(this.label);
  final String label;
}
