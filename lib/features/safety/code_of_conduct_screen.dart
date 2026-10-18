import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/widgets.dart';

/// The player code of conduct. Everyone agrees to it at sign-up, and it's
/// linked from every game page.
class CodeOfConductScreen extends StatelessWidget {
  const CodeOfConductScreen({super.key});

  static const _icons = [
    Icons.favorite_rounded,
    Icons.gpp_good_rounded,
    Icons.health_and_safety_rounded,
    Icons.handshake_rounded,
    Icons.event_available_rounded,
    Icons.campaign_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final rules = s.conductRules;
    return JogaScaffold(
      showBack: true,
      children: [
        Headline(s.conductTitle),
        Text(
          s.conductIntro,
          style: AppText.body.copyWith(color: AppColors.textSecondary),
        ),
        for (var i = 0; i < rules.length; i++)
          JogaCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.lime.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _icons[i % _icons.length],
                    color: AppColors.lime,
                    size: 20,
                  ),
                ),
                const SizedBox(width: Space.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rules[i].$1, style: AppText.bodyStrong),
                      const SizedBox(height: Space.xxs),
                      Text(rules[i].$2, style: AppText.small),
                    ],
                  ),
                ),
              ],
            ),
          ),
        JogaCard(
          tone: CardTone.fire,
          child: Row(
            children: [
              const Icon(Icons.gavel_rounded, color: AppColors.fire),
              const SizedBox(width: Space.md),
              Expanded(
                child: Text(s.conductFooter, style: AppText.smallStrong),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
