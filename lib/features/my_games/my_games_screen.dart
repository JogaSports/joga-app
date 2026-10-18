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

typedef _MyGamesData = ({List<Game> upcoming, List<MatchResult> completed});

/// Upcoming bookings and completed games with results.
class MyGamesScreen extends StatefulWidget {
  const MyGamesScreen({super.key});

  @override
  State<MyGamesScreen> createState() => _MyGamesScreenState();
}

class _MyGamesScreenState extends State<MyGamesScreen> {
  bool _showCompleted = false;

  static Future<_MyGamesData> _load(AppServices s) async {
    final me = await s.player.currentPlayer();
    final (upcoming, completed) =
        await (s.games.upcomingFor(me.id), s.player.recentResults()).wait;
    return (upcoming: upcoming, completed: completed);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final services = context.services;
    return Scaffold(
      body: SafeArea(
        child: AsyncView<_MyGamesData>(
          load: () => _load(services),
          builder: (context, data) => ListView(
            padding: const EdgeInsets.fromLTRB(
              Space.gutter,
              Space.md,
              Space.gutter,
              Space.xl,
            ),
            children: [
              Headline(s.myGamesTitle),
              const SizedBox(height: Space.md),
              Row(
                children: [
                  JogaChip.filter(
                    label: s.upcomingCount(data.upcoming.length),
                    selected: !_showCompleted,
                    onTap: () => setState(() => _showCompleted = false),
                  ),
                  const SizedBox(width: Space.sm),
                  JogaChip.filter(
                    label: s.completed,
                    selected: _showCompleted,
                    onTap: () => setState(() => _showCompleted = true),
                  ),
                ],
              ),
              const SizedBox(height: Space.md),
              if (_showCompleted)
                ..._completed(context, data.completed)
              else
                ..._upcoming(context, data.upcoming),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _upcoming(BuildContext context, List<Game> games) {
    final s = context.s;
    if (games.isEmpty) {
      return [
        EmptyState(
          icon: Icons.sports_soccer_rounded,
          title: s.noGamesBooked,
          message: s.noGamesBookedBody,
          actionLabel: s.findAGame,
          onAction: () => context.go(Routes.find),
        ),
      ];
    }
    return [
      for (final game in games) ...[
        GameCard(
          game: game,
          onTap: () => context.push(Routes.gameDay(game.id)),
          footer: Row(
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.lime),
              const SizedBox(width: Space.xs + 2),
              Expanded(
                child: Text(
                  s.bookedDaysToGo(s.daysToGo(game.startsAt)),
                  style: AppText.smallStrong,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () => _confirmCancel(context, game),
                child: Text(
                  s.cancel,
                  style: AppText.small.copyWith(color: AppColors.textMuted),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Space.md),
      ],
      Text(
        s.freeCancellationShort(AppConfig.freeCancellation.inHours),
        style: AppText.tiny,
      ),
    ];
  }

  List<Widget> _completed(BuildContext context, List<MatchResult> results) {
    final s = context.s;
    if (results.isEmpty) {
      return [
        EmptyState(
          icon: Icons.emoji_events_outlined,
          title: s.noCompleted,
          message: s.noCompletedBody,
        ),
      ];
    }
    return [
      for (final r in results) ...[
        JogaCard(
          onTap: () => context.push(Routes.postGame(r.gameId)),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${s.shortDate(r.playedAt)} · ${r.venueName}',
                      style: AppText.bodyStrong,
                    ),
                    const SizedBox(height: Space.xxs),
                    Text(
                      s.completedLine(
                        s.format(r.format),
                        r.goals,
                        r.assists,
                        r.potm,
                      ),
                      style: AppText.small,
                    ),
                  ],
                ),
              ),
              JogaChip(
                label: s.scoreLine(r),
                tone: r.won ? ChipTone.selected : ChipTone.normal,
              ),
            ],
          ),
        ),
        const SizedBox(height: Space.sm),
      ],
    ];
  }

  Future<void> _confirmCancel(BuildContext context, Game game) async {
    final s = context.s;
    final isLate =
        game.startsAt.difference(DateTime.now()) < AppConfig.freeCancellation;
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(
          Space.gutter,
          0,
          Space.gutter,
          Space.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Headline(s.cancelTitle, style: AppText.h2),
            const SizedBox(height: Space.sm),
            Text(
              isLate
                  ? s.cancelLate(AppConfig.freeCancellation.inHours)
                  : s.cancelRefund,
              style: AppText.body,
            ),
            const SizedBox(height: Space.lg),
            JogaButton(
              label: s.yesCancel,
              onPressed: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: Space.sm),
            JogaButton.secondary(
              label: s.keepSpot,
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final outcome = await context.services.bookings.cancel(game.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          outcome == CancelOutcome.refunded
              ? s.cancelledRefunded(Format.money(game.pricePence))
              : s.cancelledIfFilled,
        ),
      ),
    );
  }
}
