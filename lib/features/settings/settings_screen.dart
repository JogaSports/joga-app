import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/app_scope.dart';
import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/settings/app_settings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/models.dart';

/// Language, notifications, privacy and safety, accessibility.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = context.services;
    final settings = services.settings;
    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) {
        final s = context.s;
        return JogaScaffold(
          showBack: true,
          children: [
            Headline(s.settingsTitle),

            // Language ------------------------------------------------------
            SectionLabel(s.language),
            _Group(
              children: [
                for (final language in AppLanguage.values)
                  _Row(
                    title: language.nativeName,
                    selected: settings.language == language,
                    onTap: () => settings.language = language,
                  ),
              ],
            ),
            Text(s.languageHelp, style: AppText.tiny),

            // Notifications -------------------------------------------------
            SectionLabel(s.notificationsSection),
            _Group(
              children: [
                for (final type in NotificationType.values)
                  _SwitchRow(
                    title: s.notificationType(type),
                    value: settings.notification(type),
                    onChanged: (v) => settings.setNotification(type, v),
                  ),
              ],
            ),

            // Privacy and safety --------------------------------------------
            SectionLabel(s.privacySection),
            _Group(
              children: [
                _SwitchRow(
                  title: s.shareStats,
                  value: settings.shareStats,
                  onChanged: (v) => settings.shareStats = v,
                ),
                _Row(
                  title: s.conductLink,
                  icon: Icons.handshake_outlined,
                  onTap: () => context.push(Routes.codeOfConduct),
                ),
              ],
            ),
            Text(s.blockedPlayers.toUpperCase(), style: AppText.label),
            AsyncView<List<Person>>(
              load: services.safety.blocked,
              builder: (context, blocked) => blocked.isEmpty
                  ? Text(s.noBlocked, style: AppText.small)
                  : _Group(
                      children: [
                        for (final person in blocked)
                          _BlockedRow(person: person),
                      ],
                    ),
            ),

            // Accessibility -------------------------------------------------
            SectionLabel(s.accessibilitySection),
            _Group(
              children: [
                _SwitchRow(
                  title: s.reduceMotion,
                  subtitle: s.reduceMotionHelp,
                  value: settings.reduceMotion,
                  onChanged: (v) => settings.reduceMotion = v,
                ),
              ],
            ),

            // Demo ----------------------------------------------------------
            if (services.resetDemo != null) ...[
              SectionLabel(s.demoTools),
              _Group(
                children: [
                  _SwitchRow(
                    title: s.phoneFrame,
                    value: settings.phoneFrame,
                    onChanged: (v) => settings.phoneFrame = v,
                  ),
                  _Row(
                    title: s.resetDemo,
                    subtitle: s.resetDemoBody,
                    icon: Icons.restart_alt_rounded,
                    onTap: () {
                      final messenger = ScaffoldMessenger.of(context);
                      services.resetDemo!();
                      messenger.showSnackBar(
                        SnackBar(content: Text(s.resetDone)),
                      );
                    },
                  ),
                ],
              ),
            ],
            const SizedBox(height: Space.md),
            Text(
              s.version('0.2.0'),
              style: AppText.tiny,
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return JogaCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              const Divider(
                height: 1,
                color: AppColors.line,
                indent: Space.md,
                endIndent: Space.md,
              ),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.title,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.selected,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;

  /// Non-null for a choice row: shows a tick when selected.
  final bool? selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Space.md,
              vertical: Space.sm,
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20, color: AppColors.textMuted),
                  const SizedBox(width: Space.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppText.bodyStrong),
                      if (subtitle != null)
                        Text(subtitle!, style: AppText.small),
                    ],
                  ),
                ),
                if (selected == true)
                  const Icon(Icons.check_rounded, color: AppColors.lime)
                else if (selected == null)
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textMuted,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Space.md,
            Space.xs,
            Space.sm,
            Space.xs,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.bodyStrong),
                    if (subtitle != null) Text(subtitle!, style: AppText.small),
                  ],
                ),
              ),
              Switch(value: value, onChanged: onChanged),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlockedRow extends StatelessWidget {
  const _BlockedRow({required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Space.md,
        vertical: Space.sm,
      ),
      child: Row(
        children: [
          PersonAvatar(person: person, size: 32),
          const SizedBox(width: Space.md),
          Expanded(
            child: Text(
              '${person.firstName} ${person.lastName}',
              style: AppText.bodyStrong,
            ),
          ),
          TextButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              await context.services.safety.unblock(person);
              messenger.showSnackBar(
                SnackBar(content: Text(s.unblockedToast(person.firstName))),
              );
            },
            child: Text(s.unblock),
          ),
        ],
      ),
    );
  }
}
