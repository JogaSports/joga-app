import 'package:flutter/material.dart';

import '../../data/models/models.dart';
import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../utils/formatters.dart';
import 'avatar.dart';
import 'headline.dart';
import 'joga_card.dart';
import 'joga_chip.dart';
import 'pitch_photo.dart';

/// Spaces badge: "Last space", "2 left", "Full", or "6 spaces".
class SpacesChip extends StatelessWidget {
  const SpacesChip({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    if (game.isFull) {
      return JogaChip(label: s.spacesFull, tone: ChipTone.muted);
    }
    if (game.isLastSpace) {
      return JogaChip(label: s.spacesLast, tone: ChipTone.danger);
    }
    if (game.isAlmostFull) {
      return JogaChip(
        label: s.spacesLeft(game.spacesLeft),
        tone: ChipTone.danger,
      );
    }
    return JogaChip(label: s.spacesCount(game.spacesLeft));
  }
}

/// Large photo-led game card (Home, My Games).
class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.game,
    this.onTap,
    this.footer,
    this.reason,
  });

  final Game game;
  final VoidCallback? onTap;

  /// Replaces the default footer (players + price).
  final Widget? footer;

  /// Why this game is recommended, e.g. "Your level".
  final String? reason;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return JogaCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PitchPhoto(
            height: 110,
            borderRadius: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Headline(s.format(game.format), style: AppText.h2),
                      const SizedBox(height: Space.xxs),
                      Text(
                        '${s.relativeDay(game.startsAt)} · '
                        '${Format.time(game.startsAt)} · ${game.venue.name}',
                        style: AppText.small.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SpacesChip(game: game),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Space.md),
            child: footer ??
                Row(
                  children: [
                    AvatarStack(people: game.players, max: 4),
                    const SizedBox(width: Space.sm),
                    Text('${game.booked}/${game.capacity}',
                        style: AppText.tiny),
                    const Spacer(),
                    if (reason != null) ...[
                      JogaChip(label: reason!, icon: Icons.bolt_rounded),
                      const SizedBox(width: Space.sm),
                    ],
                    Text(
                      Format.moneyShort(game.pricePence),
                      style: AppText.h2,
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }
}

/// Compact game row with a thumbnail (Find).
class GameListTile extends StatelessWidget {
  const GameListTile({super.key, required this.game, this.onTap});

  final Game game;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return JogaCard(
      onTap: onTap,
      padding: const EdgeInsets.all(Space.sm),
      child: Row(
        children: [
          const SizedBox(
            width: 84,
            height: 84,
            child: PitchPhoto(borderRadius: Radii.sm, fade: false),
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Headline(s.format(game.format), style: AppText.h3),
                    ),
                    Text(
                      Format.moneyShort(game.pricePence),
                      style: AppText.h3,
                    ),
                  ],
                ),
                const SizedBox(height: Space.xxs),
                Text(
                  '${s.relativeDay(game.startsAt)} · '
                  '${Format.time(game.startsAt)}',
                  style: AppText.smallStrong,
                ),
                Text(
                  '${game.venue.name} · ${s.level(game.level)}',
                  style: AppText.small,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Space.xs + 2),
                Row(
                  children: [
                    SpacesChip(game: game),
                    const SizedBox(width: Space.xs),
                    for (final tag in game.tags.take(1))
                      Flexible(
                        child: JogaChip(
                          label: s.tag(tag),
                          tone: ChipTone.muted,
                        ),
                      ),
                    const Spacer(),
                    Text(
                      '${game.booked}/${game.capacity}',
                      style: AppText.tiny,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
