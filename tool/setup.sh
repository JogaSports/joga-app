#!/usr/bin/env bash
# One-time setup: generates the iOS and Android platform folders (web/ is
# already in the repo and is kept), fetches packages, tidies the code and
# runs the checks.
set -euo pipefail

flutter create . \
  --project-name joga_sports \
  --org com.jogasports \
  --platforms=ios,android,web

flutter pub get

# Applies the analyzer's safe automatic fixes (e.g. adding `const`), then
# formats everything.
dart fix --apply
dart format lib test

flutter analyze --no-fatal-infos
flutter test

echo ""
echo "Ready. Run the demo with: flutter run -d chrome"
