import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/app_scope.dart';
import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/widgets.dart';
import 'auth_helpers.dart';

enum _Provider { apple, google }

/// Sign up or sign in: Apple, Google, or email.
///
/// Apple is first and the same size as Google (App Store rule). In the demo
/// both sign in as Ray straight away.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.signUp});

  final bool signUp;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  _Provider? _busy;

  Future<void> _signIn(_Provider provider) async {
    final auth = context.services.auth;
    setState(() => _busy = provider);
    try {
      await switch (provider) {
        _Provider.apple => auth.signInWithApple(),
        _Provider.google => auth.signInWithGoogle(),
      };
      if (mounted) context.go(Routes.home);
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = null);
      showAuthError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final signUp = widget.signUp;
    final busy = _busy != null;

    return JogaScaffold(
      showBack: true,
      children: [
        const SizedBox(height: Space.md),
        Headline(signUp ? s.createAccountTitle : s.signInTitle),
        Text(
          signUp ? s.createAccountSubtitle : s.signInSubtitle,
          style: AppText.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: Space.md),
        AppleSignInButton(
          busy: _busy == _Provider.apple,
          onPressed: busy ? null : () => _signIn(_Provider.apple),
        ),
        GoogleSignInButton(
          busy: _busy == _Provider.google,
          onPressed: busy ? null : () => _signIn(_Provider.google),
        ),
        _OrDivider(label: s.orDivider),
        JogaButton.secondary(
          label: s.continueWithEmail,
          icon: Icons.mail_outline_rounded,
          onPressed: busy
              ? null
              : () => context.push(Routes.emailMode(signUp: signUp)),
        ),
        const SizedBox(height: Space.sm),
        Center(
          child: TextButton(
            onPressed: busy
                ? null
                : () => context.pushReplacement(
                      Routes.authMode(signUp: !signUp),
                    ),
            child: Text(
              signUp ? s.switchToSignIn : s.switchToSignUp,
              style: AppText.smallStrong.copyWith(color: AppColors.lime),
            ),
          ),
        ),
        const SizedBox(height: Space.lg),
        Text(s.legalNotice, style: AppText.tiny, textAlign: TextAlign.center),
        Center(
          child: TextButton(
            onPressed: () => context.push(Routes.codeOfConduct),
            child: Text(
              s.conductLink,
              style: AppText.tiny.copyWith(
                color: AppColors.textSecondary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.line)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.md),
          child: Text(label, style: AppText.small),
        ),
        const Expanded(child: Divider(color: AppColors.line)),
      ],
    );
  }
}
