import 'package:flutter_test/flutter_test.dart';
import 'package:joga_sports/core/l10n/l10n.dart';
import 'package:joga_sports/data/models/models.dart';

void main() {
  final en = LanguageScope.stringsFor(AppLanguage.english);
  final cy = LanguageScope.stringsFor(AppLanguage.welsh);

  test('both languages have the same number of list items', () {
    expect(cy.welcomeSlides.length, en.welcomeSlides.length);
    expect(cy.conductRules.length, en.conductRules.length);
    expect(cy.weekdaysShort.length, 7);
    expect(cy.monthsShort.length, 12);
  });

  test('Welsh is really Welsh', () {
    expect(cy.tabHome, 'Hafan');
    expect(cy.city(City.cardiff), 'Caerdydd');
    expect(cy.continueWithApple, 'Parhau gydag Apple');
    expect(en.continueWithApple, 'Continue with Apple');
  });

  test('dates use the right language', () {
    final now = DateTime(2026, 10, 6, 12); // a Tuesday
    expect(en.relativeDay(DateTime(2026, 10, 6, 19), now: now), 'Tonight');
    expect(cy.relativeDay(DateTime(2026, 10, 6, 19), now: now), 'Heno');
    expect(cy.relativeDay(DateTime(2026, 10, 9, 19), now: now), 'Gwe');
    expect(cy.shortDate(DateTime(2026, 10, 9)), 'Gwe 9 Hyd');
  });
}
