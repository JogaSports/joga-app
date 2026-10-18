import 'package:flutter/material.dart';

import '../../data/models/enums.dart';
import '../l10n/l10n.dart';
import 'joga_chip.dart';

/// Sport picker. Football is live; other sports show as "soon" so the
/// multi-sport direction is visible from day one.
class SportSwitcher extends StatelessWidget {
  const SportSwitcher({
    super.key,
    this.selected = Sport.football,
    this.padding,
  });

  final Sport selected;
  final EdgeInsetsGeometry? padding;

  static const _icons = {
    Sport.football: Icons.sports_soccer_rounded,
    Sport.padel: Icons.sports_tennis_rounded,
    Sport.badminton: Icons.sports_tennis_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return ChipRow(
      padding: padding,
      children: [
        for (final sport in Sport.values)
          JogaChip(
            label: sport.isLive ? s.sport(sport) : s.sportSoon(s.sport(sport)),
            icon: _icons[sport],
            tone: sport == selected
                ? ChipTone.selected
                : sport.isLive
                    ? ChipTone.normal
                    : ChipTone.muted,
          ),
      ],
    );
  }
}
