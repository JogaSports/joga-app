import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/app_scope.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/widgets.dart';
import '../../data/fake/fake_seed.dart';

/// Demo only: every screen in the app, grouped by the player loop, so the
/// whole product can be reviewed in one sitting. Remove before launch.
class DemoHubScreen extends StatelessWidget {
  const DemoHubScreen({super.key});

  static final _stages = <(String, List<_Entry>)>[
    (
      'Join',
      [
        _Entry('Welcome · signs out first', Routes.welcome, signOut: true),
        _Entry(
          'Create account (Apple, Google, email)',
          Routes.authMode(signUp: true),
          signOut: true,
        ),
        _Entry(
          'Sign up with email → verify → profile',
          Routes.emailMode(signUp: true),
          signOut: true,
        ),
        _Entry(
          'Sign in with email',
          Routes.emailMode(signUp: false),
          signOut: true,
        ),
      ],
    ),
    (
      'Find',
      [
        _Entry('Home', Routes.home, go: true),
        _Entry('Find games (towns, inclusive filters)', Routes.find,
            go: true),
        _Entry('Walking football', Routes.game('g-110')),
        _Entry("Women's game · Swansea", Routes.game('g-302')),
      ],
    ),
    (
      'Book',
      [
        _Entry(
          'Game details · players, report & block, access',
          Routes.game(FakeSeed.lastSpaceGameId),
        ),
        _Entry('Checkout (5-minute hold)',
            Routes.checkout(FakeSeed.lastSpaceGameId)),
        _Entry('Booking confirmed',
            Routes.confirmed(FakeSeed.lastSpaceGameId)),
        _Entry('Full game (waitlist)', Routes.game('g-104')),
      ],
    ),
    (
      'Play',
      [
        _Entry('My games', Routes.myGames, go: true),
        _Entry('Game day', Routes.gameDay(FakeSeed.tonightGameId)),
        _Entry(
          'Match control (organiser)',
          Routes.matchControl(FakeSeed.tonightGameId),
        ),
      ],
    ),
    (
      'Track',
      [
        _Entry('Post-game', Routes.postGame(FakeSeed.lastPlayedGameId)),
        _Entry('Stats', Routes.stats, go: true),
        _Entry('Profile', Routes.profile, go: true),
      ],
    ),
    (
      'Compete & reward',
      [
        _Entry('Streak', Routes.streak),
        _Entry('City leaderboard · after test', Routes.leaderboard),
        _Entry('Wallet', Routes.wallet),
      ],
    ),
    (
      'Grow & run',
      [
        _Entry('Joga+', Routes.membership),
        _Entry('Referrals · after test', Routes.referrals),
        _Entry('Admin dashboard', Routes.admin),
        _Entry('Community impact', Routes.impact),
      ],
    ),
    (
      'Trust & settings',
      [
        _Entry('Settings · notifications, safety', Routes.settings),
        _Entry('Player code of conduct', Routes.codeOfConduct),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var number = 0;
    return JogaScaffold(
      showBack: true,
      children: [
        const Headline('All screens'),
        const Text(
          'Demo index. Tip: book the last space, then open Match control '
          "for tonight's game and submit a result to see stats, streak and "
          'wallet update everywhere. Error states on purpose: password '
          '"wrong-password", an email containing "taken", or code 000000.',
          style: AppText.small,
        ),
        for (final (stage, entries) in _stages) ...[
          SectionLabel(stage),
          JogaCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final entry in entries)
                  ListTile(
                    dense: true,
                    leading: Text(
                      (++number).toString().padLeft(2, '0'),
                      style: AppText.h3.copyWith(color: AppColors.lime),
                    ),
                    title: Text(entry.label, style: AppText.bodyStrong),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textMuted,
                    ),
                    onTap: () async {
                      if (entry.signOut) {
                        final router = GoRouter.of(context);
                        await context.services.auth.signOut();
                        router.go(Routes.welcome);
                        if (entry.path != Routes.welcome) {
                          router.push(entry.path);
                        }
                        return;
                      }
                      entry.go
                          ? context.go(entry.path)
                          : context.push(entry.path);
                    },
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: Space.md),
      ],
    );
  }
}

class _Entry {
  const _Entry(this.label, this.path, {this.go = false, this.signOut = false});

  final String label;
  final String path;

  /// Tabs replace the stack instead of pushing.
  final bool go;

  /// Sign-in screens: sign out first so the router allows them.
  final bool signOut;
}
