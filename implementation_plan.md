# specialized_ymca_trainer_app_plan.md

## Project Vision
A specialized mobile application for YMCA members to schedule personal training sessions. The core focus is on a robust, conflict-free scheduling engine that handles multiple trainers, variable session lengths (30m, 60m, 90m), and real-time availability.

## Core Features
1.  **Trainer Management**: Profiles, specialties, and individual working hours.
2.  **Smart Scheduling Engine**:
    - Aggregated availability calendar.
    - Logic to fit 30/60/90 min blocks into open slots.
    - Prevention of double-booking.
3.  **User/Member Experience**:
    - Easy "Book Now" flow.
    - Dashboard of upcoming sessions.
4.  **Notifications System**:
    - Confirmation emails/push.
    - Reminders (24h, 1h before).

## Backend Data Structure & Logic (The Meticulous Part)

To handle the complexity of "Multiple Trainers with Different Schedules", we need a solid data schema.

### 1. Data Models (`/lib/models`)

**A. Trainer**
```dart
class Trainer {
  String id;
  String name;
  String bio;
  List<String> specialties;
  // Weekly availability template (e.g., Mon 9-5, Wed 1-8)
  Map<int, List<TimeRange>> weeklySchedule; 
}
```

**B. Appointment**
```dart
class Appointment {
  String id;
  String trainerId;
  String memberId;
  DateTime startTime;
  int durationMinutes; // 30, 60, or 90
  String status; // confirmed, cancelled, completed
}
```

**C. Availability Slot (Calculated)**
This is not necessarily stored, but calculated on the fly:
`AvailableSlot = (Trainer Working Hours) - (Existing Appointments)`

### 2. The Scheduling Logic (The Hardest Part)
We need a `SchedulingService` that performs the following checks when a user requests a time:
1.  **Trainer Check**: Is the trainer working that day?
2.  **Overlap Check**: Does `(RequestStart, RequestEnd)` overlap with any existing `Appointment` for that trainer?
3.  **Buffer Check**: (Optional) Do trainers need 15 min breaks between sessions?
4.  **Duration Fit**: If a user wants 90 mins, is there a continuous 90 min block available?

## Proposed Tech Stack for Backend
Since reliability and notifications are key:
-   **Firebase Firestore**: For the real-time database (NoSQL fits this document-style data well).
-   **Firebase Cloud Functions**: To run the "meticulous" conflict checks server-side (trusted environment) rather than trusting the client app.
-   **Firebase Cloud Messaging (FCM)**: For the push notifications.

## Implementation Steps
1.  **Clean Slate**: Wipe `main.dart`.
2.  **Models**: Implement `Trainer`, `Appointment`, `TimeRange` models in Dart.
3.  **Logic Prototype**: Write the `AvailabilityService` logic in Dart (Pure logic, no UI yet) to verify it passes all edge cases.
4.  **UI Construction**: Build the Calendar/Booking flow.
