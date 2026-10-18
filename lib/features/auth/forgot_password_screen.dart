import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/app_scope.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/widgets.dart';
import 'auth_helpers.dart';

/// Sends a password reset link. Real version: Supabase
/// `resetPasswordForEmail`, with the email sent through Resend.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _busy = false;
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await context.services.auth.sendPasswordReset(_email.text.trim());
      if (mounted) setState(() => _sent = true);
    } catch (e) {
      if (mounted) showAuthError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    if (_sent) {
      return JogaScaffold(
        showBack: true,
        bottom: JogaButton(
          label: s.backToSignIn,
          onPressed: () => context.pop(),
        ),
        children: [
          const SizedBox(height: Space.xl),
          EmptyState(
            icon: Icons.mark_email_read_outlined,
            title: s.checkInboxTitle.replaceAll('\n', ' '),
            message: s.checkInboxBody(_email.text.trim()),
          ),
        ],
      );
    }

    return Form(
      key: _form,
      child: JogaScaffold(
        showBack: true,
        bottom: JogaButton(
          label: s.sendResetLink,
          loading: _busy,
          onPressed: _send,
        ),
        children: [
          const SizedBox(height: Space.md),
          Headline(s.forgotTitle),
          Text(
            s.forgotBody,
            style: AppText.body.copyWith(color: AppColors.textSecondary),
          ),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            autocorrect: false,
            onFieldSubmitted: (_) => _send(),
            decoration: InputDecoration(
              labelText: s.emailLabel,
              prefixIcon: const Icon(Icons.mail_outline_rounded),
            ),
            validator: (v) => isValidEmail(v ?? '') ? null : s.emailInvalid,
          ),
        ],
      ),
    );
  }
}
