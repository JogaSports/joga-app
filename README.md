# Joga Sports

Find, book and play organised football, with stats, streaks and rewards.
Starting in Cardiff and Bristol, with the demo also showing Swansea, Newport
and Wrexham. Football first; padel, badminton and other sports later.

This repo is the **demo**: every screen of the MVP, a full sign-up and
sign-in journey, English and Welsh, and a community impact dashboard, all
running on dummy data for a player called **Ray**. There is no real backend,
login or payment yet. The architecture is set up so real services slot in
behind the same interfaces without touching the screens.

---

## Quick start

Requires Flutter (stable) with Dart 3.6 or newer.

```bash
# First time only: creates the ios/ and android/ folders (web/ is in the
# repo), gets packages, formats, analyses and runs the tests.
./tool/setup.sh

# Run the demo
flutter run -d chrome        # web
flutter run                  # iOS simulator / Android emulator / device

# Build for Vercel
flutter build web --release  # output in build/web
```

In VS Code, open the folder and use the **Joga (Chrome)** or
**Joga (device / simulator)** launch configurations.

On Windows, run the commands in `tool/setup.sh` one by one.

## Demo walkthrough

See `docs/DEMO_SCRIPT.md` for a 10-minute script for presenting.

1. **Welcome**: three slides, EN | CY switch top right.
2. **Get started** → Continue with Apple / Google (signs straight in as
   Ray), or **Continue with email** → create account → 6-digit code (any
   code) → profile setup → permissions → Home.
3. **Find**: Welsh towns, plus quick filters for beginner, women's,
   walking football and Welsh-language games.
4. **Game details** → see players (report and block), access and safety
   (step-free, defibrillator, first aid) → **Join game** → 5-minute hold →
   **Pay** → confirmation with confetti.
5. **My games** → tonight's game → Match control → submit a result →
   post-game, stats, streak and wallet update everywhere.
6. **Profile → Community impact**: participation by town, women and girls,
   returners, retention, Welsh-language and walking football games.
7. **Profile → Settings**: language, notifications, blocked players,
   reduce motion, demo reset.

On a laptop or projector the app shows inside a phone frame with a
**presenter panel** (language, jump-to shortcuts, reset demo). Turn the
frame off in the panel or in Settings.

Error states on purpose: sign in with the password `wrong-password`, sign
up with an email containing `taken`, or enter the code `000000`.

## Project structure

```
lib/
  main.dart                 Entry point. Picks demo or real services.
  app.dart                  Root widget: services, language, theme, router.
  core/
    config/                 App constants, feature flags
    di/                     AppServices (all repositories) + AppScope
    l10n/                   English and Welsh strings (context.s)
    router/                 Routes (paths) + GoRouter with the sign-in guard
    settings/               Language, notifications, accessibility
    theme/                  Colours, spacing, type scale, Material theme
    utils/                  Formatters (money, counts, dates, countdowns)
    widgets/                Shared UI kit (buttons, cards, chips, sign-in
                            buttons, skeletons, empty states, confetti…)
  data/
    models/                 Plain Dart domain models (no code generation)
    repositories/           Interfaces the app talks to
    fake/                   In-memory demo backend + seed data for Ray
  features/                 One folder per screen or flow
    auth/ home/ find/ game/ booking/ my_games/ game_day/ match_control/
    post_game/ stats/ profile/ settings/ safety/ impact/ streak/
    leaderboard/ wallet/ membership/ referrals/ admin/ demo/ shell/
assets/brand/               Google "G" mark, app icon (1024px)
web/                        index.html with branded splash, icons, manifest
test/                       Unit and widget tests
docs/                       Screens, decisions, backend plan, Welsh, demo
```

## Architecture in one minute

```
Screen (features/)  →  AppServices (core/di)  →  Repository interface (data/repositories)
                                                   ├── Fake…Repository   (now)
                                                   └── Supabase…Repository (next)
```

- Screens never import `data/fake`. They call `context.services.<repo>`.
- Text comes from `context.s` (English or Welsh). Never hard-code text in
  a translated screen.
- The router's redirect follows `AuthRepository.status`: signed out,
  waiting for email code, needs profile, signed in.
- `AsyncView` loads data, shows a skeleton or error, and reloads
  automatically when data changes (e.g. after a booking).
- Models are plain immutable classes with `copyWith`. No build_runner.
- Dependencies: `go_router`, and `sign_in_with_apple` for Apple's official
  button. Fonts (Barlow, OFL licence) are bundled.

## Sign in with Apple and Google

- **Apple**: `SignInWithAppleButton` from `sign_in_with_apple`, white
  style on our dark background, as Apple's guidelines ask. Apple must be
  offered whenever Google is (App Store guideline 4.8), at least as
  prominently, so it comes first.
- **Google**: drawn to Google's branding guidelines with the official "G"
  mark. On the web, Google requires its own rendered button
  (`google_sign_in_web` `renderButton`), which needs the OAuth client ID;
  swap it in when wiring auth. iOS and Android keep this button and call
  `google_sign_in`.
- Wiring both to Supabase Auth is in `docs/BACKEND_PLAN.md`.

## Going from demo to real

1. Add `supabase_flutter`, `google_sign_in`, then write
   `Supabase…Repository` classes for the interfaces in
   `data/repositories/`.
2. Add `AppServices.supabase()` and switch to it in `main.dart`.
3. Save settings with `shared_preferences`, and the language on the
   player's profile so emails and push notifications match.
4. Turn the "after test" features off in `core/config/feature_flags.dart`.
5. Remove the presenter frame (return `child` in `PresenterFrame`),
   `features/demo/`, and the demo tools in Profile and Settings.
6. App icons for iOS and Android from `assets/brand/app_icon_1024.png`
   (e.g. with `flutter_launcher_icons`).

## Conventions

- One screen per file; screen-only widgets stay private in the same file.
- Colours, spacing and text styles only from `core/theme`.
- Text only from `context.s`; add new strings to `app_strings.dart`, then
  English and Welsh (it won't compile until both have it).
- Routes only via `Routes.*`, never hard-coded strings.
- Product names and prices only from `AppConfig`.
- Run `dart format lib test` and `flutter analyze` before committing.

## Docs

- `docs/SCREENS.md`: every screen, its route and file
- `docs/DECISIONS.md`: product decisions agreed so far
- `docs/BACKEND_PLAN.md`: backend repo, tables and how each repository maps
- `docs/WELSH.md`: how the Welsh translation works and gets reviewed
- `docs/DEMO_SCRIPT.md`: presenting the demo
