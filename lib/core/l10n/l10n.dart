import 'package:flutter/widgets.dart';

import 'app_strings.dart';
import 'strings_en.dart';

export 'app_strings.dart';

/// Every piece of text in the app comes from here, so copy lives in one
/// place (`strings_en.dart`) instead of being scattered through screens.
///
/// Usage: `final s = context.s;` then `Text(s.findTitle)`.
///
/// English only. To add a language later, add another `AppStrings`
/// subclass and pick it here based on a setting.
extension StringsContext on BuildContext {
  AppStrings get s => _strings;
}

const AppStrings _strings = EnStrings();
