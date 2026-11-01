import 'package:flutter_test/flutter_test.dart';
import 'package:joga_sports/core/utils/formatters.dart';
import 'package:joga_sports/data/models/enums.dart';

void main() {
  group('Format.money', () {
    test('formats pence as pounds', () {
      expect(Format.money(800), '£8.00');
      expect(Format.money(650), '£6.50');
      expect(Format.money(-250), '−£2.50');
      expect(Format.money(128400), '£1,284.00');
    });

    test('short form drops .00', () {
      expect(Format.moneyShort(800), '£8');
      expect(Format.moneyShort(650), '£6.50');
      expect(Format.moneyShort(150000), '£1,500');
    });

    test('count adds thousands separators', () {
      expect(Format.count(7), '7');
      expect(Format.count(1284), '1,284');
      expect(Format.count(1234567), '1,234,567');
    });

    test('signed form', () {
      expect(Format.moneySigned(250), '+£2.50');
      expect(Format.moneySigned(-800), '−£8.00');
    });
  });

  group('Format dates', () {
    final now = DateTime(2026, 10, 6, 12); // a Tuesday

    test('relative day', () {
      expect(
          Format.relativeDay(DateTime(2026, 10, 6, 19), now: now), 'Tonight');
      expect(
          Format.relativeDay(DateTime(2026, 10, 7, 19), now: now), 'Tomorrow');
      expect(Format.relativeDay(DateTime(2026, 10, 9, 19), now: now), 'Fri');
    });

    test('countdown', () {
      expect(
        Format.countdown(const Duration(hours: 1, minutes: 24, seconds: 36)),
        '01 : 24 : 36',
      );
      expect(Format.countdown(const Duration(seconds: -5)), '00 : 00 : 00');
    });
  });

  group('Money in other currencies', () {
    test('Kenyan shillings drop zero cents', () {
      expect(Format.money(50000, Currency.kes), 'KSh 500');
      expect(Format.money(400000, Currency.kes), 'KSh 4,000');
      expect(Format.money(50050, Currency.kes), 'KSh 500.50');
    });

    test('Georgian lari go after the number', () {
      expect(Format.money(1500, Currency.gel), '15 ₾');
      expect(Format.money(1550, Currency.gel), '15.50 ₾');
      expect(Format.moneyShort(1500, Currency.gel), '15 ₾');
    });
  });

  group('City clocks', () {
    test('Nairobi and Tbilisi are UTC+3 and UTC+4 all year', () {
      final winter = DateTime.utc(2026, 1, 15, 16);
      final summer = DateTime.utc(2026, 7, 15, 16);
      expect(City.nairobi.wallClock(winter).hour, 19);
      expect(City.nairobi.wallClock(summer).hour, 19);
      expect(City.tbilisi.wallClock(winter).hour, 20);
      expect(City.tbilisi.wallClock(summer).hour, 20);
    });

    test('UK switches between GMT and BST on the right Sundays', () {
      // 2026: BST from 29 March 01:00 UTC to 25 October 01:00 UTC.
      expect(City.london.wallClock(DateTime.utc(2026, 3, 29, 0, 59)).hour, 0);
      expect(City.london.wallClock(DateTime.utc(2026, 3, 29, 1)).hour, 2);
      expect(City.london.wallClock(DateTime.utc(2026, 10, 25, 0, 59)).hour, 1);
      expect(City.london.wallClock(DateTime.utc(2026, 10, 25, 1)).hour, 1);
      expect(City.cardiff.wallClock(DateTime.utc(2026, 7, 1, 18)).hour, 19);
      expect(City.bristol.wallClock(DateTime.utc(2026, 12, 1, 19)).hour, 19);
    });

    test('a 7pm Nairobi kick-off reads 7pm in Nairobi', () {
      final kickOff = City.nairobi.instantAt(2026, 11, 5, 19);
      expect(kickOff, DateTime.utc(2026, 11, 5, 16));
      expect(Format.time(City.nairobi.wallClock(kickOff)), '19:00');
      expect(Format.time(City.london.wallClock(kickOff)), '16:00');
    });
  });
}
