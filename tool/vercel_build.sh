#!/usr/bin/env bash
# Vercel build (vercel.json runs this; Vercel caps the build command at 256
# characters, so the details live here).
#
# Settings come from the Vercel project's Environment Variables. With none
# set (the demo site) the app builds on fake data. The staging site sets
# USE_FAKE=false, SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY and ENV_LABEL.
set -euo pipefail

flutter/bin/flutter pub get
flutter/bin/flutter build web --release \
  --dart-define=USE_FAKE="${USE_FAKE:-true}" \
  --dart-define=SUPABASE_URL="${SUPABASE_URL:-}" \
  --dart-define=SUPABASE_PUBLISHABLE_KEY="${SUPABASE_PUBLISHABLE_KEY:-}" \
  --dart-define=ENV_LABEL="${ENV_LABEL:-STAGING}"
