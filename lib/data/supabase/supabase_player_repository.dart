import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/formatters.dart';
import '../models/models.dart';
import '../repositories/player_repository.dart';
import 'db.dart';

/// The signed-in player: profile, Home summary, stats, streak, results.
class SupabasePlayerRepository implements PlayerRepository {
  SupabasePlayerRepository(this._client);

  final SupabaseClient _client;

  String get _uid {
    final id = _client.auth.currentUser?.id;
    if (id == null) throw StateError('Please sign in again.');
    return id;
  }

  @override
  Future<Player> currentPlayer() => guard(() async {
        final uid = _uid;
        final results = await Future.wait<dynamic>([
          _client
              .from('profiles')
              .select('id, first_name, last_name, city_id, position, foot, role, created_at')
              .eq('id', uid)
              .single(),
          _client.rpc<dynamic>('is_member'),
          _client.rpc<dynamic>('my_reliability'),
        ]);
        final p = results[0] as Map<String, dynamic>;
        return Player(
          person: Person(
            id: uid,
            firstName: (p['first_name'] as String?) ?? '',
            lastName: (p['last_name'] as String?) ?? '',
          ),
          city: fromDb(City.values, p['city_id']) ?? City.london,
          position: fromDb(PlayerPosition.values, p['position']) ?? PlayerPosition.midfielder,
          foot: fromDb(PreferredFoot.values, p['foot']) ?? PreferredFoot.right,
          memberSince: parseTime(p['created_at']),
          isMember: results[1] == true,
          role: fromDb(UserRole.values, p['role']) ?? UserRole.player,
          reliabilityPercent: asInt(results[2]),
        );
      });

  @override
  Future<HomeSummary> homeSummary() => guard(() async {
        final results = await Future.wait<Object>([
          _stats(StatsPeriod.season),
          _streak(),
          _results(limit: 1),
        ]);
        final recent = results[2] as List<MatchResult>;
        return HomeSummary(
          stats: results[0] as PlayerStats,
          streak: results[1] as Streak,
          lastResult: recent.isEmpty ? null : recent.first,
        );
      });

  @override
  Future<PlayerStats> stats(StatsPeriod period) => guard(() => _stats(period));

  @override
  Future<Streak> streak() => guard(_streak);

  @override
  Future<List<MatchResult>> recentResults() => guard(() => _results(limit: 20));

  @override
  Future<PostGameSummary> postGame(String gameId) => guard(() async {
        final all = await _results(limit: 50);
        final result = all.where((r) => r.gameId == gameId).firstOrNull;
        if (result == null) throw StateError('No result for this game yet.');

        final results = await Future.wait<Object>([
          _streak(),
          _client
              .from('player_rewards')
              .select('credit_pence, reward_rules(label)')
              .eq('player_id', _uid)
              .eq('game_id', gameId),
          _nextGamesMilestone(),
        ]);
        final streak = results[0] as Streak;
        return PostGameSummary(
          result: result,
          streakWeeks: streak.currentWeeks,
          unlocked: [
            for (final r in rows(results[1]))
              Reward(
                title: ((r['reward_rules'] as Map<String, dynamic>?)?['label'] as String?) ??
                    'Reward unlocked',
                subtitle: 'Unlocked by this game',
                creditPence: asInt(r['credit_pence']) > 0 ? asInt(r['credit_pence']) : null,
              ),
          ],
          nextMilestone: results[2] as Milestone,
        );
      });

  /// Roles are given by an admin in the real app; the role switch is a demo
  /// tool only.
  @override
  Future<void> setRole(UserRole role) async =>
      throw StateError('Roles are set by an admin.');

  // ---- Internals ----------------------------------------------------------------

  Future<PlayerStats> _stats(StatsPeriod period) async {
    final results = await Future.wait<dynamic>([
      _client.rpc<dynamic>('player_stats', params: {'p_player': _uid, 'p_period': period.name}),
      _client.rpc<dynamic>('my_form', params: {'p_limit': 10}),
      _client.rpc<dynamic>('my_member_stats'),
    ]);
    final totals = firstRow(results[0]) ?? const {};
    final deeper = firstRow(results[2]) ?? const {};
    return PlayerStats(
      period: period,
      games: asInt(totals['games']),
      goals: asInt(totals['goals']),
      assists: asInt(totals['assists']),
      potm: asInt(totals['potm']),
      wins: asInt(totals['wins']),
      form: [
        for (final f in rows(results[1]))
          FormEntry(goals: asInt(f['goals']), assists: asInt(f['assists']), won: f['won'] == true),
      ],
      bestVenue: (deeper['best_venue'] as String?) ?? '–',
      cityRank: asInt(deeper['city_rank']),
    );
  }

  Future<Streak> _streak() async {
    final s = firstRow(await _client.rpc<dynamic>('my_streak')) ?? const {};
    final current = asInt(s['current_weeks']);
    final nextWeeks = s['next_reward_weeks'] == null ? null : asInt(s['next_reward_weeks']);
    final nextPence = asInt(s['next_reward_pence']);
    final last12 = [for (final w in (s['last_12'] as List<dynamic>?) ?? const []) w == true];
    return Streak(
      currentWeeks: current,
      bestWeeks: asInt(s['best_weeks']),
      lastTwelveWeeks: last12.length == 12 ? last12 : List.filled(12, false),
      playedThisWeek: s['played_this_week'] == true,
      // Streak weeks run on UK time (the backend's app_settings.timezone).
      weekEndsAt: s['week_ends_at'] == null
          ? DateTime.now()
          : City.london.wallClock(parseTime(s['week_ends_at'])),
      nextReward: Milestone(
        title: '${nextWeeks ?? current + 1}-week streak',
        progress: current,
        target: nextWeeks ?? current + 1,
        rewardLabel: nextPence > 0 ? '${Format.money(nextPence)} wallet credit' : 'Keep it going',
        isStreak: true,
      ),
      freezesLeft: asInt(s['freezes_left']),
    );
  }

  Future<List<MatchResult>> _results({required int limit}) async {
    final result = await _client.rpc<dynamic>('my_results', params: {'p_limit': limit});
    return [
      for (final r in rows(result))
        MatchResult(
          gameId: r['game_id'] as String,
          venueName: (r['venue_name'] as String?) ?? '',
          format: fromDb(GameFormat.values, r['format']) ?? GameFormat.fiveASide,
          playedAt: (fromDb(City.values, r['city_id']) ?? City.london)
              .wallClock(parseTime(r['starts_at'])),
          myTeam: fromDb(Team.values, r['team']) ?? Team.white,
          myScore: asInt(r['my_score']),
          theirScore: asInt(r['their_score']),
          goals: asInt(r['goals']),
          assists: asInt(r['assists']),
          potm: r['potm'] == true,
        ),
    ];
  }

  /// The next "games played" reward the player hasn't reached.
  Future<Milestone> _nextGamesMilestone() async {
    final results = await Future.wait<dynamic>([
      _client.rpc<dynamic>('player_stats', params: {'p_player': _uid, 'p_period': 'career'}),
      _client
          .from('reward_rules')
          .select('threshold, credit_pence, label')
          .eq('kind', 'games_played')
          .eq('is_active', true)
          .order('threshold', ascending: true),
    ]);
    final played = asInt((firstRow(results[0]) ?? const {})['games']);
    final next = rows(results[1]).where((r) => asInt(r['threshold']) > played).firstOrNull;
    final target = next == null ? played + 50 : asInt(next['threshold']);
    final credit = next == null ? 0 : asInt(next['credit_pence']);
    return Milestone(
      title: '$target games played',
      progress: played,
      target: target,
      rewardLabel: credit > 0 ? '${Format.money(credit)} wallet credit' : 'A badge',
    );
  }
}
