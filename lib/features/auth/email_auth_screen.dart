import 'package:flutter/material.dart';
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

/// Email and password. Sign-up also asks players to confirm they're 18+
/// and agree to the code of conduct.
class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen({super.key, required this.signUp});

  final bool signUp;

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _over18 = false;
  bool _agreed = false;
  bool _submitted = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final s = context.s;
    setState(() {
      _submitted = true;
      _error = null;
    });
    final valid = _form.currentState!.validate();
    final ticks = !widget.signUp || (_over18 && _agreed);
    if (!valid || !ticks) return;

    final auth = context.services.auth;
    setState(() => _busy = true);
    try {
      if (widget.signUp) {
        await auth.signUpWithEmail(
          email: _email.text.trim(),
          password: _password.text,
        );
        if (mounted) context.go(Routes.verifyEmail);
      } else {
        await auth.signInWithEmail(
          email: _email.text.trim(),
          password: _password.text,
        );
        if (mounted) context.go(Routes.home);
      }
    } on AuthFailure catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = s.authError(e.error);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = s.somethingWrong;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final signUp = widget.signUp;

    return Form(
      key: _form,
      child: AutofillGroup(
        child: JogaScaffold(
          showBack: true,
          bottom: JogaButton(
            label: signUp ? s.createAccount : s.signIn,
            loading: _busy,
            onPressed: _submit,
          ),
          children: [
            const SizedBox(height: Space.md),
            Headline(signUp ? s.signUpEmailTitle : s.signInEmailTitle),
            const SizedBox(height: Space.sm),
            if (_error != null) AuthErrorBanner(message: _error!),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              autocorrect: false,
              decoration: InputDecoration(
                labelText: s.emailLabel,
                prefixIcon: const Icon(Icons.mail_outline_rounded),
              ),
              validator: (v) => isValidEmail(v ?? '') ? null : s.emailInvalid,
            ),
            TextFormField(
              controller: _password,
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              autofillHints: [
                signUp ? AutofillHints.newPassword : AutofillHints.password,
              ],
              onFieldSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: s.passwordLabel,
                helperText: signUp ? s.passwordHint : null,
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
            if (!signUp)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push(Routes.forgotPassword),
                  child: Text(
                    s.forgotPassword,
                    style: AppText.smallStrong.copyWith(color: AppColors.lime),
                  ),
                ),
              ),
            if (signUp) ...[
              _Tick(
                value: _over18,
                label: s.confirmAge,
                error: _submitted && !_over18 ? s.mustConfirmAge : null,
                onChanged: (v) => setState(() => _over18 = v),
              ),
              _Tick(
                value: _agreed,
                label: s.agreeConduct,
                error: _submitted && !_agreed ? s.mustAgreeConduct : null,
                onChanged: (v) => setState(() => _agreed = v),
                link: s.readConduct,
                onLink: () => context.push(Routes.codeOfConduct),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Tick extends StatelessWidget {
  const _Tick({
    required this.value,
    required this.label,
    required this.onChanged,
    this.error,
    this.link,
    this.onLink,
  });

  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;
  final String? error;
  final String? link;
  final VoidCallback? onLink;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MergeSemantics(
          child: InkWell(
            onTap: () => onChanged(!value),
            borderRadius: BorderRadius.circular(Radii.sm),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 44),
              child: Row(
                children: [
                  Checkbox(
                    value: value,
                    onChanged: (v) => onChanged(v ?? false),
                  ),
                  Expanded(child: Text(label, style: AppText.body)),
                ],
              ),
            ),
          ),
        ),
        if (link != null)
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(44, 32),
              ),
              onPressed: onLink,
              child: Text(
                '$link ›',
                style: AppText.small.copyWith(color: AppColors.lime),
              ),
            ),
          ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: Text(
              error!,
              style: AppText.small.copyWith(color: AppColors.danger),
            ),
          ),
      ],
    );
  }
}
