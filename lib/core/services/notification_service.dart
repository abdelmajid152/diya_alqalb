import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:get_storage/get_storage.dart';

/// Service for managing local notifications for Azkar reminders
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static final _storage = GetStorage();
  static const String _notificationsEnabledKey = 'azkar_notifications_enabled';

  /// Notification IDs
  static const int morningAzkarId = 1;
  static const int eveningAzkarId = 2;
  static const int sleepAzkarId = 3;

  /// Initialize the notification service
  static Future<void> initialize() async {
    // Initialize timezone
    tz_data.initializeTimeZones();

    // Android settings
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Initialize plugin
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions on iOS
    await _requestPermissions();

    // Schedule notifications if enabled
    if (isNotificationsEnabled()) {
      await scheduleAllAzkarNotifications();
    }
  }

  /// Request notification permissions
  static Future<void> _requestPermissions() async {
    // Request iOS permissions
    await _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // Request Android 13+ permissions
    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - can navigate to specific Azkar screen
    // You can use Get.to(() => AzkarScreen()) here if needed
  }

  /// Check if notifications are enabled
  static bool isNotificationsEnabled() {
    return _storage.read<bool>(_notificationsEnabledKey) ?? true;
  }

  /// Enable or disable notifications
  static Future<void> setNotificationsEnabled(bool enabled) async {
    await _storage.write(_notificationsEnabledKey, enabled);
    if (enabled) {
      await scheduleAllAzkarNotifications();
    } else {
      await cancelAllNotifications();
    }
  }

  /// Schedule all Azkar notifications
  static Future<void> scheduleAllAzkarNotifications() async {
    await cancelAllNotifications();

    // Morning Azkar - 6:00 AM
    await _scheduleDailyNotification(
      id: morningAzkarId,
      hour: 6,
      minute: 0,
      title: 'أذكار الصباح 🌅',
      body: 'حان وقت أذكار الصباح، ابدأ يومك بذكر الله',
    );

    // Evening Azkar - 4:30 PM
    await _scheduleDailyNotification(
      id: eveningAzkarId,
      hour: 16,
      minute: 30,
      title: 'أذكار المساء 🌙',
      body: 'حان وقت أذكار المساء، لا تنسَ ذكر الله',
    );

    // Sleep Azkar - 9:00 PM
    await _scheduleDailyNotification(
      id: sleepAzkarId,
      hour: 21,
      minute: 0,
      title: 'أذكار النوم 😴',
      body: 'قبل النوم، اقرأ أذكار النوم للحماية والراحة',
    );
  }

  /// Schedule a daily notification at a specific time
  static Future<void> _scheduleDailyNotification({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    // Get next occurrence of the specified time
    final scheduledDate = _nextInstanceOfTime(hour, minute);

    // Android notification details
    const androidDetails = AndroidNotificationDetails(
      'azkar_reminders',
      'تذكير الأذكار',
      channelDescription: 'تذكير بأوقات الأذكار اليومية',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      styleInformation: BigTextStyleInformation(''),
    );

    // iOS notification details
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Get the next occurrence of a specific time
  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Show an immediate notification (for testing)
  static Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'azkar_test',
      'اختبار',
      channelDescription: 'إشعار اختبار',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      0,
      'اختبار الإشعارات',
      'الإشعارات تعمل بشكل صحيح ✅',
      notificationDetails,
    );
  }
}
