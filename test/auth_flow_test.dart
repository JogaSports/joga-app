import 'package:flutter_test/flutter_test.dart';
import 'package:joga_sports/core/di/app_services.dart';
import 'package:joga_sports/data/fake/fake_repositories.dart';
import 'package:joga_sports/data/models/models.dart';

void main() {
  late AppServices services;

  setUp(() => services = AppServices.fake(latency: Duration.zero));

  test('starts signed out', () {
    expect(services.auth.status, AuthStatus.signedOut);
  });

  test('Apple and Google sign straight in', () async {
    await services.auth.signInWithApple();
    expect(services.auth.status, AuthStatus.signedIn);
    await services.auth.signOut();
    await services.auth.signInWithGoogle();
    expect(services.auth.isSignedIn, isTrue);
  });

  test('email sign-up goes through verify and profile setup', () async {
    await services.auth.signUpWithEmail(
      email: 'gareth@example.com',
      password: 'password123',
    );
    expect(services.auth.status, AuthStatus.needsVerification);
    expect(services.auth.pendingEmail, 'gareth@example.com');

    await services.auth.verifyEmail('123456');
    expect(services.auth.status, AuthStatus.needsProfile);

    await services.auth.completeProfile(
      const ProfileSetup(
        firstName: 'Gareth',
        lastName: 'Jones',
        position: PlayerPosition.striker,
        foot: PreferredFoot.left,
        city: City.swansea,
      ),
    );
    final me = await services.player.currentPlayer();
    expect(services.auth.status, AuthStatus.signedIn);
    expect(me.firstName, 'Gareth');
    expect(me.city, City.swansea);
    expect(me.position, PlayerPosition.striker);
  });

  test('error states can be shown on purpose', () async {
    await expectLater(
      services.auth.signInWithEmail(
        email: 'ray@example.com',
        password: FakeAuthRepository.wrongPassword,
      ),
      throwsA(isA<AuthFailure>()),
    );
    await expectLater(
      services.auth.signUpWithEmail(
        email: 'taken@example.com',
        password: 'password123',
      ),
      throwsA(isA<AuthFailure>()),
    );
    await services.auth.signUpWithEmail(
      email: 'new@example.com',
      password: 'password123',
    );
    await expectLater(
      services.auth.verifyEmail(FakeAuthRepository.invalidCode),
      throwsA(isA<AuthFailure>()),
    );
  });

  test('demo reset signs out and restores data', () async {
    await services.auth.signInWithApple();
    await services.membership.subscribe();
    services.resetDemo!();

    final me = await services.player.currentPlayer();
    expect(services.auth.status, AuthStatus.signedOut);
    expect(me.isMember, isFalse);
  });
}
