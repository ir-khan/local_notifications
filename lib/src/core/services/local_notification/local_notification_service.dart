import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../constants/sounds.dart';

part 'local_notification_service.g.dart';

class LocalNotificationService {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationDetails get _defaultNotificationDetails => NotificationDetails(
    android: AndroidNotificationDetails(
      'local-notification',
      'Local Notification',
      channelDescription:
          'A channel used to send local notifications to device.',
      importance: Importance.max,
      priority: Priority.max,
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentBanner: true,
    ),
  );

  Future<void> initializeNotification() async {
    tz.initializeTimeZones();
    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initializationSettingsDarwin = DarwinInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );
    try {
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

      if (Platform.isIOS) {
        await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
      }

      if (Platform.isMacOS) {
        await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
      }

      if (Platform.isAndroid) {
        await _resolveAndroidImplementation();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _resolveAndroidImplementation() async {
    final android = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (android == null) return;
    await android.requestNotificationsPermission();

    for (final sound in [
      SoundConstants.sound1Android,
      SoundConstants.sound2Android,
      SoundConstants.sound3Android,
    ]) {
      final channel = AndroidNotificationChannel(
        'custom-sound-$sound',
        'Custom Sound ($sound)',
        description: 'Channel that plays the $sound notification sound.',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound(sound),
      );
      await android.createNotificationChannel(channel);
    }
  }

  Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    try {
      await _flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        _defaultNotificationDetails,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> customSoundNotification({
    required int id,
    required String title,
    required String body,
    required String soundAndroid,
    required String soundIos,
  }) async {
    try {
      await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'custom-sound-$soundAndroid',
            'Custom Sound ($soundAndroid)',
            channelDescription:
                'A channel used to send local notifications to device.',
            importance: Importance.max,
            priority: Priority.max,
            // sound: RawResourceAndroidNotificationSound(soundAndroid),
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentBanner: true,
            presentSound: true,
            sound: soundIos,
          ),
          macOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentBanner: true,
            presentSound: true,
            sound: soundIos,
          ),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> scheduleNotification({
    required String title,
    required String body,
  }) async {
    for (int i = 1; i < 6; i++) {
      try {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          i,
          '$title $i',
          '$body $i',
          tz.TZDateTime.now(tz.local).add(Duration(seconds: i * 10)),
          _defaultNotificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
    } catch (_) {}
  }
}

@riverpod
LocalNotificationService localNotificationService(Ref ref) {
  return LocalNotificationService();
}
