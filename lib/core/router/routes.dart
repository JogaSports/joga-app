/// Every route in the app. Use these helpers instead of typing paths.
abstract final class Routes {
  // Sign in and sign up
  static const welcome = '/welcome';
  static const auth = '/auth';
  static const authEmail = '/auth/email';
  static const forgotPassword = '/auth/forgot';
  static const verifyEmail = '/auth/verify';
  static const profileSetup = '/setup/profile';
  static const permissions = '/setup/permissions';

  /// Sign-up or sign-in choice (Apple, Google, email).
  static String authMode({required bool signUp}) =>
      '$auth?mode=${signUp ? 'signup' : 'signin'}';

  static String emailMode({required bool signUp}) =>
      '$authEmail?mode=${signUp ? 'signup' : 'signin'}';

  /// Reachable when signed out. Signed-in players are sent home instead.
  static const signedOutOnly = {welcome, auth, authEmail, forgotPassword};

  /// Reachable whether signed in or not.
  static const open = {codeOfConduct, demo};

  // Bottom-nav tabs
  static const home = '/home';
  static const find = '/find';
  static const myGames = '/my-games';
  static const stats = '/stats';
  static const profile = '/profile';

  // Game flow
  static String game(String id) => '/game/$id';
  static String checkout(String id) => '/game/$id/checkout';
  static String confirmed(String id) => '/game/$id/confirmed';
  static String gameDay(String id) => '/game/$id/day';
  static String matchControl(String id) => '/game/$id/match-control';
  static String postGame(String id) => '/game/$id/post-game';

  // Player
  static const streak = '/streak';
  static const wallet = '/wallet';
  static const membership = '/joga-plus';
  static const settings = '/settings';
  static const codeOfConduct = '/code-of-conduct';

  // Compete (after test)
  static const leaderboard = '/leaderboard';
  static const referrals = '/referrals';

  // Operations and partners
  static const admin = '/admin';
  static const impact = '/impact';

  /// Demo only: index of every screen.
  static const demo = '/demo';
}
