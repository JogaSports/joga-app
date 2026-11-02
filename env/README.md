# Build settings

Pick one with `--dart-define-from-file`:

| File | Backend | Use |
|---|---|---|
| (none) | Fake demo data | The demo site and pitches |
| `local.json` | Supabase on your Mac (`supabase start`) | Development |
| `staging.json` | joga-staging | Testing against the hosted backend |

```bash
flutter run -d chrome --dart-define-from-file=env/local.json
```

These files only hold **publishable** keys, which are safe to ship in the
app and to commit. Never put a secret key, database password or webhook
secret here. The local key is the Supabase CLI's shared default.
