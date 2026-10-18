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

/// New player's profile: name, position, foot, level and home town. This
/// drives "For you" games and the stats from day one.
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _form = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _last = TextEditingController();
  PlayerPosition _position = PlayerPosition.midfielder;
  PreferredFoot _foot = PreferredFoot.right;
  SkillLevel _level = SkillLevel.intermediate;
  City _city = City.cardiff;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _first.addListener(() => setState(() {}));
    _last.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await context.services.auth.completeProfile(
        ProfileSetup(
          firstName: _first.text.trim(),
          lastName: _last.text.trim(),
          position: _position,
          foot: _foot,
          level: _level,
          city: _city,
        ),
      );
      if (mounted) context.go(Routes.permissions);
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showAuthError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final preview = Person(
      id: 'new',
      firstName: _first.text.trim().isEmpty ? '?' : _first.text.trim(),
      lastName: _last.text.trim(),
    );

    return Form(
      key: _form,
      child: JogaScaffold(
        bottom: JogaButton(
          label: s.continueLabel,
          loading: _busy,
          onPressed: _save,
        ),
        children: [
          const SizedBox(height: Space.md),
          const StepHeader(step: 1, total: 2),
          Headline(s.setupTitle),
          Text(
            s.setupBody,
            style: AppText.body.copyWith(color: AppColors.textSecondary),
          ),
          Row(
            children: [
              PersonAvatar(
                person: preview,
                size: 72,
                highlight: true,
                color: AppColors.lime,
              ),
              const SizedBox(width: Space.md),
              JogaButton.secondary(
                label: s.addPhoto,
                icon: Icons.photo_camera_outlined,
                expand: false,
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(s.comingWithRealApp(s.addPhoto))),
                ),
              ),
            ],
          ),
          TextFormField(
            controller: _first,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.givenName],
            decoration: InputDecoration(labelText: s.firstName),
            validator: (v) => (v ?? '').trim().isEmpty ? s.nameRequired : null,
          ),
          TextFormField(
            controller: _last,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.familyName],
            decoration: InputDecoration(labelText: s.lastName),
          ),
          _Choice<PlayerPosition>(
            label: s.positionLabel,
            values: PlayerPosition.values,
            selected: _position,
            labelOf: s.position,
            onSelected: (v) => setState(() => _position = v),
          ),
          _Choice<PreferredFoot>(
            label: s.footLabel,
            values: PreferredFoot.values,
            selected: _foot,
            labelOf: s.foot,
            onSelected: (v) => setState(() => _foot = v),
          ),
          _Choice<SkillLevel>(
            label: s.levelLabel,
            values: SkillLevel.values,
            selected: _level,
            labelOf: s.level,
            onSelected: (v) => setState(() => _level = v),
          ),
          _Choice<City>(
            label: s.homeCity,
            values: City.values,
            selected: _city,
            labelOf: s.city,
            onSelected: (v) => setState(() => _city = v),
          ),
        ],
      ),
    );
  }
}

class _Choice<T> extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
  });

  final String label;
  final List<T> values;
  final T selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppText.label),
        const SizedBox(height: Space.sm),
        Wrap(
          spacing: Space.sm - 2,
          runSpacing: Space.sm - 2,
          children: [
            for (final value in values)
              JogaChip.filter(
                label: labelOf(value),
                selected: value == selected,
                onTap: () => onSelected(value),
              ),
          ],
        ),
      ],
    );
  }
}
