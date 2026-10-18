import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/app_scope.dart';
import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/widgets.dart';
import 'auth_helpers.dart';

/// Explains location and notifications before the system prompt appears,
/// so players know why we ask. Both are optional.
///
/// Real version: `geolocator` and `firebase_messaging` request the system
/// permissions when "Allow" is tapped.
class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final settings = context.services.settings;
    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) => JogaScaffold(
        bottom: JogaButton(
          label: s.letsPlay,
          onPressed: () => context.go(Routes.home),
        ),
        children: [
          const SizedBox(height: Space.md),
          const StepHeader(step: 2, total: 2),
          Headline(s.permissionsTitle),
          const SizedBox(height: Space.sm),
          _PermissionCard(
            icon: Icons.near_me_rounded,
            title: s.locationTitle,
            body: s.locationBody,
            allowed: settings.locationAllowed,
            onAllow: () => settings.locationAllowed = true,
          ),
          _PermissionCard(
            icon: Icons.notifications_active_rounded,
            title: s.notificationsTitle,
            body: s.notificationsBody,
            allowed: settings.notificationsAllowed,
            onAllow: () => settings.notificationsAllowed = true,
          ),
          Center(
            child: TextButton(
              onPressed: () => context.go(Routes.home),
              child: Text(s.notNow, style: AppText.small),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.allowed,
    required this.onAllow,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool allowed;
  final VoidCallback onAllow;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return JogaCard(
      tone: allowed ? CardTone.lime : CardTone.normal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.lime),
              const SizedBox(width: Space.sm),
              Expanded(child: Text(title, style: AppText.bodyStrong)),
            ],
          ),
          const SizedBox(height: Space.xs),
          Text(body, style: AppText.small),
          const SizedBox(height: Space.md),
          allowed
              ? JogaChip(
                  label: s.allowed,
                  icon: Icons.check_rounded,
                  tone: ChipTone.selected,
                )
              : JogaButton.secondary(
                  label: s.allow,
                  expand: false,
                  onPressed: onAllow,
                ),
        ],
      ),
    );
  }
}
