import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import 'joga_button.dart';

/// Friendly "nothing here yet" message with an optional next step.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.secondary = false,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Use a secondary button (e.g. "Clear filters").
  final bool secondary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Space.xl,
        vertical: Space.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.lime.withValues(alpha: 0.1),
              border: Border.all(color: AppColors.lime.withValues(alpha: 0.4)),
            ),
            child: Icon(icon, color: AppColors.lime, size: 32),
          ),
          const SizedBox(height: Space.md),
          Text(title, style: AppText.bodyStrong, textAlign: TextAlign.center),
          if (message != null) ...[
            const SizedBox(height: Space.xs),
            Text(message!, style: AppText.small, textAlign: TextAlign.center),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: Space.lg),
            secondary
                ? JogaButton.secondary(
                    label: actionLabel!,
                    expand: false,
                    onPressed: onAction,
                  )
                : JogaButton(
                    label: actionLabel!,
                    expand: false,
                    onPressed: onAction,
                  ),
          ],
        ],
      ),
    );
  }
}
