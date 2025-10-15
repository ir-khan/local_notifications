import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/sounds.dart';
import '../../../core/services/local_notification/local_notification_service.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Local Notifications')),

      body: Column(
        spacing: 15,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(localNotificationServiceProvider)
                  .showInstantNotification(
                    title: 'Instant Notification',
                    body: 'This is instant notification.',
                  );
            },
            child: Text('Instant Notification'),
          ),
          ElevatedButton(
            onPressed: () async {
              /// ✅ TODO ( Izn ur Rehman ) : Why are we using two variables `soundAndroid` and `soundIos`
              /// While we can implement this using one variable
              await ref
                  .read(localNotificationServiceProvider)
                  .customSoundNotification(
                    id: 1,
                    title: 'Sound 1 Notification',
                    body: 'This is sound 1 notification.',
                    sound: SoundConstants.sound1,
                  );
            },
            child: Text('Sound 1 Notification'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(localNotificationServiceProvider)
                  .customSoundNotification(
                    id: 2,
                    title: 'Sound 2 Notification',
                    body: 'This is sound 2 notification.',
                    sound: SoundConstants.sound2,
                  );
            },
            child: Text('Sound 2 Notification'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(localNotificationServiceProvider)
                  .customSoundNotification(
                    id: 3,
                    title: 'Sound 3 Notification',
                    body: 'This is sound 3 notification.',
                    sound: SoundConstants.sound3,
                  );
            },
            child: Text('Sound 3 Notification'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(localNotificationServiceProvider)
                  .scheduleNotification(
                    title: 'Scheduled Notification',
                    body: 'This is Scheduled notification.',
                  );
            },
            child: Text('Schedule 5 Notifications'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(localNotificationServiceProvider)
                  .cancelAllNotifications();
            },
            child: Text('Cancel All Notifications'),
          ),
        ],
      ),
    );
  }
}
