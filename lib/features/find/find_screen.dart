import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/app_scope.dart';
import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/models.dart';

/// Find: browse and filter games by day, town, format, level and tags.
///
/// The third row puts inclusive sessions up front: beginner-friendly,
/// women's, mixed and walking football games.
class FindScreen extends StatefulWidget {
  const FindScreen({super.key});

  @override
  State<FindScreen> createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen> {
  GameFilter _filter = const GameFilter();

  void _update(GameFilter filter) => setState(() => _filter = filter);

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final games = context.services.games;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Space.gutter,
                Space.md,
                Space.gutter,
                Space.sm,
              ),
              child: Headline(s.findTitle),
            ),
            _Filters(filter: _filter, onChanged: _update),
            const SizedBox(height: Space.sm),
            Expanded(
              child: AsyncView<List<Game>>(
                key: ValueKey(_filter),
                load: () => games.findGames(_filter),
                builder: (context, results) => _Results(
                  games: results,
                  city: _filter.city,
                  onClear: () => _update(GameFilter(city: _filter.city)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({required this.filter, required this.onChanged});

  final GameFilter filter;
  final ValueChanged<GameFilter> onChanged;

  /// Sessions aimed at people who might not join a standard game.
  static const _inclusiveTags = [
    GameTag.beginner,
    GameTag.womens,
    GameTag.mixed,
    GameTag.walking,
  ];

  Widget _tagChip(AppStrings s, GameTag tag, {IconData? icon}) => JogaChip(
        label: s.tag(tag),
        icon: icon,
        tone: filter.tag == tag ? ChipTone.selected : ChipTone.normal,
        onTap: () => onChanged(
          filter.copyWith(tag: () => filter.tag == tag ? null : tag),
        ),
      );

  static IconData? _iconFor(GameTag tag) => switch (tag) {
        GameTag.beginner => Icons.emoji_people_rounded,
        GameTag.womens => Icons.female_rounded,
        GameTag.walking => Icons.directions_walk_rounded,
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    const pad = EdgeInsets.symmetric(horizontal: Space.gutter);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SportSwitcher(padding: pad),
        const SizedBox(height: Space.sm),
        ChipRow(
          padding: pad,
          children: [
            for (final day in DayFilter.values)
              JogaChip.filter(
                label: s.day(day),
                selected: filter.day == day,
                onTap: () => onChanged(filter.copyWith(day: day)),
              ),
          ],
        ),
        const SizedBox(height: Space.sm),
        ChipRow(
          padding: pad,
          children: [
            for (final city in City.values)
              JogaChip(
                label: s.city(city),
                icon: city == filter.city ? Icons.place_rounded : null,
                tone: filter.city == city
                    ? ChipTone.selected
                    : city.inWales
                        ? ChipTone.normal
                        : ChipTone.muted,
                onTap: () => onChanged(filter.copyWith(city: city)),
              ),
          ],
        ),
        const SizedBox(height: Space.sm),
        ChipRow(
          padding: pad,
          children: [
            for (final tag in _inclusiveTags)
              _tagChip(s, tag, icon: _iconFor(tag)),
          ],
        ),
        const SizedBox(height: Space.sm),
        ChipRow(
          padding: pad,
          children: [
            for (final format in GameFormat.values)
              JogaChip.filter(
                label: s.format(format),
                selected: filter.format == format,
                onTap: () => onChanged(
                  filter.copyWith(
                    format: () => filter.format == format ? null : format,
                  ),
                ),
              ),
            JogaChip.filter(
              label: s.underPrice,
              selected: filter.maxPricePence != null,
              onTap: () => onChanged(
                filter.copyWith(
                  maxPricePence: () =>
                      filter.maxPricePence == null ? 699 : null,
                ),
              ),
            ),
            _tagChip(s, GameTag.casual),
          ],
        ),
      ],
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({
    required this.games,
    required this.city,
    required this.onClear,
  });

  final List<Game> games;
  final City city;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    if (games.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: EmptyState(
            icon: Icons.filter_alt_off_rounded,
            title: s.noGamesMatch,
            message: s.noGamesMatchBody,
            actionLabel: s.clearFilters,
            secondary: true,
            onAction: onClear,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        Space.gutter,
        Space.sm,
        Space.gutter,
        Space.xl,
      ),
      itemCount: games.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: Space.sm),
      itemBuilder: (context, i) {
        if (i == games.length) {
          return Padding(
            padding: const EdgeInsets.only(top: Space.sm),
            child: Text(
              s.resultsSummary(games.length, s.city(city)),
              style: AppText.tiny,
              textAlign: TextAlign.center,
            ),
          );
        }
        final game = games[i];
        return GameListTile(
          game: game,
          onTap: () => context.push(Routes.game(game.id)),
        );
      },
    );
  }
}
