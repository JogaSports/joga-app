import '../models/models.dart';

/// Sign-in and sign-up.
///
/// Demo: Apple and Google sign straight in as Ray. Email sign-up walks the
/// full journey (verify code, profile setup) with any details.
///
/// Real version: Supabase Auth. Apple via `sign_in_with_apple` (native on
/// iOS, web flow elsewhere), Google via `google_sign_in`, email with a
/// one-time code. Apple only shares the player's name on the first sign-in,
/// so save it straight away.
///
/// Methods throw [AuthFailure] for errors the player can fix.
abstract interface class AuthRepository {
  AuthStatus get status;

  bool get isSignedIn;

  /// The email waiting to be verified, if any.
  String? get pendingEmail;

  Future<void> signInWithApple();
  Future<void> signInWithGoogle();

  Future<void> signInWithEmail({
    required String email,
    required String password,
  });

  /// Creates the account and sends a 6-digit code to [email].
  Future<void> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<void> verifyEmail(String code);
  Future<void> resendCode();
  Future<void> sendPasswordReset(String email);

  /// Saves the new player's profile and finishes sign-up.
  Future<void> completeProfile(ProfileSetup profile);

  Future<void> signOut();
}
