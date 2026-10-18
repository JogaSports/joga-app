import '../../data/models/models.dart';
import '../config/app_config.dart';
import '../settings/app_settings.dart';
import 'app_strings.dart';

/// English (default).
class EnStrings extends AppStrings {
  const EnStrings();

  static const _plus = AppConfig.membershipName;

  // Common ------------------------------------------------------------------
  @override
  String get back => 'Back';
  @override
  String get cancel => 'Cancel';
  @override
  String get continueLabel => 'Continue';
  @override
  String get notNow => 'Not now';
  @override
  String get tryAgain => 'Try again';
  @override
  String get somethingWrong =>
      'Something went wrong. Check your connection and try again.';
  @override
  String get close => 'Close';
  @override
  String get seeAll => 'See all';
  @override
  String get save => 'Save';
  @override
  String get demoData => 'Demo data';
  @override
  String comingWithRealApp(String what) => '$what comes with the real app.';

  @override
  String get language => 'Language';
  @override
  String get languageHelp => 'Choose the language for the app.';

  // Dates -------------------------------------------------------------------
  @override
  List<String> get weekdaysShort =>
      const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  @override
  List<String> get weekdaysLong => const [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
  @override
  List<String> get monthsShort => const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
  @override
  String get tonight => 'Tonight';
  @override
  String get tomorrow => 'Tomorrow';
  @override
  String get today => 'Today';
  @override
  String daysToGoN(int days) => '$days days to go';

  // Welcome -----------------------------------------------------------------
  @override
  List<(String, String)> get welcomeSlides => const [
        (
          'Find a game\ntonight.',
          'Organised 5 and 7-a-side across Wales. Book a space in seconds.',
        ),
        (
          'Every goal\ncounts.',
          'Goals, assists, form and player of the match. Your football, '
              'tracked.',
        ),
        (
          'Keep the\nstreak alive.',
          'Play every week to build your streak and earn wallet rewards.',
        ),
      ];
  @override
  String get getStarted => 'Get started';
  @override
  String get haveAccount => 'I already have an account';

  // Sign in / sign up -------------------------------------------------------
  @override
  String get createAccountTitle => 'Create your\naccount';
  @override
  String get createAccountSubtitle => 'It takes less than a minute.';
  @override
  String get signInTitle => 'Welcome\nback';
  @override
  String get signInSubtitle => 'Sign in to see your games and stats.';
  @override
  String get continueWithApple => 'Continue with Apple';
  @override
  String get continueWithGoogle => 'Continue with Google';
  @override
  String get continueWithEmail => 'Continue with email';
  @override
  String get orDivider => 'or';
  @override
  String get switchToSignIn => 'Already have an account? Sign in';
  @override
  String get switchToSignUp => 'New to Joga? Create an account';
  @override
  String get legalNotice =>
      'By continuing you agree to our Terms, Privacy Policy and Player '
      'Code of Conduct. You must be 18 or over.';

  @override
  String get signInEmailTitle => 'Sign in\nwith email';
  @override
  String get signUpEmailTitle => 'Create your\naccount';
  @override
  String get emailLabel => 'Email';
  @override
  String get passwordLabel => 'Password';
  @override
  String get showPassword => 'Show password';
  @override
  String get hidePassword => 'Hide password';
  @override
  String get forgotPassword => 'Forgot password?';
  @override
  String get signIn => 'Sign in';
  @override
  String get createAccount => 'Create account';
  @override
  String get passwordHint => 'At least 8 characters';
  @override
  String get confirmAge => "I'm 18 or over";
  @override
  String get agreeConduct => 'I agree to the Player Code of Conduct';
  @override
  String get readConduct => 'Read it';
  @override
  String get emailInvalid => 'Enter a valid email address';
  @override
  String get passwordTooShort => 'Use at least 8 characters';
  @override
  String get mustConfirmAge => 'You need to be 18 or over to join';
  @override
  String get mustAgreeConduct => 'Please agree to the code of conduct';
  @override
  String authError(AuthError error) => switch (error) {
        AuthError.wrongPassword =>
          "That email and password don't match. Try again or reset your "
              'password.',
        AuthError.emailInUse =>
          "There's already an account with this email. Sign in instead.",
        AuthError.invalidCode =>
          "That code isn't right. Check your email and try again.",
        AuthError.cancelled => 'Sign-in was cancelled.',
        AuthError.network =>
          'No connection. Check your internet and try again.',
      };

  @override
  String get forgotTitle => 'Reset your\npassword';
  @override
  String get forgotBody =>
      "Enter your email and we'll send you a link to reset your password.";
  @override
  String get sendResetLink => 'Send reset link';
  @override
  String get checkInboxTitle => 'Check your\ninbox';
  @override
  String checkInboxBody(String email) => "We've sent a reset link to $email.";
  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String get verifyTitle => 'Check your\nemail';
  @override
  String verifyBody(String email) =>
      'Enter the 6-digit code we sent to $email.';
  @override
  String get verify => 'Verify';
  @override
  String resendIn(int seconds) => 'Resend code in ${seconds}s';
  @override
  String get resendCode => 'Resend code';
  @override
  String get codeSent => 'New code sent.';
  @override
  String get wrongEmail => 'Wrong email? Go back';

  @override
  String get setupTitle => 'Set up your\nplayer profile';
  @override
  String get setupBody =>
      'This helps us find games at your level and track your stats.';
  @override
  String get addPhoto => 'Add photo';
  @override
  String get firstName => 'First name';
  @override
  String get lastName => 'Last name';
  @override
  String get nameRequired => 'Enter your first name';
  @override
  String get positionLabel => 'Position';
  @override
  String get footLabel => 'Preferred foot';
  @override
  String get levelLabel => 'Ability level';
  @override
  String get homeCity => 'Home town or city';
  @override
  String stepOf(int step, int total) => 'Step $step of $total';

  @override
  String get permissionsTitle => 'Two quick\nthings';
  @override
  String get locationTitle => 'Games near you';
  @override
  String get locationBody =>
      'Use your location to show the closest games. We never share it.';
  @override
  String get notificationsTitle => 'Game reminders';
  @override
  String get notificationsBody =>
      'Kick-off reminders, team news and a nudge when your streak is at '
      'risk.';
  @override
  String get allow => 'Allow';
  @override
  String get allowed => 'Allowed';
  @override
  String get letsPlay => "Let's play";

  // Tabs --------------------------------------------------------------------
  @override
  String get tabHome => 'Home';
  @override
  String get tabFind => 'Find';
  @override
  String get tabMyGames => 'My Games';
  @override
  String get tabStats => 'Stats';
  @override
  String get tabProfile => 'Profile';

  // Shared widgets ----------------------------------------------------------
  @override
  String get spacesFull => 'Full';
  @override
  String get spacesLast => 'Last space';
  @override
  String spacesLeft(int n) => '$n left';
  @override
  String spacesCount(int n) => '$n spaces';
  @override
  String sportSoon(String sport) => '$sport · soon';

  // Home --------------------------------------------------------------------
  @override
  String get goodMorning => 'Good morning,';
  @override
  String get goodAfternoon => 'Good afternoon,';
  @override
  String get goodEvening => 'Good evening,';
  @override
  String streakChip(int weeks) => '$weeks-week streak';
  @override
  String get statGames => 'Games';
  @override
  String get statGoals => 'Goals';
  @override
  String get statAssists => 'Assists';
  @override
  String get statPotm => 'POTM';
  @override
  String get yourNextGame => 'Your next game';
  @override
  String get myGamesAction => 'My games';
  @override
  String get kickedOff => 'Kicked off';
  @override
  String kickOffIn(String countdown) => 'Kick-off in $countdown';
  @override
  String get booked => 'Booked';
  @override
  String get streakSafe => 'Streak safe this week';
  @override
  String playBySunday(int weeks) => 'Play by Sunday to hit $weeks weeks';
  @override
  String weeksToReward(int weeks, String reward) =>
      '$weeks weeks to go until $reward.';
  @override
  String get forYou => 'For you';
  @override
  String get reasonYourLevel => 'Your level';
  @override
  String get reasonNearYou => 'Near you';
  @override
  String get noGamesNearYou => 'No new games near you right now';
  @override
  String get noGamesNearYouBody =>
      'New games are added every day. Try another town in Find.';
  @override
  String get membershipPromoTitle => '$_plus · no booking fees';
  @override
  String membershipPromoBody(String price) =>
      '$price a month. Full stats and bigger rewards.';

  // Find --------------------------------------------------------------------
  @override
  String get findTitle => 'Find your\nnext game';
  @override
  String get underPrice => 'Under £7';
  @override
  String get noGamesMatch => 'No games match these filters';
  @override
  String get noGamesMatchBody =>
      'Try another day or town, or clear your filters.';
  @override
  String get clearFilters => 'Clear filters';
  @override
  String resultsSummary(int count, String city) =>
      '$city · $count ${count == 1 ? 'game' : 'games'} · sorted by kick-off';

  // Game details ------------------------------------------------------------
  @override
  String get bibsProvided => 'Bibs provided';
  @override
  String playersCount(int booked, int capacity) =>
      '$booked / $capacity players';
  @override
  String get seePlayers => 'See players';
  @override
  String organiserLine(String name) => '$name · Organiser';
  @override
  String gamesRun(int n) => '$n games run';
  @override
  String surfaceAndParking(String surface, String parking) =>
      '$surface · Parking: $parking';
  @override
  String get getDirections => 'Get directions';
  @override
  String get directionsSoon => 'Opens Apple or Google Maps in the real app.';
  @override
  String get priceGame => 'Game';
  @override
  String get bookingFee => 'Booking fee';
  @override
  String get free => 'Free';
  @override
  String get freeWithMembership => 'Free booking with $_plus ›';
  @override
  String get total => 'Total';
  @override
  String cancellationNote(int hours) =>
      'Free cancellation up to $hours hours before kick-off. After that, '
      "you're refunded if someone else takes your space.";
  @override
  String get youreIn => "You're in · Game day";
  @override
  String get gameFullWaitlist => 'Game full · Join waitlist';
  @override
  String get gameFull => 'Game full';
  @override
  String joinGame(String price) => 'Join game · $price';
  @override
  String get waitlistJoined =>
      "You're on the waitlist. We'll tell you if a space opens.";
  @override
  String get venueAccess => 'Access & safety';
  @override
  String minutes(int n) => '$n mins';
  @override
  String get organiserFirstAid => 'Organiser is first-aid trained';
  @override
  String get conductLink => 'Player code of conduct';

  // Players sheet, report and block -----------------------------------------
  @override
  String get playersInGame => 'Players in this game';
  @override
  String get you => 'You';
  @override
  String get organiserTag => 'Organiser';
  @override
  String get report => 'Report';
  @override
  String get block => 'Block';
  @override
  String get unblock => 'Unblock';
  @override
  String get blockedLabel => 'Blocked';
  @override
  String reportTitle(String name) => 'Report $name';
  @override
  String get reportBody =>
      'Reports are confidential. Our team reviews every report within '
      '24 hours.';
  @override
  String get reportDetailsHint => 'Tell us what happened (optional)';
  @override
  String get sendReport => 'Send report';
  @override
  String get reportSent => 'Thanks. Our team will review this within 24 hours.';
  @override
  String blockTitle(String name) => 'Block $name?';
  @override
  String get blockBody =>
      "You won't see each other's profiles. They won't be told.";
  @override
  String get blockConfirm => 'Block player';
  @override
  String blockedToast(String name) => 'Blocked $name.';
  @override
  String unblockedToast(String name) => 'Unblocked $name.';

  // Code of conduct ---------------------------------------------------------
  @override
  String get conductTitle => 'Player code\nof conduct';
  @override
  String get conductIntro =>
      'Joga is for everyone. Every player agrees to this before their first '
      'game.';
  @override
  List<(String, String)> get conductRules => const [
        (
          'Respect everyone',
          'Players, organisers, referees and venue staff. No bullying, no '
              'abuse.',
        ),
        (
          'Zero tolerance for discrimination',
          'Racism, homophobia, sexism or any other discrimination means an '
              'immediate ban.',
        ),
        (
          'Play safe',
          'No reckless tackles or dangerous play. Stop the game if someone '
              'is hurt.',
        ),
        (
          'Fair play',
          "Accept decisions, shake hands at the end, and remember it's a "
              'game.',
        ),
        (
          'Turn up',
          "If you can't make it, cancel in time so someone else gets your "
              'space.',
        ),
        (
          'Speak up',
          'If anything worries you, report it from the game page. Reports '
              'are confidential.',
        ),
      ];
  @override
  String get conductFooter => 'Breaking the code can lead to a ban.';

  // Checkout ----------------------------------------------------------------
  @override
  String get checkoutTitle => 'Lock in\nyour spot';
  @override
  String get holdAgain => 'Hold again';
  @override
  String get confirmWithCredit => 'Confirm · paid with credit';
  @override
  String payAndPlay(String price) => 'Pay $price & play';
  @override
  String get holdEnded => 'Your hold has ended';
  @override
  String get holdActive => 'Space held for you';
  @override
  String get holdEndedBody => 'Hold it again to carry on.';
  @override
  String get holdActiveBody => 'No one else can take it while you pay.';
  @override
  String get walletCredit => 'Wallet credit';
  @override
  String get useWalletCredit => 'Use wallet credit';
  @override
  String available(String price) => '$price available';
  @override
  String freeWith(String name) => 'Free with $name';
  @override
  String get payWith => 'Pay with';
  @override
  String get applePay => 'Apple Pay';
  @override
  String get demoNoPayment => 'Demo: no real payment is taken.';
  @override
  String membersNoFees(String name) => '$name members pay no booking fees';
  @override
  String perMonthLearnMore(String price) => '$price / month · Learn more';

  // Booking confirmed -------------------------------------------------------
  @override
  String get spotLocked => 'Your spot\nis locked!';
  @override
  String get streakSafeBooked => 'Another game this week. Your streak is safe.';
  @override
  String streakKeepsAlive(int weeks) =>
      'This game keeps your $weeks-week streak alive.';
  @override
  String get viewGame => 'View game';
  @override
  String get addToCalendar => 'Add to calendar';
  @override
  String get keepPlaying => 'Keep playing';
  @override
  String get backToHome => 'Back to home';

  // My games ----------------------------------------------------------------
  @override
  String get myGamesTitle => 'My games';
  @override
  String upcomingCount(int n) => 'Upcoming ($n)';
  @override
  String get completed => 'Completed';
  @override
  String get noGamesBooked => 'No games booked yet';
  @override
  String get noGamesBookedBody =>
      'Find a game near you and book a space in seconds.';
  @override
  String get findAGame => 'Find a game';
  @override
  String bookedDaysToGo(String daysToGo) => 'Booked · $daysToGo';
  @override
  String freeCancellationShort(int hours) =>
      'Free cancellation until ${hours}h before kick-off. After that, '
      "you're refunded if your space is filled.";
  @override
  String completedLine(String format, int goals, int assists, bool potm) =>
      '$format · $goals goals · $assists assists${potm ? ' · POTM' : ''}';
  @override
  String get noCompleted => 'No completed games yet';
  @override
  String get noCompletedBody =>
      'Your results and stats appear here after each game.';
  @override
  String get cancelTitle => 'Cancel this game?';
  @override
  String cancelLate(int hours) =>
      "It's less than $hours hours to kick-off. We'll release your space, "
      "and you'll be refunded to your wallet if someone takes it.";
  @override
  String get cancelRefund => "You'll get a full refund to your wallet.";
  @override
  String get yesCancel => 'Yes, cancel';
  @override
  String get keepSpot => 'Keep my spot';
  @override
  String cancelledRefunded(String price) =>
      'Cancelled. $price is back in your wallet.';
  @override
  String get cancelledIfFilled =>
      "Cancelled. You'll be refunded if your space is filled.";
  @override
  String scoreLine(MatchResult r) =>
      '${r.won ? 'W' : r.drew ? 'D' : 'L'} ${r.myScore}–${r.theirScore}';

  // Stats -------------------------------------------------------------------
  @override
  String get statsTitle => 'Your football';
  @override
  String get formLast10 => 'Form · last 10 games';
  @override
  String get win => 'Win';
  @override
  String get streakLast12 => 'Streak · last 12 weeks';
  @override
  String get details => 'Details';
  @override
  String get currentLabel => 'Current ';
  @override
  String weeksN(int n) => '$n weeks';
  @override
  String bestN(int n) => ' · Best $n';
  @override
  String get deeperStats => 'Deeper stats';
  @override
  String get goalsPerGame => 'Goals / game';
  @override
  String get winRate => 'Win rate';
  @override
  String get cityRank => 'City rank';
  @override
  String get bestVenue => 'Best venue';
  @override
  String get involvementsPerGame => 'Goal involvements / game';
  @override
  String get potmRate => 'POTM rate';
  @override
  String unlockWith(String name) => 'Unlock with $name';
  @override
  String cityTableRank(String city, int rank) =>
      "$city table · you're #$rank this month";

  // Profile -----------------------------------------------------------------
  @override
  String reliable(int percent) => '$percent% reliable';
  @override
  String get menuMyStats => 'My stats';
  @override
  String get menuMyGames => 'My games';
  @override
  String get menuWallet => 'Wallet';
  @override
  String get active => 'Active';
  @override
  String get join => 'Join';
  @override
  String get menuStreak => 'Streak';
  @override
  String get menuLeaderboard => 'City leaderboard';
  @override
  String get menuReferrals => 'Referrals';
  @override
  String get referralsValue => 'Give £2, get £2';
  @override
  String get menuImpact => 'Community impact';
  @override
  String get menuConduct => 'Code of conduct';
  @override
  String get menuSettings => 'Settings';
  @override
  String get signOut => 'Sign out';
  @override
  String get deleteAccount => 'Delete account';
  @override
  String get deleteTitle => 'Delete your account?';
  @override
  String get deleteBody =>
      "This removes your profile, stats and wallet credit. It can't be "
      'undone.';
  @override
  String get keepAccount => 'Keep my account';
  @override
  String get demoSection => 'Demo';
  @override
  String get viewAppAs => 'View the app as';
  @override
  String get openAdmin => 'Open admin dashboard';
  @override
  String get allScreens => 'All screens (demo index)';

  // Settings ----------------------------------------------------------------
  @override
  String get settingsTitle => 'Settings';
  @override
  String get notificationsSection => 'Notifications';
  @override
  String notificationType(NotificationType type) => switch (type) {
        NotificationType.kickOff => 'Kick-off reminders',
        NotificationType.streak => 'Streak at risk',
        NotificationType.newGames => 'New games near you',
        NotificationType.results => 'Results and stats',
      };
  @override
  String get privacySection => 'Privacy & safety';
  @override
  String get blockedPlayers => 'Blocked players';
  @override
  String get noBlocked => "You haven't blocked anyone.";
  @override
  String get shareStats => 'Show my stats on leaderboards';
  @override
  String get accessibilitySection => 'Accessibility';
  @override
  String get reduceMotion => 'Reduce motion';
  @override
  String get reduceMotionHelp => 'Turns off celebrations and animations.';
  @override
  String get demoTools => 'Demo tools';
  @override
  String get resetDemo => 'Reset demo';
  @override
  String get resetDemoBody =>
      'Puts all demo data back to the start and signs out.';
  @override
  String get resetDone => 'Demo reset.';
  @override
  String get phoneFrame => 'Phone frame on large screens';
  @override
  String version(String v) => 'Joga Sports · version $v';

  // Community impact --------------------------------------------------------
  @override
  String get impactTitle => 'Community\nimpact';
  @override
  String get impactSubtitle =>
      'Grassroots participation across Wales, measured from real bookings '
      'and attendance.';
  @override
  String get impactDemoBanner =>
      'Illustrative demo data. Live figures come from bookings once the app '
      'launches.';
  @override
  String impactPeriod(ImpactPeriod period) => switch (period) {
        ImpactPeriod.month => 'Last 30 days',
        ImpactPeriod.season => 'This season',
        ImpactPeriod.sinceLaunch => 'Since launch',
      };
  @override
  String get activePlayers => 'Active players';
  @override
  String get gamesPlayed => 'Games played';
  @override
  String get playerHours => 'Hours of football';
  @override
  String get newPlayers => 'New players';
  @override
  String get returners => 'Back playing';
  @override
  String returnersHelp(int percent) =>
      "$percent% of new players hadn't played organised football in the "
      'past year';
  @override
  String get retention => 'Still playing after 4 weeks';
  @override
  String get women => 'Women and girls';
  @override
  String womenHelp(int games) => "$games women's games";
  @override
  String get walkingGames => 'Walking football sessions';
  @override
  String get welshGames => 'Welsh-language games';
  @override
  String get averageFill => 'Average game fill';
  @override
  String get monthlyActiveTitle => 'Active players by month';
  @override
  String get byTown => 'By town';
  @override
  String get inclusionTitle => 'Reach and inclusion';
  @override
  String townLine(String players, String games) =>
      '$players players · $games games';
  @override
  String growth(int percent) => '+$percent%';
  @override
  String get sessionMix => 'Mix of games';
  @override
  String sessionType(SessionType type) => switch (type) {
        SessionType.open => 'Mixed / open',
        SessionType.womens => "Women's",
        SessionType.beginner => 'Beginner-friendly',
        SessionType.over30s => 'Over-30s',
        SessionType.walking => 'Walking football',
        SessionType.welshLanguage => 'Welsh-language',
      };
  @override
  String get exportReport => 'Export report';
  @override
  String get exportSoon => 'Monthly PDF reports come with the real app.';
  @override
  String get privacyNote =>
      'All figures are aggregated. No individual player can be identified.';
  @override
  String get pilot => 'Pilot';

  // Presenter ---------------------------------------------------------------
  @override
  String get presenterTitle => 'Interactive demo';
  @override
  String get presenterHint =>
      'Find, book and play organised football, with stats, streaks and '
      'rewards.';
  @override
  String get jumpTo => 'Jump to';
  @override
  String get welcomeScreen => 'Welcome';

  // Enum labels -------------------------------------------------------------
  @override
  String city(City city) => city.label;
  @override
  String level(SkillLevel level) => level.label;
  @override
  String format(GameFormat format) => format.label;
  @override
  String tag(GameTag tag) => tag.label;
  @override
  String day(DayFilter day) => day.label;
  @override
  String sport(Sport sport) => sport.label;
  @override
  String position(PlayerPosition position) => position.label;
  @override
  String foot(PreferredFoot foot) => foot.label;
  @override
  String facility(VenueFacility facility) => facility.label;
  @override
  String reportReason(ReportReason reason) => reason.label;
  @override
  String role(UserRole role) => switch (role) {
        UserRole.player => 'Player',
        UserRole.organiser => 'Organiser',
        UserRole.admin => 'Admin',
      };
  @override
  String period(StatsPeriod period) => period.label;
}
