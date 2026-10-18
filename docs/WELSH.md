# Welsh language

English is the default. Welsh (Cymraeg) is the second language and can be
chosen on the welcome screen (EN | CY), in Settings, or in the presenter
panel.

## How it works

- Every string lives in `lib/core/l10n/`:
  - `app_strings.dart`: the list of strings (one line each)
  - `strings_en.dart`: English
  - `strings_cy.dart`: Welsh
- Screens read text with `context.s`, e.g. `Text(context.s.findTitle)`.
- Both languages extend `AppStrings`, so **the app won't compile if a
  Welsh string is missing**.
- Dates (Llun, Maw…; Ion, Chwef…), town names (Caerdydd, Abertawe,
  Casnewydd, Wrecsam, Bryste), formats ("5 bob ochr"), tags and levels are
  translated too.

## Review before showing anyone outside the team

The Welsh is a **draft**. A fluent Welsh speaker must check it before the
demo goes to the Welsh FA or anyone else. The Welsh Language Commissioner
expects bilingual services to be the same quality in both languages, and a
mistake here undoes the good impression.

What to check:

1. Every string in `strings_cy.dart`, or the Word document
   `Joga-Welsh-Translation-Review.docx` (same strings in a table, with a
   column for corrections).
2. Tone: we use the **"chi"** form throughout. Switch to "ti" only if the
   reviewer prefers it for a sports app, and then everywhere.
3. Football terms: "cymorth" (assists), "CyG" (chwaraewr y gêm, POTM),
   "rhediad" (streak), "bob ochr" (a-side).
4. Mutations after numbers and prepositions (e.g. "5 gêm", "yng
   Nghaerdydd"). Strings avoid prepositions before town names so names can
   be dropped in safely.
5. Lengths: Welsh is often longer. Check the tab bar, buttons and chips on
   a small phone.

Then edit `strings_cy.dart`, run `flutter test` (`test/strings_test.dart`
checks a few key strings), and redeploy.

## Not translated yet

Game day, Match control, Post-game, Streak, Wallet, Joga+, Leaderboard,
Referrals and the Admin dashboard are still English. Moving them over is
the same pattern: add strings to `app_strings.dart`, then both languages.

## Later

When more languages are added, move to ARB files and `flutter gen-l10n`.
Screens won't change because they only call `context.s`. Save the chosen
language on the player's profile so emails, push notifications and
receipts arrive in the same language.
