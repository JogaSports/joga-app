import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/env.dart';
import '../../core/di/app_services.dart';
import '../../core/settings/app_settings.dart';
import 'db.dart';
import 'supabase_auth_repository.dart';
import 'supabase_booking_repository.dart';
import 'supabase_games_repository.dart';
import 'supabase_more_repositories.dart';
import 'supabase_player_repository.dart';

/// Builds [AppServices] on the real Supabase backend.
///
/// Connects with [Env.supabaseUrl] and the publishable [Env.supabaseKey],
/// then restores a returning player's session so the app opens on the
/// right screen.
Future<AppServices> buildSupabaseServices() async {
  if (Env.supabaseUrl.isEmpty || Env.supabaseKey.isEmpty) {
    throw StateError(
      'USE_FAKE is false but SUPABASE_URL or SUPABASE_PUBLISHABLE_KEY is '
      'missing. Run with --dart-define-from-file=env/local.json (or '
      'env/staging.json).',
    );
  }

  await Supabase.initialize(url: Env.supabaseUrl, publishableKey: Env.supabaseKey);
  final client = Supabase.instance.client;
  final changes = DbChanges();

  final auth = SupabaseAuthRepository(client, changes);
  await auth.restore();

  return AppServices(
    auth: auth,
    games: SupabaseGamesRepository(client),
    bookings: SupabaseBookingRepository(client, changes),
    player: SupabasePlayerRepository(client),
    matches: NotYetMatchRepository(),
    wallet: SupabaseWalletRepository(client),
    compete: SupabaseCompeteRepository(client),
    membership: SupabaseMembershipRepository(client),
    admin: NotYetAdminRepository(),
    safety: SupabaseSafetyRepository(client, changes),
    impact: NotYetImpactRepository(),
    settings: AppSettings(),
    changes: changes,
  );
}
