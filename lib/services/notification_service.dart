import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

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

    await _notificationsPlugin.initialize(initializationSettings);

    // Request Android 13+ Permissions
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

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
    // This bypasses complex background permission/API version tweaks for the demo.
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
