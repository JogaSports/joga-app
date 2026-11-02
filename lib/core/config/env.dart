/// Build-time settings, passed with `--dart-define` (or
/// `--dart-define-from-file=env/NAME.json`).
///
/// With nothing passed, the app runs as the demo on fake data. That's what
/// the existing Vercel demo site builds, so it never touches a database.
///
/// Real backend:
///   flutter run -d chrome --dart-define-from-file=env/local.json
///   flutter run -d chrome --dart-define-from-file=env/staging.json
abstract final class Env {
  /// True: demo data for Ray, no backend. False: real Supabase backend.
  static const useFake = bool.fromEnvironment('USE_FAKE', defaultValue: true);

  /// Supabase project URL, e.g. `https://PROJECT-REF.supabase.co`
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  /// The project's PUBLISHABLE key. Safe to ship in the app; never put the
  /// secret key here.
  static const supabaseKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  /// Corner label so nobody mistakes a test site for the real app.
  /// Empty hides it (production).
  static const label = String.fromEnvironment('ENV_LABEL', defaultValue: 'STAGING');

  static bool get isDemo => useFake;
}
