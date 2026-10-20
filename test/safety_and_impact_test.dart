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

  test('every town in Wales has games to book', () async {
    for (final city in City.values.where((c) => c.inWales)) {
      final games = await services.games.findGames(GameFilter(city: city));
      expect(games, isNotEmpty, reason: city.label);
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
