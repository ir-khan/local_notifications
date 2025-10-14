import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/local_notification/local_notification_service.dart';

part 'app_startup_provider.g.dart';

@Riverpod(keepAlive: true)
Future<void> appStartup(Ref ref) async {
  await ref.watch(localNotificationServiceProvider).initializeNotification();
}
