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

/// Shown after opening a password reset link: the player is signed in for
/// this one step and picks a new password.
class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _busy = false;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final s = context.s;
    setState(() => _busy = true);
    try {
      await context.services.auth.setNewPassword(_password.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(s.passwordUpdated)));
      context.go(Routes.home);
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showAuthError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Form(
      key: _form,
      child: JogaScaffold(
        bottom: JogaButton(
          label: s.saveNewPassword,
          loading: _busy,
          onPressed: _save,
        ),
        children: [
          const SizedBox(height: Space.md),
          Headline(s.newPasswordTitle),
          Text(
            s.newPasswordBody,
            style: AppText.body.copyWith(color: AppColors.textSecondary),
          ),
          TextFormField(
            controller: _password,
            obscureText: _obscure,
            autofocus: true,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.newPassword],
            onFieldSubmitted: (_) => _save(),
            decoration: InputDecoration(
              labelText: s.newPasswordLabel,
              helperText: s.passwordHint,
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                tooltip: _obscure ? s.showPassword : s.hidePassword,
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
            validator: (v) =>
                (v ?? '').length >= 8 ? null : s.passwordTooShort,
          ),
        ],
      ),
    );
  }
}
