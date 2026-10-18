import '../models/models.dart';

/// Reporting and blocking players.
///
/// Real version: a `reports` table reviewed by the Joga team (alerts for
/// discrimination or violence), and a `blocks` table that hides blocked
/// players from each other's games and lists.
abstract interface class SafetyRepository {
  Future<void> report({
    required Person person,
    required ReportReason reason,
    String details = '',
    String? gameId,
  });

  Future<void> block(Person person);
  Future<void> unblock(Person person);
  Future<List<Person>> blocked();
}
