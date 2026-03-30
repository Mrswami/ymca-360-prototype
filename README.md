# YMCA 360 — Prototype

> A Flutter-based, production-hardened prototype that re-imagines YMCA member engagement through a unified mobile platform. Built to demonstrate enterprise-grade architecture while remaining visually distinct from the official YMCA 360 application.

---

## What This Is

This is an **unofficial prototype** — not affiliated with or endorsed by the YMCA or its official technology vendors. It exists to:

1. **Demonstrate** a modern, scalable alternative to the current operational tooling
2. **Prototype** member-facing features (booking, payments, notifications) at production quality
3. **Propose** a technical architecture capable of integrating with legacy systems (Daxko)

> The app intentionally uses an **Inverted Orange & Green color scheme** to distinguish it from the official YMCA 360 purple branding.

---

## Feature Status

| Feature | Status |
|---|---|
| Multi-Role Auth (Member / Trainer / Manager) | ✅ Live |
| Hybrid Stripe Payments (Mobile Sheet + Web Checkout) | ✅ Live |
| Firebase Cloud Functions (Node 20) | ✅ Deployed |
| Push Notifications via FCM | ✅ Live |
| Admin Notification Broadcast Panel | ✅ Live |
| Department Pages (Aquatics, Childcare, Cycling, Yoga) | ✅ Live |
| Trainer Booking Calendar with Stripe | ✅ Live |
| Manager Dashboard (Transactions, User Mgmt, Seeder) | ✅ Live |
| Pickleball Integration (DUPR Profile, Booking) | 🚧 In Progress |
| Daxko Member Sync (Cloud Function Connector) | 📋 Planned |
| Beta Deployment (TestFlight / Play Console) | 📋 Planned |

---

## Getting Started

### Prerequisites
- Flutter SDK (stable channel)
- Firebase CLI (`npm install -g firebase-tools`)
- A Firebase project with Firestore, FCM, and Functions enabled

### Setup

```bash
# Install Flutter dependencies
flutter pub get

# Run for web (dev)
flutter run -d chrome --dart-define=STRIPE_PK=pk_test_YOUR_KEY_HERE

# Run for Android
flutter run -d android --dart-define=STRIPE_PK=pk_test_YOUR_KEY_HERE
```

> **Note:** `firebase_options.dart` is excluded from version control. Run `flutterfire configure` to generate it for your Firebase project.

### Firebase Functions

```bash
cd functions
npm install
firebase deploy --only functions
```

---

## Security Notes

- **No secrets are committed** — Stripe keys are injected via `--dart-define` at build time.
- **`firebase_options.dart`** is gitignored — you must run `flutterfire configure` locally.
- **Firebase Security Rules** are the primary protection layer for Firestore data (key exposure is expected behavior for Firebase Web API keys).
- **Stripe Secret Key** is stored in Firebase Functions environment config, never in app code.

---

## Architecture

```
lib/
├── main.dart           # App entry, Firebase init, role-based routing
├── theme/              # Inverted Orange & Green design system
├── screens/            # Feature screens (home, scheduler, admin/)
├── services/           # Stripe, Notifications, Auth, Remote Config
├── providers/          # Riverpod state providers
├── models/             # Data models
└── widgets/            # Shared UI components

functions/
└── index.js            # Cloud Functions: Stripe, FCM Notifications, Pickleball
```

---

*Built to demonstrate what community-focused operations can look like when modern software engineering meets institutional fitness.*
