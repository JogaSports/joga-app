# Product decisions

Agreed before the build. Change here first, then in code.

| Topic | Decision | Where in code |
|---|---|---|
| Name | Joga Sports; membership is **Joga+** | `AppConfig` |
| Launch sport | Football only. Data model is sport-aware (`Sport`, `GameFormat`) so padel and badminton slot in later | `data/models/enums.dart` |
| Streak rule | **Weekly**: play at least once Monday–Sunday. Joga+ gets one streak freeze a month | `Streak`, `FakeMatchRepository` |
| Player of the match | **Picked by the organiser** in Match control. Player vote can come later | `match_control_screen.dart` |
| Player ratings | **None for now.** Post-game feedback is about the game and organiser, not players | `post_game_screen.dart` |
| Leaderboards, referrals, waitlist | Built, **switched on after the test period** | `FeatureFlags` |
| Admin | **Desktop web first**, with a phone layout for today's games | `admin_screen.dart` |
| Joga+ benefits | No booking fees, full stats, streak freeze, double milestone rewards, early access | `FakeSeed.membershipBenefits` |
| Booking fee | £1 per booking, free for Joga+ | `AppConfig.bookingFeePence` |
| Space hold | 5 minutes while paying | `AppConfig.spaceHold` |
| Cancellation | Free up to 24h before. After that, refunded only if the space is filled | `AppConfig.freeCancellation` |
| Photos | Placeholder pitch graphics until venue photos exist | `PitchPhoto` |
| Demo towns | Demo data covers Cardiff, Swansea, Newport and Wrexham, plus Bristol (marked as outside Wales). Launch towns still to confirm | `City`, `FakeSeed` |
| Languages | **English by default, Welsh second**. Welsh uses the "chi" form and must be checked by a fluent speaker | `core/l10n/` |
| Sign-in | Apple, Google and email. Apple shown first (App Store rule) | `features/auth/` |
| Age | **18+ only** for now, confirmed at sign-up | `email_auth_screen.dart` |
| Conduct | Every player agrees to the code of conduct at sign-up; report and block on every player | `features/safety/` |
| Impact data | Aggregated only; no individual player visible. Demo numbers are labelled as illustrative | `features/impact/` |
| Partner branding | **No Welsh FA or other partner logos** without written permission | – |

## Still to decide

- Which towns launch first (the demo shows five)

- Reward amounts per milestone (placeholders: £2.50 at 25 games, £5 at a
  10-week streak, doubled for Joga+)
- Whether organisers and venues are paid through the platform (Stripe
  Connect)
- Final logo (the `JogaLogo` widget is a placeholder)
