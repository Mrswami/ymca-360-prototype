# System Architecture: High-Level Overview

This document outlines the proposed technical architecture for the YMCA 360 Ecosystem, integrating the Mobile App, Firebase, Stripe, and the legacy Daxko system.

## 1. Core Components

### A. Mobile App (Flutter)
The user-facing interface for iOS and Android.
*   **Role**: Presentation Layer.
*   **Responsibilities**: UI, Input Handling, Local Notifications, Device Hardware (Camera/GPS).

### B. Firebase (Backend-as-a-Service)
The modern, agile backend that acts as the "Middleman".
*   **Authentication**: Handles Login (Email, Phone, Google) and links it to the Member ID.
*   **Firestore (NoSQL DB)**: Stores app-specific data that Daxko doesn't handle (e.g., "Favorite Trainers", "Workout Logs", "Chat History").
*   **Cloud Storage**: Securely stores separate files like "Income Verification" images.
*   **Cloud Functions**: Server-side logic that securely talks to Daxko and Stripe.

### C. Stripe (Payment Gateway)
Handles transactional payments for non-membership items.
*   **Use Cases**: Booking single PT sessions, buying paid class drop-ins, paying for merchandise.
*   **Flow**: App collects Card -> Stripe processes -> Notification sent to Firebase -> App confirms.

### D. Daxko (Legacy System of Record)
The source of truth for Membership status.
*   **Role**: The Database of Record.
*   **Responsibilities**: Monthly Dues, Member Status (Active/Inactive), Gate Access control.

---

## 2. Integration Flows

### Flow A: "MFA Discount Verification"
1.  **Trigger**: Daxko marks Member 101 as `MFA_Pending`.
2.  **Sync**: Nightly Firebase Function polls Daxko API for changes.
3.  **Alert**: Firebase Cloud Messaging sends Push Notification to App.
4.  **Action**: User uploads "PayStub.jpg" via App.
5.  **Storage**: Image saved to Firebase Storage (Encrypted).
6.  **Staff Alert**: Firebase triggers email to Membership Director with link to review.

### Flow B: "Booking a PT Session"
1.  **User**: Selects "Sarah Connor - 10 AM".
2.  **App**: Prompts for Payment ($50) via Stripe Sheet.
3.  **Stripe**: Processes $50, returns `Success_Token`.
4.  **Firebase**:
    *   Records transaction.
    *   Creates Appointment record.
    *   Reduces Sarah's availability.
5.  **Sync**: (Optional) Pushes appointment info into Daxko Appointment Scheduler (if API allows).

---

## 3. Security Model
*   **User Data**: Never stored on device.
*   **Payments**: PCI Compliance handled entirely by Stripe SDK.
*   **API Keys**: Daxko keys stored in Google Cloud Secret Manager (never in the app).
