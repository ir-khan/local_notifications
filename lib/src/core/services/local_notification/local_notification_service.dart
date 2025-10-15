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
        await _resolveIosImplementation();
      } else if (Platform.isMacOS) {
        await _resolveMacosImplementation();
      } else if (Platform.isAndroid) {
        await _resolveAndroidImplementation();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _resolveIosImplementation() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> _resolveMacosImplementation() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> _resolveAndroidImplementation() async {
    final android = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (android == null) return;
    await android.requestNotificationsPermission();

    for (final sound in SoundConstants.values) {
      final channel = AndroidNotificationChannel(
        'custom-sound-${sound.android}',
        'Custom Sound (${sound.android})',
        description:
            'Channel that plays the ${sound.android} notification sound.',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound(sound.android),
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
    required SoundConstants sound,
  }) async {
    try {
      await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'custom-sound-${sound.android}',
            'Custom Sound (${sound.android})',
            channelDescription:
                'A channel used to send local notifications to device.',
            importance: Importance.max,
            priority: Priority.max,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentBanner: true,
            presentSound: true,
            sound: sound.iOS,
          ),
          macOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentBanner: true,
            presentSound: true,
            sound: sound.iOS,
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
