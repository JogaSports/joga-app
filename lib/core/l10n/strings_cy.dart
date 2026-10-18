import '../../data/models/models.dart';
import '../config/app_config.dart';
import '../settings/app_settings.dart';
import 'app_strings.dart';

/// Welsh (Cymraeg).
///
/// DRAFT: must be checked by a fluent Welsh speaker before it goes to
/// anyone outside the team. Uses the "chi" form throughout. See
/// docs/WELSH.md for the review process.
class CyStrings extends AppStrings {
  const CyStrings();

  static const _plus = AppConfig.membershipName;

  // Common ------------------------------------------------------------------
  @override
  String get back => 'Yn ôl';
  @override
  String get cancel => 'Canslo';
  @override
  String get continueLabel => 'Parhau';
  @override
  String get notNow => 'Nid nawr';
  @override
  String get tryAgain => 'Rhowch gynnig arall arni';
  @override
  String get somethingWrong =>
      "Aeth rhywbeth o'i le. Gwiriwch eich cysylltiad a rhowch gynnig arall "
      'arni.';
  @override
  String get close => 'Cau';
  @override
  String get seeAll => "Gweld y cyfan";
  @override
  String get save => 'Cadw';
  @override
  String get demoData => 'Data demo';
  @override
  String comingWithRealApp(String what) => "$what: yn dod gyda'r ap go iawn.";

  @override
  String get language => 'Iaith';
  @override
  String get languageHelp => 'Dewiswch iaith yr ap.';

  // Dates -------------------------------------------------------------------
  @override
  List<String> get weekdaysShort =>
      const ['Llun', 'Maw', 'Mer', 'Iau', 'Gwe', 'Sad', 'Sul'];
  @override
  List<String> get weekdaysLong => const [
        'Dydd Llun',
        'Dydd Mawrth',
        'Dydd Mercher',
        'Dydd Iau',
        'Dydd Gwener',
        'Dydd Sadwrn',
        'Dydd Sul',
      ];
  @override
  List<String> get monthsShort => const [
        'Ion',
        'Chwef',
        'Maw',
        'Ebr',
        'Mai',
        'Meh',
        'Gorff',
        'Awst',
        'Medi',
        'Hyd',
        'Tach',
        'Rhag',
      ];
  @override
  String get tonight => 'Heno';
  @override
  String get tomorrow => 'Yfory';
  @override
  String get today => 'Heddiw';
  @override
  String daysToGoN(int days) => '$days diwrnod i fynd';

  // Welcome -----------------------------------------------------------------
  @override
  List<(String, String)> get welcomeSlides => const [
        (
          'Dewch o hyd i\ngêm heno.',
          "Gemau 5 a 7 bob ochr wedi'u trefnu ledled Cymru. Archebwch le "
              'mewn eiliadau.',
        ),
        (
          'Mae pob gôl\nyn cyfrif.',
          "Goliau, cymorth, perfformiad a chwaraewr y gêm. Eich pêl-droed, "
              "wedi'i gofnodi.",
        ),
        (
          "Cadwch y\nrhediad i fynd.",
          "Chwaraewch bob wythnos i adeiladu eich rhediad ac ennill gwobrau "
              "i'ch waled.",
        ),
      ];
  @override
  String get getStarted => 'Dechrau arni';
  @override
  String get haveAccount => 'Mae gen i gyfrif yn barod';

  // Sign in / sign up -------------------------------------------------------
  @override
  String get createAccountTitle => 'Creu eich\ncyfrif';
  @override
  String get createAccountSubtitle => "Mae'n cymryd llai na munud.";
  @override
  String get signInTitle => 'Croeso\nyn ôl';
  @override
  String get signInSubtitle =>
      "Mewngofnodwch i weld eich gemau a'ch ystadegau.";
  @override
  String get continueWithApple => 'Parhau gydag Apple';
  @override
  String get continueWithGoogle => 'Parhau gyda Google';
  @override
  String get continueWithEmail => 'Parhau gydag e-bost';
  @override
  String get orDivider => 'neu';
  @override
  String get switchToSignIn => 'Oes gennych chi gyfrif? Mewngofnodi';
  @override
  String get switchToSignUp => 'Newydd i Joga? Creu cyfrif';
  @override
  String get legalNotice =>
      "Wrth barhau, rydych chi'n cytuno i'n Telerau, ein Polisi Preifatrwydd "
      "a'r Cod Ymddygiad i Chwaraewyr. Rhaid i chi fod yn 18 oed neu'n hŷn.";

  @override
  String get signInEmailTitle => 'Mewngofnodi\ngydag e-bost';
  @override
  String get signUpEmailTitle => 'Creu eich\ncyfrif';
  @override
  String get emailLabel => 'E-bost';
  @override
  String get passwordLabel => 'Cyfrinair';
  @override
  String get showPassword => 'Dangos cyfrinair';
  @override
  String get hidePassword => 'Cuddio cyfrinair';
  @override
  String get forgotPassword => 'Wedi anghofio eich cyfrinair?';
  @override
  String get signIn => 'Mewngofnodi';
  @override
  String get createAccount => 'Creu cyfrif';
  @override
  String get passwordHint => 'O leiaf 8 nod';
  @override
  String get confirmAge => "Rwy'n 18 oed neu'n hŷn";
  @override
  String get agreeConduct => "Rwy'n cytuno i'r Cod Ymddygiad i Chwaraewyr";
  @override
  String get readConduct => 'Darllen';
  @override
  String get emailInvalid => 'Rhowch gyfeiriad e-bost dilys';
  @override
  String get passwordTooShort => 'Defnyddiwch o leiaf 8 nod';
  @override
  String get mustConfirmAge => "Rhaid i chi fod yn 18 oed neu'n hŷn i ymuno";
  @override
  String get mustAgreeConduct => "Cytunwch i'r cod ymddygiad";
  @override
  String authError(AuthError error) => switch (error) {
        AuthError.wrongPassword =>
          "Dydy'r e-bost a'r cyfrinair ddim yn cyfateb. Rhowch gynnig arall "
              'arni neu ailosodwch eich cyfrinair.',
        AuthError.emailInUse =>
          "Mae cyfrif gyda'r e-bost hwn yn barod. Mewngofnodwch yn lle hynny.",
        AuthError.invalidCode =>
          "Dydy'r cod ddim yn gywir. Gwiriwch eich e-bost a rhowch gynnig "
              'arall arni.',
        AuthError.cancelled => "Cafodd y mewngofnodi ei ganslo.",
        AuthError.network =>
          'Dim cysylltiad. Gwiriwch eich rhyngrwyd a rhowch gynnig arall '
              'arni.',
      };

  @override
  String get forgotTitle => 'Ailosod eich\ncyfrinair';
  @override
  String get forgotBody =>
      "Rhowch eich e-bost a byddwn ni'n anfon dolen i ailosod eich "
      'cyfrinair.';
  @override
  String get sendResetLink => 'Anfon dolen';
  @override
  String get checkInboxTitle => 'Gwiriwch eich\nmewnflwch';
  @override
  String checkInboxBody(String email) =>
      'Rydyn ni wedi anfon dolen ailosod i $email.';
  @override
  String get backToSignIn => "Yn ôl i fewngofnodi";

  @override
  String get verifyTitle => 'Gwiriwch eich\ne-bost';
  @override
  String verifyBody(String email) =>
      "Rhowch y cod 6 digid a anfonon ni i $email.";
  @override
  String get verify => 'Gwirio';
  @override
  String resendIn(int seconds) => 'Ailanfon y cod mewn ${seconds}e';
  @override
  String get resendCode => 'Ailanfon y cod';
  @override
  String get codeSent => "Cod newydd wedi'i anfon.";
  @override
  String get wrongEmail => 'E-bost anghywir? Ewch yn ôl';

  @override
  String get setupTitle => 'Creu eich\nproffil chwaraewr';
  @override
  String get setupBody =>
      "Mae hyn yn ein helpu i ddod o hyd i gemau ar eich lefel a chofnodi "
      'eich ystadegau.';
  @override
  String get addPhoto => 'Ychwanegu llun';
  @override
  String get firstName => 'Enw cyntaf';
  @override
  String get lastName => 'Cyfenw';
  @override
  String get nameRequired => 'Rhowch eich enw cyntaf';
  @override
  String get positionLabel => 'Safle';
  @override
  String get footLabel => 'Hoff droed';
  @override
  String get levelLabel => 'Lefel gallu';
  @override
  String get homeCity => 'Tref neu ddinas gartref';
  @override
  String stepOf(int step, int total) => 'Cam $step o $total';

  @override
  String get permissionsTitle => 'Dau beth\nsydyn';
  @override
  String get locationTitle => 'Gemau yn agos atoch chi';
  @override
  String get locationBody =>
      'Defnyddiwch eich lleoliad i weld y gemau agosaf. Fyddwn ni byth yn ei '
      'rannu.';
  @override
  String get notificationsTitle => 'Nodiadau atgoffa';
  @override
  String get notificationsBody =>
      "Nodyn atgoffa cyn y gic gyntaf, newyddion tîm, a phrociad pan fydd "
      'eich rhediad mewn perygl.';
  @override
  String get allow => 'Caniatáu';
  @override
  String get allowed => "Wedi'i ganiatáu";
  @override
  String get letsPlay => 'Amdani!';

  // Tabs --------------------------------------------------------------------
  @override
  String get tabHome => 'Hafan';
  @override
  String get tabFind => 'Chwilio';
  @override
  String get tabMyGames => 'Fy Ngemau';
  @override
  String get tabStats => 'Ystadegau';
  @override
  String get tabProfile => 'Proffil';

  // Shared widgets ----------------------------------------------------------
  @override
  String get spacesFull => 'Llawn';
  @override
  String get spacesLast => 'Un lle ar ôl';
  @override
  String spacesLeft(int n) => '$n ar ôl';
  @override
  String spacesCount(int n) => '$n lle';
  @override
  String sportSoon(String sport) => '$sport · cyn bo hir';

  // Home --------------------------------------------------------------------
  @override
  String get goodMorning => 'Bore da,';
  @override
  String get goodAfternoon => 'Prynhawn da,';
  @override
  String get goodEvening => 'Noswaith dda,';
  @override
  String streakChip(int weeks) => 'Rhediad $weeks wythnos';
  @override
  String get statGames => 'Gemau';
  @override
  String get statGoals => 'Goliau';
  @override
  String get statAssists => 'Cymorth';
  @override
  String get statPotm => 'CyG';
  @override
  String get yourNextGame => 'Eich gêm nesaf';
  @override
  String get myGamesAction => 'Fy ngemau';
  @override
  String get kickedOff => 'Wedi dechrau';
  @override
  String kickOffIn(String countdown) => 'Cic gyntaf mewn $countdown';
  @override
  String get booked => "Wedi'i archebu";
  @override
  String get streakSafe => "Rhediad yn ddiogel yr wythnos hon";
  @override
  String playBySunday(int weeks) =>
      'Chwaraewch erbyn dydd Sul i gyrraedd $weeks wythnos';

  /// The reward label comes from the server in English for now, so the
  /// Welsh version leaves it out.
  @override
  String weeksToReward(int weeks, String reward) =>
      '$weeks wythnos i fynd tan eich gwobr nesaf.';
  @override
  String get forYou => 'I chi';
  @override
  String get reasonYourLevel => 'Eich lefel';
  @override
  String get reasonNearYou => 'Yn agos';
  @override
  String get noGamesNearYou => "Dim gemau newydd yn agos atoch chi nawr";
  @override
  String get noGamesNearYouBody =>
      "Mae gemau newydd yn cael eu hychwanegu bob dydd. Rhowch gynnig ar dref "
      'arall.';
  @override
  String get membershipPromoTitle => '$_plus · dim ffioedd archebu';
  @override
  String membershipPromoBody(String price) =>
      '$price y mis. Ystadegau llawn a gwobrau mwy.';

  // Find --------------------------------------------------------------------
  @override
  String get findTitle => "Dewch o hyd i'ch\ngêm nesaf";
  @override
  String get underPrice => 'Llai na £7';
  @override
  String get noGamesMatch => "Does dim gemau'n cyfateb i'r hidlwyr hyn";
  @override
  String get noGamesMatchBody =>
      "Rhowch gynnig ar ddiwrnod neu dref arall, neu cliriwch yr hidlwyr.";
  @override
  String get clearFilters => 'Clirio hidlwyr';
  @override
  String resultsSummary(int count, String city) =>
      "$city · $count gêm · yn ôl amser y gic gyntaf";

  // Game details ------------------------------------------------------------
  @override
  String get bibsProvided => 'Bibiau ar gael';
  @override
  String playersCount(int booked, int capacity) =>
      '$booked / $capacity chwaraewr';
  @override
  String get seePlayers => 'Gweld chwaraewyr';
  @override
  String organiserLine(String name) => '$name · Trefnydd';
  @override
  String gamesRun(int n) => "$n gêm wedi'u trefnu";
  @override
  String surfaceAndParking(String surface, String parking) =>
      '$surface · Parcio: $parking';
  @override
  String get getDirections => 'Cyfarwyddiadau';
  @override
  String get directionsSoon =>
      "Yn agor Apple Maps neu Google Maps yn yr ap go iawn.";
  @override
  String get priceGame => 'Gêm';
  @override
  String get bookingFee => 'Ffi archebu';
  @override
  String get free => 'Am ddim';
  @override
  String get freeWithMembership => 'Archebu am ddim gyda $_plus ›';
  @override
  String get total => 'Cyfanswm';
  @override
  String cancellationNote(int hours) =>
      'Canslo am ddim hyd at $hours awr cyn y gic gyntaf. Ar ôl hynny, cewch '
      'ad-daliad os bydd rhywun arall yn cymryd eich lle.';
  @override
  String get youreIn => "Rydych chi i mewn · Diwrnod gêm";
  @override
  String get gameFullWaitlist => "Gêm yn llawn · Ymuno â'r rhestr aros";
  @override
  String get gameFull => 'Gêm yn llawn';
  @override
  String joinGame(String price) => "Ymuno â'r gêm · $price";
  @override
  String get waitlistJoined =>
      "Rydych chi ar y rhestr aros. Byddwn ni'n rhoi gwybod i chi os bydd "
      'lle yn dod yn rhydd.';
  @override
  String get venueAccess => 'Mynediad a diogelwch';
  @override
  String minutes(int n) => '$n munud';
  @override
  String get organiserFirstAid =>
      "Mae'r trefnydd wedi'i hyfforddi mewn cymorth cyntaf";
  @override
  String get conductLink => 'Cod ymddygiad i chwaraewyr';

  // Players sheet, report and block -----------------------------------------
  @override
  String get playersInGame => "Chwaraewyr yn y gêm hon";
  @override
  String get you => 'Chi';
  @override
  String get organiserTag => 'Trefnydd';
  @override
  String get report => 'Riportio';
  @override
  String get block => 'Blocio';
  @override
  String get unblock => 'Dadflocio';
  @override
  String get blockedLabel => "Wedi'i flocio";
  @override
  String reportTitle(String name) => 'Riportio $name';
  @override
  String get reportBody =>
      "Mae adroddiadau'n gyfrinachol. Mae ein tîm yn adolygu pob adroddiad o "
      'fewn 24 awr.';
  @override
  String get reportDetailsHint => 'Dywedwch wrthon ni beth ddigwyddodd '
      '(dewisol)';
  @override
  String get sendReport => 'Anfon adroddiad';
  @override
  String get reportSent => 'Diolch. Bydd ein tîm yn adolygu hyn o fewn 24 awr.';
  @override
  String blockTitle(String name) => 'Blocio $name?';
  @override
  String get blockBody =>
      "Fyddwch chi ddim yn gweld proffiliau eich gilydd. Fydd dim neges yn "
      'mynd atyn nhw.';
  @override
  String get blockConfirm => 'Blocio chwaraewr';
  @override
  String blockedToast(String name) => 'Wedi blocio $name.';
  @override
  String unblockedToast(String name) => 'Wedi dadflocio $name.';

  // Code of conduct ---------------------------------------------------------
  @override
  String get conductTitle => 'Cod ymddygiad\ni chwaraewyr';
  @override
  String get conductIntro =>
      "Mae Joga i bawb. Mae pob chwaraewr yn cytuno i hyn cyn ei gêm gyntaf.";
  @override
  List<(String, String)> get conductRules => const [
        (
          'Parchu pawb',
          "Chwaraewyr, trefnwyr, dyfarnwyr a staff y lleoliad. Dim bwlio, dim "
              'sarhau.',
        ),
        (
          'Dim goddefgarwch i wahaniaethu',
          'Mae hiliaeth, homoffobia, rhywiaeth neu unrhyw wahaniaethu arall yn '
              'golygu gwaharddiad ar unwaith.',
        ),
        (
          "Chwarae'n ddiogel",
          "Dim taclo byrbwyll na chwarae peryglus. Stopiwch y gêm os bydd "
              "rhywun wedi'i anafu.",
        ),
        (
          'Chwarae teg',
          "Derbyniwch benderfyniadau, ysgwydwch law ar y diwedd, a chofiwch "
              "mai gêm yw hi.",
        ),
        (
          'Troi i fyny',
          "Os na allwch chi ddod, canslwch mewn pryd er mwyn i rywun arall "
              'gael eich lle.',
        ),
        (
          'Codi llais',
          "Os oes rhywbeth yn eich poeni, riportiwch e o dudalen y gêm. Mae "
              "adroddiadau'n gyfrinachol.",
        ),
      ];
  @override
  String get conductFooter => "Gall torri'r cod arwain at waharddiad.";

  // Checkout ----------------------------------------------------------------
  @override
  String get checkoutTitle => 'Sicrhau\neich lle';
  @override
  String get holdAgain => 'Dal eto';
  @override
  String get confirmWithCredit => 'Cadarnhau · talu gyda chredyd';
  @override
  String payAndPlay(String price) => 'Talu $price a chwarae';
  @override
  String get holdEnded => "Mae'r amser dal wedi dod i ben";
  @override
  String get holdActive => "Lle wedi'i ddal i chi";
  @override
  String get holdEndedBody => "Daliwch y lle eto i barhau.";
  @override
  String get holdActiveBody =>
      "All neb arall ei gymryd tra byddwch chi'n talu.";
  @override
  String get walletCredit => 'Credyd waled';
  @override
  String get useWalletCredit => 'Defnyddio credyd waled';
  @override
  String available(String price) => '$price ar gael';
  @override
  String freeWith(String name) => 'Am ddim gyda $name';
  @override
  String get payWith => 'Talu gyda';
  @override
  String get applePay => 'Apple Pay';
  @override
  String get demoNoPayment => 'Demo: does dim taliad go iawn.';
  @override
  String membersNoFees(String name) =>
      'Does dim ffioedd archebu i aelodau $name';
  @override
  String perMonthLearnMore(String price) => '$price / mis · Dysgu mwy';

  // Booking confirmed -------------------------------------------------------
  @override
  String get spotLocked => 'Mae eich lle\nyn saff!';
  @override
  String get streakSafeBooked =>
      "Gêm arall yr wythnos hon. Mae eich rhediad yn ddiogel.";
  @override
  String streakKeepsAlive(int weeks) =>
      "Mae'r gêm hon yn cadw eich rhediad $weeks wythnos i fynd.";
  @override
  String get viewGame => "Gweld y gêm";
  @override
  String get addToCalendar => "Ychwanegu at y calendr";
  @override
  String get keepPlaying => 'Daliwch ati i chwarae';
  @override
  String get backToHome => "Yn ôl i'r hafan";

  // My games ----------------------------------------------------------------
  @override
  String get myGamesTitle => 'Fy ngemau';
  @override
  String upcomingCount(int n) => 'I ddod ($n)';
  @override
  String get completed => 'Wedi gorffen';
  @override
  String get noGamesBooked => "Dim gemau wedi'u harchebu eto";
  @override
  String get noGamesBookedBody =>
      'Dewch o hyd i gêm yn agos atoch chi ac archebwch le mewn eiliadau.';
  @override
  String get findAGame => 'Dod o hyd i gêm';
  @override
  String bookedDaysToGo(String daysToGo) => "Wedi'i archebu · $daysToGo";
  @override
  String freeCancellationShort(int hours) =>
      'Canslo am ddim tan $hours awr cyn y gic gyntaf. Ar ôl hynny, cewch '
      "ad-daliad os bydd eich lle'n cael ei lenwi.";
  @override
  String completedLine(String format, int goals, int assists, bool potm) =>
      '$format · $goals gôl · $assists cymorth${potm ? ' · CyG' : ''}';
  @override
  String get noCompleted => "Dim gemau wedi'u gorffen eto";
  @override
  String get noCompletedBody =>
      "Bydd eich canlyniadau a'ch ystadegau'n ymddangos yma ar ôl pob gêm.";
  @override
  String get cancelTitle => "Canslo'r gêm hon?";
  @override
  String cancelLate(int hours) =>
      "Mae llai na $hours awr tan y gic gyntaf. Byddwn ni'n rhyddhau eich "
      "lle, a chewch ad-daliad i'ch waled os bydd rhywun yn ei gymryd.";
  @override
  String get cancelRefund => "Cewch ad-daliad llawn i'ch waled.";
  @override
  String get yesCancel => 'Ie, canslo';
  @override
  String get keepSpot => 'Cadw fy lle';
  @override
  String cancelledRefunded(String price) =>
      'Wedi canslo. Mae $price yn ôl yn eich waled.';
  @override
  String get cancelledIfFilled =>
      "Wedi canslo. Cewch ad-daliad os bydd eich lle'n cael ei lenwi.";

  /// E = ennill (won), Cyf = cyfartal (drew), C = colli (lost).
  @override
  String scoreLine(MatchResult r) =>
      '${r.won ? 'E' : r.drew ? 'Cyf' : 'C'} ${r.myScore}–${r.theirScore}';

  // Stats -------------------------------------------------------------------
  @override
  String get statsTitle => 'Eich pêl-droed';
  @override
  String get formLast10 => 'Perfformiad · 10 gêm ddiwethaf';
  @override
  String get win => 'Ennill';
  @override
  String get streakLast12 => 'Rhediad · 12 wythnos ddiwethaf';
  @override
  String get details => 'Manylion';
  @override
  String get currentLabel => 'Nawr ';
  @override
  String weeksN(int n) => '$n wythnos';
  @override
  String bestN(int n) => ' · Gorau $n';
  @override
  String get deeperStats => 'Ystadegau manwl';
  @override
  String get goalsPerGame => 'Goliau / gêm';
  @override
  String get winRate => 'Canran ennill';
  @override
  String get cityRank => 'Safle yn y ddinas';
  @override
  String get bestVenue => 'Lleoliad gorau';
  @override
  String get involvementsPerGame => 'Rhan mewn goliau / gêm';
  @override
  String get potmRate => 'Canran CyG';
  @override
  String unlockWith(String name) => 'Datgloi gyda $name';
  @override
  String cityTableRank(String city, int rank) =>
      "Tabl $city · rydych chi'n #$rank y mis hwn";

  // Profile -----------------------------------------------------------------
  @override
  String reliable(int percent) => 'Dibynadwy $percent%';
  @override
  String get menuMyStats => 'Fy ystadegau';
  @override
  String get menuMyGames => 'Fy ngemau';
  @override
  String get menuWallet => 'Waled';
  @override
  String get active => 'Yn weithredol';
  @override
  String get join => 'Ymuno';
  @override
  String get menuStreak => 'Rhediad';
  @override
  String get menuLeaderboard => "Tabl y ddinas";
  @override
  String get menuReferrals => 'Gwahodd ffrindiau';
  @override
  String get referralsValue => 'Rhowch £2, cewch £2';
  @override
  String get menuImpact => 'Effaith gymunedol';
  @override
  String get menuConduct => 'Cod ymddygiad';
  @override
  String get menuSettings => 'Gosodiadau';
  @override
  String get signOut => 'Allgofnodi';
  @override
  String get deleteAccount => 'Dileu cyfrif';
  @override
  String get deleteTitle => 'Dileu eich cyfrif?';
  @override
  String get deleteBody =>
      "Mae hyn yn dileu eich proffil, eich ystadegau a'ch credyd waled. Does "
      'dim modd dadwneud hyn.';
  @override
  String get keepAccount => 'Cadw fy nghyfrif';
  @override
  String get demoSection => 'Demo';
  @override
  String get viewAppAs => "Gweld yr ap fel";
  @override
  String get openAdmin => 'Agor y dangosfwrdd gweinyddu';
  @override
  String get allScreens => 'Pob sgrin (mynegai demo)';

  // Settings ----------------------------------------------------------------
  @override
  String get settingsTitle => 'Gosodiadau';
  @override
  String get notificationsSection => 'Hysbysiadau';
  @override
  String notificationType(NotificationType type) => switch (type) {
        NotificationType.kickOff => 'Nodyn atgoffa cyn y gic gyntaf',
        NotificationType.streak => 'Rhediad mewn perygl',
        NotificationType.newGames => 'Gemau newydd yn agos',
        NotificationType.results => 'Canlyniadau ac ystadegau',
      };
  @override
  String get privacySection => 'Preifatrwydd a diogelwch';
  @override
  String get blockedPlayers => "Chwaraewyr wedi'u blocio";
  @override
  String get noBlocked => 'Dydych chi ddim wedi blocio neb.';
  @override
  String get shareStats => 'Dangos fy ystadegau ar y tablau';
  @override
  String get accessibilitySection => 'Hygyrchedd';
  @override
  String get reduceMotion => 'Lleihau symudiad';
  @override
  String get reduceMotionHelp => 'Yn diffodd dathliadau ac animeiddiadau.';
  @override
  String get demoTools => 'Offer demo';
  @override
  String get resetDemo => 'Ailosod y demo';
  @override
  String get resetDemoBody =>
      "Yn rhoi'r holl ddata demo yn ôl i'r dechrau ac yn allgofnodi.";
  @override
  String get resetDone => "Demo wedi'i ailosod.";
  @override
  String get phoneFrame => 'Ffrâm ffôn ar sgriniau mawr';
  @override
  String version(String v) => 'Joga Sports · fersiwn $v';

  // Community impact --------------------------------------------------------
  @override
  String get impactTitle => 'Effaith\ngymunedol';
  @override
  String get impactSubtitle =>
      "Cyfranogiad ar lawr gwlad ledled Cymru, wedi'i fesur o archebion a "
      'phresenoldeb go iawn.';
  @override
  String get impactDemoBanner =>
      "Data demo enghreifftiol. Bydd ffigurau byw yn dod o archebion pan "
      "fydd yr ap yn lansio.";
  @override
  String impactPeriod(ImpactPeriod period) => switch (period) {
        ImpactPeriod.month => 'Y 30 diwrnod diwethaf',
        ImpactPeriod.season => "Y tymor hwn",
        ImpactPeriod.sinceLaunch => 'Ers lansio',
      };
  @override
  String get activePlayers => 'Chwaraewyr gweithgar';
  @override
  String get gamesPlayed => "Gemau wedi'u chwarae";
  @override
  String get playerHours => 'Oriau o bêl-droed';
  @override
  String get newPlayers => 'Chwaraewyr newydd';
  @override
  String get returners => "Yn ôl yn chwarae";
  @override
  String returnersHelp(int percent) =>
      "Doedd $percent% o chwaraewyr newydd ddim wedi chwarae pêl-droed "
      "wedi'i drefnu yn y flwyddyn ddiwethaf";
  @override
  String get retention => "Yn dal i chwarae ar ôl 4 wythnos";
  @override
  String get women => 'Menywod a merched';
  @override
  String womenHelp(int games) => '$games gêm i fenywod';
  @override
  String get walkingGames => 'Sesiynau pêl-droed cerdded';
  @override
  String get welshGames => 'Gemau Cymraeg';
  @override
  String get averageFill => 'Llenwi gemau ar gyfartaledd';
  @override
  String get monthlyActiveTitle => 'Chwaraewyr gweithgar bob mis';
  @override
  String get byTown => 'Fesul tref';
  @override
  String get inclusionTitle => 'Cyrhaeddiad a chynhwysiant';
  @override
  String townLine(String players, String games) =>
      '$players chwaraewr · $games gêm';
  @override
  String growth(int percent) => '+$percent%';
  @override
  String get sessionMix => 'Cymysgedd o gemau';
  @override
  String sessionType(SessionType type) => switch (type) {
        SessionType.open => 'Cymysg / agored',
        SessionType.womens => 'Menywod',
        SessionType.beginner => 'Addas i ddechreuwyr',
        SessionType.over30s => 'Dros 30',
        SessionType.walking => 'Pêl-droed cerdded',
        SessionType.welshLanguage => 'Cymraeg',
      };
  @override
  String get exportReport => 'Allforio adroddiad';
  @override
  String get exportSoon =>
      "Mae adroddiadau PDF misol yn dod gyda'r ap go iawn.";
  @override
  String get privacyNote =>
      "Mae pob ffigur wedi'i gyfuno. Does dim modd adnabod unrhyw chwaraewr "
      'unigol.';
  @override
  String get pilot => 'Peilot';

  // Presenter ---------------------------------------------------------------
  @override
  String get presenterTitle => 'Demo rhyngweithiol';
  @override
  String get presenterHint =>
      "Dod o hyd i bêl-droed wedi'i drefnu, archebu a chwarae, gydag "
      'ystadegau, rhediadau a gwobrau.';
  @override
  String get jumpTo => 'Neidio i';
  @override
  String get welcomeScreen => 'Croeso';

  // Enum labels -------------------------------------------------------------
  @override
  String city(City city) => switch (city) {
        City.cardiff => 'Caerdydd',
        City.swansea => 'Abertawe',
        City.newport => 'Casnewydd',
        City.wrexham => 'Wrecsam',
        City.bristol => 'Bryste',
      };
  @override
  String level(SkillLevel level) => switch (level) {
        SkillLevel.beginner => 'Dechreuwyr',
        SkillLevel.intermediate => 'Canolradd',
        SkillLevel.competitive => 'Cystadleuol',
      };
  @override
  String format(GameFormat format) => switch (format) {
        GameFormat.fiveASide => '5 bob ochr',
        GameFormat.sevenASide => '7 bob ochr',
      };
  @override
  String tag(GameTag tag) => switch (tag) {
        GameTag.casual => 'Hamddenol',
        GameTag.competitive => 'Cystadleuol',
        GameTag.mixed => 'Cymysg',
        GameTag.over30s => 'Dros 30',
        GameTag.womens => 'Menywod',
        GameTag.walking => 'Pêl-droed cerdded',
        GameTag.welshSpeaking => 'Cymraeg',
      };
  @override
  String day(DayFilter day) => switch (day) {
        DayFilter.all => 'Unrhyw ddiwrnod',
        DayFilter.today => 'Heno',
        DayFilter.tomorrow => 'Yfory',
        DayFilter.weekend => 'Penwythnos',
      };
  @override
  String sport(Sport sport) => switch (sport) {
        Sport.football => 'Pêl-droed',
        Sport.padel => 'Padel',
        Sport.badminton => 'Badminton',
      };
  @override
  String position(PlayerPosition position) => switch (position) {
        PlayerPosition.goalkeeper => 'Gôl-geidwad',
        PlayerPosition.defender => 'Amddiffynnwr',
        PlayerPosition.midfielder => 'Canol cae',
        PlayerPosition.winger => 'Asgellwr',
        PlayerPosition.striker => 'Ymosodwr',
      };
  @override
  String foot(PreferredFoot foot) => switch (foot) {
        PreferredFoot.left => 'Chwith',
        PreferredFoot.right => 'De',
        PreferredFoot.both => 'Y ddwy',
      };
  @override
  String facility(VenueFacility facility) => switch (facility) {
        VenueFacility.stepFree => 'Mynediad heb risiau',
        VenueFacility.accessibleToilet => 'Toiled hygyrch',
        VenueFacility.changingRooms => 'Ystafelloedd newid',
        VenueFacility.defibrillator => 'Diffibriliwr ar y safle',
        VenueFacility.firstAid => 'Pecyn cymorth cyntaf',
        VenueFacility.floodlights => 'Llifoleuadau',
        VenueFacility.parking => 'Parcio',
      };
  @override
  String reportReason(ReportReason reason) => switch (reason) {
        ReportReason.abuse => 'Iaith sarhaus',
        ReportReason.discrimination => 'Gwahaniaethu',
        ReportReason.violence => 'Ymddygiad treisgar',
        ReportReason.unsafePlay => 'Chwarae peryglus',
        ReportReason.noShow => "Methu troi i fyny dro ar ôl tro",
        ReportReason.other => 'Rhywbeth arall',
      };
  @override
  String role(UserRole role) => switch (role) {
        UserRole.player => 'Chwaraewr',
        UserRole.organiser => 'Trefnydd',
        UserRole.admin => 'Gweinyddwr',
      };
  @override
  String period(StatsPeriod period) => switch (period) {
        StatsPeriod.career => 'Gyrfa',
        StatsPeriod.season => 'Tymor',
        StatsPeriod.month => 'Mis',
      };
}
