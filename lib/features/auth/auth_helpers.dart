import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/models.dart';

/// Shows an [AuthFailure] (or anything else) as a friendly snack bar.
void showAuthError(BuildContext context, Object error) {
  final s = context.s;
  final message =
      error is AuthFailure ? s.authError(error.error) : s.somethingWrong;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// Simple email check: something@something.something
bool isValidEmail(String value) =>
    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());

/// Red banner for errors the player needs to read (wrong password etc.).
class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(Space.md),
        decoration: BoxDecoration(
          color: AppColors.danger.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: AppColors.danger.withValues(alpha: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.danger,
              size: 20,
            ),
            const SizedBox(width: Space.sm),
            Expanded(child: Text(message, style: AppText.smallStrong)),
          ],
        ),
      ),
    );
  }
}

/// "Step 1 of 2" with a progress bar, for profile setup.
class StepHeader extends StatelessWidget {
  const StepHeader({super.key, required this.step, required this.total});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.s.stepOf(step, total).toUpperCase(), style: AppText.label),
        const SizedBox(height: Space.sm),
        JogaProgressBar(value: step / total),
      ],
    );
  }
}
