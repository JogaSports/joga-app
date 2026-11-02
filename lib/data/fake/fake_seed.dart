import '../../core/config/app_config.dart';
import '../models/models.dart';

/// Dummy data for the demo. Everything here is made up.
///
/// Dates are relative to "now" so the demo always looks live: Ray has a
/// game kicking off in about an hour and a half, and there are games to
/// book over the next few days.
abstract final class FakeSeed {
  // People ------------------------------------------------------------------

  static const ray = Person(id: 'p-ray', firstName: 'Ray', lastName: 'Mensah');

  static const dan = Person(id: 'p-dan', firstName: 'Dan', lastName: 'Thomas');

  static const people = <Person>[
    Person(id: 'p-ade', firstName: 'Ade', lastName: 'Rotimi'),
    Person(id: 'p-sam', firstName: 'Sam', lastName: 'Kelly'),
    Person(id: 'p-liam', firstName: 'Liam', lastName: 'Price'),
    Person(id: 'p-gethin', firstName: 'Gethin', lastName: 'Knight'),
    Person(id: 'p-omar', firstName: 'Omar', lastName: 'Bashir'),
    Person(id: 'p-tomi', firstName: 'Tomi', lastName: 'Fashola'),
    Person(id: 'p-mo', firstName: 'Mo', lastName: 'Nasser'),
    Person(id: 'p-rhys', firstName: 'Rhys', lastName: 'Evans'),
    Person(id: 'p-jack', firstName: 'Jack', lastName: 'Williams'),
    Person(id: 'p-chris', firstName: 'Chris', lastName: 'Davies'),
    Person(id: 'p-alex', firstName: 'Alex', lastName: 'Parry'),
    Person(id: 'p-matt', firstName: 'Matt', lastName: 'Griffiths'),
    Person(id: 'p-tom', firstName: 'Tom', lastName: 'Lewis'),
    Person(id: 'p-kieran', firstName: 'Kieran', lastName: "O'Neill"),
    Person(id: 'p-josh', firstName: 'Josh', lastName: 'Bennett'),
    Person(id: 'p-kwame', firstName: 'Kwame', lastName: 'Asante'),
    Person(id: 'p-dylan', firstName: 'Dylan', lastName: 'Walsh'),
    Person(id: 'p-callum', firstName: 'Callum', lastName: 'Jones'),
    Person(id: 'p-ben', firstName: 'Ben', lastName: 'Hughes'),
    Person(id: 'p-luke', firstName: 'Luke', lastName: 'Stevens'),
    Person(id: 'p-harri', firstName: 'Harri', lastName: 'Watkins'),
    Person(id: 'p-idris', firstName: 'Idris', lastName: 'Yusuf'),
    Person(id: 'p-sophie', firstName: 'Sophie', lastName: 'Hale'),
    Person(id: 'p-amara', firstName: 'Amara', lastName: 'Obi'),
    Person(id: 'p-ellie', firstName: 'Ellie', lastName: 'Morgan'),
    Person(id: 'p-grace', firstName: 'Grace', lastName: 'Lloyd'),
    Person(id: 'p-megan', firstName: 'Megan', lastName: 'Rees'),
    Person(id: 'p-cerys', firstName: 'Cerys', lastName: 'Pugh'),
    Person(id: 'p-ffion', firstName: 'Ffion', lastName: 'Jenkins'),
    Person(id: 'p-nia', firstName: 'Nia', lastName: 'Roberts'),
  ];

  static List<Person> pick(int from, int count) =>
      [for (var i = 0; i < count; i++) people[(from + i) % people.length]];

  // London, Nairobi and Tbilisi regulars and organisers. Same names as the
  // backend's local seed.
  static const marcus = Person(id: 'p-marcus', firstName: 'Marcus', lastName: 'Reid');
  static const chloe = Person(id: 'p-chloe', firstName: 'Chloe', lastName: 'Mensah');
  static const kevin = Person(id: 'p-kevin', firstName: 'Kevin', lastName: 'Mwangi');
  static const giorgi = Person(id: 'p-giorgi', firstName: 'Giorgi', lastName: 'Beridze');

  static const londoners = <Person>[
    Person(id: 'p-zara', firstName: 'Zara', lastName: 'Ahmed'),
    Person(id: 'p-tunde', firstName: 'Tunde', lastName: 'Bakare'),
    Person(id: 'p-jamie', firstName: 'Jamie', lastName: 'Cole'),
    Person(id: 'p-aisha', firstName: 'Aisha', lastName: 'Khan'),
    Person(id: 'p-kofi', firstName: 'Kofi', lastName: 'Boateng'),
    Person(id: 'p-priya', firstName: 'Priya', lastName: 'Shah'),
    Person(id: 'p-ryan', firstName: 'Ryan', lastName: "O'Connor"),
    Person(id: 'p-leon', firstName: 'Leon', lastName: 'Grant'),
    Person(id: 'p-sofia', firstName: 'Sofia', lastName: 'Rossi'),
    Person(id: 'p-dami', firstName: 'Dami', lastName: 'Adeyemi'),
  ];

  static const nairobians = <Person>[
    Person(id: 'p-brian', firstName: 'Brian', lastName: 'Otieno'),
    Person(id: 'p-faith', firstName: 'Faith', lastName: 'Wanjiru'),
    Person(id: 'p-dennis', firstName: 'Dennis', lastName: 'Kiprop'),
    Person(id: 'p-mercy', firstName: 'Mercy', lastName: 'Achieng'),
    Person(id: 'p-collins', firstName: 'Collins', lastName: 'Odhiambo'),
    Person(id: 'p-njeri', firstName: 'Grace', lastName: 'Njeri'),
    Person(id: 'p-peter', firstName: 'Peter', lastName: 'Kamau'),
    Person(id: 'p-ian', firstName: 'Ian', lastName: 'Mutua'),
    Person(id: 'p-lilian', firstName: 'Lilian', lastName: 'Atieno'),
    Person(id: 'p-samuel', firstName: 'Samuel', lastName: 'Kiptoo'),
  ];

  static const tbilisians = <Person>[
    Person(id: 'p-nika', firstName: 'Nika', lastName: 'Kapanadze'),
    Person(id: 'p-luka', firstName: 'Luka', lastName: 'Gelashvili'),
    Person(id: 'p-mariam', firstName: 'Mariam', lastName: 'Lomidze'),
    Person(id: 'p-davit', firstName: 'Davit', lastName: 'Tsiklauri'),
    Person(id: 'p-giga', firstName: 'Giga', lastName: 'Maisuradze'),
    Person(id: 'p-levan', firstName: 'Levan', lastName: 'Chkheidze'),
    Person(id: 'p-nino', firstName: 'Nino', lastName: 'Japaridze'),
    Person(id: 'p-irakli', firstName: 'Irakli', lastName: 'Melia'),
    Person(id: 'p-tamar', firstName: 'Tamar', lastName: 'Abashidze'),
    Person(id: 'p-sandro', firstName: 'Sandro', lastName: 'Gabunia'),
  ];

  /// Regulars in [city], for leaderboards.
  static List<Person> regularsIn(City city) => switch (city) {
        City.cardiff => people.take(12).toList(),
        City.bristol => people.skip(12).take(12).toList(),
        City.london => londoners,
        City.nairobi => nairobians,
        City.tbilisi => tbilisians,
      };

  static List<Person> _from(List<Person> pool, int from, int count) =>
      [for (var i = 0; i < count; i++) pool[(from + i) % pool.length]];

  static Player player(DateTime now) => Player(
        person: ray,
        city: City.cardiff,
        position: PlayerPosition.winger,
        foot: PreferredFoot.right,
        memberSince: DateTime(now.year, now.month - 7),
        isMember: false,
        role: UserRole.player,
        reliabilityPercent: 98,
      );

  // Venues ------------------------------------------------------------------

  static const golCardiff = Venue(
    id: 'v-gol',
    name: 'Gôl Cardiff',
    city: City.cardiff,
    address: 'Leckwith Road, Cardiff CF11 8AZ',
    surface: '3G · moulds or astros',
    parking: 'Free, on site',
    facilities: [
      VenueFacility.floodlights,
      VenueFacility.changingRooms,
      VenueFacility.stepFree,
      VenueFacility.accessibleToilet,
      VenueFacility.defibrillator,
      VenueFacility.firstAid,
      VenueFacility.parking,
    ],
  );
  static const leckwith = Venue(
    id: 'v-leckwith',
    name: 'Leckwith 3G',
    city: City.cardiff,
    address: 'Leckwith Close, Cardiff CF11 8AX',
    surface: '3G · moulds or astros',
    parking: 'Free, on site',
    facilities: [
      VenueFacility.floodlights,
      VenueFacility.changingRooms,
      VenueFacility.stepFree,
      VenueFacility.defibrillator,
      VenueFacility.firstAid,
      VenueFacility.parking,
    ],
  );
  static const canton = Venue(
    id: 'v-canton',
    name: 'Canton Sports Cage',
    city: City.cardiff,
    address: 'Market Road, Cardiff CF5 1QE',
    surface: 'Astro · astros only',
    parking: 'Street parking',
    facilities: [
      VenueFacility.floodlights,
      VenueFacility.firstAid,
    ],
  );
  static const splott = Venue(
    id: 'v-splott',
    name: 'Splott 3G',
    city: City.cardiff,
    address: 'Splott Road, Cardiff CF24 2BZ',
    surface: '3G · moulds or astros',
    parking: 'Pay and display',
    facilities: [
      VenueFacility.floodlights,
      VenueFacility.changingRooms,
      VenueFacility.stepFree,
      VenueFacility.accessibleToilet,
      VenueFacility.defibrillator,
      VenueFacility.firstAid,
    ],
  );
  static const templeQuay = Venue(
    id: 'v-temple',
    name: 'Temple Quay Cage',
    city: City.bristol,
    address: 'Temple Gate, Bristol BS1 6PL',
    surface: 'Astro · astros only',
    parking: 'NCP nearby',
    facilities: [
      VenueFacility.floodlights,
      VenueFacility.firstAid,
    ],
  );
  static const eastville = Venue(
    id: 'v-eastville',
    name: 'Eastville 3G',
    city: City.bristol,
    address: 'Eastville Park, Bristol BS5 6YA',
    surface: '3G · moulds or astros',
    parking: 'Free, on site',
    facilities: [
      VenueFacility.floodlights,
      VenueFacility.changingRooms,
      VenueFacility.defibrillator,
      VenueFacility.firstAid,
      VenueFacility.parking,
    ],
  );
  static const ashton = Venue(
    id: 'v-ashton',
    name: 'Ashton Park Astro',
    city: City.bristol,
    address: 'Blackmoors Lane, Bristol BS3 2JL',
    surface: 'Astro · astros only',
    parking: 'Free, on site',
    facilities: [
      VenueFacility.floodlights,
      VenueFacility.stepFree,
      VenueFacility.firstAid,
      VenueFacility.parking,
    ],
  );

  // London. Made-up venues for the demo.
  static const shoreditch = Venue(
    id: 'v-shoreditch',
    name: 'Shoreditch Cage',
    city: City.london,
    address: 'Shoreditch, London E2',
    surface: 'Astro · astros only',
    parking: 'Street parking',
    facilities: [VenueFacility.floodlights, VenueFacility.firstAid],
  );
  static const hackneyWick = Venue(
    id: 'v-hackney-wick',
    name: 'Hackney Wick 3G',
    city: City.london,
    address: 'Hackney Wick, London E9',
    surface: '3G · moulds or astros',
    parking: 'Pay and display',
    facilities: [
      VenueFacility.floodlights,
      VenueFacility.changingRooms,
      VenueFacility.stepFree,
      VenueFacility.accessibleToilet,
      VenueFacility.defibrillator,
      VenueFacility.firstAid,
    ],
  );

  // Nairobi
  static const westlands = Venue(
    id: 'v-westlands',
    name: 'Westlands Turf',
    city: City.nairobi,
    address: 'Westlands, Nairobi',
    surface: '3G · moulds or astros',
    parking: 'Free, on site',
    facilities: [
      VenueFacility.floodlights,
      VenueFacility.changingRooms,
      VenueFacility.firstAid,
      VenueFacility.parking,
    ],
  );
  static const kilimani = Venue(
    id: 'v-kilimani',
    name: 'Kilimani 5s',
    city: City.nairobi,
    address: 'Kilimani, Nairobi',
    surface: 'Astro · astros only',
    parking: 'Street parking',
    facilities: [VenueFacility.floodlights, VenueFacility.firstAid],
  );

  // Tbilisi
  static const vakePark = Venue(
    id: 'v-vake',
    name: 'Vake Park Pitch',
    city: City.tbilisi,
    address: 'Vake, Tbilisi',
    surface: '3G · moulds or astros',
    parking: 'Free, on site',
    facilities: [
      VenueFacility.floodlights,
      VenueFacility.changingRooms,
      VenueFacility.stepFree,
      VenueFacility.defibrillator,
      VenueFacility.firstAid,
      VenueFacility.parking,
    ],
  );
  static const saburtalo = Venue(
    id: 'v-saburtalo',
    name: 'Saburtalo Cage',
    city: City.tbilisi,
    address: 'Saburtalo, Tbilisi',
    surface: 'Astro · astros only',
    parking: 'Street parking',
    facilities: [VenueFacility.floodlights, VenueFacility.firstAid],
  );

  // Games -------------------------------------------------------------------

  /// Ray's booked game tonight. Used by Game Day, Match Control, Post-game.
  static const tonightGameId = 'g-100';

  /// A game with one space left, for the booking demo.
  static const lastSpaceGameId = 'g-101';

  /// Ray's last completed game.
  static const lastPlayedGameId = 'g-099';

  static List<Game> games(DateTime now) {
    // A kick-off at hh:mm on the city's own clock, [dayOffset] days from
    // today there. UK unless a city is given.
    DateTime at(int dayOffset, int hour,
        [int minute = 0, City city = City.cardiff]) {
      final today = city.wallClock(now);
      return city.instantAt(
          today.year, today.month, today.day + dayOffset, hour, minute);
    }

    int daysToSaturday() =>
        (DateTime.saturday - City.cardiff.wallClock(now).weekday) % 7;

    Game game({
      required String id,
      required GameFormat format,
      required Venue venue,
      required String pitch,
      required DateTime startsAt,
      required List<GameTag> tags,
      required int pricePence,
      required List<Person> players,
      Person organiser = dan,
      int organiserGamesRun = 142,
    }) =>
        Game(
          id: id,
          format: format,
          venue: venue,
          pitch: pitch,
          startsAt: startsAt,
          duration: const Duration(minutes: 60),
          tags: tags,
          pricePence: pricePence,
          players: players,
          organiser: organiser,
          organiserGamesRun: organiserGamesRun,
        );

    return [
      // Ray's game tonight: full, kicks off in 1h 24m.
      game(
        id: tonightGameId,
        format: GameFormat.fiveASide,
        venue: golCardiff,
        pitch: 'Pitch 1',
        startsAt: now.add(const Duration(hours: 1, minutes: 24, seconds: 36)),
        tags: [GameTag.mixed],
        pricePence: 800,
        players: [ray, ...pick(0, 9)],
      ),
      game(
        id: lastSpaceGameId,
        format: GameFormat.fiveASide,
        venue: golCardiff,
        pitch: 'Pitch 2',
        startsAt: at(1, 19),
        tags: [GameTag.mixed],
        pricePence: 800,
        players: pick(4, 9),
      ),
      game(
        id: 'g-102',
        format: GameFormat.sevenASide,
        venue: canton,
        pitch: 'Main cage',
        startsAt: at(1, 20),
        tags: [GameTag.beginner, GameTag.casual],
        pricePence: 600,
        players: pick(8, 8),
        organiser: people[10],
        organiserGamesRun: 56,
      ),
      game(
        id: 'g-103',
        format: GameFormat.fiveASide,
        venue: splott,
        pitch: 'Pitch 3',
        startsAt: at(2, 18, 30),
        tags: [GameTag.mixed],
        pricePence: 700,
        players: pick(12, 6),
      ),
      game(
        id: 'g-104',
        format: GameFormat.sevenASide,
        venue: leckwith,
        pitch: 'Pitch 1',
        startsAt: at(3, 19),
        tags: [GameTag.mixed],
        pricePence: 600,
        players: pick(2, 14),
      ),
      game(
        id: 'g-105',
        format: GameFormat.fiveASide,
        venue: golCardiff,
        pitch: 'Pitch 4',
        startsAt: at(4, 20),
        tags: [GameTag.casual],
        pricePence: 800,
        players: pick(15, 5),
        organiser: people[12],
        organiserGamesRun: 88,
      ),
      game(
        id: 'g-106',
        format: GameFormat.fiveASide,
        venue: leckwith,
        pitch: 'Pitch 2',
        startsAt: at(daysToSaturday() == 0 ? 7 : daysToSaturday(), 10),
        tags: [GameTag.beginner, GameTag.womens, GameTag.casual],
        pricePence: 600,
        players: pick(22, 4),
        organiser: people[23],
        organiserGamesRun: 31,
      ),
      game(
        id: 'g-108',
        format: GameFormat.sevenASide,
        venue: leckwith,
        pitch: 'Pitch 1',
        startsAt: at(daysToSaturday() == 0 ? 7 : daysToSaturday(), 18),
        tags: [GameTag.mixed],
        pricePence: 600,
        players: [ray, ...pick(6, 7)],
      ),
      // Cardiff: inclusive sessions
      game(
        id: 'g-109',
        format: GameFormat.fiveASide,
        venue: canton,
        pitch: 'Main cage',
        startsAt: at(3, 20),
        tags: [GameTag.mixed],
        pricePence: 700,
        players: pick(17, 6),
        organiser: people[20],
        organiserGamesRun: 47,
      ),
      game(
        id: 'g-110',
        format: GameFormat.fiveASide,
        venue: splott,
        pitch: 'Pitch 1',
        startsAt: at(2, 10, 30),
        tags: [GameTag.beginner, GameTag.walking],
        pricePence: 400,
        players: pick(10, 7),
        organiser: people[12],
        organiserGamesRun: 88,
      ),
      // London
      game(
        id: 'g-301',
        format: GameFormat.fiveASide,
        venue: shoreditch,
        pitch: 'Cage',
        startsAt: at(1, 19),
        tags: [GameTag.mixed],
        pricePence: 900,
        players: _from(londoners, 0, 7),
        organiser: marcus,
        organiserGamesRun: 81,
      ),
      game(
        id: 'g-302',
        format: GameFormat.fiveASide,
        venue: hackneyWick,
        pitch: 'Pitch 1',
        startsAt: at(daysToSaturday() == 0 ? 7 : daysToSaturday(), 11),
        tags: [GameTag.beginner, GameTag.womens, GameTag.casual],
        pricePence: 700,
        players: [londoners[0], londoners[3], londoners[5], londoners[8]],
        organiser: chloe,
        organiserGamesRun: 27,
      ),
      game(
        id: 'g-303',
        format: GameFormat.fiveASide,
        venue: hackneyWick,
        pitch: 'Pitch 2',
        startsAt: at(2, 20),
        tags: [GameTag.mixed],
        pricePence: 900,
        players: _from(londoners, 4, 9),
        organiser: marcus,
        organiserGamesRun: 81,
      ),
      // Nairobi (prices in Kenyan cents: 50000 = KSh 500)
      game(
        id: 'g-401',
        format: GameFormat.sevenASide,
        venue: westlands,
        pitch: 'Pitch 1',
        startsAt: at(1, 19, 0, City.nairobi),
        tags: [GameTag.mixed],
        pricePence: 50000,
        players: _from(nairobians, 0, 10),
        organiser: kevin,
        organiserGamesRun: 46,
      ),
      game(
        id: 'g-402',
        format: GameFormat.fiveASide,
        venue: kilimani,
        pitch: 'Cage',
        startsAt: at(3, 18, 0, City.nairobi),
        tags: [GameTag.beginner, GameTag.casual],
        pricePence: 40000,
        players: _from(nairobians, 3, 6),
        organiser: kevin,
        organiserGamesRun: 46,
      ),
      // Tbilisi (prices in tetri: 1500 = 15 ₾)
      game(
        id: 'g-501',
        format: GameFormat.fiveASide,
        venue: vakePark,
        pitch: 'Pitch 1',
        startsAt: at(2, 20, 0, City.tbilisi),
        tags: [GameTag.mixed],
        pricePence: 1500,
        players: _from(tbilisians, 0, 8),
        organiser: giorgi,
        organiserGamesRun: 33,
      ),
      game(
        id: 'g-502',
        format: GameFormat.sevenASide,
        venue: saburtalo,
        pitch: 'Cage',
        startsAt: at(4, 20, 0, City.tbilisi),
        tags: [GameTag.mixed],
        pricePence: 1500,
        players: _from(tbilisians, 2, 9),
        organiser: giorgi,
        organiserGamesRun: 33,
      ),
      // Bristol
      game(
        id: 'g-201',
        format: GameFormat.fiveASide,
        venue: templeQuay,
        pitch: 'Cage A',
        startsAt: at(1, 19, 30),
        tags: [GameTag.mixed],
        pricePence: 750,
        players: pick(3, 7),
        organiser: people[8],
        organiserGamesRun: 64,
      ),
      game(
        id: 'g-202',
        format: GameFormat.sevenASide,
        venue: eastville,
        pitch: 'Pitch 2',
        startsAt: at(2, 20),
        tags: [GameTag.mixed],
        pricePence: 650,
        players: pick(9, 10),
        organiser: people[8],
        organiserGamesRun: 64,
      ),
      game(
        id: 'g-203',
        format: GameFormat.fiveASide,
        venue: ashton,
        pitch: 'Pitch 1',
        startsAt: at(3, 18),
        tags: [GameTag.beginner, GameTag.casual],
        pricePence: 700,
        players: pick(18, 9),
        organiser: people[8],
        organiserGamesRun: 64,
      ),
    ];
  }

  /// Games that finished earlier today without a submitted result. Admin
  /// view only.
  static List<Game> finishedToday(DateTime now) => [
        Game(
          id: 'g-090',
          format: GameFormat.fiveASide,
          venue: canton,
          pitch: 'Main cage',
          startsAt: now.subtract(const Duration(hours: 3)),
          duration: const Duration(minutes: 60),
          tags: const [GameTag.mixed],
          pricePence: 700,
          players: pick(1, 10),
          organiser: people[10],
          organiserGamesRun: 56,
        ),
        Game(
          id: 'g-091',
          format: GameFormat.sevenASide,
          venue: eastville,
          pitch: 'Pitch 1',
          startsAt: now.subtract(const Duration(hours: 2)),
          duration: const Duration(minutes: 60),
          tags: const [GameTag.beginner, GameTag.casual],
          pricePence: 600,
          players: pick(5, 6),
          organiser: people[8],
          organiserGamesRun: 64,
        ),
      ];

  // History -----------------------------------------------------------------

  static MatchResult lastResult(DateTime now) => MatchResult(
        gameId: lastPlayedGameId,
        venueName: golCardiff.name,
        format: GameFormat.fiveASide,
        playedAt: now.subtract(const Duration(days: 7)),
        myTeam: Team.white,
        myScore: 7,
        theirScore: 5,
        goals: 3,
        assists: 2,
        potm: true,
      );

  static List<MatchResult> olderResults(DateTime now) => [
        MatchResult(
          gameId: 'g-095',
          venueName: leckwith.name,
          format: GameFormat.sevenASide,
          playedAt: now.subtract(const Duration(days: 11)),
          myTeam: Team.orange,
          myScore: 4,
          theirScore: 6,
          goals: 1,
          assists: 1,
          potm: false,
        ),
        MatchResult(
          gameId: 'g-093',
          venueName: splott.name,
          format: GameFormat.fiveASide,
          playedAt: now.subtract(const Duration(days: 16)),
          myTeam: Team.white,
          myScore: 5,
          theirScore: 5,
          goals: 2,
          assists: 0,
          potm: false,
        ),
      ];

  static const lastResultRewards = <Reward>[
    Reward(title: 'Player of the match', subtitle: 'Your 4th POTM award'),
    Reward(
      title: '4-week streak',
      subtitle: 'Kept alive for another week',
    ),
  ];

  /// Oldest first. The last item is the game above.
  static const form = <FormEntry>[
    FormEntry(goals: 1, assists: 1, won: true),
    FormEntry(goals: 0, assists: 2, won: false),
    FormEntry(goals: 1, assists: 0, won: true),
    FormEntry(goals: 2, assists: 1, won: true),
    FormEntry(goals: 0, assists: 0, won: false),
    FormEntry(goals: 1, assists: 1, won: true),
    FormEntry(goals: 3, assists: 0, won: true),
    FormEntry(goals: 2, assists: 0, won: false),
    FormEntry(goals: 1, assists: 1, won: false),
    FormEntry(goals: 3, assists: 2, won: true),
  ];

  /// Oldest first. The last item is the current week (not played yet).
  static const lastTwelveWeeks = <bool>[
    true, true, false, true, true, true, false, true, true, true, true, false,
  ];

  static List<WalletEntry> walletEntries(DateTime now) => [
        WalletEntry(
          label: 'Welcome credit',
          type: WalletEntryType.reward,
          amountPence: 300,
          date: now.subtract(const Duration(days: 60)),
        ),
        WalletEntry(
          label: 'Refund · Canton cancelled',
          type: WalletEntryType.refund,
          amountPence: 600,
          date: now.subtract(const Duration(days: 30)),
        ),
        WalletEntry(
          label: 'Game booking · Splott 3G',
          type: WalletEntryType.booking,
          amountPence: -600,
          date: now.subtract(const Duration(days: 16)),
        ),
        WalletEntry(
          label: 'Referral · Sophie',
          type: WalletEntryType.referral,
          amountPence: 200,
          date: now.subtract(const Duration(days: 12)),
        ),
        WalletEntry(
          label: '20 games milestone',
          type: WalletEntryType.reward,
          amountPence: 250,
          date: now.subtract(const Duration(days: 11)),
        ),
      ];

  static const membershipBenefits = AppConfig.membershipBenefits;

  static const referrals = <ReferralEntry>[
    ReferralEntry(name: 'Sophie', stage: ReferralStage.rewarded),
    ReferralEntry(name: 'Josh', stage: ReferralStage.firstGame),
    ReferralEntry(name: 'Kieran', stage: ReferralStage.joined),
  ];
}
