# Use By Date — Flutter client

Local-first iOS/Android app: photograph food, read or estimate expiry dates, and get a reminder.

## Setup

```bash
cd client
flutter pub get
dart run build_runner build
```

Point the app at the Next.js API (default is local):

```bash
flutter run --dart-define=PHOTO_API_BASE_URL=http://127.0.0.1:3000
```

On a physical device, `127.0.0.1` is the phone itself. Use your computer’s LAN IP instead, e.g. `http://192.168.0.10:3000`.

Package ID: `com.smartcompany.usebydate`.

## Features (MVP)

- Camera / album pick (share_lib album grid)
- Gemini analysis via `POST /api/photos/analyze`
- Local Drift SQLite + photos in app documents
- Local notifications on the expiry day or N days before (Settings)
# UseByDate
