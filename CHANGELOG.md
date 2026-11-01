# Changelog

## 0.2.3 – Launch cities

- Cities are now Bristol, London, Cardiff, Nairobi and Tbilisi, in that
  order, matching the backend. Swansea, Newport and Wrexham are gone
- Each city has its country, timezone and currency (`City` in
  `data/models/enums.dart`)
- Prices show in the game's currency: £8.00, KSh 500, 15 ₾
- Kick-off times and "Tonight / Tomorrow" use the city's own clock, so a
  Nairobi 7pm game reads 7pm on any phone
- Booking fee is per city. Nairobi and Tbilisi fees are placeholders until
  the PO decides how money works outside the UK
- Wallet credit is offered on UK games only (the wallet holds pounds);
  cancelling a Nairobi or Tbilisi game doesn't refund to the wallet
- Find's price filter uses each city's amount (Under £7, Under KSh 500…)
- Admin revenue and margin totals count UK games (£); each game row shows
  its own currency
- Demo data: venues, games and players in London, Nairobi and Tbilisi with
  the same ids as the backend seed (g-301 to g-502)

## 0.2.2 – English only, fixes

- Removed Welsh completely (language switch, translations, review doc).
  All copy stays in one place, `core/l10n/strings_en.dart`
- Welcome slides no longer overflow on short or narrow screens
- Community impact: monthly chart no longer overflows; labels scale down
- Presenter panel jump-to buttons sign in or out as needed, so they go
  straight to the screen instead of bouncing via the sign-in guard
- Demo data loads faster (shorter simulated delay)

## 0.2.1 – Recreational focus

- Removed ability levels (beginner / intermediate / competitive): Joga is
  recreational football. "Beginner-friendly" is now a game tag
- Removed the Competitive, Over-30s and Welsh-speaking tags
- Deeper stats (city rank, best venue, rates) are free for everyone; Joga+
  is no booking fees, streak freeze and bigger rewards
- Profile setup no longer asks for ability level

## 0.2.0 – Welsh FA demo polish

- Sign-up and sign-in journey: welcome slides, Apple and Google buttons
  (Apple's official widget, Google drawn to its brand guidelines), email
  sign-in and sign-up with 18+ and code-of-conduct consent, forgot
  password, 6-digit email code, profile setup, permissions, sign out
- Router guard driven by auth status
- English (default) and Welsh, switchable on the welcome screen, in
  Settings and in the presenter panel
- Swansea, Newport and Wrexham venues and games; Bristol kept as the
  first city outside Wales
- Inclusive filters: beginner, women's, walking football, Welsh-language,
  mixed, over-30s
- Venue access and safety on game details (step-free, accessible toilet,
  defibrillator, first aid, changing rooms)
- Players list with report and block; player code of conduct
- Community impact dashboard (illustrative data, clearly labelled)
- Settings: language, notifications, privacy and safety, blocked players,
  reduce motion, demo tools
- Presenter mode: phone frame and presenter panel on large screens, demo
  reset
- Polish: skeleton loaders, designed empty states, native page
  transitions, confetti, haptics, larger tap targets, screen-reader labels
- Web: branded splash, app icon, favicon, manifest, link-preview tags
- New tests for auth, safety, impact, strings and language switching

## 0.1.0 – Demo skeleton

- All 18 MVP and after-test screens plus a demo index, on dummy data for Ray
- In-memory fake backend: booking with a 5-minute hold, cancellations,
  match control, stats, weekly streaks, wallet ledger, Joga+
- Repository interfaces ready for Supabase
- Unit tests for formatters and fake repositories, widget smoke test
