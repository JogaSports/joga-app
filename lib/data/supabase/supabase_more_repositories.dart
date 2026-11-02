import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/app_config.dart';
import '../../core/utils/formatters.dart';
import '../models/models.dart';
import '../repositories/admin_repository.dart';
import '../repositories/compete_repository.dart';
import '../repositories/impact_repository.dart';
import '../repositories/match_repository.dart';
import '../repositories/membership_repository.dart';
import '../repositories/safety_repository.dart';
import '../repositories/wallet_repository.dart';
import 'db.dart';

// Wallet, safety, leaderboards and referrals, Joga+, and the screens that
// are wired in round 2 (match control, admin, impact).

/// Wallet credit: the append-only ledger, plus progress to rewards.
class SupabaseWalletRepository implements WalletRepository {
  SupabaseWalletRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<Wallet> wallet() => guard(() async {
        final uid = _client.auth.currentUser?.id;
        if (uid == null) throw StateError('Please sign in again.');
        final results = await Future.wait<dynamic>([
          _client
              .from('wallet_ledger')
              .select('type, amount_pence, label, created_at')
              .eq('player_id', uid)
              .order('created_at', ascending: false),
          _client
              .from('reward_rules')
              .select('kind, threshold, credit_pence, label')
              .eq('is_active', true)
              .order('threshold', ascending: true),
          _client.rpc<dynamic>('player_stats', params: {'p_player': uid, 'p_period': 'career'}),
          _client.rpc<dynamic>('my_streak'),
        ]);
        final career = firstRow(results[2]) ?? const {};
        final streak = firstRow(results[3]) ?? const {};
        final progress = {
          'games_played': asInt(career['games']),
          'streak_weeks': asInt(streak['current_weeks']),
          'potm_awards': asInt(career['potm']),
        };

        // The next reward of each kind the player hasn't reached yet.
        final milestones = <Milestone>[];
        for (final kind in progress.keys) {
          final next = rows(results[1])
              .where((r) => r['kind'] == kind && asInt(r['threshold']) > progress[kind]!)
              .firstOrNull;
          if (next == null) continue;
          final credit = asInt(next['credit_pence']);
          milestones.add(
            Milestone(
              title: (next['label'] as String?) ?? '',
              progress: progress[kind]!,
              target: asInt(next['threshold']),
              rewardLabel: credit > 0 ? Format.money(credit) : 'Badge',
              isStreak: kind == 'streak_weeks',
            ),
          );
        }

        return Wallet(
          entries: [
            for (final e in rows(results[0]))
              WalletEntry(
                label: (e['label'] as String?) ?? '',
                type: switch (e['type']) {
                  'referral' => WalletEntryType.referral,
                  'booking' => WalletEntryType.booking,
                  'refund' => WalletEntryType.refund,
                  'top_up' => WalletEntryType.topUp,
                  _ => WalletEntryType.reward,
                },
                amountPence: asInt(e['amount_pence']),
                date: parseTime(e['created_at']),
              ),
          ],
          milestones: milestones,
        );
      });
}

/// Report and block other players.
class SupabaseSafetyRepository implements SafetyRepository {
  SupabaseSafetyRepository(this._client, this._changes);

  final SupabaseClient _client;
  final DbChanges _changes;

  @override
  Future<void> report({
    required Person person,
    required ReportReason reason,
    String details = '',
    String? gameId,
  }) =>
      guard(() async {
        await _client.rpc<dynamic>('report_player', params: {
          'p_player': person.id,
          'p_reason': dbName(reason),
          'p_details': details,
          'p_game': gameId,
        });
      });

  @override
  Future<void> block(Person person) => guard(() async {
        await _client.rpc<dynamic>('block_player', params: {'p_player': person.id});
        _changes.changed();
      });

  @override
  Future<void> unblock(Person person) => guard(() async {
        await _client.rpc<dynamic>('unblock_player', params: {'p_player': person.id});
        _changes.changed();
      });

  @override
  Future<List<Person>> blocked() => guard(() async {
        final result = await _client.rpc<dynamic>('my_blocked_players');
        return [
          for (final r in rows(result))
            Person(
              id: r['player_id'] as String,
              firstName: (r['first_name'] as String?) ?? '',
              lastName: (r['last_name'] as String?) ?? '',
            ),
        ];
      });
}

/// City leaderboards and referrals.
class SupabaseCompeteRepository implements CompeteRepository {
  SupabaseCompeteRepository(this._client);

  final SupabaseClient _client;

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July', //
    'August', 'September', 'October', 'November', 'December',
  ];

  @override
  Future<Leaderboard> leaderboard(City city, LeaderboardMetric metric) => guard(() async {
        final result = await _client.rpc<dynamic>('leaderboard', params: {
          'p_city': dbName(city),
          'p_metric': metric.name,
          'p_limit': 20,
        });
        return Leaderboard(
          city: city,
          metric: metric,
          monthLabel: _months[city.clockNow().month - 1],
          entries: [
            for (final r in rows(result))
              LeaderboardEntry(
                position: asInt(r['rank']),
                person: Person(
                  id: r['player_id'] as String,
                  firstName: (r['first_name'] as String?) ?? '',
                  lastName: (r['last_initial'] as String?) ?? '',
                ),
                value: asInt(r['value']),
                isMe: r['is_me'] == true,
              ),
          ],
          prize: 'Top of the ${metric.label.toLowerCase()} table wins a month of free games.',
        );
      });

  @override
  Future<Referrals> referrals() => guard(() async {
        final uid = _client.auth.currentUser?.id;
        if (uid == null) throw StateError('Please sign in again.');
        final results = await Future.wait<dynamic>([
          _client.from('profiles').select('referral_code').eq('id', uid).single(),
          _client
              .from('referrals')
              .select('stage, referred:profiles!referrals_referred_id_fkey(first_name)')
              .eq('referrer_id', uid)
              .order('created_at', ascending: false),
        ]);
        return Referrals(
          code: ((results[0] as Map<String, dynamic>)['referral_code'] as String?) ?? '',
          rewardPence: AppConfig.referralRewardPence,
          entries: [
            for (final r in rows(results[1]))
              ReferralEntry(
                name: ((r['referred'] as Map<String, dynamic>?)?['first_name'] as String?) ?? '',
                stage: fromDb(ReferralStage.values, r['stage']) ?? ReferralStage.joined,
              ),
          ],
        );
      });
}

/// Joga+. Buying it needs the App Store and Google Play (RevenueCat), so it
/// can't be bought on the web build.
class SupabaseMembershipRepository implements MembershipRepository {
  SupabaseMembershipRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<MembershipOffer> offer() => guard(() async {
        final isMember = await _client.rpc<dynamic>('is_member');
        return MembershipOffer(
          name: AppConfig.membershipName,
          monthlyPence: AppConfig.membershipMonthlyPence,
          benefits: AppConfig.membershipBenefits,
          isActive: isMember == true,
        );
      });

  @override
  Future<void> subscribe() async => throw StateError(
        '${AppConfig.membershipName} will be available in the iPhone and '
        'Android apps.',
      );
}

const _nextUpdate = 'This part of the app is coming in the next update.';

/// Match control: wired in round 2.
class NotYetMatchRepository implements MatchRepository {
  @override
  Future<MatchSheet> loadSheet(String gameId) async => throw StateError(_nextUpdate);

  @override
  Future<void> submit(MatchSheet sheet) async => throw StateError(_nextUpdate);
}

/// Admin dashboard: wired in round 2.
class NotYetAdminRepository implements AdminRepository {
  @override
  Future<AdminDashboard> dashboard() async => throw StateError(_nextUpdate);
}

/// Community impact: wired in round 2.
class NotYetImpactRepository implements ImpactRepository {
  @override
  Future<ImpactDashboard> dashboard(ImpactPeriod period) async => throw StateError(_nextUpdate);
}
