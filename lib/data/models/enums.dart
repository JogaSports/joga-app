// Shared enums for the domain.

/// Sports on the platform. Football launches first; the others are designed
/// in from the start so the data model never assumes football.
enum Sport {
  football('Football', isLive: true),
  padel('Padel', isLive: false),
  badminton('Badminton', isLive: false);

  const Sport(this.label, {required this.isLive});
  final String label;
  final bool isLive;
}

/// Towns and cities with games. Wales launches first; Bristol is the first
/// expansion city outside Wales.
enum City {
  cardiff('Cardiff'),
  swansea('Swansea'),
  newport('Newport'),
  wrexham('Wrexham'),
  bristol('Bristol', inWales: false);

  const City(this.label, {this.inWales = true});
  final String label;
  final bool inWales;
}

/// Game formats. Capacity is total players across both teams.
enum GameFormat {
  fiveASide('5-a-side', Sport.football, 10),
  sevenASide('7-a-side', Sport.football, 14);

  const GameFormat(this.label, this.sport, this.capacity);
  final String label;
  final Sport sport;
  final int capacity;
}

/// Tags that help players find the right game. Joga is recreational
/// football, so there are no ability levels; "Beginner-friendly" marks
/// games that suit people new to playing or coming back to it.
enum GameTag {
  beginner('Beginner-friendly'),
  womens("Women's"),
  mixed('Mixed'),
  walking('Walking football'),
  casual('Casual');

  const GameTag(this.label);
  final String label;
}

enum UserRole { player, organiser, admin }

enum Team {
  white('White'),
  orange('Orange');

  const Team(this.label);
  final String label;
}

enum PlayerPosition {
  goalkeeper('Goalkeeper'),
  defender('Defender'),
  midfielder('Midfielder'),
  winger('Winger'),
  striker('Striker');

  const PlayerPosition(this.label);
  final String label;
}

enum PreferredFoot {
  left('Left'),
  right('Right'),
  both('Both');

  const PreferredFoot(this.label);
  final String label;
}

/// What a venue has on site. Shown on game details so players know about
/// access and safety before they book.
enum VenueFacility {
  stepFree('Step-free access'),
  accessibleToilet('Accessible toilet'),
  changingRooms('Changing rooms'),
  defibrillator('Defibrillator on site'),
  firstAid('First aid kit'),
  floodlights('Floodlit'),
  parking('Parking');

  const VenueFacility(this.label);
  final String label;
}
