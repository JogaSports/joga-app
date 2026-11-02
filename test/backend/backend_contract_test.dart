// Checks the app's real-backend code against Supabase running on your Mac.
//
// Skipped in a normal `flutter test`. To run:
//   cd ../joga-backend && supabase start && supabase db reset
//   cd ../joga-app
//   flutter test test/backend --dart-define-from-file=env/local.json \
//     --dart-define=BACKEND_TESTS=true
//
// Uses the local seed (Ray, Dan, demo games) and Mailpit for sign-up codes,
// so run `supabase db reset` first: the booking test spends Ray's credit.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:joga_sports/core/config/env.dart';
import 'package:joga_sports/data/models/models.dart';
import 'package:joga_sports/data/supabase/db.dart';
import 'package:joga_sports/data/supabase/supabase_auth_repository.dart';
import 'package:joga_sports/data/supabase/supabase_booking_repository.dart';
import 'package:joga_sports/data/supabase/supabase_games_repository.dart';
import 'package:joga_sports/data/supabase/supabase_more_repositories.dart';
import 'package:joga_sports/data/supabase/supabase_player_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _run = bool.fromEnvironment('BACKEND_TESTS');
const _skip = _run ? false : 'Backend tests are off. See the top of this file.';

// Seed ids (joga-backend supabase/seed.sql).
String _game(int n) => '20000000-0000-4000-a000-${n.toString().padLeft(12, '0')}';
const _ray = '00000000-0000-4000-a000-000000000001';

void main() {
  late SupabaseClient client;
  late DbChanges changes;
  late SupabaseAuthRepository auth;
  late SupabaseGamesRepository games;
  late SupabaseBookingRepository bookings;
  late SupabasePlayerRepository player;
  late SupabaseWalletRepository wallet;

  setUpAll(() {
    if (!_run) return;
    client = _newClient();
    changes = DbChanges();
    auth = SupabaseAuthRepository(client, changes);
    games = SupabaseGamesRepository(client);
    bookings = SupabaseBookingRepository(client, changes);
    player = SupabasePlayerRepository(client);
    wallet = SupabaseWalletRepository(client);
  });

  group('signed in as Ray (seed)', () {
    test('signs in with email and password', () async {
      await auth.signInWithEmail(email: 'ray@joga.demo', password: 'joga-demo-2026');
      expect(auth.status, AuthStatus.signedIn);
    }, skip: _skip);

    test('a wrong password is a friendly error', () async {
      final other = SupabaseAuthRepository(
        _newClient(),
        DbChanges(),
      );
      await expectLater(
        other.signInWithEmail(email: 'ray@joga.demo', password: 'not-it'),
        throwsA(isA<AuthFailure>().having((f) => f.error, 'error', AuthError.wrongPassword)),
      );
    }, skip: _skip);

    test('profile, Home and stats load', () async {
      final me = await player.currentPlayer();
      expect(me.firstName, 'Ray');
      expect(me.city, City.cardiff);
      expect(me.position, PlayerPosition.winger);

      final home = await player.homeSummary();
      expect(home.stats.games, greaterThan(0));
      expect(home.streak.currentWeeks, 4);
      expect(home.lastResult, isNotNull);
      expect(await player.recentResults(), hasLength(20));
    }, skip: _skip);

    test('Find returns games with players, in each city', () async {
      for (final city in City.values) {
        final found = await games.findGames(GameFilter(city: city));
        expect(found, isNotEmpty, reason: city.label);
        for (final g in found) {
          expect(g.city, city);
        }
      }
      final cardiff = await games.findGames(const GameFilter(city: City.cardiff));
      expect(cardiff.any((g) => g.players.isNotEmpty), isTrue);
    }, skip: _skip);

    test('game details: tonight\'s game is full and Ray is on it', () async {
      final g = await games.getGame(_game(100));
      expect(g.players, hasLength(10));
      expect(g.hasPlayer(_ray), isTrue);
      expect(g.venue.facilities, contains(VenueFacility.defibrillator));
    }, skip: _skip);

    test('Nairobi: priced in shillings, no wallet, can\'t pay yet', () async {
      final q = await bookings.quote(_game(402));
      expect(q.currency, Currency.kes);
      expect(q.gamePence, 40000);
      expect(q.walletAvailablePence, 0);
      final hold = await bookings.holdSpace(_game(402));
      await expectLater(bookings.confirm(hold, useWallet: true), throwsA(isA<StateError>()));
    }, skip: _skip);

    test('book with wallet credit, then cancel for a refund', () async {
      final before = (await wallet.wallet()).balancePence;
      expect(before, greaterThanOrEqualTo(700),
          reason: 'Run `supabase db reset` first: this test spends Ray\'s credit.');

      final q = await bookings.quote(_game(106));
      expect(q.feePence, 100);
      expect(q.totalPence(useWallet: true), 0);

      final hold = await bookings.holdSpace(_game(106));
      final booking = await bookings.confirm(hold, useWallet: true);
      expect(booking.walletUsedPence, 700);
      expect((await games.upcomingFor(_ray)).map((g) => g.id), contains(_game(106)));

      expect(await bookings.cancel(_game(106)), CancelOutcome.refunded);
      expect((await wallet.wallet()).balancePence, before - 100,
          reason: 'game price back, £1 fee kept');
    }, skip: _skip);

    test('backend errors arrive as readable messages', () async {
      await expectLater(
        bookings.holdSpace(_game(104)), // full game
        throwsA(isA<StateError>().having((e) => e.message, 'message', contains('full'))),
      );
    }, skip: _skip);

    test('signs out', () async {
      await auth.signOut();
      expect(auth.status, AuthStatus.signedOut);
    }, skip: _skip);
  });

  test('new player: sign up, 6-digit code, profile set-up', () async {
    final fresh = SupabaseAuthRepository(
      _newClient(),
      DbChanges(),
    );
    final email = 'contract.${DateTime.now().millisecondsSinceEpoch}@joga.test';

    await fresh.signUpWithEmail(email: email, password: 'joga-test-2026');
    expect(fresh.status, AuthStatus.needsVerification);
    expect(fresh.pendingEmail, email);

    await expectLater(
      fresh.verifyEmail('000000'),
      throwsA(isA<AuthFailure>().having((f) => f.error, 'error', AuthError.invalidCode)),
    );

    final code = await _codeFromMailpit(email);
    await fresh.verifyEmail(code);
    expect(fresh.status, AuthStatus.needsProfile);

    await fresh.completeProfile(
      const ProfileSetup(
        firstName: 'Contract',
        lastName: 'Test',
        position: PlayerPosition.striker,
        foot: PreferredFoot.left,
        city: City.nairobi,
      ),
    );
    expect(fresh.status, AuthStatus.signedIn);

    await expectLater(
      fresh.signUpWithEmail(email: email, password: 'joga-test-2026'),
      throwsA(isA<AuthFailure>().having((f) => f.error, 'error', AuthError.emailInUse)),
    );
  }, skip: _skip);
}

/// A client for tests. The app itself uses the PKCE flow with the storage
/// supabase_flutter provides; a bare client has no storage, so tests use
/// the implicit flow (same endpoints for password and code sign-in).
SupabaseClient _newClient() => SupabaseClient(
      Env.supabaseUrl,
      Env.supabaseKey,
      authOptions: const AuthClientOptions(authFlowType: AuthFlowType.implicit),
    );

/// The sign-up code from the local test inbox (Mailpit, port 54324).
Future<String> _codeFromMailpit(String email) async {
  final http = HttpClient();
  try {
    for (var attempt = 0; attempt < 20; attempt++) {
      final search = await _getJson(
        http,
        Uri.parse('http://127.0.0.1:54324/api/v1/search?query=${Uri.encodeQueryComponent('to:"$email"')}'),
      );
      final messages = (search['messages'] as List<dynamic>?) ?? const [];
      if (messages.isNotEmpty) {
        final id = (messages.first as Map<String, dynamic>)['ID'];
        final message = await _getJson(http, Uri.parse('http://127.0.0.1:54324/api/v1/message/$id'));
        final text = '${message['Subject']} ${message['Text']}';
        final match = RegExp(r'\b(\d{6})\b').firstMatch(text);
        if (match != null) return match.group(1)!;
      }
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    throw StateError('No sign-up email for $email in Mailpit (http://127.0.0.1:54324).');
  } finally {
    http.close();
  }
}

Future<Map<String, dynamic>> _getJson(HttpClient http, Uri uri) async {
  final request = await http.getUrl(uri);
  final response = await request.close();
  final body = await response.transform(utf8.decoder).join();
  return jsonDecode(body) as Map<String, dynamic>;
}
