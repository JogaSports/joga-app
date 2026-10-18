import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/config/app_config.dart';
import 'core/di/app_scope.dart';
import 'core/di/app_services.dart';
import 'core/l10n/l10n.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/demo/presenter_frame.dart';

/// Root widget: provides services and language, then sets up theme and
/// navigation.
class JogaApp extends StatefulWidget {
  const JogaApp({super.key, required this.services});

  final AppServices services;

  @override
  State<JogaApp> createState() => _JogaAppState();
}

class _JogaAppState extends State<JogaApp> {
  late final GoRouter _router = buildRouter(services: widget.services);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      services: widget.services,
      child: LanguageScope(
        settings: widget.services.settings,
        child: MaterialApp.router(
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.dark,
          routerConfig: _router,
          scrollBehavior: const _AppScrollBehavior(),
          // On a laptop or projector the demo shows inside a phone frame
          // with a presenter panel. On a phone it's full screen as normal.
          builder: (context, child) => PresenterFrame(
            router: _router,
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

/// Lets a mouse or trackpad drag scrollable content on the web and
/// desktop, not just touch. Without this, the welcome slides and the
/// sideways chip rows can't be swiped in the browser demo.
class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
      };
}
