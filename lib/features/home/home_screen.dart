import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/di/app_scope.dart';
import '../../core/di/app_services.dart';
import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/models.dart';

typedef _HomeData = ({
  Player me,
  HomeSummary summary,
  List<Game> upcoming,
  List<Game> forYou,
});

/// Home: next game, streak nudge, season numbers and personalised games.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static Future<_HomeData> _load(AppServices s) async {
    final me = await s.player.currentPlayer();
    final (summary, upcoming, forYou) = await (
      s.player.homeSummary(),
      s.games.upcomingFor(me.id),
      s.games.recommendedFor(me.id),
    ).wait;
    return (me: me, summary: summary, upcoming: upcoming, forYou: forYou);
  }

  @override
  Widget build(BuildContext context) {
    final services = context.services;
    return Scaffold(
      body: SafeArea(
        child: AsyncView<_HomeData>(
          load: () => _load(services),
          builder: (context, data) => _HomeBody(data: data),
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.data});

  final _HomeData data;

  String _greeting(AppStrings s) {
    final hour = DateTime.now().hour;
    if (hour < 12) return s.goodMorning;
    if (hour < 18) return s.goodAfternoon;
    return s.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final me = data.me;
    final stats = data.summary.stats;
    final streak = data.summary.streak;
    final next = data.upcoming.isEmpty ? null : data.upcoming.first;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Space.gutter,
        Space.md,
        Space.gutter,
        Space.xl,
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_greeting(s), style: AppText.small),
                  Headline(me.firstName),
                ],
              ),
            ),
            Semantics(
              button: true,
              label: s.tabProfile,
              child: InkResponse(
                onTap: () => context.go(Routes.profile),
                child: PersonAvatar(person: me.person, size: 42),
              ),
            ),
          ],
        ),
        const SizedBox(height: Space.md),
        Row(
          children: [
            JogaChip(
              label: s.streakChip(streak.currentWeeks),
              icon: Icons.local_fire_department_rounded,
              tone: ChipTone.fire,
              onTap: () => context.push(Routes.streak),
            ),
            const SizedBox(width: Space.sm),
            JogaChip(
              label: s.city(me.city),
              icon: Icons.place_rounded,
              onTap: () => context.go(Routes.find),
            ),
          ],
        ),
        const SizedBox(height: Space.md),
        const SportSwitcher(),
        const SizedBox(height: Space.md),
        GestureDetector(
          onTap: () => context.go(Routes.stats),
          child: StatRow(
            tiles: [
              StatTile(value: '${stats.games}', label: s.statGames),
              StatTile(value: '${stats.goals}', label: s.statGoals),
              StatTile(value: '${stats.assists}', label: s.statAssists),
            ],
          ),
        ),
        if (next != null) ...[
          SectionLabel(
            s.yourNextGame,
            action: s.myGamesAction,
            onAction: () => context.go(Routes.myGames),
          ),
          GameCard(
            game: next,
            onTap: () => context.push(Routes.gameDay(next.id)),
            footer: _NextGameFooter(game: next),
          ),
        ],
        const SizedBox(height: Space.md),
        _StreakNudge(streak: streak),
        SectionLabel(
          s.forYou,
          action: s.seeAll,
          onAction: () => context.go(Routes.find),
        ),
        if (data.forYou.isEmpty)
          JogaCard(
            child: EmptyState(
              icon: Icons.search_rounded,
              title: s.noGamesNearYou,
              message: s.noGamesNearYouBody,
              actionLabel: s.findAGame,
              secondary: true,
              onAction: () => context.go(Routes.find),
            ),
          )
        else
          for (final game in data.forYou) ...[
            GameCard(
              game: game,
              reason: game.tags.contains(GameTag.beginner)
                  ? s.tag(GameTag.beginner)
                  : s.reasonNearYou,
              onTap: () => context.push(Routes.game(game.id)),
            ),
            const SizedBox(height: Space.md),
          ],
        if (!me.isMember) const _MembershipPromo(),
      ],
    );
  }
}

class _NextGameFooter extends StatefulWidget {
  const _NextGameFooter({required this.game});

  final Game game;

  @override
  State<_NextGameFooter> createState() => _NextGameFooterState();
}

class _NextGameFooterState extends State<_NextGameFooter> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final left = widget.game.startsAt.difference(DateTime.now());
    return Row(
      children: [
        const Icon(Icons.timer_outlined, size: 18, color: AppColors.lime),
        const SizedBox(width: Space.xs + 2),
        Expanded(
          child: Text(
            left.isNegative
                ? s.kickedOff
                : s.kickOffIn(Format.countdown(left)),
            style: AppText.smallStrong,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        JogaChip(label: s.booked, tone: ChipTone.selected),
      ],
    );
  }
}

class _StreakNudge extends StatelessWidget {
  const _StreakNudge({required this.streak});

  final Streak streak;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final safe = streak.playedThisWeek;
    return JogaCard(
      tone: safe ? CardTone.lime : CardTone.fire,
      onTap: () => context.push(Routes.streak),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                safe
                    ? Icons.verified_rounded
                    : Icons.local_fire_department_rounded,
                size: 18,
                color: safe ? AppColors.lime : AppColors.fire,
              ),
              const SizedBox(width: Space.xs + 2),
              Expanded(
                child: Text(
                  safe
                      ? s.streakSafe
                      : s.playBySunday(streak.currentWeeks + 1),
                  style: AppText.bodyStrong,
                ),
              ),
              if (!safe)
                Text(
                  '${s.weekday(streak.weekEndsAt)} '
                  '${Format.time(streak.weekEndsAt)}',
                  style: AppText.tiny,
                ),
            ],
          ),
          const SizedBox(height: Space.xs),
          Text(
            s.weeksToReward(
              streak.nextReward.remaining,
              streak.nextReward.rewardLabel,
            ),
            style: AppText.small,
          ),
          const SizedBox(height: Space.sm),
          JogaProgressBar(
            value: streak.nextReward.ratio,
            color: AppColors.fire,
          ),
        ],
      ),
    );
  }
}

class _MembershipPromo extends StatelessWidget {
  const _MembershipPromo();

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return JogaCard(
      tone: CardTone.lime,
      onTap: () => context.push(Routes.membership),
      child: Row(
        children: [
          const Icon(Icons.workspace_premium_rounded, color: AppColors.lime),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Headline(
                  s.membershipPromoTitle,
                  style: AppText.h3,
                  color: AppColors.lime,
                ),
                const SizedBox(height: Space.xxs),
                Text(
                  s.membershipPromoBody(
                    Format.money(AppConfig.membershipMonthlyPence),
                  ),
                  style: AppText.small,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
