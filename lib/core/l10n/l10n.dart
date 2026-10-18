import 'package:flutter/widgets.dart';

import '../settings/app_settings.dart';
import 'app_language.dart';
import 'app_strings.dart';
import 'strings_cy.dart';
import 'strings_en.dart';

export 'app_language.dart';
export 'app_strings.dart';

/// Gives every widget the strings for the current language, and rebuilds
/// them when the language changes in Settings.
///
/// Usage: `final s = context.s;` then `Text(s.findTitle)`.
class LanguageScope extends InheritedNotifier<AppSettings> {
  const LanguageScope({
    super.key,
    required AppSettings settings,
    required super.child,
  }) : super(notifier: settings);

  static const _en = EnStrings();
  static const _cy = CyStrings();

  static AppStrings stringsFor(AppLanguage language) => switch (language) {
        AppLanguage.english => _en,
        AppLanguage.welsh => _cy,
      };

  static AppStrings of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LanguageScope>();
    final language = scope?.notifier?.language ?? AppLanguage.english;
    return stringsFor(language);
  }
}

extension StringsContext on BuildContext {
  AppStrings get s => LanguageScope.of(this);
}
