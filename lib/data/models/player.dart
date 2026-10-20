import 'enums.dart';
import 'person.dart';

/// The signed-in player's profile.
class Player {
  const Player({
    required this.person,
    required this.city,
    required this.position,
    required this.foot,
    required this.memberSince,
    required this.isMember,
    required this.role,
    required this.reliabilityPercent,
  });

  final Person person;
  final City city;
  final PlayerPosition position;
  final PreferredFoot foot;
  final DateTime memberSince;

  /// Has an active Joga+ membership.
  final bool isMember;
  final UserRole role;

  /// Share of booked games the player actually turned up to.
  final int reliabilityPercent;

  String get id => person.id;
  String get firstName => person.firstName;

  Player copyWith({
    Person? person,
    City? city,
    PlayerPosition? position,
    PreferredFoot? foot,
    bool? isMember,
    UserRole? role,
  }) =>
      Player(
        person: person ?? this.person,
        city: city ?? this.city,
        position: position ?? this.position,
        foot: foot ?? this.foot,
        memberSince: memberSince,
        isMember: isMember ?? this.isMember,
        role: role ?? this.role,
        reliabilityPercent: reliabilityPercent,
      );
}
