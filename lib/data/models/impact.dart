import 'enums.dart';

enum ImpactPeriod { month, season, sinceLaunch }

/// Participation in one town.
class TownImpact {
  const TownImpact({
    required this.city,
    required this.players,
    required this.games,
    required this.growthPercent,
  });

  final City city;
  final int players;
  final int games;

  /// Change in active players against the previous period.
  final int growthPercent;
}

enum SessionType { open, womens, beginner, over30s, walking, welshLanguage }

/// Share of games by type, e.g. women's games.
class SessionShare {
  const SessionShare({required this.type, required this.percent});

  final SessionType type;
  final int percent;
}

/// Grassroots participation numbers for organisers, partners and funders.
///
/// Real version: a Postgres view over bookings, attendance and profiles,
/// with personal data aggregated away (no individual players visible).
class ImpactDashboard {
  const ImpactDashboard({
    required this.period,
    required this.activePlayers,
    required this.gamesPlayed,
    required this.playerHours,
    required this.newPlayers,
    required this.returnersPercent,
    required this.retentionPercent,
    required this.womenPercent,
    required this.womensGames,
    required this.walkingGames,
    required this.welshLanguageGames,
    required this.averageFillPercent,
    required this.monthlyActive,
    required this.towns,
    required this.sessions,
  });

  final ImpactPeriod period;
  final int activePlayers;
  final int gamesPlayed;
  final int playerHours;
  final int newPlayers;

  /// New players who hadn't played organised football in the last year.
  final int returnersPercent;

  /// Players still playing four weeks after their first game.
  final int retentionPercent;
  final int womenPercent;
  final int womensGames;
  final int walkingGames;
  final int welshLanguageGames;
  final int averageFillPercent;

  /// Active players per month, oldest first. Each entry is (month, players).
  final List<(int, int)> monthlyActive;
  final List<TownImpact> towns;
  final List<SessionShare> sessions;
}
