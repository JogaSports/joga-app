import 'package:flutter_test/flutter_test.dart';
import 'package:joga_sports/core/di/app_services.dart';
import 'package:joga_sports/data/fake/fake_seed.dart';
import 'package:joga_sports/data/models/models.dart';

void main() {
  late AppServices services;

  setUp(() => services = AppServices.fake(latency: Duration.zero));

  test('blocking and unblocking a player', () async {
    final player = FakeSeed.people.first;
    await services.safety.block(player);
    expect(await services.safety.blocked(), contains(player));
    await services.safety.unblock(player);
    expect(await services.safety.blocked(), isEmpty);
  });

  test('reporting a player is accepted', () async {
    await services.safety.report(
      person: FakeSeed.people.first,
      reason: ReportReason.abuse,
      details: 'Shouting at the organiser',
      gameId: FakeSeed.tonightGameId,
    );
  });

  test('every launch city has games to book', () async {
    expect(City.values.map((c) => c.label),
        ['Bristol', 'London', 'Cardiff', 'Nairobi', 'Tbilisi']);
    for (final city in City.values) {
      final games = await services.games.findGames(GameFilter(city: city));
      expect(games, isNotEmpty, reason: city.label);
    }
  });

  test('Nairobi games kick off at 7pm Nairobi time, priced in shillings',
      () async {
    final game = await services.games.getGame('g-401');
    expect(game.city, City.nairobi);
    expect(game.kickOff.hour, 19);
    expect(game.currency, Currency.kes);

    final quote = await services.bookings.quote('g-401');
    expect(quote.currency, Currency.kes);
    expect(quote.gamePence, 50000);
    expect(quote.feePence, City.nairobi.bookingFeeMinor);
    expect(quote.walletAvailablePence, 0,
        reason: 'the wallet holds pounds, so it is UK only for now');
  });

  test('the price filter uses each city\'s own amount', () async {
    for (final city in City.values) {
      final cheap = await services.games.findGames(
        GameFilter(city: city, maxPricePence: city.underPriceMinor - 1),
      );
      for (final g in cheap) {
        expect(g.pricePence, lessThan(city.underPriceMinor), reason: g.id);
      }
    }
  });

  test('inclusive filters find games', () async {
    for (final tag in [GameTag.beginner, GameTag.womens, GameTag.walking]) {
      final found = <Game>[];
      for (final city in City.values) {
        found.addAll(
          await services.games.findGames(GameFilter(city: city, tag: tag)),
        );
      }
      expect(found, isNotEmpty, reason: tag.label);
    }
  });

  test('impact dashboard covers every town and adds up', () async {
    final data = await services.impact.dashboard(ImpactPeriod.month);
    expect(data.towns.map((t) => t.city).toSet(), City.values.toSet());
    expect(data.sessions.fold<int>(0, (sum, s) => sum + s.percent), 100);
    expect(data.monthlyActive, hasLength(6));
  });
}
