import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/app_scope.dart';
import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/models.dart';
import 'auth_helpers.dart';

/// Six-digit email code. Submits by itself once six digits are in, and
/// supports one-time-code autofill on iOS and Android.
class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  static const _length = 6;
  static const _resendAfter = 30;

  final _code = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  int _wait = _resendAfter;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _code.addListener(_onChanged);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _wait = _resendAfter);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _wait -= 1);
      if (_wait <= 0) t.cancel();
    });
  }

  void _onChanged() {
    // Keep the error visible after the field is cleared; hide it once the
    // player starts typing again.
    setState(() {
      if (_code.text.isNotEmpty) _error = null;
    });
    if (_code.text.length == _length && !_busy) _verify();
  }

  Future<void> _verify() async {
    final s = context.s;
    setState(() => _busy = true);
    try {
      await context.services.auth.verifyEmail(_code.text);
      if (mounted) context.go(Routes.profileSetup);
    } on AuthFailure catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = s.authError(e.error);
      });
      _code.clear();
      _focus.requestFocus();
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showAuthError(context, e);
    }
  }

  Future<void> _resend() async {
    final s = context.s;
    await context.services.auth.resendCode();
    if (!mounted) return;
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s.codeSent)),
    );
  }

  Future<void> _wrongEmail() async {
    await context.services.auth.signOut();
    if (mounted) context.go(Routes.emailMode(signUp: true));
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final email = context.services.auth.pendingEmail ?? '';

    return JogaScaffold(
      bottom: JogaButton(
        label: s.verify,
        loading: _busy,
        onPressed: _code.text.length == _length ? _verify : null,
      ),
      children: [
        const SizedBox(height: Space.xl),
        Headline(s.verifyTitle),
        Text(
          s.verifyBody(email),
          style: AppText.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: Space.sm),
        _CodeBoxes(
          controller: _code,
          focusNode: _focus,
          length: _length,
          hasError: _error != null,
        ),
        if (_error != null) AuthErrorBanner(message: _error!),
        Row(
          children: [
            TextButton(
              onPressed: _wait > 0 ? null : _resend,
              child: Text(
                _wait > 0 ? s.resendIn(_wait) : s.resendCode,
                style: AppText.smallStrong.copyWith(
                  color: _wait > 0 ? AppColors.textMuted : AppColors.lime,
                ),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: _wrongEmail,
              child: Text(s.wrongEmail, style: AppText.small),
            ),
          ],
        ),
      ],
    );
  }
}

/// Six boxes drawn over one invisible text field, so paste, autofill and
/// backspace all work the way people expect.
class _CodeBoxes extends StatelessWidget {
  const _CodeBoxes({
    required this.controller,
    required this.focusNode,
    required this.length,
    required this.hasError,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final int length;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final code = controller.text;
    return SizedBox(
      height: 64,
      child: Stack(
        children: [
          Row(
            children: [
              for (var i = 0; i < length; i++) ...[
                if (i > 0) const SizedBox(width: Space.sm),
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(Radii.md),
                      border: Border.all(
                        width: 1.5,
                        color: hasError
                            ? AppColors.danger
                            : i == code.length && focusNode.hasFocus
                                ? AppColors.lime
                                : AppColors.line,
                      ),
                    ),
                    child: Text(
                      i < code.length ? code[i] : '',
                      style: AppText.number.copyWith(fontSize: 28),
                    ),
                  ),
                ),
              ],
            ],
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
                showCursor: false,
                enableInteractiveSelection: false,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(length),
                ],
                decoration: const InputDecoration(
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
