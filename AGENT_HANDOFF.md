# Agent Handoff & Project Context

## Project: YMCA 360 Prototype (`example_app`)
**Objective:** Create a modern, high-velocity prototype for a YMCA mobile/web app to showcase value over their existing legacy software stack.

---

## 🏗️ Architecture & Stack
- **Framework:** Flutter (Mobile + Web support).
- **Backend:** Firebase (Auth, Firestore, Hosting, Analytics).
- **CI/CD:** GitHub Actions.
    - `flutter_test.yml`: Runs unit tests on every push.
    - `firebase_hosting_merge.yml`: Automatically builds and deploys to Firebase Hosting on merge to `master`.

## 🔄 Current Workflow (SOP)
The project has moved from manual hacking to a professional CI/CD flow.
1.  **Work in Branches:** Always use `git checkout -b feature/name`.
2.  **Push to GitHub:** Triggers automated tests.
3.  **Merge to Master:** Triggers automated deployment to `xmca14.web.app`.

## ✅ Completed Features
1.  **Childcare Registration:**
    - Integrated `webview_flutter` to bridge users to `ezchildtrack.com`.
    - Includes `ChildcareWebView` screen and Home Screen entry point.
    - Handles Web vs. Native platform differences (Safe initialization).
2.  **Manager Analytics:**
    - Entry point in `ManagerDashboard` to view Firebase Analytics.
3.  **Infrastructure:**
    - Unit Tests setup (`test/user_model_test.dart`).
    - CI/CD Pipelines established.
    - Web support fixed (`setJavaScriptMode` error resolved).
4.  **Payments (Hybrid):**
    - Native Stripe Payment Sheet on Mobile.
    - Stripe Checkout Redirection on Web.
    - Cloud Functions for secure intent creation.

## ⏭️ Next Steps (Backlog)
- **Refactor State Management:** ✅ Done (Riverpod).
- **Data Pagination:** ✅ Done (Added to UserRepository).
- **Remote Config:** ✅ Done (Childcare Registration).
- **Dev Environment:** ✅ Done (`xmca14-dev`).

## ⚠️ Important Notes for Agents
- **Workspace Restrictions:** The user may have restricted terminal access. You might need to ask the user to switch active folders or run `git push` manually if the tool fails.
- **Web Build:** Ensure any new packages have web support (`_web` variants) or are conditionally imported.
- **Service Account:** The `FIREBASE_SERVICE_ACCOUNT_XMCA14` secret is set in GitHubRepo for deployment.

---

## 🏆 Professional Standards Implemented
*(Added from Professional Dev Checklist)*

### 1. State Management (The "Brain")
- **Action:** Refactored from `setState` to **Riverpod**.
- **Why:** Scales logic, improves testability, isolates UI from Data.

### 2. Environment Isolation (The "Sandbox")
- **Action:** Created **`xmca14-dev`** workspace.
- **Why:** Separation of Prod vs Dev data.

### 3. Remote Configuration (The "Kill Switch")
- **Action:** Implemented **Firebase Remote Config** (Childcare URL).
- **Why:** Instant updates without App Store reviews.

### 4. Scalable Data Access (Pagination)
- **Action:** Added `limit` and `cursor` support to `UserRepository`.
- **Why:** Prevents crashes when member count grows > 1000.

### 5. Automated Pipelines (CI/CD)
- **Action:** GitHub Actions (`flutter_test` + `firebase_deploy`).
- **Why:** Prevents broken code from hitting production.

### 6. Observability (Analytics)
- **Action:** Integrated **Firebase Analytics**.
- **Why:** Data-driven decisions (e.g. tracking "Childcare Button" clicks).
