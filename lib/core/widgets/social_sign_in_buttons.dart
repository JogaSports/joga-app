import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../l10n/l10n.dart';
import '../theme/app_spacing.dart';

/// Apple's official "Sign in with Apple" button from the
/// `sign_in_with_apple` package, so the logo, font and proportions follow
/// Apple's Human Interface Guidelines.
///
/// White style, because Apple asks for the white button on dark
/// backgrounds. App Store rule: when Google sign-in is offered, Apple must
/// be offered too, at the same size or more prominent, so this goes first.
class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({
    super.key,
    required this.onPressed,
    this.busy = false,
  });

  final VoidCallback? onPressed;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return _BusyOverlay(
      busy: busy,
      enabled: onPressed != null,
      spinnerColor: Colors.black,
      child: SignInWithAppleButton(
        onPressed: onPressed ?? () {},
        text: context.s.continueWithApple,
        height: 50,
        style: SignInWithAppleButtonStyle.white,
        borderRadius: const BorderRadius.all(Radius.circular(Radii.md)),
      ),
    );
  }
}

/// "Continue with Google" button drawn to Google's sign-in branding
/// guidelines (dark theme): #131314 fill, #8E918F 1px border, the
/// standard four-colour "G" mark unaltered, Roboto Medium label.
///
/// Real version: on the web, Google requires its own rendered button
/// (`renderButton` from `google_sign_in_web`), which needs the OAuth client
/// ID; swap it in when wiring auth. On iOS and Android this button stays
/// and calls `google_sign_in` natively.
class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.busy = false,
  });

  final VoidCallback? onPressed;
  final bool busy;

  static const _fill = Color(0xFF131314);
  static const _border = Color(0xFF8E918F);
  static const _text = Color(0xFFE3E3E3);

  @override
  Widget build(BuildContext context) {
    final label = context.s.continueWithGoogle;
    return _BusyOverlay(
      busy: busy,
      enabled: onPressed != null,
      spinnerColor: _text,
      child: Semantics(
        button: true,
        label: label,
        excludeSemantics: true,
        child: Material(
          color: _fill,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.md),
            side: const BorderSide(color: _border),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/brand/google_g.png',
                    width: 20,
                    height: 20,
                    filterQuality: FilterQuality.medium,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontFamilyFallback: ['Barlow'],
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: 0.25,
                        color: _text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Dims a provider button and shows a spinner while signing in, without
/// changing the button itself (both brands ask for it to stay as is).
class _BusyOverlay extends StatelessWidget {
  const _BusyOverlay({
    required this.busy,
    required this.enabled,
    required this.spinnerColor,
    required this.child,
  });

  final bool busy;
  final bool enabled;
  final Color spinnerColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        IgnorePointer(
          ignoring: busy || !enabled,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: enabled || busy ? 1 : 0.5,
            child: child,
          ),
        ),
        if (busy)
          Padding(
            padding: const EdgeInsets.only(right: Space.lg),
            child: SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: spinnerColor,
              ),
            ),
          ),
      ],
    );
  }
}
