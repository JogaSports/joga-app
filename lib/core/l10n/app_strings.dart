import '../../data/models/models.dart';
import '../settings/app_settings.dart';

/// Every piece of text in the translated screens.
///
/// English ([EnStrings]) is the default and Welsh ([CyStrings]) the second
/// language. Both extend this class, so the app won't compile if a Welsh
/// string is missing. Add a string here first, then to both languages.
///
/// Later this can move to ARB files and `flutter gen-l10n` if we add more
/// languages; the screens won't change because they only call `context.s`.
abstract class AppStrings {
  const AppStrings();

  // Common ------------------------------------------------------------------
  String get back;
  String get cancel;
  String get continueLabel;
  String get notNow;
  String get tryAgain;
  String get somethingWrong;
  String get close;
  String get seeAll;
  String get save;
  String get demoData;
  String comingWithRealApp(String what);

  String get language;
  String get languageHelp;

  // Dates -------------------------------------------------------------------
  List<String> get weekdaysShort;
  List<String> get weekdaysLong;
  List<String> get monthsShort;
  String get tonight;
  String get tomorrow;
  String get today;
  String daysToGoN(int days);

  // Welcome -----------------------------------------------------------------
  /// (title, body) for each welcome slide.
  List<(String, String)> get welcomeSlides;
  String get getStarted;
  String get haveAccount;

  // Sign in / sign up -------------------------------------------------------
  String get createAccountTitle;
  String get createAccountSubtitle;
  String get signInTitle;
  String get signInSubtitle;
  String get continueWithApple;
  String get continueWithGoogle;
  String get continueWithEmail;
  String get orDivider;
  String get switchToSignIn;
  String get switchToSignUp;
  String get legalNotice;

  String get signInEmailTitle;
  String get signUpEmailTitle;
  String get emailLabel;
  String get passwordLabel;
  String get showPassword;
  String get hidePassword;
  String get forgotPassword;
  String get signIn;
  String get createAccount;
  String get passwordHint;
  String get confirmAge;
  String get agreeConduct;
  String get readConduct;
  String get emailInvalid;
  String get passwordTooShort;
  String get mustConfirmAge;
  String get mustAgreeConduct;
  String authError(AuthError error);

  String get forgotTitle;
  String get forgotBody;
  String get sendResetLink;
  String get checkInboxTitle;
  String checkInboxBody(String email);
  String get backToSignIn;

  String get verifyTitle;
  String verifyBody(String email);
  String get verify;
  String resendIn(int seconds);
  String get resendCode;
  String get codeSent;
  String get wrongEmail;

  String get setupTitle;
  String get setupBody;
  String get addPhoto;
  String get firstName;
  String get lastName;
  String get nameRequired;
  String get positionLabel;
  String get footLabel;
  String get levelLabel;
  String get homeCity;
  String stepOf(int step, int total);

  String get permissionsTitle;
  String get locationTitle;
  String get locationBody;
  String get notificationsTitle;
  String get notificationsBody;
  String get allow;
  String get allowed;
  String get letsPlay;

  // Tabs --------------------------------------------------------------------
  String get tabHome;
  String get tabFind;
  String get tabMyGames;
  String get tabStats;
  String get tabProfile;

  // Shared widgets ----------------------------------------------------------
  String get spacesFull;
  String get spacesLast;
  String spacesLeft(int n);
  String spacesCount(int n);
  String sportSoon(String sport);

  // Home --------------------------------------------------------------------
  String get goodMorning;
  String get goodAfternoon;
  String get goodEvening;
  String streakChip(int weeks);
  String get statGames;
  String get statGoals;
  String get statAssists;
  String get statPotm;
  String get yourNextGame;
  String get myGamesAction;
  String get kickedOff;
  String kickOffIn(String countdown);
  String get booked;
  String get streakSafe;
  String playBySunday(int weeks);
  String weeksToReward(int weeks, String reward);
  String get forYou;
  String get reasonYourLevel;
  String get reasonNearYou;
  String get noGamesNearYou;
  String get noGamesNearYouBody;
  String get membershipPromoTitle;
  String membershipPromoBody(String price);

  // Find --------------------------------------------------------------------
  String get findTitle;
  String get underPrice;
  String get noGamesMatch;
  String get noGamesMatchBody;
  String get clearFilters;
  String resultsSummary(int count, String city);

  // Game details ------------------------------------------------------------
  String get bibsProvided;
  String playersCount(int booked, int capacity);
  String get seePlayers;
  String organiserLine(String name);
  String gamesRun(int n);
  String surfaceAndParking(String surface, String parking);
  String get getDirections;
  String get directionsSoon;
  String get priceGame;
  String get bookingFee;
  String get free;
  String get freeWithMembership;
  String get total;
  String cancellationNote(int hours);
  String get youreIn;
  String get gameFullWaitlist;
  String get gameFull;
  String joinGame(String price);
  String get waitlistJoined;
  String get venueAccess;
  String minutes(int n);
  String get organiserFirstAid;
  String get conductLink;

  // Players sheet, report and block -----------------------------------------
  String get playersInGame;
  String get you;
  String get organiserTag;
  String get report;
  String get block;
  String get unblock;
  String get blockedLabel;
  String reportTitle(String name);
  String get reportBody;
  String get reportDetailsHint;
  String get sendReport;
  String get reportSent;
  String blockTitle(String name);
  String get blockBody;
  String get blockConfirm;
  String blockedToast(String name);
  String unblockedToast(String name);

  // Code of conduct ---------------------------------------------------------
  String get conductTitle;
  String get conductIntro;

  /// (title, body) for each rule.
  List<(String, String)> get conductRules;
  String get conductFooter;

  // Checkout ----------------------------------------------------------------
  String get checkoutTitle;
  String get holdAgain;
  String get confirmWithCredit;
  String payAndPlay(String price);
  String get holdEnded;
  String get holdActive;
  String get holdEndedBody;
  String get holdActiveBody;
  String get walletCredit;
  String get useWalletCredit;
  String available(String price);
  String freeWith(String name);
  String get payWith;
  String get applePay;
  String get demoNoPayment;
  String membersNoFees(String name);
  String perMonthLearnMore(String price);

  // Booking confirmed -------------------------------------------------------
  String get spotLocked;
  String get streakSafeBooked;
  String streakKeepsAlive(int weeks);
  String get viewGame;
  String get addToCalendar;
  String get keepPlaying;
  String get backToHome;

  // My games ----------------------------------------------------------------
  String get myGamesTitle;
  String upcomingCount(int n);
  String get completed;
  String get noGamesBooked;
  String get noGamesBookedBody;
  String get findAGame;
  String bookedDaysToGo(String daysToGo);
  String freeCancellationShort(int hours);
  String completedLine(String format, int goals, int assists, bool potm);
  String get noCompleted;
  String get noCompletedBody;
  String get cancelTitle;
  String cancelLate(int hours);
  String get cancelRefund;
  String get yesCancel;
  String get keepSpot;
  String cancelledRefunded(String price);
  String get cancelledIfFilled;
  String scoreLine(MatchResult result);

  // Stats -------------------------------------------------------------------
  String get statsTitle;
  String get formLast10;
  String get win;
  String get streakLast12;
  String get details;
  String get currentLabel;
  String weeksN(int n);
  String bestN(int n);
  String get deeperStats;
  String get goalsPerGame;
  String get winRate;
  String get cityRank;
  String get bestVenue;
  String get involvementsPerGame;
  String get potmRate;
  String unlockWith(String name);
  String cityTableRank(String city, int rank);

  // Profile -----------------------------------------------------------------
  String reliable(int percent);
  String get menuMyStats;
  String get menuMyGames;
  String get menuWallet;
  String get active;
  String get join;
  String get menuStreak;
  String get menuLeaderboard;
  String get menuReferrals;
  String get referralsValue;
  String get menuImpact;
  String get menuConduct;
  String get menuSettings;
  String get signOut;
  String get deleteAccount;
  String get deleteTitle;
  String get deleteBody;
  String get keepAccount;
  String get demoSection;
  String get viewAppAs;
  String get openAdmin;
  String get allScreens;

  // Settings ----------------------------------------------------------------
  String get settingsTitle;
  String get notificationsSection;
  String notificationType(NotificationType type);
  String get privacySection;
  String get blockedPlayers;
  String get noBlocked;
  String get shareStats;
  String get accessibilitySection;
  String get reduceMotion;
  String get reduceMotionHelp;
  String get demoTools;
  String get resetDemo;
  String get resetDemoBody;
  String get resetDone;
  String get phoneFrame;
  String version(String v);

  // Community impact --------------------------------------------------------
  String get impactTitle;
  String get impactSubtitle;
  String get impactDemoBanner;
  String impactPeriod(ImpactPeriod period);
  String get activePlayers;
  String get gamesPlayed;
  String get playerHours;
  String get newPlayers;
  String get returners;
  String returnersHelp(int percent);
  String get retention;
  String get women;
  String womenHelp(int games);
  String get walkingGames;
  String get welshGames;
  String get averageFill;
  String get monthlyActiveTitle;
  String get byTown;
  String get inclusionTitle;
  String townLine(String players, String games);
  String growth(int percent);
  String get sessionMix;
  String sessionType(SessionType type);
  String get exportReport;
  String get exportSoon;
  String get privacyNote;
  String get pilot;

  // Presenter ---------------------------------------------------------------
  String get presenterTitle;
  String get presenterHint;
  String get jumpTo;
  String get welcomeScreen;

  // Enum labels -------------------------------------------------------------
  String city(City city);
  String level(SkillLevel level);
  String format(GameFormat format);
  String tag(GameTag tag);
  String day(DayFilter day);
  String sport(Sport sport);
  String position(PlayerPosition position);
  String foot(PreferredFoot foot);
  String facility(VenueFacility facility);
  String reportReason(ReportReason reason);
  String role(UserRole role);
  String period(StatsPeriod period);

  // Helpers built on the strings above (shared by both languages) ----------

  /// Tue
  String weekday(DateTime d) => weekdaysShort[d.weekday - 1];

  /// Tuesday
  String weekdayLong(DateTime d) => weekdaysLong[d.weekday - 1];

  /// 7 Oct
  String dayMonth(DateTime d) => '${d.day} ${monthsShort[d.month - 1]}';

  /// Tue 7 Oct
  String shortDate(DateTime d) => '${weekday(d)} ${dayMonth(d)}';

  /// "Tonight", "Tomorrow", or "Thu".
  String relativeDay(DateTime d, {DateTime? now}) {
    final diff = _daysFromToday(d, now);
    if (diff == 0) return tonight;
    if (diff == 1) return tomorrow;
    return weekday(d);
  }

  /// "2 days to go", "Today"
  String daysToGo(DateTime d, {DateTime? now}) {
    final diff = _daysFromToday(d, now);
    if (diff <= 0) return today;
    if (diff == 1) return tomorrow;
    return daysToGoN(diff);
  }

  static int _daysFromToday(DateTime d, DateTime? now) {
    final n = now ?? DateTime.now();
    final today = DateTime(n.year, n.month, n.day);
    return DateTime(d.year, d.month, d.day).difference(today).inDays;
  }
}
