# 🥒 Pickleball Integration Roadmap

## 1. DUPR Integration (Ratings & Identity)

**Goal**: Display user's DUPR rating and match history on their profile.

### API Structure (Mocked for Phase 1)
Since we need a Partner API key, we will create a `DuprService` in the app that mimics the real API responses.

**Mock Data Structure:**
```json
{
  "playerId": "DUPR-123456",
  "fullName": "John Doe",
  "ratings": {
    "doubles": 4.25,
    "singles": 3.89
  },
  "matches": 15,
  "lastUpdate": "2026-02-14"
}
```

### Implementation Steps
1. **Database Update**: Add `duprId` field to the user's Firestore profile.
2. **UI Component**: Create a "Pickleball Stats" card on the Home Screen.
3. **Cloud Function**: (Future) Securely fetch data from `partner-api.mydupr.com`.

---

## 2. Pickleball Den Integration (Bookings & Schedule)

**Goal**: Allow users to reserve courts or view schedules.

### Challenge
Pickleball Den does **not** have a public API. Scrapping is unstable and likely violates ToS.

### Strategy: "The Portal Approach"
We will integrate Pickleball Den using a seamless WebView or Deep Links.

**Option A: In-App Browser (WebView)**
- Embed `pickleballden.com` inside the specific tab.
- **Pros**: Keeps user in the app.
- **Cons**: Might require user to login again inside the WebView.

**Option B: Deep Linking / Smart Redirects**
- "Book a Court" button -> Opens Pickleball Den specific club page.
- **Pros**: Easiest implementation, reliable.

**Option C: Direct Partnership (Long Term)**
- Contact `support@pickleballden.com` to request API access for "YMCA 360 App".

---

## 3. Dedicated Pickleball Feature Set (Cloud Native)

Since external integration is limited, we can build **YMCA-specific** pickleball features directly in Firebase:

1.  **Open Play Finder**: "Who's playing now?" status toggle.
2.  **Ladder/League Tracker**: Simple leaderboard stored in Firestore.
3.  **Court Check-in**: GPS-based check-in for analytics.

## 📅 Proposed Architecture

```dart
// lib/services/pickleball_service.dart

class PickleballService {
  // 1. DUPR Integration
  Future<DuprProfile> getPlayerRating(String duprId) async {
    // Return mock data for now
    return DuprProfile(doubles: 3.5, singles: 3.2);
  }

  // 2. Booking Redirect
  void openBookingPortal() {
    launchUrl(Uri.parse('https://app.pickleballden.com/club/ymca-id'));
  }
}
```
