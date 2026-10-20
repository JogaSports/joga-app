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

/// Wraps the whole app.
///
/// On a phone it does nothing (apart from honouring "Reduce motion"). On a
/// laptop or projector it shows the app inside an iPhone-sized frame, with
/// a presenter panel beside it: jump-to shortcuts and a reset, so a live
/// demo never gets stuck.
///
/// Demo only. In the real app, return [child] (keep the reduce-motion
/// part).
class PresenterFrame extends StatelessWidget {
  const PresenterFrame({super.key, required this.router, required this.child});

  final GoRouter router;
  final Widget child;

  static const _screen = Size(390, 844);
  static const _bezel = 12.0;
  static const _minWidth = 760.0;
  static const _panelWidth = 1120.0;

  @override
  Widget build(BuildContext context) {
    final settings = context.services.settings;
    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) {
        final media = MediaQuery.of(context);
        final reduceMotion = settings.reduceMotion || media.disableAnimations;
        final app = MediaQuery(
          data: media.copyWith(disableAnimations: reduceMotion),
          child: child,
        );

        final wide = media.size.width >= _minWidth && media.size.height >= 560;
        if (!wide || !settings.phoneFrame) return app;

        final showPanel = media.size.width >= _panelWidth;
        return ColoredBox(
          color: const Color(0xFF050605),
          child: Stack(
            children: [
              const Positioned.fill(child: _Backdrop()),
              Row(
                children: [
                  if (showPanel)
                    SizedBox(
                      width: 340,
                      child: _PresenterPanel(router: router),
                    ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(Space.xl),
                        child: FittedBox(
                          child: _Device(
                            child: MediaQuery(
                              data: media.copyWith(
                                size: _screen,
                                padding: const EdgeInsets.only(
                                  top: 47,
                                  bottom: 30,
                                ),
                                viewPadding: const EdgeInsets.only(
                                  top: 47,
                                  bottom: 30,
                                ),
                                viewInsets: EdgeInsets.zero,
                                disableAnimations: reduceMotion,
                              ),
                              child: child,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (showPanel) const SizedBox(width: 340),
                ],
              ),
              if (!showPanel)
                Positioned(
                  top: Space.lg,
                  left: Space.lg,
                  child: _CompactTools(router: router),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Jumps straight to [path] from the presenter panel.
///
/// The sign-in guard would otherwise bounce the jump: app screens redirect
/// to Welcome when signed out, and Welcome redirects to Home when signed
/// in. So this signs in as Ray for app screens, and
/// signs out for Welcome, before navigating.
Future<void> presenterJump(
  BuildContext context,
  GoRouter router,
  String path,
) async {
  final auth = context.services.auth;
  final wantsSignedOut = Routes.signedOutOnly.contains(path);
  final open = Routes.open.contains(path);
  if (wantsSignedOut && auth.status != AuthStatus.signedOut) {
    await auth.signOut();
  } else if (!wantsSignedOut && !open && !auth.isSignedIn) {
    await auth.signInWithApple();
  }
  router.go(path);
}

/// iPhone-style frame with a status bar and dynamic island.
class _Device extends StatelessWidget {
  const _Device({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const screen = PresenterFrame._screen;
    const bezel = PresenterFrame._bezel;
    return Container(
      width: screen.width + bezel * 2,
      height: screen.height + bezel * 2,
      padding: const EdgeInsets.all(bezel),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D1E),
        borderRadius: BorderRadius.circular(56),
        border: Border.all(color: const Color(0xFF34393A), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.lime.withValues(alpha: 0.08),
            blurRadius: 80,
            spreadRadius: 4,
          ),
          const BoxShadow(
            color: Colors.black,
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(44),
        child: Stack(
          children: [
            Positioned.fill(child: child),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(child: _StatusBar()),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontFamily: 'Barlow',
      fontWeight: FontWeight.w700,
      fontSize: 15,
      color: AppColors.textPrimary,
    );
    return ExcludeSemantics(
      child: SizedBox(
        height: 47,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 34,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Text('9:41', style: style),
                  Spacer(),
                  Icon(
                    Icons.signal_cellular_alt_rounded,
                    size: 17,
                    color: AppColors.textPrimary,
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.wifi_rounded,
                    size: 17,
                    color: AppColors.textPrimary,
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.battery_full_rounded,
                    size: 19,
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Subtle floodlight glow behind the phone.
class _Backdrop extends StatelessWidget {
  const _Backdrop();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.2, -0.6),
          radius: 1.1,
          colors: [
            AppColors.lime.withValues(alpha: 0.07),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class _PresenterPanel extends StatelessWidget {
  const _PresenterPanel({required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final services = context.services;
    final shortcuts = <(IconData, String, String)>[
      (Icons.waving_hand_rounded, s.welcomeScreen, Routes.welcome),
      (Icons.home_rounded, s.tabHome, Routes.home),
      (Icons.search_rounded, s.tabFind, Routes.find),
      (Icons.bar_chart_rounded, s.tabStats, Routes.stats),
      (Icons.insights_rounded, s.menuImpact, Routes.impact),
      (Icons.grid_view_rounded, s.allScreens, Routes.demo),
    ];

    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Space.xxl, Space.xxl, 0, Space.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const JogaLogo(size: 30),
            const SizedBox(height: Space.xl),
            Headline(s.presenterTitle, style: AppText.h2),
            const SizedBox(height: Space.sm),
            Text(s.presenterHint, style: AppText.small),
            const SizedBox(height: Space.xl),
            Text(s.jumpTo.toUpperCase(), style: AppText.label),
            const SizedBox(height: Space.xs),
            for (final (icon, label, path) in shortcuts)
              _PanelLink(
                icon: icon,
                label: label,
                onTap: () => presenterJump(context, router, path),
              ),
            const Spacer(),
            if (services.resetDemo != null)
              _PanelLink(
                icon: Icons.restart_alt_rounded,
                label: s.resetDemo,
                onTap: () {
                  services.resetDemo!();
                  router.go(Routes.welcome);
                },
              ),
            _PanelLink(
              icon: Icons.fullscreen_rounded,
              label: s.phoneFrame,
              trailing: Switch(
                value: services.settings.phoneFrame,
                onChanged: (v) => services.settings.phoneFrame = v,
              ),
              onTap: () => services.settings.phoneFrame = false,
            ),
            const SizedBox(height: Space.sm),
            Text(s.demoData, style: AppText.tiny),
          ],
        ),
      ),
    );
  }
}

class _PanelLink extends StatelessWidget {
  const _PanelLink({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Radii.sm),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.lime),
            const SizedBox(width: Space.md),
            Expanded(child: Text(label, style: AppText.bodyStrong)),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

/// Medium-width screens: just the essentials, top left.
class _CompactTools extends StatelessWidget {
  const _CompactTools({required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final services = context.services;
    return Material(
      type: MaterialType.transparency,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (services.resetDemo != null)
            // No tooltips here: this sits outside the app's Navigator,
            // where there's no Overlay to show them in.
            Semantics(
              label: s.resetDemo,
              child: IconButton.filledTonal(
                onPressed: () {
                  services.resetDemo!();
                  router.go(Routes.welcome);
                },
                icon: const Icon(Icons.restart_alt_rounded),
              ),
            ),
          Semantics(
            label: s.allScreens,
            child: IconButton.filledTonal(
              onPressed: () => presenterJump(context, router, Routes.demo),
              icon: const Icon(Icons.grid_view_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
