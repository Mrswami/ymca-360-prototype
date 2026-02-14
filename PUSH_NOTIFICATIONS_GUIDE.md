# Push Notifications - Testing Guide

## ✅ What's Implemented

1. **Firebase Cloud Messaging (FCM)** - Fully integrated
2. **Local Notifications** - For foreground display
3. **Topic Subscriptions** - All users auto-subscribe to `all_users` topic
4. **Background Handling** - Notifications work even when app is closed
5. **"Remember Me"** - Already working (checkbox on login screen)

---

## 🧪 How to Test Push Notifications

### Method 1: Firebase Console (Easiest)

1. **Open Firebase Console**:
   - Go to: `https://console.firebase.google.com/project/xmca14/messaging`

2. **Create New Notification**:
   - Click **"Send your first message"** or **"New campaign"**
   - Click **"Firebase Notification messages"**

3. **Fill in the form**:
   - **Notification title**: `Class Cancelled`
   - **Notification text**: `Yoga class at 3pm has been cancelled due to instructor illness`
   - Click **"Next"**

4. **Target**:
   - Select **"Topic"**
   - Enter: `all_users`
   - Click **"Next"**

5. **Scheduling**:
   - Select **"Now"**
   - Click **"Next"**

6. **Additional options** (optional):
   - Skip or customize
   - Click **"Review"**

7. **Send**:
   - Click **"Publish"**

8. **Result**:
   - Within seconds, all devices with the app installed will receive the notification
   - If app is open: Notification appears as a banner
   - If app is closed: Notification appears in system tray

---

### Method 2: Using FCM Token (For specific device)

1. **Get your device token**:
   - Install the new app build
   - Open the app
   - Check the console logs (or use `flutter run` in terminal)
   - Look for: `📱 FCM Token: <long-string>`
   - Copy this token

2. **Send via Firebase Console**:
   - Go to: `https://console.firebase.google.com/project/xmca14/messaging`
   - Create new notification (same as Method 1)
   - In **Target** step, select **"FCM registration token"**
   - Paste your token
   - Continue and send

---

### Method 3: Using REST API (Advanced)

```bash
# Get your Server Key from Firebase Console → Project Settings → Cloud Messaging

curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "/topics/all_users",
    "notification": {
      "title": "Class Update",
      "body": "Spin class moved to Studio B"
    },
    "data": {
      "type": "class_update",
      "classId": "123"
    }
  }'
```

---

## 📱 Expected Behavior

### When App is Open (Foreground)
- ✅ Notification appears as a banner at the top
- ✅ Plays sound
- ✅ Can tap to dismiss

### When App is in Background
- ✅ Notification appears in system tray
- ✅ Plays sound
- ✅ Tapping opens the app

### When App is Closed (Terminated)
- ✅ Notification appears in system tray
- ✅ Plays sound
- ✅ Tapping launches the app

---

## 🔍 Debugging

### Check if FCM is working:

1. **Install the new build** (from Firebase App Distribution email)
2. **Open the app**
3. **Check logs** (if running via `flutter run`):
   ```
   ✅ FCM permission granted
   📱 FCM Token: <token>
   ✅ Subscribed to: all_users
   ✅ FCM initialized
   ```

### If notifications don't appear:

1. **Check Android notification permissions**:
   - Settings → Apps → YMCA 360 → Notifications → Ensure "All" is enabled

2. **Check Firebase Console**:
   - Go to Cloud Messaging
   - Verify "Cloud Messaging API" is enabled

3. **Check logs for errors**:
   - Look for `❌ FCM` messages in console

---

## 🎯 Use Cases

### 1. Class Cancellations
```
Title: "Class Cancelled"
Body: "Yoga class at 3pm has been cancelled"
Topic: all_users
```

### 2. Facility Updates
```
Title: "Pool Closed"
Body: "The pool will be closed tomorrow for maintenance"
Topic: all_users
```

### 3. Special Events
```
Title: "New Class Added!"
Body: "Try our new Pickleball class starting Monday"
Topic: all_users
```

### 4. Personal Reminders (Future)
```
Title: "Session Reminder"
Body: "Your PT session with Sarah starts in 1 hour"
Topic: user_<userId>
```

---

## 🚀 Next Steps (Future Enhancements)

1. **Admin Panel**: Build a screen in Manager Dashboard to send notifications
2. **User Preferences**: Let users choose which notification types they want
3. **Scheduled Notifications**: Send reminders 1 hour before booked sessions
4. **Rich Notifications**: Add images, action buttons ("View Details", "Cancel")
5. **Analytics**: Track notification open rates

---

## 📝 Notes

- **"Remember Me" is already working!** The checkbox on the login screen persists your session.
- **Notifications require the new build** - Make sure to install the latest APK from Firebase App Distribution
- **Topic subscriptions are automatic** - All users are subscribed to `all_users` on first launch
- **Background handler is registered** - Notifications work even when app is completely closed

---

## 🔗 Quick Links

- [Firebase Console - Cloud Messaging](https://console.firebase.google.com/project/xmca14/messaging)
- [Firebase Console - Project Settings](https://console.firebase.google.com/project/xmca14/settings/general)
- [FCM Documentation](https://firebase.google.com/docs/cloud-messaging)

---

**Last Updated**: 2026-02-14
