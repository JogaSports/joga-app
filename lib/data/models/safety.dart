import 'person.dart';

/// Why a player is being reported. Every report is reviewed by the Joga
/// team; discrimination and violence are escalated straight away.
enum ReportReason {
  abuse('Abusive language'),
  discrimination('Discrimination'),
  violence('Violent conduct'),
  unsafePlay('Dangerous play'),
  noShow('Repeated no-shows'),
  other('Something else');

  const ReportReason(this.label);
  final String label;
}

class PlayerReport {
  const PlayerReport({
    required this.person,
    required this.reason,
    required this.details,
    required this.createdAt,
    this.gameId,
  });

  final Person person;
  final ReportReason reason;
  final String details;
  final DateTime createdAt;
  final String? gameId;
}
