import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/models.dart';
import '../../features/admin/admin_screen.dart';
import '../../features/auth/email_auth_screen.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/permissions_screen.dart';
import '../../features/auth/profile_setup_screen.dart';
import '../../features/auth/sign_in_screen.dart';
import '../../features/auth/verify_email_screen.dart';
import '../../features/auth/welcome_screen.dart';
import '../../features/booking/booking_confirmed_screen.dart';
import '../../features/booking/checkout_screen.dart';
import '../../features/demo/demo_hub_screen.dart';
import '../../features/find/find_screen.dart';
import '../../features/game/game_details_screen.dart';
import '../../features/game_day/game_day_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/impact/impact_screen.dart';
import '../../features/leaderboard/leaderboard_screen.dart';
import '../../features/match_control/match_control_screen.dart';
import '../../features/membership/membership_screen.dart';
import '../../features/my_games/my_games_screen.dart';
import '../../features/post_game/post_game_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/referrals/referrals_screen.dart';
import '../../features/safety/code_of_conduct_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/shell/app_shell.dart';
import '../../features/stats/stats_screen.dart';
import '../../features/streak/streak_screen.dart';
import '../../features/wallet/wallet_screen.dart';
import '../di/app_services.dart';
import 'routes.dart';

/// App navigation.
///
/// The five tabs live in a [StatefulShellRoute] so each tab keeps its own
/// scroll position and history. Everything else opens full screen on top.
///
/// [_redirect] keeps players on the right step of sign-up: signed-out
/// players only see the welcome and sign-in screens, new accounts go
/// through verify and profile setup, and signed-in players skip the
/// sign-in screens.
GoRouter buildRouter({
  required AppServices services,
  String initialLocation = Routes.welcome,
}) {
  String id(GoRouterState state) => state.pathParameters['id']!;
  bool signUp(GoRouterState state) =>
      state.uri.queryParameters['mode'] != 'signin';

  return GoRouter(
    initialLocation: initialLocation,
    refreshListenable: services.changes,
    redirect: (context, state) => _redirect(services, state),
    routes: [
      // Sign in and sign up ----------------------------------------------
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: Routes.auth,
        builder: (context, state) => SignInScreen(signUp: signUp(state)),
      ),
      GoRoute(
        path: Routes.authEmail,
        builder: (context, state) => EmailAuthScreen(signUp: signUp(state)),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: Routes.verifyEmail,
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      GoRoute(
        path: Routes.profileSetup,
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: Routes.permissions,
        builder: (context, state) => const PermissionsScreen(),
      ),

      // Main app -----------------------------------------------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          _tab(Routes.home, const HomeScreen()),
          _tab(Routes.find, const FindScreen()),
          _tab(Routes.myGames, const MyGamesScreen()),
          _tab(Routes.stats, const StatsScreen()),
          _tab(Routes.profile, const ProfileScreen()),
        ],
      ),
      GoRoute(
        path: '/game/:id',
        builder: (context, state) => GameDetailsScreen(gameId: id(state)),
        routes: [
          GoRoute(
            path: 'checkout',
            builder: (context, state) => CheckoutScreen(gameId: id(state)),
          ),
          GoRoute(
            path: 'confirmed',
            builder: (context, state) =>
                BookingConfirmedScreen(gameId: id(state)),
          ),
          GoRoute(
            path: 'day',
            builder: (context, state) => GameDayScreen(gameId: id(state)),
          ),
          GoRoute(
            path: 'match-control',
            builder: (context, state) => MatchControlScreen(gameId: id(state)),
          ),
          GoRoute(
            path: 'post-game',
            builder: (context, state) => PostGameScreen(gameId: id(state)),
          ),
        ],
      ),
      GoRoute(
        path: Routes.streak,
        builder: (context, state) => const StreakScreen(),
      ),
      GoRoute(
        path: Routes.wallet,
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: Routes.membership,
        builder: (context, state) => const MembershipScreen(),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.codeOfConduct,
        builder: (context, state) => const CodeOfConductScreen(),
      ),
      GoRoute(
        path: Routes.leaderboard,
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: Routes.referrals,
        builder: (context, state) => const ReferralsScreen(),
      ),
      GoRoute(
        path: Routes.admin,
        builder: (context, state) => const AdminScreen(),
      ),
      GoRoute(
        path: Routes.impact,
        builder: (context, state) => const ImpactScreen(),
      ),
      GoRoute(
        path: Routes.demo,
        builder: (context, state) => const DemoHubScreen(),
      ),
    ],
  );
}

String? _redirect(AppServices services, GoRouterState state) {
  final location = state.matchedLocation;
  if (Routes.open.contains(location)) return null;
  final signedOutOnly = Routes.signedOutOnly.contains(location);

  return switch (services.auth.status) {
    AuthStatus.signedOut => signedOutOnly ? null : Routes.welcome,
    AuthStatus.needsVerification =>
      location == Routes.verifyEmail ? null : Routes.verifyEmail,
    AuthStatus.needsProfile =>
      location == Routes.profileSetup ? null : Routes.profileSetup,
    // Profile setup and permissions stay reachable for a moment after
    // sign-up finishes, so the journey isn't cut short.
    AuthStatus.signedIn => signedOutOnly ? Routes.home : null,
  };
}

StatefulShellBranch _tab(String path, Widget screen) => StatefulShellBranch(
      routes: [
        GoRoute(path: path, builder: (context, state) => screen),
      ],
    );
