# Firebase Setup Checklist

This document tracks all the Firebase Console settings that need to be enabled for the app to work properly. Use this as a reference when setting up new Firebase projects or debugging issues.

---

## 🔐 Authentication

### Required Sign-In Providers
Go to: `Firebase Console → Authentication → Sign-in method`

- [x] **Anonymous Authentication** ✅ REQUIRED
  - Status: **ENABLED**
  - Why: The app uses anonymous auth for demo/guest access
  - Symptom if disabled: Login buttons do nothing or show auth errors
  - Date enabled: 2026-02-14

- [ ] **Email/Password** (Future)
  - Status: Not yet implemented
  - Why: For real user accounts

- [ ] **Google Sign-In** (Future)
  - Status: Not yet implemented
  - Why: Social login option

---

## 🔔 Cloud Messaging (Push Notifications)

### Setup
Go to: `Firebase Console → Cloud Messaging`

- [x] **Cloud Messaging API Enabled**
  - Status: **ENABLED** (auto-enabled with Firebase)
  - Why: Allows sending push notifications to users
  - Date enabled: 2026-02-14

### Server Key (for backend)
Go to: `Firebase Console → Project Settings → Cloud Messaging → Server key`

- [ ] **Server Key** (Future - for backend notification sending)
  - Status: Not yet needed (currently using topic-based notifications)
  - Why: Backend services need this to send targeted notifications
  - Note: Will be needed when implementing admin "Send Notification" feature

---

## 🗄️ Firestore Database

### Database Setup
Go to: `Firebase Console → Firestore Database`

- [x] **Firestore Database Created**
  - Mode: Production mode (with security rules)
  - Location: us-central (or your preferred region)
  - Why: Stores user data, transactions, schedules, etc.

### Security Rules
Current rules should allow:
- Authenticated users to read/write their own data
- Admin users to access all data

---

## 📱 App Distribution

### Tester Groups
Go to: `Firebase Console → App Distribution → Testers & Groups`

- [x] **"testers" Group Created** ✅ REQUIRED
  - Members: Your email address
  - Why: GitHub Actions uploads builds to this group
  - Symptom if missing: Build succeeds but email distribution fails
  - Date created: 2026-02-13

---

## 🌐 Hosting

### Deployment Setup
Go to: `Firebase Console → Hosting`

- [x] **Hosting Site Created**
  - Site: xmca14.web.app
  - Why: Hosts the web version of the app
  - Deployment: Automated via GitHub Actions

---

## ⚙️ Remote Config

### Feature Flags
Go to: `Firebase Console → Remote Config`

- [x] **Childcare URL Parameter**
  - Key: `childcare_registration_url`
  - Value: `https://www.ezchildtrack.com/...`
  - Why: Allows updating external URLs without app updates

---

## 💳 Cloud Functions (Stripe Integration)

### Functions Deployed
Go to: `Firebase Console → Functions`

- [x] **createPaymentIntent** (Mobile payments)
- [x] **createCheckoutSession** (Web payments)
- [ ] **Stripe Webhook Handler** (Future - for payment confirmations)

### Environment Variables
Required secrets for Cloud Functions:
- `STRIPE_SECRET_KEY` (set via Firebase CLI)

---

## 📊 Analytics

### Basic Setup
Go to: `Firebase Console → Analytics`

- [x] **Google Analytics Enabled**
  - Why: Track user behavior and feature usage
  - Events tracked: childcare_reg_link_clicked, etc.

---

## 🔑 Service Accounts & Permissions

### GitHub Actions Service Account
Go to: `Google Cloud Console → IAM & Admin → Service Accounts`

- [x] **github-actions-deployer**
  - Roles:
    - Firebase Hosting Admin
    - Service Account User
  - Why: Allows GitHub to deploy web builds
  - Symptom if missing: "Permission denied" errors in GitHub Actions
  - Date created: 2026-02-13

### GitHub Secrets
Go to: `GitHub Repo → Settings → Secrets and variables → Actions`

Required secrets:
- [x] `FIREBASE_SERVICE_ACCOUNT_XMCA14` (Service account JSON)
- [x] `FIREBASE_CLI_TOKEN` (For App Distribution)
- [x] `FIREBASE_APP_ID_ANDROID` (App ID for distribution)

---

## 🐛 Common Issues & Solutions

### Issue: "Login doesn't work"
**Solution:** Enable Anonymous Authentication in Firebase Console
- Go to: Authentication → Sign-in method → Anonymous → Enable

### Issue: "Build succeeds but no email from App Distribution"
**Solution:** Create the "testers" group and add yourself
- Go to: App Distribution → Testers & Groups → Add group → Name: "testers"

### Issue: "Web deployment fails with 403 Permission Denied"
**Solution:** Recreate service account with proper roles
- Go to: Google Cloud Console → IAM → Service Accounts
- Create new account with "Firebase Hosting Admin" role
- Download JSON key and update GitHub secret

### Issue: "Stripe payments fail"
**Solution:** Check Cloud Functions environment variables
- Ensure `STRIPE_SECRET_KEY` is set
- Verify functions are deployed and active

---

## 📝 Setup Order for New Projects

When creating a new Firebase project, follow this order:

1. **Create Firebase Project** (Firebase Console)
2. **Enable Authentication** → Anonymous (minimum)
3. **Create Firestore Database** (Production mode)
4. **Add Android/iOS/Web Apps** (Project Settings)
5. **Download config files** (google-services.json, GoogleService-Info.plist)
6. **Create App Distribution "testers" group**
7. **Create Service Account** for GitHub Actions
8. **Set up GitHub Secrets** (Service account JSON, CLI token, App ID)
9. **Deploy Cloud Functions** (if using Stripe/backend)
10. **Enable Remote Config** (for feature flags)

---

## 🔄 Last Updated
- **Date:** 2026-02-14
- **By:** Antigravity AI
- **Project:** YMCA 360 Prototype (xmca14)

---

## 📞 Quick Links

- [Firebase Console](https://console.firebase.google.com/project/xmca14)
- [Google Cloud Console](https://console.cloud.google.com/iam-admin/iam/project?project=xmca14)
- [GitHub Repository](https://github.com/Mrswami/ymca-360-prototype)
- [GitHub Actions](https://github.com/Mrswami/ymca-360-prototype/actions)
- [Live Web App](https://xmca14.web.app)
