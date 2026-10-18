import 'package:flutter/material.dart';

import '../../core/di/app_scope.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/models.dart';

/// Everyone in a game, with report and block on each player.
Future<void> showPlayersSheet(
  BuildContext context, {
  required Game game,
  required String myId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _PlayersSheet(game: game, myId: myId),
  );
}

class _PlayersSheet extends StatelessWidget {
  const _PlayersSheet({required this.game, required this.myId});

  final Game game;
  final String myId;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final services = context.services;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.92,
      builder: (context, scroll) => AsyncView<List<Person>>(
        load: services.safety.blocked,
        builder: (context, blocked) => ListView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(
            Space.gutter,
            0,
            Space.gutter,
            Space.xl,
          ),
          children: [
            Headline(s.playersInGame, style: AppText.h2),
            const SizedBox(height: Space.xs),
            Text(
              s.playersCount(game.booked, game.capacity),
              style: AppText.small,
            ),
            const SizedBox(height: Space.md),
            _PlayerRow(
              person: game.organiser,
              tag: s.organiserTag,
              isMe: game.organiser.id == myId,
              blocked: blocked.contains(game.organiser),
              gameId: game.id,
            ),
            for (final person in game.players)
              _PlayerRow(
                person: person,
                tag: person.id == myId ? s.you : null,
                isMe: person.id == myId,
                blocked: blocked.contains(person),
                gameId: game.id,
              ),
          ],
        ),
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  const _PlayerRow({
    required this.person,
    required this.isMe,
    required this.blocked,
    required this.gameId,
    this.tag,
  });

  final Person person;
  final bool isMe;
  final bool blocked;
  final String gameId;
  final String? tag;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Row(
        children: [
          PersonAvatar(person: person, size: 36, highlight: isMe),
          const SizedBox(width: Space.md),
          Expanded(
            child: Text(
              '${person.firstName} ${person.lastName}',
              style: AppText.bodyStrong.copyWith(
                color: blocked ? AppColors.textMuted : AppColors.textPrimary,
              ),
            ),
          ),
          if (tag != null) JogaChip(label: tag!, tone: ChipTone.muted),
          if (blocked) JogaChip(label: s.blockedLabel, tone: ChipTone.danger),
          if (!isMe)
            PopupMenuButton<String>(
              tooltip: '${s.report} / ${s.block}',
              icon: const Icon(
                Icons.more_horiz_rounded,
                color: AppColors.textMuted,
              ),
              color: AppColors.surfaceRaised,
              onSelected: (action) => switch (action) {
                'report' => showReportSheet(
                    context,
                    person: person,
                    gameId: gameId,
                  ),
                'block' => blocked
                    ? _unblock(context, person)
                    : confirmBlock(context, person),
                _ => null,
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'report',
                  child: Row(
                    children: [
                      const Icon(Icons.flag_outlined, size: 18),
                      const SizedBox(width: Space.sm),
                      Text(s.report),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'block',
                  child: Row(
                    children: [
                      Icon(
                        blocked ? Icons.lock_open_rounded : Icons.block_rounded,
                        size: 18,
                      ),
                      const SizedBox(width: Space.sm),
                      Text(blocked ? s.unblock : s.block),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _unblock(BuildContext context, Person person) async {
    final s = context.s;
    final messenger = ScaffoldMessenger.of(context);
    await context.services.safety.unblock(person);
    messenger.showSnackBar(
      SnackBar(content: Text(s.unblockedToast(person.firstName))),
    );
  }
}

/// Report a player: pick a reason, add details, send.
Future<void> showReportSheet(
  BuildContext context, {
  required Person person,
  String? gameId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _ReportSheet(person: person, gameId: gameId),
  );
}

class _ReportSheet extends StatefulWidget {
  const _ReportSheet({required this.person, this.gameId});

  final Person person;
  final String? gameId;

  @override
  State<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<_ReportSheet> {
  ReportReason? _reason;
  final _details = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final s = context.s;
    final reason = _reason;
    if (reason == null) return;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    await context.services.safety.report(
      person: widget.person,
      reason: reason,
      details: _details.text.trim(),
      gameId: widget.gameId,
    );
    navigator.pop();
    messenger.showSnackBar(SnackBar(content: Text(s.reportSent)));
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Space.gutter,
        0,
        Space.gutter,
        Space.xl + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Headline(s.reportTitle(widget.person.firstName), style: AppText.h2),
            const SizedBox(height: Space.xs),
            Text(s.reportBody, style: AppText.small),
            const SizedBox(height: Space.md),
            Wrap(
              spacing: Space.sm - 2,
              runSpacing: Space.sm - 2,
              children: [
                for (final reason in ReportReason.values)
                  JogaChip.filter(
                    label: s.reportReason(reason),
                    selected: _reason == reason,
                    onTap: () => setState(() => _reason = reason),
                  ),
              ],
            ),
            const SizedBox(height: Space.md),
            TextField(
              controller: _details,
              minLines: 3,
              maxLines: 5,
              maxLength: 500,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(hintText: s.reportDetailsHint),
            ),
            const SizedBox(height: Space.sm),
            JogaButton(
              label: s.sendReport,
              icon: Icons.flag_rounded,
              loading: _busy,
              onPressed: _reason == null ? null : _send,
            ),
          ],
        ),
      ),
    );
  }
}

/// Confirm, then block.
Future<void> confirmBlock(BuildContext context, Person person) async {
  final s = context.s;
  final safety = context.services.safety;
  final messenger = ScaffoldMessenger.of(context);
  final confirmed = await showModalBottomSheet<bool>(
    context: context,
    showDragHandle: true,
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(
        Space.gutter,
        0,
        Space.gutter,
        Space.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Headline(s.blockTitle(person.firstName), style: AppText.h2),
          const SizedBox(height: Space.sm),
          Text(s.blockBody, style: AppText.body),
          const SizedBox(height: Space.lg),
          JogaButton(
            label: s.blockConfirm,
            icon: Icons.block_rounded,
            onPressed: () => Navigator.of(context).pop(true),
          ),
          const SizedBox(height: Space.sm),
          JogaButton.secondary(
            label: s.cancel,
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    ),
  );
  if (confirmed != true) return;
  await safety.block(person);
  messenger.showSnackBar(
    SnackBar(content: Text(s.blockedToast(person.firstName))),
  );
}
