# Screens

30 screens plus the demo index, grouped by the player loop.
"After test" screens are built but switched off for the MVP via
`FeatureFlags`.

| # | Stage | Screen | Route | File | Scope |
|---|---|---|---|---|---|
| 1 | Join | Welcome | `/welcome` | `features/auth/welcome_screen.dart` | MVP |
| 1a | Join | Sign up / sign in (Apple, Google, email) | `/auth?mode=` | `features/auth/sign_in_screen.dart` | MVP |
| 1b | Join | Email sign in / sign up | `/auth/email?mode=` | `features/auth/email_auth_screen.dart` | MVP |
| 1c | Join | Forgot password | `/auth/forgot` | `features/auth/forgot_password_screen.dart` | MVP |
| 1d | Join | Verify email (6-digit code) | `/auth/verify` | `features/auth/verify_email_screen.dart` | MVP |
| 1e | Join | Profile setup | `/setup/profile` | `features/auth/profile_setup_screen.dart` | MVP |
| 1f | Join | Permissions | `/setup/permissions` | `features/auth/permissions_screen.dart` | MVP |
| 2 | Find | Home | `/home` | `features/home/home_screen.dart` | MVP |
| 3 | Find | Find games | `/find` | `features/find/find_screen.dart` | MVP |
| 4 | Book | Game details | `/game/:id` | `features/game/game_details_screen.dart` | MVP |
| 5 | Book | Checkout (5-minute hold) | `/game/:id/checkout` | `features/booking/checkout_screen.dart` | MVP |
| 6 | Book | Booking confirmed | `/game/:id/confirmed` | `features/booking/booking_confirmed_screen.dart` | MVP |
| 7 | Play | My games | `/my-games` | `features/my_games/my_games_screen.dart` | MVP |
| 8 | Play | Game day | `/game/:id/day` | `features/game_day/game_day_screen.dart` | MVP |
| 9 | Play | Match control (organiser) | `/game/:id/match-control` | `features/match_control/match_control_screen.dart` | MVP |
| 10 | Track | Post-game + share card | `/game/:id/post-game` | `features/post_game/post_game_screen.dart` | MVP |
| 11 | Track | Stats | `/stats` | `features/stats/stats_screen.dart` | MVP |
| 12 | Track | Profile | `/profile` | `features/profile/profile_screen.dart` | MVP |
| 13 | Reward | Streak | `/streak` | `features/streak/streak_screen.dart` | MVP |
| 14 | Compete | City leaderboard | `/leaderboard` | `features/leaderboard/leaderboard_screen.dart` | After test |
| 15 | Reward | Wallet | `/wallet` | `features/wallet/wallet_screen.dart` | MVP |
| 16 | Grow | Joga+ | `/joga-plus` | `features/membership/membership_screen.dart` | MVP |
| 17 | Grow | Referrals | `/referrals` | `features/referrals/referrals_screen.dart` | After test |
| 18 | Run | Admin dashboard | `/admin` | `features/admin/admin_screen.dart` | MVP |
| 19 | Run | Community impact | `/impact` | `features/impact/impact_screen.dart` | MVP |
| 20 | Trust | Settings | `/settings` | `features/settings/settings_screen.dart` | MVP |
| 21 | Trust | Player code of conduct | `/code-of-conduct` | `features/safety/code_of_conduct_screen.dart` | MVP |
| – | Trust | Players list, report, block (sheets) | from game details | `features/safety/player_safety_sheets.dart` | MVP |
| – | Demo | All screens index | `/demo` | `features/demo/demo_hub_screen.dart` | Demo only |
| – | Demo | Presenter frame and panel | wraps the app | `features/demo/presenter_frame.dart` | Demo only |


## Differentiators built into the demo

- **For you** games on Home (home town, not yet full, beginner-friendly)
- **5-minute hold** on the last space at checkout
- **Refund if your space is filled** on late cancellations
- **Reliability %** on the player profile
- **Game tags**: Beginner-friendly, Women's, Mixed, Walking football,
  Casual. No ability levels: Joga is recreational football
- **Access and safety** on every game page; report and block; code of
  conduct agreed at sign-up
- **Community impact** dashboard for partners
- **Shareable post-game card**
- **Sport switcher** with padel and badminton marked "soon"
