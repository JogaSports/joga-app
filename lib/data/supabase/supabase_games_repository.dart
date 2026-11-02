import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';
import '../repositories/games_repository.dart';
import 'db.dart';

/// Games from the `game_listing` view, with the players on each game loaded
/// for the whole list in one call (`game_players_for`).
class SupabaseGamesRepository implements GamesRepository {
  SupabaseGamesRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Game>> findGames(GameFilter filter) => guard(() async {
        var query = _client
            .from('game_listing')
            .select()
            .eq('city_id', dbName(filter.city))
            .eq('status', 'scheduled')
            .gt('starts_at', DateTime.now().toUtc().toIso8601String());
        if (filter.format case final format?) {
          query = query.eq('format', dbName(format));
        }
        if (filter.tag case final tag?) {
          query = query.contains('tags', [dbName(tag)]);
        }
        if (filter.maxPricePence case final max?) {
          query = query.lte('price_pence', max);
        }
        final result = await query.order('starts_at', ascending: true).limit(100);

        // "Tonight", "Tomorrow" and "Weekend" on the city's own clock.
        final cityNow = filter.city.clockNow();
        final today = DateTime.utc(cityNow.year, cityNow.month, cityNow.day);
        bool matchesDay(DateTime startsAt) {
          final d = filter.city.wallClock(startsAt);
          final diff = DateTime.utc(d.year, d.month, d.day).difference(today).inDays;
          return switch (filter.day) {
            DayFilter.all => true,
            DayFilter.today => diff == 0,
            DayFilter.tomorrow => diff == 1,
            DayFilter.weekend =>
              d.weekday == DateTime.saturday || d.weekday == DateTime.sunday,
          };
        }

        final listing = rows(result)
            .where((r) => matchesDay(parseTime(r['starts_at'])))
            .toList();
        return _withPlayers(listing);
      });

  @override
  Future<List<Game>> recommendedFor(String playerId) => guard(() async {
        final result = await _client.rpc<dynamic>('recommended_games', params: {'p_limit': 3});
        return _withPlayers(rows(result));
      });

  @override
  Future<Game> getGame(String gameId) => guard(() async {
        final row = await _client.from('game_listing').select().eq('id', gameId).maybeSingle();
        if (row == null) throw StateError('This game no longer exists.');
        return (await _withPlayers([row])).single;
      });

  @override
  Future<List<Game>> upcomingFor(String playerId) => guard(() async {
        final result = await _client.rpc<dynamic>('my_upcoming_games');
        return _withPlayers(rows(result));
      });

  /// Turns listing rows into [Game]s, adding who's playing on each.
  Future<List<Game>> _withPlayers(List<Map<String, dynamic>> listing) async {
    if (listing.isEmpty) return const [];
    final ids = [for (final r in listing) r['id'] as String];
    final result = await _client.rpc<dynamic>('game_players_for', params: {'p_games': ids});
    final players = <String, List<Person>>{};
    for (final p in rows(result)) {
      players.putIfAbsent(p['game_id'] as String, () => []).add(
            Person(
              id: p['player_id'] as String,
              firstName: (p['first_name'] as String?) ?? '',
              lastName: (p['last_initial'] as String?) ?? '',
            ),
          );
    }
    return [
      for (final r in listing)
        if (gameFromRow(r, players[r['id']] ?? const []) case final game?) game,
    ];
  }
}

/// A `game_listing` row -> [Game]. Null for a sport, format or city this
/// version of the app doesn't know (so a newer backend can't crash it).
Game? gameFromRow(Map<String, dynamic> r, List<Person> players) {
  final city = fromDb(City.values, r['city_id']);
  final format = fromDb(GameFormat.values, r['format']);
  if (city == null || format == null) return null;
  return Game(
    id: r['id'] as String,
    format: format,
    venue: Venue(
      id: r['venue_id'] as String,
      name: r['venue_name'] as String,
      city: city,
      address: (r['address'] as String?) ?? '',
      surface: (r['surface'] as String?) ?? '',
      parking: (r['parking'] as String?) ?? '',
      facilities: listFromDb(VenueFacility.values, r['facilities']),
    ),
    pitch: (r['pitch'] as String?) ?? '',
    startsAt: parseTime(r['starts_at']),
    duration: Duration(minutes: asInt(r['duration_minutes'])),
    tags: listFromDb(GameTag.values, r['tags']),
    pricePence: asInt(r['price_pence']),
    players: players,
    organiser: Person(
      id: r['organiser_id'] as String,
      firstName: (r['organiser_first_name'] as String?) ?? '',
      lastName: (r['organiser_last_initial'] as String?) ?? '',
    ),
    organiserGamesRun: asInt(r['organiser_games_run']),
  );
}
