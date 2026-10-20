import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/models.dart';

/// First screen: three swipeable slides explaining Joga, then sign up or
/// sign in.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _pages = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final slides = s.welcomeSlides;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const PitchPhoto(borderRadius: 0, fade: false),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.45, 1],
                colors: [
                  Color(0x66000000),
                  Color(0xCC000000),
                  AppColors.background,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: Space.md),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: JogaLogo(size: 26),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pages,
                      itemCount: slides.length,
                      onPageChanged: (i) => setState(() => _page = i),
                      itemBuilder: (context, i) => _Slide(
                        index: i,
                        title: slides[i].$1,
                        body: slides[i].$2,
                      ),
                    ),
                  ),
                  _Dots(
                    count: slides.length,
                    index: _page,
                    onTap: (i) => _pages.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  const SizedBox(height: Space.xl),
                  JogaButton(
                    label: s.getStarted,
                    onPressed: () =>
                        context.push(Routes.authMode(signUp: true)),
                  ),
                  const SizedBox(height: Space.sm),
                  JogaButton(
                    label: s.haveAccount,
                    variant: JogaButtonVariant.ghost,
                    onPressed: () =>
                        context.push(Routes.authMode(signUp: false)),
                  ),
                  const SizedBox(height: Space.md),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({required this.index, required this.title, required this.body});

  final int index;
  final String title;
  final String body;

  /// Below this height the illustration is dropped and the title shrinks,
  /// so small or landscape screens never overflow.
  static const _compactHeight = 420.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final compact = box.maxHeight < _compactHeight;
        // Scrolls only if the content still doesn't fit.
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: box.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!compact) ...[
                  Center(child: _SlideVisual(index: index)),
                  const SizedBox(height: Space.xl),
                ],
                Text(
                  title.toUpperCase(),
                  style: AppText.hero.copyWith(fontSize: compact ? 38 : 50),
                ),
                const SizedBox(height: Space.md),
                Text(
                  body,
                  style: AppText.body.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A small illustration per slide, built from the app's own components.
class _SlideVisual extends StatelessWidget {
  const _SlideVisual({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return ExcludeSemantics(
      child: switch (index) {
        0 => Wrap(
            alignment: WrapAlignment.center,
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              JogaChip(
                label: s.format(GameFormat.fiveASide),
                icon: Icons.sports_soccer_rounded,
                tone: ChipTone.selected,
              ),
              JogaChip(label: s.format(GameFormat.sevenASide)),
              JogaChip(label: s.spacesLast, tone: ChipTone.danger),
              JogaChip(
                label: s.tonight,
                icon: Icons.nightlight_round,
              ),
            ],
          ),
        1 => SizedBox(
            width: 280,
            child: StatRow(
              tiles: [
                StatTile(value: '18', label: s.statGoals),
                StatTile(value: '11', label: s.statAssists),
                StatTile(
                  value: '4',
                  label: s.statPotm,
                  valueColor: AppColors.lime,
                ),
              ],
            ),
          ),
        _ => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                size: 72,
                color: AppColors.fire,
              ),
              const SizedBox(height: Space.sm),
              JogaChip(label: s.streakChip(4), tone: ChipTone.fire),
            ],
          ),
      },
    );
  }
}

/// Page dots. Each dot is tappable (with a 44px target), so the slides can
/// also be changed by clicking, not only by swiping.
class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index, required this.onTap});

  final int count;
  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < count; i++)
          Semantics(
            button: true,
            selected: i == index,
            label: '${i + 1} / $count',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(i),
              child: SizedBox(
                height: 44,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 6),
                    width: i == index ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == index ? AppColors.lime : AppColors.line,
                      borderRadius: BorderRadius.circular(Radii.pill),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
