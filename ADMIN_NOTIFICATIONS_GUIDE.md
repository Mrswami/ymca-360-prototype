# Admin Notification Panel - Setup Guide

## ✅ What's Implemented

The admin notification panel is now available in the Manager Dashboard! It includes:

1. **Live Preview** - See how your notification will look before sending
2. **Notification Types**:
   - 📢 General Announcement
   - 🏋️ Class Update
   - ⚠️ Facility Alert
   - 🎉 Special Event
   - 🔧 Maintenance Notice

3. **Target Audiences**:
   - All Users
   - Members Only
   - Trainers Only

---

## 🚀 How to Deploy the Cloud Function

The admin panel requires a Cloud Function to send notifications. Here's how to deploy it:

### Option 1: Deploy via Firebase CLI (Recommended)

```bash
cd "c:\Cursor Projects\xmca14-dev"
firebase deploy --only functions:sendNotification
```

**Note**: If you get an npm error about Node version, that's okay - Firebase will use Node 20 on their servers.

### Option 2: Deploy All Functions

```bash
firebase deploy --only functions
```

This will deploy all Cloud Functions (including the existing Stripe payment functions).

---

## 📱 How to Use the Admin Panel

1. **Login as Manager**:
   - Open the app
   - Click "Manager" on the welcome screen

2. **Navigate to Notification Panel**:
   - Scroll down in the Manager Dashboard
   - Click "Send Push Notification" (orange card with bell icon)

3. **Create Your Notification**:
   - Select notification type (e.g., "Facility Alert")
   - Enter title (e.g., "Pool Closed")
   - Enter message (e.g., "The pool will be closed tomorrow for maintenance")
   - Select target audience (e.g., "All Users")
   - Watch the live preview update as you type!

4. **Send**:
   - Click "Send Notification"
   - All users in the selected group will receive it instantly!

---

## 🧪 Testing

### Test 1: Send to All Users
1. Create notification with title: "Test Notification"
2. Body: "This is a test from the admin panel!"
3. Type: General
4. Target: All Users
5. Click Send
6. Check your phone - you should receive it within seconds!

### Test 2: Different Notification Types
Try each notification type to see different icons:
- **General**: 🔔 Bell icon
- **Class Update**: 🏋️ Fitness icon
- **Facility Alert**: ⚠️ Warning icon
- **Event**: 📅 Calendar icon
- **Maintenance**: 🔧 Wrench icon

---

## 🔍 Troubleshooting

### "Failed to send" error

**Cause**: Cloud Function not deployed yet

**Solution**: Deploy the function using the commands above

### "Permission denied" error

**Cause**: Cloud Functions API not enabled

**Solution**:
1. Go to: `https://console.cloud.google.com/apis/library/cloudfunctions.googleapis.com?project=xmca14`
2. Click "Enable"
3. Try deploying again

### Notification not received

**Possible causes**:
1. User hasn't installed the latest app build with FCM support
2. User hasn't granted notification permissions
3. User isn't subscribed to the target topic

**Solution**: Make sure you're testing with the latest app build from Firebase App Distribution

---

## 📊 Notification Analytics

To see how many users received your notifications:

1. Go to: `https://console.firebase.google.com/project/xmca14/notification`
2. Click on "Reports"
3. View delivery rates, open rates, and more

---

## 🎯 Use Cases

### Scenario 1: Emergency Closure
```
Type: Facility Alert
Title: "YMCA Closed Today"
Body: "Due to severe weather, all facilities are closed today. Stay safe!"
Target: All Users
```

### Scenario 2: New Class Announcement
```
Type: Event
Title: "New Pickleball Class!"
Body: "Join us for our new Pickleball class starting Monday at 6pm"
Target: All Users
```

### Scenario 3: Class Cancellation
```
Type: Class Update
Title: "Yoga Class Cancelled"
Body: "Today's 3pm yoga class has been cancelled due to instructor illness"
Target: Members Only
```

### Scenario 4: Maintenance Notice
```
Type: Maintenance
Title: "Pool Maintenance"
Body: "The pool will be closed for cleaning from 8am-12pm tomorrow"
Target: All Users
```

---

## 🚀 Future Enhancements

Ideas for expanding the notification system:

1. **Scheduled Notifications**: Send notifications at a specific time
2. **User Preferences**: Let users choose which notification types they want
3. **Rich Notifications**: Add images, action buttons
4. **Notification History**: View all sent notifications
5. **Analytics Dashboard**: Track open rates and engagement
6. **Template Library**: Save frequently used notification templates

---

## 📝 Notes

- Notifications are sent instantly (no delay)
- Users must have the latest app build installed
- Topic subscriptions happen automatically on first app launch
- The live preview updates as you type!

---

**Last Updated**: 2026-02-14
