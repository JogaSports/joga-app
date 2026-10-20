import 'package:flutter/material.dart';

import '../../core/di/app_scope.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/models.dart';

/// Community impact: grassroots participation for organisers, partners
/// and funders. Every number is aggregated; no individual player can be
/// identified.
///
/// Demo: illustrative numbers, clearly labelled. Real version: a Postgres
/// view over bookings and attendance, refreshed nightly.
class ImpactScreen extends StatefulWidget {
  const ImpactScreen({super.key});

  @override
  State<ImpactScreen> createState() => _ImpactScreenState();
}

class _ImpactScreenState extends State<ImpactScreen> {
  ImpactPeriod _period = ImpactPeriod.month;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final impact = context.services.impact;
    return JogaScaffold(
      showBack: true,
      actions: [
        TextButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(s.exportSoon)),
          ),
          icon: const Icon(
            Icons.ios_share_rounded,
            size: 18,
            color: AppColors.lime,
          ),
          label: Text(
            s.exportReport,
            style: AppText.smallStrong.copyWith(color: AppColors.lime),
          ),
        ),
      ],
      children: [
        Headline(s.impactTitle),
        Text(
          s.impactSubtitle,
          style: AppText.body.copyWith(color: AppColors.textSecondary),
        ),
        _DemoBanner(text: s.impactDemoBanner),
        ChipRow(
          children: [
            for (final period in ImpactPeriod.values)
              JogaChip.filter(
                label: s.impactPeriod(period),
                selected: period == _period,
                onTap: () => setState(() => _period = period),
              ),
          ],
        ),
        AsyncView<ImpactDashboard>(
          key: ValueKey(_period),
          load: () => impact.dashboard(_period),
          builder: (context, data) => _Dashboard(data: data),
        ),
      ],
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({required this.data});

  final ImpactDashboard data;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final maxShare = data.sessions.fold<int>(
      1,
      (m, x) => x.percent > m ? x.percent : m,
    );
    final maxTown = data.towns.fold<int>(
      1,
      (m, t) => t.players > m ? t.players : m,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _Kpi(
                value: Format.count(data.activePlayers),
                label: s.activePlayers,
                hero: true,
              ),
            ),
            const SizedBox(width: Space.sm),
            Expanded(
              child: _Kpi(
                value: Format.count(data.gamesPlayed),
                label: s.gamesPlayed,
              ),
            ),
          ],
        ),
        const SizedBox(height: Space.sm),
        Row(
          children: [
            Expanded(
              child: _Kpi(
                value: Format.count(data.playerHours),
                label: s.playerHours,
              ),
            ),
            const SizedBox(width: Space.sm),
            Expanded(
              child: _Kpi(
                value: Format.count(data.newPlayers),
                label: s.newPlayers,
              ),
            ),
          ],
        ),
        SectionLabel(s.monthlyActiveTitle),
        JogaCard(
          child: _MonthlyBars(
            months: data.monthlyActive,
            monthNames: s.monthsShort,
          ),
        ),
        SectionLabel(s.inclusionTitle),
        JogaCard(
          child: Column(
            children: [
              _RateRow(
                label: s.returners,
                help: s.returnersHelp(data.returnersPercent),
                percent: data.returnersPercent,
              ),
              const JogaDivider(),
              _RateRow(label: s.retention, percent: data.retentionPercent),
              const JogaDivider(),
              _RateRow(
                label: s.women,
                help: s.womenHelp(data.womensGames),
                percent: data.womenPercent,
              ),
              const JogaDivider(),
              _RateRow(label: s.averageFill, percent: data.averageFillPercent),
              const JogaDivider(),
              PriceRow(
                label: s.walkingGames,
                value: Format.count(data.walkingGames),
              ),
            ],
          ),
        ),
        SectionLabel(s.byTown),
        JogaCard(
          child: Column(
            children: [
              for (var i = 0; i < data.towns.length; i++) ...[
                if (i > 0) const SizedBox(height: Space.md),
                _TownRow(town: data.towns[i], maxPlayers: maxTown),
              ],
            ],
          ),
        ),
        SectionLabel(s.sessionMix),
        JogaCard(
          child: Column(
            children: [
              for (var i = 0; i < data.sessions.length; i++) ...[
                if (i > 0) const SizedBox(height: Space.sm),
                _ShareRow(
                  label: s.sessionType(data.sessions[i].type),
                  percent: data.sessions[i].percent,
                  maxPercent: maxShare,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: Space.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              size: 16,
              color: AppColors.textMuted,
            ),
            const SizedBox(width: Space.sm),
            Expanded(child: Text(s.privacyNote, style: AppText.tiny)),
          ],
        ),
      ],
    );
  }
}

class _DemoBanner extends StatelessWidget {
  const _DemoBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Space.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: AppColors.fire.withValues(alpha: 0.5)),
        color: AppColors.fire.withValues(alpha: 0.08),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.fire),
          const SizedBox(width: Space.sm),
          Expanded(child: Text(text, style: AppText.smallStrong)),
        ],
      ),
    );
  }
}

class _Kpi extends StatelessWidget {
  const _Kpi({required this.value, required this.label, this.hero = false});

  final String value;
  final String label;
  final bool hero;

  @override
  Widget build(BuildContext context) {
    return JogaCard(
      tone: hero ? CardTone.lime : CardTone.normal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppText.number.copyWith(
                fontSize: 34,
                color: hero ? AppColors.lime : AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: Space.xs),
          Text(
            label.toUpperCase(),
            style: AppText.tiny.copyWith(letterSpacing: 0.8),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

/// Single-series column chart: active players per month. The current
/// month is full lime; earlier months are a darker step of the same hue.
/// Hover (web) or long-press (phone) shows the exact value.
///
/// Every part has a fixed slot (value label, bar area, month label), and
/// labels scale down rather than wrap, so it can't overflow at any width.
class _MonthlyBars extends StatelessWidget {
  const _MonthlyBars({required this.months, required this.monthNames});

  final List<(int, int)> months;
  final List<String> monthNames;

  static const _barArea = 140.0;
  static const _valueSlot = 20.0;
  static const _gap = 4.0;

  @override
  Widget build(BuildContext context) {
    final peak = months.fold<int>(1, (m, e) => e.$2 > m ? e.$2 : m);
    return Semantics(
      label: [
        for (final (month, players) in months)
          '${monthNames[month - 1]} ${Format.count(players)}',
      ].join(', '),
      child: ExcludeSemantics(
        child: Column(
          children: [
            SizedBox(
              height: _valueSlot + _gap + _barArea,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var i = 0; i < months.length; i++)
                    Expanded(
                      child: Tooltip(
                        message: '${monthNames[months[i].$1 - 1]}: '
                            '${Format.count(months[i].$2)}',
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: _valueSlot,
                                child: i == months.length - 1
                                    ? FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          Format.count(months[i].$2),
                                          maxLines: 1,
                                          style: AppText.smallStrong,
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(height: _gap),
                              Container(
                                height: _barArea * months[i].$2 / peak,
                                decoration: BoxDecoration(
                                  color: i == months.length - 1
                                      ? AppColors.lime
                                      : AppColors.limeDeep,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.line),
            const SizedBox(height: Space.xs),
            Row(
              children: [
                for (final (month, _) in months)
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        monthNames[month - 1],
                        maxLines: 1,
                        style: AppText.tiny,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RateRow extends StatelessWidget {
  const _RateRow({required this.label, required this.percent, this.help});

  final String label;
  final int percent;
  final String? help;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: AppText.bodyStrong)),
            Text('$percent%', style: AppText.h3.copyWith(color: AppColors.lime)),
          ],
        ),
        const SizedBox(height: Space.xs),
        JogaProgressBar(value: percent / 100),
        if (help != null) ...[
          const SizedBox(height: Space.xs),
          Text(help!, style: AppText.small),
        ],
      ],
    );
  }
}

class _TownRow extends StatelessWidget {
  const _TownRow({required this.town, required this.maxPlayers});

  final TownImpact town;
  final int maxPlayers;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                s.city(town.city),
                style: AppText.bodyStrong,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (!town.city.inWales) ...[
              const SizedBox(width: Space.sm),
              JogaChip(label: s.pilot, tone: ChipTone.muted),
            ],
            const Spacer(),
            JogaChip(
              label: s.growth(town.growthPercent),
              icon: Icons.trending_up_rounded,
              tone: ChipTone.selected,
            ),
          ],
        ),
        const SizedBox(height: Space.xs),
        JogaProgressBar(value: town.players / maxPlayers, height: 8),
        const SizedBox(height: Space.xs),
        Text(
          s.townLine(Format.count(town.players), Format.count(town.games)),
          style: AppText.small,
        ),
      ],
    );
  }
}

class _ShareRow extends StatelessWidget {
  const _ShareRow({
    required this.label,
    required this.percent,
    required this.maxPercent,
  });

  final String label;
  final int percent;

  /// Longest bar's value, so bars are scaled to each other.
  final int maxPercent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(label, style: AppText.small, maxLines: 2),
        ),
        const SizedBox(width: Space.sm),
        Expanded(
          child: JogaProgressBar(value: percent / maxPercent, height: 8),
        ),
        const SizedBox(width: Space.sm),
        SizedBox(
          width: 38,
          child: Text(
            '$percent%',
            style: AppText.smallStrong,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
