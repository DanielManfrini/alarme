import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _scheduleAlarm() async {
  final scheduledNotificationDateTime =
      DateTime.now().add(const Duration(seconds: 5));
  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'alarm_notif',
    'alarm_notif',
    channelDescription: 'Channel for Alarm notification',
    icon: 'app_icon',
    sound: RawResourceAndroidNotificationSound('alarm_sound'),
    importance: Importance.max,
    priority: Priority.high,
  );
  //const iOSPlatformChannelSpecifics = IOSNotificationDetails();
  const platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.schedule(
    0,
    'Office',
    'Good morning! Time for office.',
    scheduledNotificationDateTime,
    platformChannelSpecifics,
  );
}

Future<void> _playAlarmSound() async {
  final assetsAudioPlayer = AssetsAudioPlayer();
  try {
    await assetsAudioPlayer.open(
      Audio("assets/alarm_sound.mp3"),
      autoStart: true,
      showNotification: true,
    );
  } catch (e) {
    print(e);
  }
}

void scheduleAlarm(
    int id, String title, String body, DateTime scheduledTime) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  try {
    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Alarme',
      'É hora do seu alarme',
      scheduledTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
    );
    // Notificação agendada com sucesso
    print('Notificação agendada com sucesso');
  } catch (e) {
    // Falha ao agendar a notificação
    print('Falha ao agendar a notificação: $e');
  }
}

// void scheduleAlarmInBackground(
//     DateTime scheduledTime, Function callback) async {
//   const int alarmId = 0;
//   await AndroidAlarmManager.oneShotAt(
//     scheduledTime,
//     alarmId,
//     callback,
//     exact: true,
//     wakeup: true,
//   );
// }
