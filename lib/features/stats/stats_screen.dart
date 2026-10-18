import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/config/feature_flags.dart';
import '../../core/di/app_scope.dart';
import '../../core/di/app_services.dart';
import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/models.dart';
import 'widgets/form_chart.dart';
import 'widgets/streak_calendar.dart';

typedef _StatsData = ({PlayerStats stats, Streak streak, Player me});

/// Your football: totals by period, form, streak and Joga+ stats.
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  StatsPeriod _period = StatsPeriod.career;

  static Future<_StatsData> _load(AppServices s, StatsPeriod period) async {
    final (stats, streak, me) = await (
      s.player.stats(period),
      s.player.streak(),
      s.player.currentPlayer(),
    ).wait;
    return (stats: stats, streak: streak, me: me);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final services = context.services;
    return Scaffold(
      body: SafeArea(
        child: AsyncView<_StatsData>(
          key: ValueKey(_period),
          load: () => _load(services, _period),
          builder: (context, data) => ListView(
            padding: const EdgeInsets.fromLTRB(
              Space.gutter,
              Space.md,
              Space.gutter,
              Space.xl,
            ),
            children: [
              Headline(s.statsTitle),
              const SizedBox(height: Space.md),
              ChipRow(
                children: [
                  for (final p in StatsPeriod.values)
                    JogaChip.filter(
                      label: s.period(p),
                      selected: p == _period,
                      onTap: () => setState(() => _period = p),
                    ),
                ],
              ),
              const SizedBox(height: Space.md),
              _Totals(stats: data.stats),
              SectionLabel(s.formLast10),
              JogaCard(child: FormChart(form: data.stats.form)),
              SectionLabel(
                s.streakLast12,
                action: s.details,
                onAction: () => context.push(Routes.streak),
              ),
              JogaCard(
                onTap: () => context.push(Routes.streak),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreakCalendar(weeks: data.streak.lastTwelveWeeks),
                    const SizedBox(height: Space.sm),
                    Text.rich(
                      TextSpan(
                        style: AppText.small,
                        children: [
                          TextSpan(text: s.currentLabel),
                          TextSpan(
                            text: s.weeksN(data.streak.currentWeeks),
                            style: const TextStyle(
                              color: AppColors.fire,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(text: s.bestN(data.streak.bestWeeks)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SectionLabel(
                s.deeperStats,
                trailing: const JogaChip(
                  label: AppConfig.membershipName,
                  tone: ChipTone.selected,
                ),
              ),
              _MemberStats(stats: data.stats, unlocked: data.me.isMember),
              if (FeatureFlags.leaderboards) ...[
                const SizedBox(height: Space.md),
                JogaCard(
                  onTap: () => context.push(Routes.leaderboard),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.leaderboard_rounded,
                        color: AppColors.lime,
                      ),
                      const SizedBox(width: Space.md),
                      Expanded(
                        child: Text(
                          s.cityTableRank(
                            s.city(data.me.city),
                            data.stats.cityRank,
                          ),
                          style: AppText.bodyStrong,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textMuted,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals({required this.stats});

  final PlayerStats stats;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Column(
      children: [
        StatRow(
          tiles: [
            StatTile(value: '${stats.games}', label: s.statGames),
            StatTile(value: '${stats.goals}', label: s.statGoals),
            StatTile(value: '${stats.assists}', label: s.statAssists),
            StatTile(value: '${stats.potm}', label: s.statPotm),
          ],
        ),
        const SizedBox(height: Space.sm),
        StatRow(
          tiles: [
            StatTile(
              value: stats.goalsPerGame.toStringAsFixed(2),
              label: s.goalsPerGame,
            ),
            StatTile(value: '${stats.winRatePercent}%', label: s.winRate),
          ],
        ),
      ],
    );
  }
}

class _MemberStats extends StatelessWidget {
  const _MemberStats({required this.stats, required this.unlocked});

  final PlayerStats stats;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final content = JogaCard(
      child: Column(
        children: [
          PriceRow(label: s.cityRank, value: '#${stats.cityRank}'),
          PriceRow(label: s.bestVenue, value: stats.bestVenue),
          PriceRow(
            label: s.involvementsPerGame,
            value: stats.games == 0
                ? '0'
                : ((stats.goals + stats.assists) / stats.games)
                    .toStringAsFixed(2),
          ),
          PriceRow(label: s.potmRate, value: _potmRate()),
        ],
      ),
    );
    if (unlocked) return content;

    return Stack(
      children: [
        content,
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Radii.md),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.background.withValues(alpha: 0.55),
                    AppColors.background.withValues(alpha: 0.95),
                  ],
                ),
              ),
              child: Center(
                child: JogaButton(
                  label: s.unlockWith(AppConfig.membershipName),
                  icon: Icons.lock_rounded,
                  expand: false,
                  onPressed: () => context.push(Routes.membership),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _potmRate() =>
      stats.games == 0 ? '0%' : '${(stats.potm / stats.games * 100).round()}%';
}
