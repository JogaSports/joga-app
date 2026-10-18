import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/config/feature_flags.dart';
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

typedef _ProfileData = ({
  Player me,
  PlayerStats stats,
  Streak streak,
  Wallet wallet,
});

/// The player's identity, plus wallet, membership, referrals and settings.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static Future<_ProfileData> _load(AppServices s) async {
    final (me, stats, streak, wallet) = await (
      s.player.currentPlayer(),
      s.player.stats(StatsPeriod.career),
      s.player.streak(),
      s.wallet.wallet(),
    ).wait;
    return (me: me, stats: stats, streak: streak, wallet: wallet);
  }

  @override
  Widget build(BuildContext context) {
    final services = context.services;
    return Scaffold(
      body: SafeArea(
        child: AsyncView<_ProfileData>(
          load: () => _load(services),
          builder: (context, data) => _Profile(data: data),
        ),
      ),
    );
  }
}

class _Profile extends StatelessWidget {
  const _Profile({required this.data});

  final _ProfileData data;

  void _soon(BuildContext context, String what) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.s.comingWithRealApp(what))),
      );

  Future<void> _confirmDelete(BuildContext context) async {
    final s = context.s;
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
            Headline(s.deleteTitle, style: AppText.h2),
            const SizedBox(height: Space.sm),
            Text(s.deleteBody, style: AppText.body),
            const SizedBox(height: Space.lg),
            JogaButton(
              label: s.deleteAccount,
              onPressed: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: Space.sm),
            JogaButton.secondary(
              label: s.keepAccount,
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      ),
    );
    if (confirmed == true && context.mounted) {
      _soon(context, s.deleteAccount);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final me = data.me;
    final stats = data.stats;
    final services = context.services;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Space.gutter,
        Space.lg,
        Space.gutter,
        Space.xl,
      ),
      children: [
        Center(child: PersonAvatar(person: me.person, size: 84)),
        const SizedBox(height: Space.md),
        Headline(
          '${me.person.firstName} ${me.person.lastName}',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Space.xs),
        Text(
          '${s.city(me.city)} · ${s.level(me.level)} · '
          '${s.position(me.position)}',
          style: AppText.small,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Space.md),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: Space.sm,
          runSpacing: Space.sm,
          children: [
            JogaChip(
              label: s.streakChip(data.streak.currentWeeks),
              icon: Icons.local_fire_department_rounded,
              tone: ChipTone.fire,
              onTap: () => context.push(Routes.streak),
            ),
            JogaChip(
              label: s.reliable(me.reliabilityPercent),
              icon: Icons.verified_rounded,
            ),
            if (me.isMember)
              const JogaChip(
                label: AppConfig.membershipName,
                tone: ChipTone.selected,
              ),
          ],
        ),
        const SizedBox(height: Space.lg),
        StatRow(
          tiles: [
            StatTile(value: '${stats.games}', label: s.statGames),
            StatTile(value: '${stats.goals}', label: s.statGoals),
            StatTile(value: '${stats.assists}', label: s.statAssists),
            StatTile(value: '${stats.potm}', label: s.statPotm),
          ],
        ),
        const SizedBox(height: Space.lg),
        _Menu(
          items: [
            _MenuItem(
              icon: Icons.bar_chart_rounded,
              label: s.menuMyStats,
              onTap: () => context.go(Routes.stats),
            ),
            _MenuItem(
              icon: Icons.calendar_month_rounded,
              label: s.menuMyGames,
              onTap: () => context.go(Routes.myGames),
            ),
            _MenuItem(
              icon: Icons.account_balance_wallet_rounded,
              label: s.menuWallet,
              value: Format.money(data.wallet.balancePence),
              onTap: () => context.push(Routes.wallet),
            ),
            _MenuItem(
              icon: Icons.workspace_premium_rounded,
              label: AppConfig.membershipName,
              value: me.isMember ? s.active : s.join,
              onTap: () => context.push(Routes.membership),
            ),
            _MenuItem(
              icon: Icons.local_fire_department_rounded,
              label: s.menuStreak,
              onTap: () => context.push(Routes.streak),
            ),
            if (FeatureFlags.leaderboards)
              _MenuItem(
                icon: Icons.leaderboard_rounded,
                label: s.menuLeaderboard,
                onTap: () => context.push(Routes.leaderboard),
              ),
            if (FeatureFlags.referrals)
              _MenuItem(
                icon: Icons.card_giftcard_rounded,
                label: s.menuReferrals,
                value: s.referralsValue,
                onTap: () => context.push(Routes.referrals),
              ),
          ],
        ),
        const SizedBox(height: Space.md),
        _Menu(
          items: [
            _MenuItem(
              icon: Icons.insights_rounded,
              label: s.menuImpact,
              onTap: () => context.push(Routes.impact),
            ),
            _MenuItem(
              icon: Icons.handshake_outlined,
              label: s.menuConduct,
              onTap: () => context.push(Routes.codeOfConduct),
            ),
          ],
        ),
        const SizedBox(height: Space.md),
        _Menu(
          items: [
            _MenuItem(
              icon: Icons.settings_rounded,
              label: s.menuSettings,
              value: services.settings.language.nativeName,
              onTap: () => context.push(Routes.settings),
            ),
            _MenuItem(
              icon: Icons.logout_rounded,
              label: s.signOut,
              onTap: () async {
                await services.auth.signOut();
                if (context.mounted) context.go(Routes.welcome);
              },
            ),
            _MenuItem(
              icon: Icons.delete_outline_rounded,
              label: s.deleteAccount,
              danger: true,
              onTap: () => _confirmDelete(context),
            ),
          ],
        ),
        SectionLabel(s.demoSection),
        Text(s.viewAppAs, style: AppText.small),
        const SizedBox(height: Space.sm),
        ChipRow(
          children: [
            for (final role in UserRole.values)
              JogaChip.filter(
                label: s.role(role),
                selected: me.role == role,
                onTap: () => services.player.setRole(role),
              ),
          ],
        ),
        const SizedBox(height: Space.md),
        if (me.role == UserRole.admin) ...[
          JogaButton.secondary(
            label: s.openAdmin,
            icon: Icons.dashboard_rounded,
            onPressed: () => context.push(Routes.admin),
          ),
          const SizedBox(height: Space.sm),
        ],
        JogaButton.secondary(
          label: s.allScreens,
          icon: Icons.grid_view_rounded,
          onPressed: () => context.push(Routes.demo),
        ),
      ],
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.value,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;
  final bool danger;
}

class _Menu extends StatelessWidget {
  const _Menu({required this.items});

  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return JogaCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              const Divider(
                height: 1,
                color: AppColors.line,
                indent: Space.md,
                endIndent: Space.md,
              ),
            _row(items[i]),
          ],
        ],
      ),
    );
  }

  Widget _row(_MenuItem item) {
    final color = item.danger ? AppColors.danger : AppColors.textPrimary;
    return InkWell(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Space.md,
          vertical: Space.md,
        ),
        child: Row(
          children: [
            Icon(item.icon,
                size: 20, color: item.danger ? color : AppColors.textMuted),
            const SizedBox(width: Space.md),
            Expanded(
              child: Text(
                item.label,
                style: AppText.bodyStrong.copyWith(color: color),
              ),
            ),
            if (item.value != null) Text(item.value!, style: AppText.small),
            const SizedBox(width: Space.xs),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
