import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';
import '../repositories/auth_repository.dart';
import 'db.dart';

/// Sign-in and sign-up with Supabase Auth.
///
/// Email: sign up -> 6-digit code by email -> profile set-up. Password
/// resets send a link that opens the app on "Choose a new password".
/// Apple and Google aren't wired yet; they say so instead of failing.
///
/// [status] drives the router. It's worked out from the session and the
/// player's profile (`age_confirmed_at` is set once profile set-up is done).
class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client, this._changes) {
    _sub = _client.auth.onAuthStateChange.listen(_onAuthEvent);
  }

  final SupabaseClient _client;
  final DbChanges _changes;
  late final StreamSubscription<AuthState> _sub;

  AuthStatus _status = AuthStatus.signedOut;
  String? _pendingEmail;
  bool _recovering = false;

  /// Call once at start-up, before showing the app, so a returning player
  /// lands on the right screen.
  Future<void> restore() async {
    if (_client.auth.currentSession == null) {
      _status = AuthStatus.signedOut;
      return;
    }
    try {
      await _loadStatus(notify: false);
    } catch (_) {
      // Offline or the session can't be used: start signed out.
      _status = AuthStatus.signedOut;
    }
  }

  void dispose() => _sub.cancel();

  @override
  AuthStatus get status =>
      _recovering ? AuthStatus.needsNewPassword : _status;

  @override
  bool get isSignedIn => status == AuthStatus.signedIn;

  @override
  String? get pendingEmail => _pendingEmail;

  // ---- Email --------------------------------------------------------------

  @override
  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) =>
      _auth(() async {
        final res = await _client.auth.signUp(email: email, password: password);
        // With email confirmation on, Supabase doesn't say an address is
        // taken (so emails can't be guessed); it returns a user with no
        // identities instead.
        final identities = res.user?.identities;
        if (identities != null && identities.isEmpty) {
          throw const AuthFailure(AuthError.emailInUse);
        }
        if (res.session != null) {
          // Confirmation is switched off on this project.
          _pendingEmail = null;
          await _loadStatus();
          return;
        }
        _pendingEmail = email;
        _set(AuthStatus.needsVerification);
      });

  @override
  Future<void> verifyEmail(String code) => _auth(() async {
        final email = _pendingEmail;
        if (email == null) throw const AuthFailure(AuthError.invalidCode);
        await _client.auth.verifyOTP(type: OtpType.email, email: email, token: code);
        _pendingEmail = null;
        await _loadStatus();
      });

  @override
  Future<void> resendCode() => _auth(() async {
        final email = _pendingEmail;
        if (email == null) return;
        await _client.auth.resend(type: OtpType.signup, email: email);
      });

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) =>
      _auth(() async {
        try {
          await _client.auth.signInWithPassword(email: email, password: password);
        } on AuthException catch (e) {
          if (e.code == 'email_not_confirmed') {
            // Signed up but never entered the code: send a fresh one and
            // go to the code screen.
            _pendingEmail = email;
            await _client.auth.resend(type: OtpType.signup, email: email);
            _set(AuthStatus.needsVerification);
            return;
          }
          rethrow;
        }
        await _loadStatus();
      });

  @override
  Future<void> sendPasswordReset(String email) => _auth(() async {
        await _client.auth.resetPasswordForEmail(email, redirectTo: _redirectUrl);
      });

  @override
  Future<void> setNewPassword(String password) => _auth(() async {
        await _client.auth.updateUser(UserAttributes(password: password));
        _recovering = false;
        await _loadStatus();
      });

  // ---- Apple and Google: not set up on this build yet -----------------------

  @override
  Future<void> signInWithApple() async =>
      throw const AuthFailure(AuthError.notAvailable);

  @override
  Future<void> signInWithGoogle() async =>
      throw const AuthFailure(AuthError.notAvailable);

  // ---- Profile and sign-out ---------------------------------------------------

  @override
  Future<void> completeProfile(ProfileSetup profile) => _auth(() async {
        await _client.rpc<dynamic>('complete_profile', params: {
          'p_first_name': profile.firstName,
          'p_last_name': profile.lastName,
          'p_city': dbName(profile.city),
          'p_position': dbName(profile.position),
          'p_foot': dbName(profile.foot),
        });
        _set(AuthStatus.signedIn);
      });

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (_) {
      // Signing out locally is what matters; ignore network errors.
    }
    _pendingEmail = null;
    _recovering = false;
    _set(AuthStatus.signedOut);
  }

  // ---- Internals ----------------------------------------------------------------

  void _set(AuthStatus status) {
    _status = status;
    _changes.changed();
  }

  /// Signed in: does the player still need to set up their profile?
  Future<void> _loadStatus({bool notify = true}) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      _status = AuthStatus.signedOut;
    } else {
      final row = await _client
          .from('profiles')
          .select('age_confirmed_at')
          .eq('id', user.id)
          .maybeSingle();
      _status = row?['age_confirmed_at'] == null
          ? AuthStatus.needsProfile
          : AuthStatus.signedIn;
    }
    if (notify) _changes.changed();
  }

  void _onAuthEvent(AuthState state) {
    switch (state.event) {
      case AuthChangeEvent.passwordRecovery:
        _recovering = true;
        _changes.changed();
      case AuthChangeEvent.signedOut:
        if (_status != AuthStatus.signedOut &&
            _status != AuthStatus.needsVerification) {
          _recovering = false;
          _set(AuthStatus.signedOut);
        }
      default:
        break;
    }
  }

  /// Where password reset links send the player back to. On the web, the
  /// site they're using (it must be in Supabase's allowed redirect URLs).
  String? get _redirectUrl =>
      kIsWeb ? Uri.base.origin : 'com.jogasports.app://login-callback';

  /// Runs [action], turning Supabase errors into [AuthFailure]s the screens
  /// already know how to show.
  Future<void> _auth(Future<void> Function() action) async {
    try {
      await action();
    } on AuthFailure {
      rethrow;
    } on AuthException catch (e) {
      throw AuthFailure(_authError(e));
    } on PostgrestException catch (e) {
      throw StateError(e.details is String ? e.details! as String : e.message);
    } catch (e) {
      if ('$e'.contains('SocketException') || '$e'.contains('ClientException')) {
        throw const AuthFailure(AuthError.network);
      }
      rethrow;
    }
  }

  static AuthError _authError(AuthException e) {
    final code = e.code ?? '';
    final message = e.message.toLowerCase();
    if (code == 'invalid_credentials' || message.contains('invalid login')) {
      return AuthError.wrongPassword;
    }
    if (code == 'user_already_exists' ||
        code == 'email_exists' ||
        message.contains('already registered')) {
      return AuthError.emailInUse;
    }
    if (code == 'otp_expired' ||
        code == 'otp_disabled' ||
        message.contains('token has expired or is invalid')) {
      return AuthError.invalidCode;
    }
    if (code == 'weak_password' ||
        code == 'same_password' ||
        message.contains('password should')) {
      return AuthError.weakPassword;
    }
    if (code.startsWith('over_') || e.statusCode == '429') {
      return AuthError.tooManyAttempts;
    }
    return AuthError.unknown;
  }
}
