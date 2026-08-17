# Use By Date — Flutter client

Local-first iOS/Android app: photograph food, read or estimate expiry dates, and get a reminder.

## Setup

```bash
cd client
flutter pub get
dart run build_runner build
flutter run
```

Default API: [https://use-by-date-server.vercel.app](https://use-by-date-server.vercel.app)

Local server override:

```bash
flutter run --dart-define=PHOTO_API_BASE_URL=http://127.0.0.1:3000
```

Package ID: `com.smartcompany.useByDate`.

## Features (MVP)

- Camera / album pick (share_lib album grid), up to 3 photos
- Gemini analysis via `POST /api/photos/analyze`
- Local Drift SQLite + photos in app documents
- Local notifications on the expiry day or N days before (Settings)
