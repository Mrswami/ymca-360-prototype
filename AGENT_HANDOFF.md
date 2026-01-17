# Agent Handoff: YMCA 360 Prototype

**Last Updated:** January 10, 2026
**Current Branch:** `master` (Merged from `feature/demo-enhancements`)
**Goal:** High-fidelity Sales Pitch Prototype for Austin YMCA Executives.

## 1. Project Context
This is a **Flutter** app simulating the "YMCA 360" experience. It is designed to impress executives with "Common Sense" features like Digital ID, Class Schedules, and Admin Workflows (MFA Verification).
*   **Target Device:** Samsung S23 (User's personal phone).
*   **Web Host:** GitHub Pages (`/docs` folder).

## 2. Key Features Implemented
*   **Welcome Screen**: Matches the official design (Dark mode, Hero image).
*   **Role-Based Access**:
    *   **Member**: Home, Classes, Book PT, Profile.
    *   **Manager**: Dashboard with "Simulate MFA" toggle.
    *   **Trainer**: Schedule Editor.
*   **Digital ID (Home Tab)**: Tapping the barcode card opens a large Code128 barcode dialog.
*   **Class Schedule (Classes Tab)**: Replaced generic "On Demand" with a TownLake-specific schedule (Aquatics, Group Fitness).
*   **MFA Workflow**:
    *   Toggle in Manager Menu (`Simulate MFA Trigger`).
    *   Shows "Action Required" banner on Home.
    *   User uploads doc -> Success.
*   **Mock Payments**: `SchedulerScreen` simulates a "Visa on File" payment flow.

## 3. Technical State
*   **Data**: All data is **Mock** (`MockData` class). Resets on app restart.
*   **Auth**: Simulated via `AuthService`.
*   **Notifications**: Uses `flutter_local_notifications`. Permissions logic added for Android 13+.
*   **Signing**:
    *   `debug` builds work perfectly.
    *   `release` builds (`flutter build apk --release`) are currently **FAILING** due to `key.properties` configuration in `android/app/build.gradle.kts`.
    *   *Workaround:* Use `--debug` builds for demo.

## 4. Next Steps for Next Agent
1.  **Fix Release Signing**: The `build.gradle.kts` logic for reading `key.properties` is fragile. Needs a rewrite to reliably build release APKs/Bundles.
2.  **Real Backend**: The user has requested a road map for Firebase/Daxko integration (See `ARCHITECTURE.md`).
3.  **UI Polish**: The "Wellness" button on Welcome Screen is currently a blank placeholder.

## 5. Critical Files
*   `lib/main.dart`: Entry point. Handles `WelcomeScreen` -> `MainShell` transition and Tab Navigation.
*   `lib/screens/home_screen.dart`: Contains the Digital ID logic and Location Picker.
*   `lib/services/auth_service.dart`: Contains the `hasPendingMFA` demo toggle.
