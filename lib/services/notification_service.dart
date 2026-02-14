import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static bool _fcmInitialized = false;

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    // For iOS/macOS, we need to request permissions
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request Android 13+ Permissions
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // Initialize Firebase Cloud Messaging
    await _initializeFCM();
  }

  /// Initialize Firebase Cloud Messaging for push notifications
  static Future<void> _initializeFCM() async {
    if (_fcmInitialized) return;

    try {
      // Request permission for iOS/Web
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('✅ FCM permission granted');
      } else {
        debugPrint('❌ FCM permission denied');
        return;
      }

      // Create Android notification channel for FCM
      const androidChannel = AndroidNotificationChannel(
        'ymca_360_fcm',
        'YMCA 360 Push Notifications',
        description: 'Class updates, cancellations, and announcements',
        importance: Importance.high,
      );

      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);

      // Get FCM token
      String? token = await _firebaseMessaging.getToken();
      debugPrint('📱 FCM Token: $token');

      // Listen to token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        debugPrint('🔄 FCM Token refreshed: $newToken');
        // TODO: Send to backend to update user's device registry
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background/terminated message taps
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

      // Check if app was opened from terminated state
      RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageTap(initialMessage);
      }

      // Subscribe to default topic
      await subscribeToTopic('all_users');

      _fcmInitialized = true;
      debugPrint('✅ FCM initialized');
    } catch (e) {
      debugPrint('❌ FCM initialization failed: $e');
    }
  }

  /// Handle FCM message received in foreground
  static void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('📬 FCM Foreground: ${message.notification?.title}');

    if (message.notification != null) {
      _showFCMNotification(message);
    }
  }

  /// Show local notification for FCM message
  static Future<void> _showFCMNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'ymca_360_fcm',
      'YMCA 360 Push Notifications',
      channelDescription: 'Class updates, cancellations, and announcements',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  /// Handle notification tap
  static void _handleMessageTap(RemoteMessage message) {
    debugPrint('👆 Notification tapped: ${message.data}');
    // TODO: Navigate based on message.data['type']
  }

  /// Handle local notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('👆 Local notification tapped: ${response.payload}');
  }

  /// Subscribe to FCM topic
  static Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    debugPrint('✅ Subscribed to: $topic');
  }

  /// Unsubscribe from FCM topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    debugPrint('❌ Unsubscribed from: $topic');
  }

  /// Get FCM token
  static Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  // ===== EXISTING LOCAL NOTIFICATION METHODS =====

  static Future<void> showBookingConfirmation(
      String trainerName, DateTime date) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'booking_channel',
      'Bookings',
      channelDescription: 'Notifications for confirmed PT sessions',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0,
      'Booking Confirmed!',
      'You are booked with $trainerName on ${_formatDate(date)}.',
      platformChannelSpecifics,
    );
  }

  static Future<void> scheduleReminder(String trainerName, DateTime date) async {
    // Temporary Demo Implementation: Wait 10 seconds then show notification
    Future.delayed(const Duration(seconds: 10), () async {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'reminder_channel',
        'Reminders',
        channelDescription: 'Session reminders',
        importance: Importance.max,
        priority: Priority.high,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(
        1,
        'Upcoming Session Reminder',
        'Get ready! You have a session with $trainerName soon.',
        platformChannelSpecifics,
      );
    });
  }

  static String _formatDate(DateTime date) {
    return '${date.month}/${date.day} at ${date.hour > 12 ? date.hour - 12 : date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

/// Background FCM handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🔔 Background FCM: ${message.notification?.title}');
}
