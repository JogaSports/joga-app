import 'enums.dart';

/// Where the signed-in user is in the sign-up journey. The router uses this
/// to decide which screen to show.
enum AuthStatus {
  /// Not signed in: welcome and sign-in screens only.
  signedOut,

  /// Signed up with email; waiting for the 6-digit code.
  needsVerification,

  /// Account exists but the player profile isn't set up yet.
  needsProfile,

  /// Fully signed in.
  signedIn,

  /// Opened a password reset link: choose a new password before carrying
  /// on.
  needsNewPassword,
}

enum AuthError {
  wrongPassword,
  emailInUse,
  invalidCode,
  cancelled,
  network,
  weakPassword,
  tooManyAttempts,

  /// Apple and Google sign-in aren't set up on this build yet.
  notAvailable,
  unknown,
}

/// Thrown by [AuthRepository] methods. Screens turn [error] into a message.
class AuthFailure implements Exception {
  const AuthFailure(this.error);

  final AuthError error;

  @override
  String toString() => 'AuthFailure($error)';
}

/// What a new player tells us during profile setup.
class ProfileSetup {
  const ProfileSetup({
    required this.firstName,
    required this.lastName,
    required this.position,
    required this.foot,
    required this.city,
  });

  final String firstName;
  final String lastName;
  final PlayerPosition position;
  final PreferredFoot foot;
  final City city;
}
